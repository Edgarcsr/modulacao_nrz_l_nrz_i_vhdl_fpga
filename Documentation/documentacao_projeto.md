# Documentação do Projeto

Este documento descreve o funcionamento interno dos módulos de modulação digital implementados no repositório. O foco está na arquitetura, nas interfaces e na lógica de operação do circuito, para permitir entendimento, manutenção e extensão do projeto.

O repositório contém duas implementações independentes:

- **NRZ-L**: o nível da saída representa diretamente o valor do bit.
- **NRZ-I**: a transição da saída representa o valor do bit.

## 1. Visão geral do circuito

Os módulos recebem uma sequência de 16 bits por `data_in` e geram uma saída serial modulada em uma das variações de codificação **Non-Return-to-Zero**. A sequência é processada bit a bit, sincronizada por `clk` e reiniciada por `reset`.

O comportamento comum aos dois módulos é o seguinte:

- um contador interno define a duração de cada bit;
- um ponteiro interno seleciona qual posição de `data_in` está sendo processada;
- a saída modulado é atualizada ao longo dos ciclos de clock;
- o circuito retorna ao início do vetor quando todos os bits foram consumidos.

No projeto, a leitura do vetor ocorre do **MSB para o LSB**, isto é, `data_in(15)` é processado primeiro e `data_in(0)` por ultimo.

## 2. Diagrama de blocos

```mermaid
graph TD
    CLK[clk] --> CNT[Contador de ticks]
    RST[reset] --> CNT
    RST --> PTR[Ponteiro do bit atual]
  DIN[data_in(DATA_WIDTH-1 downto 0)] --> SEL[Selecao do bit atual]
    PTR --> SEL
    CNT --> SEL
    SEL --> MOD[Logica NRZ]
    MOD --> OUT[nrz_out]
  MOD --> PMOD[tx_pmod - somente NRZ-L]
    CNT --> IDX[bit_idx]
    PTR --> IDX
```

O diagrama resume o fluxo principal:

- `clk` temporiza o circuito;
- `reset` reinicia os registradores internos;
- o contador define a janela de um bit;
- o ponteiro escolhe o bit atual;
- a logica NRZ produz a saida serial;
- `bit_idx` expõe a posicao interna para depuracao em waveform ou LEDs.

## 3. Interface do modulo

### 3.1 Interface de NRZ-L

| Porta | Tipo | Funcao |
| --- | --- | --- |
| `clk` | `std_logic` | Sinal de clock da FPGA |
| `reset` | `std_logic` | Reset assíncrono do circuito |
| `data_in` | `std_logic_vector(DATA_WIDTH - 1 downto 0)` | Sequencia de bits de entrada |
| `nrz_out` | `std_logic` | Saida modulada principal, ligada ao LED |
| `tx_pmod` | `std_logic` | Saida paralela para o pino PMOD |
| `bit_idx` | `integer range 0 to 15` | Posicao do bit atualmente processado |

### 3.2 Interface de NRZ-I

| Porta | Tipo | Funcao |
| --- | --- | --- |
| `clk` | `std_logic` | Sinal de clock da FPGA |
| `reset` | `std_logic` | Reset assíncrono do circuito |
| `data_in` | `std_logic_vector(DATA_WIDTH - 1 downto 0)` | Sequencia de bits de entrada |
| `nrz_out` | `std_logic` | Saida modulada principal, ligada ao LED |
| `bit_idx` | `integer range 0 to 15` | Posicao do bit atualmente processado |

Nos dois casos, `data_in` representa a sequencia paralela a ser serializada. A saida `nrz_out` corresponde ao sinal visualizado na simulação e na placa.

## 4. Parametros configuraveis

Os generics controlam os parametros estruturais do modulo.

| Generic | Tipo | Funcao |
| --- | --- | --- |
| `DATA_WIDTH` | `integer` | Define o tamanho do vetor de entrada |
| `TICKS_PER_BIT` | `integer` | Define quantos ciclos de clock compoem cada bit |

### Valores de referencia no codigo

- **NRZ-L**: `DATA_WIDTH = 16` e `TICKS_PER_BIT = 100000000`
- **NRZ-I**: `DATA_WIDTH = 16` e `TICKS_PER_BIT = 10`

O parametro `DATA_WIDTH` determina a largura do barramento de entrada. O parametro `TICKS_PER_BIT` determina a duracao temporal de cada bit e, por isso, controla a velocidade aparente da serializacao.

## 5. Funcionamento interno

### 5.1 Reset e inicializacao

Quando `reset` esta em nivel alto, os registradores internos sao reiniciados:

- o ponteiro retorna para `DATA_WIDTH - 1`;
- o contador de ticks volta para zero;
- a saida e colocada em `0`;
- no NRZ-I, a variavel de nivel atual tambem retorna para `0`.

Esse comportamento garante uma condicao inicial conhecida para simulacao e para uso na placa.

### 5.2 Selecao do bit atual

O ponteiro interno `bit_ptr` controla a posicao lida em `data_in`. A cada fim de periodo de bit:

- se `bit_ptr` for diferente de zero, o valor e decrementado;
- se `bit_ptr` chegar a zero, o circuito volta para `DATA_WIDTH - 1`.

Assim, o circuito percorre continuamente o vetor de entrada em loop.

### 5.3 Contador de duracao do bit

O contador `tick_counter` determina quantos ciclos de clock o bit atual permanece ativo.

- enquanto `tick_counter < TICKS_PER_BIT - 1`, o contador e incrementado;
- quando o limite e atingido, o contador volta para zero e o ponteiro avanca para o proximo bit.

Esse mecanismo desacopla a frequencia do clock da duracao percebida do sinal modulado.

### 5.4 Logica de NRZ-L

No NRZ-L, a saida representa diretamente o valor lido do vetor:

- se `data_in(bit_ptr) = '1'`, a saida permanece em nivel alto;
- se `data_in(bit_ptr) = '0'`, a saida permanece em nivel baixo.

Em cada borda de clock, o valor atual do bit e copiado para `nrz_out`. O sinal `tx_pmod` recebe o mesmo valor quando o modulo e o NRZ-L com saida extra para PMOD.

### 5.5 Logica de NRZ-I

No NRZ-I, o estado da linha precisa ser lembrado entre bits consecutivos. Para isso, o circuito usa o sinal interno `current_lvl`.

O comportamento e o seguinte:

- se o bit atual for `1`, o nivel atual e invertido;
- se o bit atual for `0`, o nivel atual e mantido;
- durante o periodo restante do bit, a saida continua exibindo o mesmo nivel.

Essa regra implementa a codificacao NRZ-I classica: o valor binario e representado por transicao no inicio do intervalo de bit, e nao por nivel fixo durante todo o intervalo.

## 6. Mapeamento fisico na placa

O projeto base usa a placa **Basys3**. O mapeamento dos sinais de top level para os recursos fisicos aparece nos arquivos `.xdc` de cada projeto.

### 6.1 NRZ-L

| Sinal | Pino FPGA | Recurso na placa | Funcao |
| --- | --- | --- | --- |
| `clk` | `W5` | Clock de 100 MHz | Clock principal do projeto |
| `reset` | `U18` | Botao central `btnC` | Reinicio assíncrono |
| `data_in[0]` | `V17` | `SW0` | Bit menos significativo da entrada |
| `data_in[1]` | `V16` | `SW1` | Bit de entrada |
| `data_in[2]` | `W16` | `SW2` | Bit de entrada |
| `data_in[3]` | `W17` | `SW3` | Bit de entrada |
| `data_in[4]` | `W15` | `SW4` | Bit de entrada |
| `data_in[5]` | `V15` | `SW5` | Bit de entrada |
| `data_in[6]` | `W14` | `SW6` | Bit de entrada |
| `data_in[7]` | `W13` | `SW7` | Bit de entrada |
| `data_in[8]` | `V2` | `SW8` | Bit de entrada |
| `data_in[9]` | `T3` | `SW9` | Bit de entrada |
| `data_in[10]` | `T2` | `SW10` | Bit de entrada |
| `data_in[11]` | `R3` | `SW11` | Bit de entrada |
| `data_in[12]` | `W2` | `SW12` | Bit de entrada |
| `data_in[13]` | `U1` | `SW13` | Bit de entrada |
| `data_in[14]` | `T1` | `SW14` | Bit de entrada |
| `data_in[15]` | `R2` | `SW15` | Bit mais significativo da entrada |
| `nrz_out` | `U16` | `LED0` | Saida modulada principal |
| `bit_idx[0]` | `P3` | `LED12` | Depuracao do indice interno |
| `bit_idx[1]` | `N3` | `LED13` | Depuracao do indice interno |
| `bit_idx[2]` | `P1` | `LED14` | Depuracao do indice interno |
| `bit_idx[3]` | `L1` | `LED15` | Depuracao do indice interno |
| `tx_pmod` | `J1` | PMOD JA1 | Saida auxiliar para osciloscopio |

### 6.2 NRZ-I

| Sinal | Pino FPGA | Recurso na placa | Funcao |
| --- | --- | --- | --- |
| `clk` | `W5` | Clock de 100 MHz | Clock principal do projeto |
| `reset` | `U18` | Botao central `btnC` | Reinicio assíncrono |
| `data_in[0]` | `V17` | `SW0` | Bit menos significativo da entrada |
| `data_in[1]` | `V16` | `SW1` | Bit de entrada |
| `data_in[2]` | `W16` | `SW2` | Bit de entrada |
| `data_in[3]` | `W17` | `SW3` | Bit de entrada |
| `data_in[4]` | `W15` | `SW4` | Bit de entrada |
| `data_in[5]` | `V15` | `SW5` | Bit de entrada |
| `data_in[6]` | `W14` | `SW6` | Bit de entrada |
| `data_in[7]` | `W13` | `SW7` | Bit de entrada |
| `data_in[8]` | `V2` | `SW8` | Bit de entrada |
| `data_in[9]` | `T3` | `SW9` | Bit de entrada |
| `data_in[10]` | `T2` | `SW10` | Bit de entrada |
| `data_in[11]` | `R3` | `SW11` | Bit de entrada |
| `data_in[12]` | `W2` | `SW12` | Bit de entrada |
| `data_in[13]` | `U1` | `SW13` | Bit de entrada |
| `data_in[14]` | `T1` | `SW14` | Bit de entrada |
| `data_in[15]` | `R2` | `SW15` | Bit mais significativo da entrada |
| `nrz_out` | `U16` | `LED0` | Saida modulada principal |
| `bit_idx[0]` | `P3` | `LED12` | Depuracao do indice interno |
| `bit_idx[1]` | `N3` | `LED13` | Depuracao do indice interno |
| `bit_idx[2]` | `P1` | `LED14` | Depuracao do indice interno |
| `bit_idx[3]` | `L1` | `LED15` | Depuracao do indice interno |

## 7. Dependencias e ambiente

O projeto depende do seguinte ambiente minimo:

- **Vivado 2025.1** ou versao compativel;
- **Placa Basys3** como plataforma alvo;
- **Linguagem VHDL** para descricao do hardware;
- **Bibliotecas IEEE**:
  - `IEEE.STD_LOGIC_1164.ALL`
  - `IEEE.NUMERIC_STD.ALL`

Essas bibliotecas fornecem, respectivamente, os tipos e operacoes logicas basicas e os recursos numericos usados no controle do contador e do ponteiro interno.

## 8. Observacoes de manutencao

Alguns pontos sao importantes para quem pretende modificar o circuito:

- qualquer alteracao na largura de `data_in` exige ajuste do generic `DATA_WIDTH` e do mapeamento fisico correspondente;
- qualquer alteracao no tempo de bit exige revisao de `TICKS_PER_BIT` e da forma de simulacao;
- a ordem de leitura do vetor continua do MSB para o LSB, a menos que a logica do ponteiro seja alterada;
- no NRZ-I, a variavel de estado `current_lvl` e essencial para preservar a informacao da transicao entre bits.

As demonstracoes praticas do comportamento dos modulos estao disponíveis em [/Assets](../Assets/), junto dos vídeos usados para apoio ao projeto.

## 9. Resumo operacional

Em termos de fluxo, o circuito opera assim:

1. o reset coloca o sistema em um estado conhecido;
2. o clock aciona o contador interno;
3. o ponteiro seleciona o bit atual de `data_in`;
4. a regra de modulacao converte o bit em nivel ou transicao;
5. a saida e aplicada em `nrz_out` e, no caso do NRZ-L, tambem em `tx_pmod`;
6. ao fim do vetor, o sistema retorna ao primeiro bit e reinicia o ciclo.

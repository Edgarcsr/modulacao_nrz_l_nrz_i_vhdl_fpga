# Extra - Saída pelo PMOD (Analog Discovery 3)

Disponibiliza o sinal modulado NRZ-L em um pino do conector PMOD da placa, permitindo visualizar a forma de onda em tempo real usando o **Analog Discovery 3 Pro Bundle** com o aplicativo **Waveform**.

## Vídeo de demonstração

Veja o NRZ-L funcionando com saída PMOD:

- [nrz-l-all-3-working.mov](../../../Assets/nrz-l-all-3-working.mov) (inclui visualização no Waveform)

## Estrutura desta pasta

```
PMOD/
├── src/          Código VHDL adaptado com saída no PMOD
├── constraints/  Constraint com mapeamento do pino PMOD (J2)
└── docs/         (Tutoriais e vídeos das conexões — quando disponível)
```

## Arquivos

- **`src/nrz_l.vhd`** — Versão modificada do circuito NRZ-L com saída no pino PMOD
- **`constraints/basys3_nrz_i.xdc`** — Constraint que mapeia o sinal para um dos pinos do conector PMOD J2 da Basys3

## Equipamentos necessários

- **Placa FPGA Basys3**
- **Analog Discovery 3 Pro Bundle** (com aplicativo Waveform)
- **Cabos jumper** ou pontas de prova para conectar ao PMOD
- **Cabo USB** para programar a placa
- **Computador** com Waveform instalado

## Conexão física

### Localização do PMOD na placa

O conector **PMOD J2** está localizado na parte inferior direita da placa Basys3. É um conector de 8 pinos (4 de sinal, 4 de GND).

### Mapeamento de pinos

A constraint define o pino PMOD específico onde o sinal será enviado. Consulte a documentação da Basys3 ou o arquivo `.xdc` para identificar o pino exato.

### Conexão do Analog Discovery

1. **Canal analógico do Analog Discovery** → Pino PMOD com o sinal modulado
2. **Ground do Analog Discovery** → Pino de GND do PMOD (ou GND da placa)

⚠️ **Importante**: Use sempre uma referência de GND para fechar o circuito de medição.

## Como reproduzir

### 1. Preparar o código e síntese

1. Copie o arquivo `src/nrz_l.vhd` para o seu projeto Vivado
2. Copie o arquivo `constraints/basys3_nrz_i.xdc` para os constraints do projeto
3. No Vivado, execute `Run Synthesis` e `Run Implementation`
4. Clique em `Generate Bitstream`

### 2. Programar a placa

1. Conecte a placa Basys3 ao computador via USB
2. No Vivado, clique em `Program Device`
3. Aguarde o carregamento (leds da placa podem piscar durante o processo)

### 3. Visualizar no Waveform

1. Conecte o Analog Discovery ao pino PMOD conforme descrito acima
2. Abra o aplicativo **Waveform** no computador
3. Configure o canal analógico:
   - **Time scale**: ~1 µs/div (ajuste conforme necessário para ver a forma de onda inteira)
   - **Vertical scale**: ~2 V/div ou automático
   - **Trigger**: Automático ou Manual (sobre uma transição)

4. Inicie a captura e observe a forma de onda característica da **modulação NRZ-L**:
   - Níveis altos e baixos constantes durante cada intervalo de bit
   - Transições abruptas entre bits

### Dicas de medição

- **Período do bit**: Meça o tempo entre transições. Este é o intervalo de um bit.
- **Amplitude do sinal**: Normalmente entre 0V e 3.3V (tensão lógica da Basys3)
- **Frequência de operação**: Ajuste a escala de tempo do osciloscópio para capturar vários bits completos
- **Sincronização**: Se a forma de onda parecer instável, ajuste o trigger do osciloscópio para sincronizar com as transições

## Observações

- O sinal é digital (lógico), não analógico. O Waveform mostrará transições abruptas entre 0V e 3.3V
- O Analog Discovery 3 Pro Bundle oferece excelente resolução temporal para capturar os detalhes da modulação
- Mantenha os cabos curtos para evitar ruído
- Se observar comportamento instável, verifique se o GND está bem conectado
- Consulte a documentação do Waveform para opções avançadas de análise (FFT, medições de frequência, etc.)

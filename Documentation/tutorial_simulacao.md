# 2.1 Tutorial de Simulação no Vivado

Este tutorial mostra o passo a passo para executar a simulação comportamental dos projetos do repositório no Vivado.

Ele se aplica tanto ao projeto **NRZ-L** quanto ao projeto **NRZ-I**. Quando houver diferença de nome de arquivo, os exemplos abaixo mostram os dois caminhos.

## 1. Pré-requisitos

- **Sistema operacional:** Windows 10 ou Windows 11
- **Vivado:** Vivado 2025.1 ou versão compatível
- **Projetos prontos para abrir:**
  - `NRZ-L/vivado-project/Projeto NRZ-L.xpr`
  - `NRZ-I/vivado-project/Projeto NRZ-I.xpr`

### Vídeo de referência no repositório

O vídeo de apoio correspondente está em [/Assets](../Assets/). O arquivo mais próximo desta etapa é [tutorial-open-project.mp4](../Assets/tutorial-open-project.mp4).

## 2. Abertura do projeto

1. Abra o Vivado.
2. Clique em **Open Project**.
3. Navegue até a pasta do projeto desejado.
4. Selecione o arquivo `.xpr` correspondente.

### Caminhos dos projetos

- **NRZ-L:** `NRZ-L/vivado-project/Projeto NRZ-L.xpr`
- **NRZ-I:** `NRZ-I/vivado-project/Projeto NRZ-I.xpr`

### Vídeo de referência no repositório

O vídeo de apoio correspondente está em [/Assets](../Assets/). Consulte [tutorial-open-project.mp4](../Assets/tutorial-open-project.mp4).

## 3. Estrutura dos arquivos no Vivado

Depois de abrir o projeto, verifique a organização nos painéis do Vivado:

- **Design Sources:** contém o módulo principal do circuito.
- **Simulation Sources:** contém o testbench.
- **Constraints:** contém o arquivo `.xdc` com o mapeamento dos pinos.

### Arquivos principais

- **NRZ-L**
  - Source: `NRZ-L/src/nrz_l.vhd`
  - Testbench: `NRZ-L/sim/nrz_l_tb.vhd`
  - Top module: `nrz_l`
- **NRZ-I**
  - Source: `NRZ-I/src/nrz_i.vhd`
  - Testbench: `NRZ-I/sim/nrz_i_tb.vhd`
  - Top module: `nrz_i`

### Vídeo de referência no repositório

O vídeo de apoio correspondente está em [/Assets](../Assets/). A navegação básica pelo projeto aparece nos vídeos de demonstração do repositório.

## 4. Configuração da simulação

1. No painel **Sources**, localize o testbench em **Simulation Sources**.
2. Clique com o botão direito sobre o testbench.
3. Selecione **Set as Top**.
4. Abra a configuração de tempo da simulação, se necessário, para garantir que a janela cubra toda a sequência de bits.

### Tempo recomendado

O testbench dos dois projetos usa:

- `DATA_W = 16`
- `BIT_PERIOD = 20 ns`

Isso significa que um tempo de simulação de aproximadamente **320 ns** já cobre a sequência completa. Para visualizar com folga, pode-se usar **400 ns**.

### Vídeo de referência no repositório

O vídeo de apoio correspondente está em [/Assets](../Assets/). O fluxo de simulação é demonstrado nos materiais gravados do projeto.

## 5. Execução da simulação

1. Clique em **Run Simulation**.
2. Escolha **Run Behavioral Simulation**.
3. Aguarde a abertura do simulador e do waveform viewer.

### Vídeo de referência no repositório

O vídeo de apoio correspondente está em [/Assets](../Assets/). Para esta etapa, consulte os vídeos de demonstração do NRZ-L e do NRZ-I.

## 6. Visualização do waveform

Depois que a simulação abrir:

1. Adicione os sinais necessários ao waveform, caso eles ainda não apareçam.
2. Ajuste a escala de tempo para enxergar a sequência completa.
3. Use zoom in e zoom out para analisar uma transição por vez.
4. Observe a relação entre `data_in`, `clk`, `reset`, `nrz_out` e `bit_idx`.

### O que observar

- **NRZ-L:** o valor de saída acompanha diretamente o bit lido.
- **NRZ-I:** o valor de saída alterna quando o bit lido é `1` e permanece igual quando o bit lido é `0`.

### Vídeo de referência no repositório

O vídeo de apoio correspondente está em [/Assets](../Assets/). O comportamento do waveform é visível nas demonstrações do NRZ-L e do NRZ-I.

## 7. Resultado esperado

Com a sequência de teste `1100101011110001`, espera-se ver:

- a leitura dos bits na ordem do MSB para o LSB;
- o contador de bits avançando ao longo da simulação;
- a saída `nrz_out` seguindo o comportamento de NRZ-L ou NRZ-I, conforme o projeto aberto;
- o reset limpando a saída no início da simulação.

### Vídeo de referência no repositório

O vídeo de apoio correspondente está em [/Assets](../Assets/). O resultado esperado pode ser observado nas demonstrações do projeto.

## Dicas rápidas

- Se o waveform parecer curto, aumente o tempo de simulação para algo como 400 ns.
- Se os sinais não aparecerem, verifique se o testbench foi definido como top.
- Se o projeto aberto for o NRZ-L, o top module deve ser `nrz_l`; se for o NRZ-I, deve ser `nrz_i`.

# Modulação NRZ-L

Implementação em VHDL da modulação **Unipolar NRZ-L** (Non-Return-to-Zero Level), em que o bit é representado pelo nível do pulso durante todo o intervalo do bit: **1 = nível alto**, **0 = nível baixo**.

## Estrutura desta pasta

```
NRZ-L/
├── src/                Código-fonte VHDL do circuito principal
├── sim/                Testbench para simulação
├── constraints/        Mapeamento dos pinos da FPGA (.xdc)
├── vivado-project/     Projeto Vivado pronto para abrir
└── extras/             Atividades opcionais (PMOD e VGA)
    ├── PMOD/           Saída pelo PMOD para osciloscópio
    └── VGA/            Saída VGA com cores pulsantes
```

## Arquivos de código

- **`src/nrz_l.vhd`** — Código-fonte do circuito principal da modulação NRZ-L
- **`sim/nrz_l_tb.vhd`** — Testbench para simulação comportamental
- **`constraints/basys3_nrz_l.xdc`** — Mapeamento dos pinos da FPGA Basys3

## Por onde começar

### Para uma simulação rápida (5 minutos)

1. Abra o Vivado
2. Carregue o projeto: `vivado-project/Projeto NRZ-L.xpr`
3. Clique em `Run Simulation` → `Run Behavioral Simulation`
4. Observe os sinais no waveform viewer

### Para reproduzir o projeto do zero

Siga esta ordem:

1. **Entenda a teoria**
   - NRZ-L é uma codificação unipolar onde cada bit é representado por um nível de tensão constante durante o intervalo do bit
   - Implementaremos um conversor de dados digitais para este formato modulado

2. **Estude o código**
   - Abra `src/nrz_l.vhd` e entenda a estrutura da entidade e arquitetura
   - Identifique os sinais de entrada (clock, reset, dados) e saída (sinal modulado)

3. **Simule no Vivado**
   - Abra `vivado-project/Projeto NRZ-L.xpr`
   - Execute `Run Simulation` → `Run Behavioral Simulation`
   - Observe o comportamento dos sinais em `sim/nrz_l_tb.vhd`

4. **Sintetize para a placa**
   - No Vivado, clique em `Run Synthesis`
   - Verifique se há erros ou warnings
   - Clique em `Run Implementation`

5. **Grave na FPGA**
   - Clique em `Generate Bitstream`
   - Conecte a placa Basys3 via USB
   - Clique em `Program Device`
   - Observe a saída na placa (pinos mapeados em constraints)

## Extras (opcionais)

Este projeto implementou as duas atividades extras:

- [**PMOD - Osciloscópio**](./extras/PMOD/) — Conecte um osciloscópio ao pino PMOD J2 para visualizar o sinal modulado em tempo real
- [**VGA - Visualização**](./extras/VGA/) — Visualize a forma de onda com cores pulsantes em um monitor VGA conectado à placa

Acesse os subdiretórios para instruções de uso e esquemáticos de conexão.

# Modulação NRZ-I

Implementação em VHDL da modulação **Unipolar NRZ-I** (Non-Return-to-Zero Inverted), em que o bit é representado pela **transição** do pulso no início do intervalo de bit: **1 = inversão do nível**, **0 = mantém o nível anterior**.

## Estrutura desta pasta

```
NRZ-I/
├── src/                Código-fonte VHDL do circuito principal
├── sim/                Testbench para simulação
├── constraints/        Mapeamento dos pinos da FPGA (.xdc)
├── vivado-project/     Projeto Vivado pronto para abrir
└── extras/             Atividades opcionais (PMOD e VGA)
    ├── PMOD/           Saída pelo PMOD para osciloscópio
    └── VGA/            Saída VGA com cores pulsantes
```

## Arquivos de código

- **`src/nrz_i.vhd`** — Código-fonte do circuito principal da modulação NRZ-I
- **`sim/nrz_i_tb.vhd`** — Testbench para simulação comportamental
- **`constraints/basys3_nrz_i.xdc`** — Mapeamento dos pinos da FPGA Basys3

## Por onde começar

### Para uma simulação rápida (5 minutos)

1. Abra o Vivado
2. Carregue o projeto: `vivado-project/Projeto NRZ-I.xpr`
3. Clique em `Run Simulation` → `Run Behavioral Simulation`
4. Observe os sinais no waveform viewer e note as **transições** representando os bits

### Para reproduzir o projeto do zero

Siga esta ordem:

1. **Entenda a teoria (e compare com NRZ-L)**
   - NRZ-I é uma codificação baseada em **transições**: um bit '1' causa uma inversão do nível, enquanto um bit '0' mantém o nível anterior
   - Esta abordagem oferece melhor recuperação de clock em alguns cenários
   - Acesse o projeto [NRZ-L](../NRZ-L/) anterior para revisar a primeira modulação

2. **Estude as diferenças com NRZ-L**
   - Compare `src/nrz_i.vhd` com `../NRZ-L/src/nrz_l.vhd`
   - Identifique como a lógica de transição difere da lógica de nível
   - Note o uso de estado anterior para determinar o próximo nível

3. **Estude o código NRZ-I**
   - Abra `src/nrz_i.vhd` e entenda a máquina de estados (se aplicável)
   - Identifique como a entrada de dados controla as transições

4. **Simule no Vivado**
   - Abra `vivado-project/Projeto NRZ-I.xpr`
   - Execute `Run Simulation` → `Run Behavioral Simulation`
   - Use a aba de waveform para observar as **transições** (não apenas níveis)
   - Compare com a simulação do NRZ-L para ver as diferenças

5. **Sintetize para a placa**
   - No Vivado, clique em `Run Synthesis`
   - Verifique se há erros ou warnings
   - Clique em `Run Implementation`

6. **Grave na FPGA**
   - Clique em `Generate Bitstream`
   - Conecte a placa Basys3 via USB
   - Clique em `Program Device`
   - Observe a saída na placa (pinos mapeados em constraints)

## Extras (opcionais)

Este projeto implementou as duas atividades extras:

- [**PMOD - Osciloscópio**](./extras/PMOD/) — Conecte um osciloscópio ao pino PMOD J2 para visualizar o sinal modulado em tempo real e observar as **transições** características da NRZ-I
- [**VGA - Visualização**](./extras/VGA/) — Visualize a forma de onda com cores pulsantes em um monitor VGA conectado à placa, evidenciando as transições de sinal

Acesse os subdiretórios para instruções de uso e esquemáticos de conexão.

## Próximo passo

Você concluiu os dois projetos principais do trabalho. Agora acesse o [Relatório técnico final](../Documentation/) para ver a análise comparativa entre **NRZ-L** e **NRZ-I**, os resultados obtidos, a análise de eficiência espectral, e as conclusões do grupo.

---

**Dúvidas?** Consulte o relatório final ou a documentação do projeto no repositório raiz.

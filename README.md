![GitHub Stars](https://www.shieldcn.dev/github/stars/Edgarcsr/modulacao_nrz_l_nrz_i_vhdl_fpga.svg?variant=secondary&size=sm)
![Commits](https://www.shieldcn.dev/github/commits/Edgarcsr/modulacao_nrz_l_nrz_i_vhdl_fpga.svg?variant=secondary&size=sm)
![Branches](https://www.shieldcn.dev/github/branches/Edgarcsr/modulacao_nrz_l_nrz_i_vhdl_fpga.svg?variant=ghost&size=sm&theme=violet)
![Contributors](https://www.shieldcn.dev/github/contributors/Edgarcsr/modulacao_nrz_l_nrz_i_vhdl_fpga.svg?theme=emerald&variant=ghost&size=sm)
![License](https://www.shieldcn.dev/github/license/Edgarcsr/modulacao_nrz_l_nrz_i_vhdl_fpga.svg?variant=ghost&size=sm&theme=orange)

# Modulação Digital em VHDL

Trabalho da disciplina de **Comunicação de Dados - Sistemas Reconfiguráveis**, 2026.

## Integrantes

- Edgar Camacho Seabra Ribeiro (RA: 081230039)
- Henrico Birochi (RA: 081230027)
- Nicholas Birochi (RA: 081230038)
- Vitor A. Braghttoni (RA: 081230024)

## Descrição

Este trabalho implementa, em VHDL, dois sistemas de modulação digital: **Unipolar NRZ-L** e **Unipolar NRZ-I**. O código foi simulado no Vivado Simulator e implementado na placa FPGA Basys3. Cada projeto é auto-contido com seu próprio código, testbench, constraints e documentação, além de atividades extras opcionais (saída PMOD para osciloscópio e saída VGA com cores pulsantes).

## Estrutura do repositório

```
modulacao_nrz_l_nrz_i_vhdl_fpga/
├── NRZ-L/              Projeto da modulação NRZ-L (auto-contido)
│   ├── src/            Código-fonte VHDL do circuito
│   ├── sim/            Testbench para simulação
│   ├── constraints/    Mapeamento dos pinos da FPGA (.xdc)
│   ├── vivado-project/ Projeto Vivado pronto para abrir
│   └── extras/         Atividades opcionais (PMOD e VGA)
├── NRZ-I/              Projeto da modulação NRZ-I (auto-contido)
│   ├── src/            Código-fonte VHDL do circuito
│   ├── sim/            Testbench para simulação
│   ├── constraints/    Mapeamento dos pinos da FPGA (.xdc)
│   ├── vivado-project/ Projeto Vivado pronto para abrir
│   └── extras/         Atividades opcionais (PMOD e VGA)
├── Documentation/      Documentação consolidada (relatório final)
└── README.md           Este arquivo
```

Cada projeto possui:

- **src/** com o código VHDL principal
- **sim/** com o testbench para simulação
- **constraints/** com o mapeamento de pinos para a Basys3
- **vivado-project/** com o projeto Vivado pronto para abrir e simular/sintetizar
- **extras/** com as atividades opcionais implementadas (PMOD e VGA)

## Projetos

- [**Modulação NRZ-L**](./NRZ-L/) — bit representado pelo nível do pulso
- [**Modulação NRZ-I**](./NRZ-I/) — bit representado pela transição do pulso

## Ferramentas utilizadas

- **Vivado 2025.1** (ou compatível)
- **Placa FPGA Basys3**
- **Linguagem**: VHDL
- **Simulação**: Vivado Simulator
- **Síntese e implementação**: Vivado Design Suite

## Como começar

Recomendamos iniciar pelo projeto NRZ-L para entender os conceitos básicos:

1. Acesse a pasta [NRZ-L/](./NRZ-L/)
2. Leia o README local para uma visão geral do projeto
3. Siga o tutorial de simulação para ver o circuito funcionando

Para uma **simulação rápida sem ler documentação**:

1. Abra o Vivado
2. Carregue o projeto em `NRZ-L/vivado-project/Projeto NRZ-L.xpr`
3. Clique em `Run Simulation` → `Run Behavioral Simulation`

Após concluir o NRZ-L, siga para o [NRZ-I/](./NRZ-I/) para aprender a segunda modulação e comparar as diferenças.

## Atividades extras realizadas

- **PMOD (Osciloscópio)** — Disponibiliza o sinal modulado em um pino PMOD da placa para visualização em osciloscópio físico
- **VGA (Visualização)** — Exibe a forma de onda em cores pulsantes na tela via saída VGA

Detalhes e tutoriais em cada projeto.

---

<p align="center">
  Feito com 💛 na CEFSA
</p>

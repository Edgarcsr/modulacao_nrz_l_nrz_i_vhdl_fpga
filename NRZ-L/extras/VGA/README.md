# Extra - Saída VGA (Visualização)

Implementa uma saída de vídeo VGA que exibe a forma de onda do sinal modulado **NRZ-L** na tela com cores pulsantes, permitindo visualizar a modulação em tempo real sem necessidade de osciloscópio.

## Estrutura desta pasta

```
VGA/
├── src/          Código VHDL do circuito com gerador VGA
├── constraints/  Constraint com mapeamento dos pinos VGA
└── docs/         (Tutoriais e fotos — quando disponível)
```

## Arquivos

- **`src/nrz_l.vhd`** — Versão modificada do circuito NRZ-L com controlador VGA integrado
- **`constraints/basys3_nrz_i.xdc`** — Constraint que mapeia os sinais VGA (R, G, B, HSYNC, VSYNC) para os pinos da Basys3

## Equipamentos necessários

- **Placa FPGA Basys3**
- **Monitor VGA** (resolução recomendada 640×480 ou compatível)
- **Cabo VGA** (DB-15 macho-macho)
- **Cabo USB** para programar a placa

## Mapeamento de pinos VGA

Os pinos VGA da Basys3 são:

- **R** (Vermelho) — Pino JB1
- **G** (Verde) — Pino JB2
- **B** (Azul) — Pino JB3
- **HSYNC** (Sincronismo Horizontal) — Pino JB4
- **VSYNC** (Sincronismo Vertical) — Pino JB5
- **GND** — Pinos JB6 e JB7

Consulte a constraint `basys3_nrz_i.xdc` para confirmação exata.

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

### 3. Conectar o monitor

1. Conecte o cabo VGA do monitor ao conector PMOD VGA da Basys3
2. Ligue o monitor
3. Dentro de alguns segundos, a forma de onda deve aparecer na tela

### 4. Visualizar e interagir

- **Forma de onda**: Deve aparecer em cores pulsantes, mostrando graficamente o sinal modulado NRZ-L
- **Cores**: Mudam constantemente para criar efeito visual da modulação
- **Sincronismo**: Se a imagem estiver distorcida ou piscando, ajuste a resolução ou sincronismo no monitor

## Características da visualização

- **Resolução**: 640×480 pixels (VGA padrão)
- **Cores**: RGB com pulsação dinâmica conforme o estado do sinal
- **Taxa de atualização**: Sincronizada com o sinal de modulação
- **Representação**: A forma de onda é desenhada na tela em tempo real

## Dicas de troubleshooting

| Problema                      | Solução                                                                      |
| ----------------------------- | ---------------------------------------------------------------------------- |
| Monitor exibe tela preta      | Verifique se o cabo VGA está bem conectado; tente outra resolução no monitor |
| Imagem distorcida ou piscando | Ajuste os controles de sincronismo (H-Sync, V-Sync) no menu do monitor       |
| Apenas uma cor visível        | Verifique o mapeamento dos pinos R, G, B no constraint                       |
| Sem sinal no monitor          | Confirme que o bitstream foi programado na placa e que o USB está conectado  |

## Próxima atividade

Após visualizar a forma de onda NRZ-L na tela VGA, você pode:

1. Explorar o [PMOD - Osciloscópio](../PMOD/) para validar o sinal com um equipamento profissional
2. Retornar ao [README principal](../../README.md) do projeto NRZ-L
3. Passar para o projeto [NRZ-I](../../../NRZ-I/) para aprender a segunda modulação

---

**Observação**: Este extra demonstra a versatilidade da FPGA, permitindo visualizações em tempo real de sinais sem hardware externo especializado.

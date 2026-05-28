# Extra - Saída VGA (Visualização)

Implementa uma saída de vídeo VGA que exibe a forma de onda do sinal modulado **NRZ-I** na tela com **cores em tempo real**: **preto** representa nível baixo e **branco** representa nível alto, evidenciando as **transições** características.

## Vídeo de demonstração

Veja o NRZ-I funcionando com saída VGA:

- [nrz-i-vga.mov](../../../Assets/nrz-i-vga.mov)

## Estrutura desta pasta

```
VGA/
├── src/          Código VHDL do circuito com gerador VGA
├── constraints/  Constraint com mapeamento dos pinos VGA
└── docs/         (Tutoriais e vídeos — quando disponível)
```

## Arquivos

- **`src/nrz_i.vhd`** — Versão modificada do circuito NRZ-I com controlador VGA integrado
- **`constraints/basys3_nrz_i.xdc`** — Constraint que mapeia os sinais VGA (R, G, B, HSYNC, VSYNC) para os pinos da Basys3

## Equipamentos necessários

- **Placa FPGA Basys3**
- **Monitor VGA** (resolução recomendada 640×480 ou compatível)
- **Cabo VGA** (DB-15 macho-macho)
- **Cabo USB** para programar a placa

## Mapa de cores

| Nível     | Cor       | Significado  |
| --------- | --------- | ------------ |
| **Baixa** | ⬛ Preto  | Lógico baixo |
| **Alta**  | ⬜ Branco | Lógico alto  |

## Como reproduzir

### 1. Preparar o código e síntese

1. Copie o arquivo `src/nrz_i.vhd` para o seu projeto Vivado
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
3. Dentro de alguns segundos, a forma de onda deve aparecer com alternando entre **preto** (0) e **branco** (1)

### 4. Visualizar

- **Forma de onda em tempo real**: As cores mudando entre preto e branco representam as transições e o estado do sinal
- **Sincronismo**: Se a imagem estiver distorcida ou piscando, ajuste a resolução ou sincronismo no monitor

## Características da visualização

- **Resolução**: 640×480 pixels (VGA padrão)
- **Mapa de cores**: Preto (nível baixo) e Branco (nível alto)
- **Taxa de atualização**: Sincronizada com o sinal de modulação em tempo real
- **Enfoque**: Visualização clara das **transições** características do NRZ-I

## Dicas de troubleshooting

| Problema                      | Solução                                                                      |
| ----------------------------- | ---------------------------------------------------------------------------- |
| Monitor exibe tela preta      | Verifique se o cabo VGA está bem conectado; tente outra resolução no monitor |
| Imagem distorcida ou piscando | Ajuste os controles de sincronismo (H-Sync, V-Sync) no menu do monitor       |
| Apenas uma cor visível        | Verifique se o cabo VGA está bem conectado; tente outra resolução no monitor |
| Imagem distorcida ou piscando | Ajuste os controles de sincronismo (H-Sync, V-Sync) no menu do monitor       |
| Cores não aparecem            | Verifique se o bitstream foi programado corretamente                         |

**Observação**: Este extra demonstra a versatilidade da FPGA na visualização de sinais em tempo real, combinando processamento de sinal com interface gráfica.

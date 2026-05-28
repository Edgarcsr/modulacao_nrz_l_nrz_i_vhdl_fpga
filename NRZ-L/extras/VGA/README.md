# Extra - Saída VGA (Visualização)

Implementa uma saída de vídeo VGA que exibe a forma de onda do sinal modulado **NRZ-L** na tela com **cores em tempo real**: **vermelho** representa nível baixo (bit 0) e **verde** representa nível alto (bit 1).

## Vídeo de demonstração

Veja o projeto NRZ-L funcionando completamente (simulação, programação e saída VGA):

- [nrz-l-all-3-working.mov](../../../Assets/nrz-l-all-3-working.mov)

## Estrutura desta pasta

```
VGA/
├── src/          Código VHDL do circuito com gerador VGA
├── constraints/  Constraint com mapeamento dos pinos VGA
└── docs/         (Tutoriais e vídeos — quando disponível)
```

## Arquivos

- **`src/nrz_l.vhd`** — Versão modificada do circuito NRZ-L com controlador VGA integrado
- **`constraints/basys3_nrz_i.xdc`** — Constraint que mapeia os sinais VGA (R, G, B, HSYNC, VSYNC) para os pinos da Basys3

## Equipamentos necessários

- **Placa FPGA Basys3**
- **Monitor VGA** (resolução recomendada 640×480 ou compatível)
- **Cabo VGA** (DB-15 macho-macho)
- **Cabo USB** para programar a placa

## Mapa de cores

| Nível     | Cor         | Significado          |
| --------- | ----------- | -------------------- |
| **Baixa** | 🔴 Vermelho | Bit 0 (lógico baixo) |
| **Alta**  | 🟢 Verde    | Bit 1 (lógico alto)  |

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
3. Dentro de alguns segundos, a forma de onda deve aparecer com **vermelho** (bit 0) e **verde** (bit 1)

### 4. Visualizar

- **Forma de onda em tempo real**: As cores mudando entre vermelho e verde representam os bits sendo transmitidos
- **Sincronismo**: Se a imagem estiver distorcida ou piscando, ajuste a resolução ou sincronismo no monitor

## Características da visualização

- **Resolução**: 640×480 pixels (VGA padrão)
- **Mapa de cores**: Vermelho (bit 0) e Verde (bit 1)
- **Taxa de atualização**: Sincronizada com o sinal de modulação em tempo real

## Dicas de troubleshooting

| Problema                      | Solução                                                                      |
| ----------------------------- | ---------------------------------------------------------------------------- |
| Monitor exibe tela preta      | Verifique se o cabo VGA está bem conectado; tente outra resolução no monitor |
| Imagem distorcida ou piscando | Ajuste os controles de sincronismo (H-Sync, V-Sync) no menu do monitor       |
| Apenas uma cor visível        | Verifique o mapeamento dos pinos R, G, B no constraint                       |
| Sem sinal no monitor          | Confirme que o bitstream foi programado na placa e que o USB está conectado  |

---

**Observação**: Este extra demonstra a versatilidade da FPGA, permitindo visualizações em tempo real de sinais sem hardware externo especializado.

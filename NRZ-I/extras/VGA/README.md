# Extra - Saída VGA (Visualização)

Implementa uma saída de vídeo VGA que exibe a forma de onda do sinal modulado **NRZ-I** na tela com cores pulsantes, permitindo visualizar a modulação em tempo real sem necessidade de osciloscópio.

## Estrutura desta pasta

```
VGA/
├── src/          Código VHDL do circuito com gerador VGA
├── constraints/  Constraint com mapeamento dos pinos VGA
└── docs/         (Tutoriais e fotos — quando disponível)
```

## Arquivos

- **`src/nrz_i.vhd`** — Versão modificada do circuito NRZ-I com controlador VGA integrado
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
3. Dentro de alguns segundos, a forma de onda deve aparecer na tela

### 4. Visualizar e interagir

- **Forma de onda**: Deve aparecer em cores pulsantes, mostrando graficamente o sinal modulado NRZ-I
- **Cores**: Mudam constantemente para criar efeito visual da modulação baseada em transições
- **Sincronismo**: Se a imagem estiver distorcida ou piscando, ajuste a resolução ou sincronismo no monitor

## Características da visualização

- **Resolução**: 640×480 pixels (VGA padrão)
- **Cores**: RGB com pulsação dinâmica conforme o estado do sinal e transições
- **Taxa de atualização**: Sincronizada com o sinal de modulação
- **Representação**: A forma de onda é desenhada na tela em tempo real, evidenciando as **transições** características do NRZ-I

## Análise comparativa com NRZ-L

Para apreciar a diferença entre as duas modulações:

1. Programe o circuito NRZ-L VGA (pasta `../../NRZ-L/extras/VGA/`)
2. Observe e anote o padrão visual (cores contínuas por intervalo de bit)
3. Agora programe o circuito NRZ-I VGA
4. Compare visualmente:
   - **NRZ-L**: Cores estáveis durante cada intervalo de bit
   - **NRZ-I**: Cores pulsam/mudam no início de cada transição (bits '1')

## Dicas de troubleshooting

| Problema                      | Solução                                                                              |
| ----------------------------- | ------------------------------------------------------------------------------------ |
| Monitor exibe tela preta      | Verifique se o cabo VGA está bem conectado; tente outra resolução no monitor         |
| Imagem distorcida ou piscando | Ajuste os controles de sincronismo (H-Sync, V-Sync) no menu do monitor               |
| Apenas uma cor visível        | Verifique o mapeamento dos pinos R, G, B no constraint                               |
| Sem sinal no monitor          | Confirme que o bitstream foi programado na placa e que o USB está conectado          |
| Padrão diferente do esperado  | Verifique se o código VHDL foi carregado corretamente; teste com simulação no Vivado |

## Próxima atividade

Após visualizar a forma de onda NRZ-I na tela VGA, você pode:

1. Explorar o [PMOD - Osciloscópio](../PMOD/) para validar o sinal com um equipamento profissional
2. Comparar visualmente com o [NRZ-L VGA](../../../NRZ-L/extras/VGA/) para entender as diferenças entre modulações
3. Retornar ao [README principal](../../README.md) do projeto NRZ-I
4. Acessar o [Relatório técnico final](../../../Documentation/) para análise comparativa completa

---

**Observação**: Este extra demonstra a versatilidade da FPGA na visualização de sinais em tempo real, combinando processamento de sinal com interface gráfica.

# 2.2 Tutorial de Gravação na Placa FPGA

Este tutorial mostra o passo a passo para sintetizar, implementar e gravar o projeto na placa Basys3 usando o Vivado.

Ele se aplica tanto ao projeto **NRZ-L** quanto ao projeto **NRZ-I**. Os caminhos dos arquivos principais mudam apenas no nome do projeto e do top module.

## 1. Pré-requisitos

- **Placa FPGA Basys3**
- **Cabo USB** para alimentação e programação
- **Drivers da Digilent instalados**, quando necessário
- **Vivado 2025.1** ou versão compatível
- **Projeto aberto no Vivado**

### Vídeo de referência no repositório

O vídeo de apoio correspondente está em [/Assets](../Assets/). Para este fluxo, o arquivo mais útil é [tutorial-program-device.mp4](../Assets/tutorial-program-device.mp4).

## 2. Síntese

1. Abra o projeto no Vivado.
2. No painel **Flow Navigator**, clique em **Run Synthesis**.
3. Aguarde o término do processo e confira se não houve erros.

### Vídeo de referência no repositório

O vídeo de apoio correspondente está em [/Assets](../Assets/). O fluxo de síntese aparece no material geral de programação do projeto.

## 3. Implementação

1. Após a síntese, clique em **Run Implementation**.
2. Aguarde a implementação terminar.
3. Verifique mensagens de erro ou warning antes de seguir.

### Vídeo de referência no repositório

O vídeo de apoio correspondente está em [/Assets](../Assets/). A etapa de implementação aparece no material de demonstração do projeto.

## 4. Geração do bitstream

1. Clique em **Generate Bitstream**.
2. Aguarde a criação do arquivo `.bit`.
3. Se o Vivado solicitar, aceite a continuação automática das etapas anteriores.

### Vídeo de referência no repositório

O vídeo de apoio correspondente está em [/Assets](../Assets/). Consulte [tutorial-program-device.mp4](../Assets/tutorial-program-device.mp4).

## 5. Conexão da placa

1. Conecte a Basys3 ao computador via USB.
2. Ligue a placa, se necessário.
3. No Vivado, abra o **Hardware Manager**.
4. Clique em **Open Target** e depois em **Auto Connect**.

### Vídeo de referência no repositório

O vídeo de apoio correspondente está em [/Assets](../Assets/). A conexão da placa é mostrada no material de programação do dispositivo.

## 6. Programação

1. Com a placa detectada, clique em **Program Device**.
2. Selecione o bitstream gerado.
3. Confirme a programação da FPGA.

### Vídeo de referência no repositório

O vídeo de apoio correspondente está em [/Assets](../Assets/). Consulte [tutorial-program-device.mp4](../Assets/tutorial-program-device.mp4).

## 7. Mapeamento de uso na placa

O mapeamento usado neste projeto é o mesmo para NRZ-L e NRZ-I:

- **Switches SW15 a SW0:** entrada `data_in[15:0]`
- **LED 0:** saída principal `nrz_out`
- **LEDs 12 a 15:** sinal `bit_idx` para depuração visual
- **Botão central `btnC`:** reset

### Observações importantes

- A sequência de bits é lida do **MSB para o LSB**.
- Em outras palavras, o primeiro bit transmitido é o valor de `data_in[15]`.
- O LED 0 mostra a saída serial resultante.

### Vídeo de referência no repositório

O vídeo de apoio correspondente está em [/Assets](../Assets/). As demonstrações do projeto mostram o uso dos switches, LEDs e do botão de reset.

## 8. Como testar

Uma sequência simples para teste é:

`1100101011110001`

### O que esperar

- **NRZ-L:** o LED 0 acompanha os bits diretamente. Bits `1` mantêm o nível alto e bits `0` mantêm o nível baixo.
- **NRZ-I:** o LED 0 muda de estado apenas quando um `1` é lido; para `0`, o nível permanece igual ao anterior.
- Os LEDs 12 a 15 podem ser usados para acompanhar a posição do bit que está sendo processado.

### Sequência sugerida de teste

1. Coloque `1100101011110001` nos switches.
2. Pressione `btnC` para resetar o circuito.
3. Observe o LED 0 e compare com o comportamento esperado de cada modulação.
4. Troque alguns bits nos switches para repetir a validação.

### Vídeo de referência no repositório

O vídeo de apoio correspondente está em [/Assets](../Assets/). Os arquivos [nrz-l-all-3-working.mov](../Assets/nrz-l-all-3-working.mov), [nrz-i-explained.mov](../Assets/nrz-i-explained.mov), [nrz-i-pmod.mov](../Assets/nrz-i-pmod.mov) e [nrz-i-vga.mov](../Assets/nrz-i-vga.mov) mostram o resultado em funcionamento.

## Dicas rápidas

- Se a placa não aparecer no Hardware Manager, verifique o cabo USB e os drivers da Digilent.
- Se o bitstream não gerar, revise a etapa de síntese e implementação.
- Se a saída não mudar como esperado, confira se o projeto correto foi programado e se o mapeamento dos sinais no `.xdc` está sendo usado.

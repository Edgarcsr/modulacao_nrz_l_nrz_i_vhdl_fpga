# Extra - Saída pelo PMOD (Analog Discovery 3)

Disponibiliza o sinal modulado **NRZ-I** em um pino do conector PMOD da placa, permitindo visualizar a forma de onda em tempo real usando o **Analog Discovery 3 Pro Bundle** com o aplicativo **Waveform**.

## Vídeos de demonstração

Veja o NRZ-I funcionando com saída PMOD:

- [nrz-i-explained.mov](../../../Assets/nrz-i-explained.mov) (explicação teórica)
- [nrz-i-pmod.mov](../../../Assets/nrz-i-pmod.mov) (visualização no Waveform)

## Estrutura desta pasta

```
PMOD/
├── src/          Código VHDL adaptado com saída no PMOD
├── constraints/  Constraint com mapeamento do pino PMOD (J2)
└── docs/         (Tutoriais e vídeos das conexões — quando disponível)
```

## Arquivos

- **`src/nrz_i.vhd`** — Versão modificada do circuito NRZ-I com saída no pino PMOD
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

1. Copie o arquivo `src/nrz_i.vhd` para o seu projeto Vivado
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

4. Inicie a captura e observe a forma de onda característica da **modulação NRZ-I**:
   - **Transições abruptas** no início de cada intervalo de bit '1'
   - **Sem transição** (mantém nível anterior) para cada bit '0'
   - Observe como o sinal "inverte" quando um bit é '1', diferentemente do NRZ-L

### Análise comparativa com NRZ-L

Para apreciar a diferença entre NRZ-L e NRZ-I:

1. Programe o circuito NRZ-L (pasta `../../NRZ-L/extras/PMOD/`)
2. Observe e anote a forma de onda (níveis contínuos)
3. Agora programe o circuito NRZ-I
4. Compare:
   - **NRZ-L**: Mostra níveis altos e baixos para cada bit
   - **NRZ-I**: Mostra transições (inversões) para bits '1' e ausência de mudança para bits '0'

### Dicas de medição

- **Período do bit**: Meça o tempo entre transições. Este é o intervalo de um bit.
- **Amplitude do sinal**: Normalmente entre 0V e 3.3V (tensão lógica da Basys3)
- **Frequência de operação**: Ajuste a escala de tempo do osciloscópio para capturar vários bits completos
- **Sincronização**: Se a forma de onda parecer instável, ajuste o trigger do osciloscópio para sincronizar com as transições (especialmente importante para NRZ-I)
- **Transições**: Conte o número de transições para entender melhor a sequência de bits

## Observações

- O sinal é digital (lógico), não analógico. O Waveform mostrará transições abruptas entre 0V e 3.3V
- O Analog Discovery 3 Pro Bundle oferece excelente resolução temporal para capturar os detalhes das **transições** em NRZ-I
- Mantenha os cabos curtos para evitar ruído
- Se observar comportamento instável, verifique se o GND está bem conectado
- NRZ-I pode exigir maior cuidado na sincronização do trigger, pois as transições são o sinal principal
- Use a função de medição de frequência do Waveform para validar a taxa de transmissão

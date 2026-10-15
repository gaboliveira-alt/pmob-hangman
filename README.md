# Integrantes da equipe

- Gabriel Oliveira Pinto

---

# Jogo da Forca (Hangman Game)

Aplicação móvel do clássico **Jogo da Forca**, desenvolvida em **Flutter/Dart** para a disciplina de
**Programação para Dispositivos Móveis** (Curso de Tecnologia em Sistemas de Computação — UESPI).

O aplicativo funciona **integralmente offline**. As respostas, categorias, níveis de dificuldade e dicas
são carregadas em tempo de execução a partir de um arquivo **JSON** incluído nos assets do projeto.

## Funcionalidades

- Seleção de **categoria** e **nível de dificuldade** obtidos do arquivo JSON.
- Sorteio aleatório de respostas, sem repetição durante a sessão (RF04).
- Tabuleiro que oculta apenas as letras; **espaços, hífens e demais caracteres não alfabéticos** são
  exibidos automaticamente desde o início da rodada.
- Respostas de **uma ou várias palavras**, com comparação que **ignora acentuação** e preserva a grafia
  original na exibição.
- Teclado com **somente letras** (A–Z); letras já utilizadas ficam identificadas.
- Representação gráfica **progressiva** da forca/boneco (6 partes).
- **Sistema de dicas** (uma dica por rodada).
- Telas de **resultado** (vitória/derrota) com resposta completa, erros e uso de dica.
- **Estatísticas da sessão**: rodadas concluídas, vitórias/derrotas (número e percentual), erros e dicas.
- Tela **Sobre/Equipe** com os nomes dos integrantes.

## Tecnologias

- [Flutter](https://flutter.dev/) (Material 3)
- [Dart](https://dart.dev/)
- Sem dependências externas além da SDK do Flutter.

## Como obter e executar

Pré-requisitos: Flutter SDK instalado e configurado, com um dispositivo/emulador **Android**.

```bash
# clonar o repositório
git clone <URL_DO_REPOSITORIO>
cd <NOME_DO_REPOSITORIO>

# baixar as dependências
flutter pub get

# executar a aplicação
flutter run

# análise estática (deve terminar sem erros/advertências)
flutter analyze

# formatação do código
dart format .
```

## Dependências adicionais

Nenhuma. O projeto usa apenas recursos locais e o arquivo JSON fornecido com a atividade.

## Estrutura geral da aplicação

```
assets/data/                    # JSON com respostas, categorias, dificuldades e dicas
lib/
  main.dart                     # ponto de entrada (runApp)
  app.dart                      # MaterialApp, tema e ciclo de vida do controller
  game_scope.dart               # expõe o GameController para a árvore de widgets
  domain/                       # regras e modelos do jogo (Dart puro, sem Flutter)
  data/                         # carregamento e desserialização do asset JSON
  presentation/
    state/                      # GameController (ChangeNotifier único)
    labels/                      # rótulos em português dos enums
    widgets/                    # tabuleiro, teclado e forca
    screens/                    # seleção, rodada/resultado, estatísticas e equipe
```

A arquitetura separa **regras de negócio**, **acesso aos dados locais** e **interface**, de forma que a
lógica do jogo não fica acoplada à camada de apresentação.

## Premissas e decisões de projeto

- A cedilha (`Ç`) é normalizada para `C` por ser um diacrítico; a comparação ignora a acentuação, mas a
  grafia original é sempre preservada na exibição.
- As estatísticas consideram apenas **rodadas concluídas**; o total de rodadas é a soma de vitórias e derrotas.
- A resposta é marcada como utilizada **ao ser apresentada**, conforme o RF04.
- A dica é contabilizada no momento do pedido, no máximo uma vez por rodada.
- O número máximo de erros é **6**, compatível com as 6 partes do boneco.
- O teclado oferece **somente A–Z**, independentemente da resposta sorteada.
- As respostas do arquivo de dados são **globalmente únicas**; a chave de controle de uso combina
  categoria, dificuldade e texto da resposta.
- A **exaustão** de uma combinação categoria + nível é informada e oferece **liberar explicitamente**
  as respostas daquele conjunto.
- **Abandonar** uma rodada em andamento pede confirmação e **não altera** as estatísticas nem a
  marcação de resposta usada.
- Os dados são carregados em tempo de execução de `assets/data/hangman.json`; **nenhum dado é copiado
  para o código-fonte**.
- **Sem testes automatizados**; a validação é manual.

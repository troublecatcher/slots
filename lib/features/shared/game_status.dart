enum GameStatus {
  initial('GAME COST'),
  inProgress('RUNNING'),
  win('WIN'),
  lose('LOSE');

  final String title;

  const GameStatus(this.title);
}

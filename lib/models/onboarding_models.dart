class OnboardModel {
  final String title;
  final String subtitle;
  final String imgPath;

  OnboardModel(
    this.title,
    this.subtitle,
    this.imgPath,
  );
}

List<OnboardModel> onBoardPages = [
  OnboardModel(
    'Tip0 Title',
    'Tip0 Subtitle',
    'assets/images/tip0.png',
  ),
  OnboardModel(
    'Tip1 Title',
    'Tip1 Subtitle',
    'assets/images/tip1.png',
  ),
  OnboardModel(
    'Tip2 Title',
    'Tip2 Subtitle',
    'assets/images/tip2.png',
  ),
  OnboardModel(
    'Tip3 Title',
    'Tip3 Subtitle',
    'assets/images/tip3.png',
  ),
];

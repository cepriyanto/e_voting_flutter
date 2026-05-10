class Routes {
  static const login = '/login';
  static const register = '/register';
  static const dashboard = '/dashboard';
  static const kandidat = '/kandidat';
  static const detailKandidat = '/detail-kandidat';
  static const riwayat = '/riwayat';
  static const profile = '/profile';
  static const hasilVoting = '/hasil-voting';
}

class PrefKeys {
  static const users = 'evoting_users';
  static const loggedIn = 'evoting_is_logged_in';
  static const loggedNim = 'evoting_logged_nim';
  static String voteHistory(String nim) => 'evoting_history_$nim';
  static String voteStatus(String nim) => 'evoting_voted_$nim';
}

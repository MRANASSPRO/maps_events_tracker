class APIPath {

  static String job(String jobId) => 'activites/$jobId';
  static String jobs() => 'activites';
  static String entry(String entryId) =>'entries/$entryId';
  static String entries() => 'entries';

  /*static String job(String jobId) => 'jobs/$jobId';
  static String jobs() => 'jobs';
  static String entry(String entryId) =>'entries/$entryId';
  static String entries() => 'entries';*/


  /*static String job(String uid, String jobId) => 'users/$uid/jobs/$jobId';
  static String jobs(String uid) => 'users/$uid/jobs';
  static String entry(String uid, String entryId) =>'users/$uid/entries/$entryId';
  static String entries(String uid) => 'users/$uid/entries';*/

}

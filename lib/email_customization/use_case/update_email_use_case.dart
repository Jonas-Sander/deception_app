import 'dart:convert';

import 'package:http/http.dart' as http;

class UpdateEmailUseCase {
  final CloudflareApi cloudflareApi;

  UpdateEmailUseCase(this.cloudflareApi);

  Future<void> updateEmails({
    required String privateEmail,
    required String deceptionEmail,
  }) async {
    // Wie aktualisiert man einen vorhandenen Eintrag? (ID)?

    // Was ist, wenn der Eintrag von außen erstellt wird/wurde?

    // Was ist, wenn die Weiterleitungen zu lange sind für ein einzigen
    // DNS-Eintrag und auf mehrere DNS-Einträge aufgeteilt werden müssen?
    // (Als erstes einfach die Länge beschränken?)

    // Creates DNS Record with forwarding just as a temporary prototype.
    final _privateEmail = Email.parse(privateEmail);
    final _deceptionEmail = Email.parse(deceptionEmail);
    final recordId = await createEmailForwarding(
        deceptionEmail: _deceptionEmail, privateEmail: _privateEmail);
    print(recordId);
  }

  Future<DnsEntryId> createEmailForwarding({
    required Email privateEmail,
    required Email deceptionEmail,
  }) async {
    return await cloudflareApi.createDnsRecord(
      type: 'TXT',
      name: 'deception.team',
      // z.B. foward-email=jsan:deception@jonassander.com
      content: 'forward-email=${deceptionEmail.localPart}:$privateEmail',
      ttl: 120,
    );
  }
}

class Email {
  final String localPart;
  final String domain;

  const Email(this.localPart, this.domain);

  factory Email.parse(String email) {
    final parts = email.split('@');
    return Email(parts[0], parts[1]);
  }

  //ToLower?
  @override
  String toString() {
    return '$localPart@$domain';
  }
}

class CloudflareApi {
  CloudflareApi(this.zoneId);
  static Uri baseUrl = Uri.parse('https://api.cloudflare.com/client/v4/');
  // Uri dnsRecordUrl(DnsEntryId dnsEntryId) => dnsRecordsUrl.resolve('$dnsEntryId');
  Uri get dnsRecordsUrl =>
      baseUrl.resolveUri(Uri.parse('zones/$zoneId/dns_records'));
  final String zoneId;
  final String token = 'PLACEHOLDER';

  Future<DnsEntryId> createDnsRecord({
    required String type,
    required String name,
    required String content,
    required int ttl,
  }) async {
    final body = json.encode({
      'type': type,
      'name': name,
      'content': content,
      'ttl': ttl,
    });
    print(body);
    final response = await http.post(dnsRecordsUrl,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer 7V1_F-H25yHxg4wY6xgtbuqCvKvy9LFgyslHt0q4',
        },
        body: body);

    if (response.statusCode != 200) {
      throw Exception(
          'Bad status code: ${response.statusCode}. Body: ${response.body}');
    }
    final res = json.decode(response.body) as Map<String, Object?>;
    if (res['success'] == false) {
      throw Exception(res);
    }

    return DnsEntryId((res['result'] as Map)['id']! as String);
  }
}

class DnsEntryId {
  final String idString;

  const DnsEntryId(this.idString);

  @override
  String toString() => 'DnsEntryId(idString: $idString)';
}

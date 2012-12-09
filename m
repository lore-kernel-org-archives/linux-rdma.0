From: Garrett Cooper <yanegomi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] [RFC] osm_log printing incorrectly assumes that pthread_t
 is not opaque type
Date: Sun, 9 Dec 2012 01:26:42 -0800 (PST)
Message-ID: <alpine.BSF.2.00.1212090125590.64779@toaster.local>
Mime-Version: 1.0
Content-Type: MULTIPART/Mixed; BOUNDARY="967339439-1792731705-1355044682=:64779"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-ID: <alpine.BSF.2.00.1212090125591.64779-Fqwm7F1mg36Nj9Bq2fkWzw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--967339439-1792731705-1355044682=:64779
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII; FORMAT=flowed
Content-ID: <alpine.BSF.2.00.1212090125592.64779-Fqwm7F1mg36Nj9Bq2fkWzw@public.gmane.org>

Hi,
 	When porting a newer version of OFED to FreeBSD and running the compile 
against clang with all of the warnings enabled, I ran into build failures 
because osm_log, etc assumes that pthread_t is an integral type (which is valid 
on Linux, but not necessarily correct on other platforms). The fix I 
implemented was attached, but that doesn't necessarily seem correct either, so 
I was wondering what was trying to be gained by printing out the thread ID 
(especially because syslog(9) isn't necessarily an asynch safe syscall [1]).
Thanks,
-Garrett

1. http://linux.die.net/man/7/signal

>From 55c3bafa1d866dc045e16fbf792dc64d03d25431 Mon Sep 17 00:00:00 2001
From: Garrett Cooper <garrett.cooper-nKaf5Oxk4VbQT0dZR+AlfA@public.gmane.org>
Date: Thu, 6 Dec 2012 21:41:17 -0800
Subject: [PATCH 2/2] Use %p when printing out pthread_t in the logging fns on FreeBSD

A [slightly] more portable way to do this would be to use
pthread_set(_)?name_np, but even that is not super well-defined across
BSD versions, Linux, and OSX. See
http://stackoverflow.com/questions/2369738/can-i-set-the-name-of-a-thread-in-pthreads-linux
for more details.
---
  contrib/ofed/management/opensm/opensm/osm_log.c | 9 +++++++++
  1 file changed, 9 insertions(+)

diff --git a/contrib/ofed/management/opensm/opensm/osm_log.c 
b/contrib/ofed/management/opensm/opensm/osm_log.c
index deadc57..f4ef394 100644
--- a/contrib/ofed/management/opensm/opensm/osm_log.c
+++ b/contrib/ofed/management/opensm/opensm/osm_log.c
@@ -189,7 +189,11 @@ _retry:
  _retry:
  	ret =
  	    fprintf(p_log->out_port,
+#if defined(__FreeBSD__)
+		    "%s %02d %02d:%02d:%02d %06d [%p] 0x%02x -> %s",
+#else
  		    "%s %02d %02d:%02d:%02d %06d [%04X] 0x%02x -> %s",
+#endif
  		    (result.tm_mon <
  		     12 ? month_str[result.tm_mon] : "???"),
  		    result.tm_mday, result.tm_hour, result.tm_min,
@@ -302,7 +306,12 @@ _retry:
  _retry:
  	ret =
  	    fprintf(p_log->out_port,
+#if defined(__FreeBSD__)
+		    "%s %02d %02d:%02d:%02d %06d [%p] 0x%02x -> %s",
+#else
  		    "%s %02d %02d:%02d:%02d %06d [%04X] 0x%02x -> %s",
+
+#endif
  		    (result.tm_mon <
  		     12 ? month_str[result.tm_mon] : "???"),
  		    result.tm_mday, result.tm_hour, result.tm_min,
-- 
1.8.0.1
--967339439-1792731705-1355044682=:64779
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII; NAME=0002-Use-p-when-printing-out-pthread_t-in-the-logging-fns.patch
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.BSF.2.00.1212090117580.64779-Fqwm7F1mg36Nj9Bq2fkWzw@public.gmane.org>
Content-Description: 
Content-Disposition: ATTACHMENT; FILENAME=0002-Use-p-when-printing-out-pthread_t-in-the-logging-fns.patch

RnJvbSA1NWMzYmFmYTFkODY2ZGMwNDVlMTZmYmY3OTJkYzY0ZDAzZDI1NDMx
IE1vbiBTZXAgMTcgMDA6MDA6MDAgMjAwMQ0KRnJvbTogR2FycmV0dCBDb29w
ZXIgPGdhcnJldHQuY29vcGVyQGlzaWxvbi5jb20+DQpEYXRlOiBUaHUsIDYg
RGVjIDIwMTIgMjE6NDE6MTcgLTA4MDANClN1YmplY3Q6IFtQQVRDSCAyLzJd
IFVzZSAlcCB3aGVuIHByaW50aW5nIG91dCBwdGhyZWFkX3QgaW4gdGhlIGxv
Z2dpbmcgZm5zIG9uDQogRnJlZUJTRA0KDQpBIFtzbGlnaHRseV0gbW9yZSBw
b3J0YWJsZSB3YXkgdG8gZG8gdGhpcyB3b3VsZCBiZSB0byB1c2UNCnB0aHJl
YWRfc2V0KF8pP25hbWVfbnAsIGJ1dCBldmVuIHRoYXQgaXMgbm90IHN1cGVy
IHdlbGwtZGVmaW5lZCBhY3Jvc3MNCkJTRCB2ZXJzaW9ucywgTGludXgsIGFu
ZCBPU1guIFNlZQ0KaHR0cDovL3N0YWNrb3ZlcmZsb3cuY29tL3F1ZXN0aW9u
cy8yMzY5NzM4L2Nhbi1pLXNldC10aGUtbmFtZS1vZi1hLXRocmVhZC1pbi1w
dGhyZWFkcy1saW51eA0KZm9yIG1vcmUgZGV0YWlscy4NCi0tLQ0KIGNvbnRy
aWIvb2ZlZC9tYW5hZ2VtZW50L29wZW5zbS9vcGVuc20vb3NtX2xvZy5jIHwg
OSArKysrKysrKysNCiAxIGZpbGUgY2hhbmdlZCwgOSBpbnNlcnRpb25zKCsp
DQoNCmRpZmYgLS1naXQgYS9jb250cmliL29mZWQvbWFuYWdlbWVudC9vcGVu
c20vb3BlbnNtL29zbV9sb2cuYyBiL2NvbnRyaWIvb2ZlZC9tYW5hZ2VtZW50
L29wZW5zbS9vcGVuc20vb3NtX2xvZy5jDQppbmRleCBkZWFkYzU3Li5mNGVm
Mzk0IDEwMDY0NA0KLS0tIGEvY29udHJpYi9vZmVkL21hbmFnZW1lbnQvb3Bl
bnNtL29wZW5zbS9vc21fbG9nLmMNCisrKyBiL2NvbnRyaWIvb2ZlZC9tYW5h
Z2VtZW50L29wZW5zbS9vcGVuc20vb3NtX2xvZy5jDQpAQCAtMTg5LDcgKzE4
OSwxMSBAQCBfcmV0cnk6DQogX3JldHJ5Og0KIAlyZXQgPQ0KIAkgICAgZnBy
aW50ZihwX2xvZy0+b3V0X3BvcnQsDQorI2lmIGRlZmluZWQoX19GcmVlQlNE
X18pDQorCQkgICAgIiVzICUwMmQgJTAyZDolMDJkOiUwMmQgJTA2ZCBbJXBd
IDB4JTAyeCAtPiAlcyIsDQorI2Vsc2UNCiAJCSAgICAiJXMgJTAyZCAlMDJk
OiUwMmQ6JTAyZCAlMDZkIFslMDRYXSAweCUwMnggLT4gJXMiLA0KKyNlbmRp
Zg0KIAkJICAgIChyZXN1bHQudG1fbW9uIDwNCiAJCSAgICAgMTIgPyBtb250
aF9zdHJbcmVzdWx0LnRtX21vbl0gOiAiPz8/IiksDQogCQkgICAgcmVzdWx0
LnRtX21kYXksIHJlc3VsdC50bV9ob3VyLCByZXN1bHQudG1fbWluLA0KQEAg
LTMwMiw3ICszMDYsMTIgQEAgX3JldHJ5Og0KIF9yZXRyeToNCiAJcmV0ID0N
CiAJICAgIGZwcmludGYocF9sb2ctPm91dF9wb3J0LA0KKyNpZiBkZWZpbmVk
KF9fRnJlZUJTRF9fKQ0KKwkJICAgICIlcyAlMDJkICUwMmQ6JTAyZDolMDJk
ICUwNmQgWyVwXSAweCUwMnggLT4gJXMiLA0KKyNlbHNlDQogCQkgICAgIiVz
ICUwMmQgJTAyZDolMDJkOiUwMmQgJTA2ZCBbJTA0WF0gMHglMDJ4IC0+ICVz
IiwNCisNCisjZW5kaWYNCiAJCSAgICAocmVzdWx0LnRtX21vbiA8DQogCQkg
ICAgIDEyID8gbW9udGhfc3RyW3Jlc3VsdC50bV9tb25dIDogIj8/PyIpLA0K
IAkJICAgIHJlc3VsdC50bV9tZGF5LCByZXN1bHQudG1faG91ciwgcmVzdWx0
LnRtX21pbiwNCi0tIA0KMS44LjAuMQ0KDQo=

--967339439-1792731705-1355044682=:64779--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

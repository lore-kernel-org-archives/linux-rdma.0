From: Garrett Cooper <yanegomi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/3] Avoid linker error with clang 3.0
Date: Sun, 9 Dec 2012 03:07:25 -0800 (PST)
Message-ID: <alpine.BSF.2.00.1212090306300.64779@toaster.local>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="967339439-2103473437-1355051246=:64779"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--967339439-2103473437-1355051246=:64779
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII

It seems that there's a bug when linking inlined functions with clang; this
issue will need to be upstreamed and reverified with clang 3.2.

Signed-off-by: Garrett Cooper <yanegomi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
  osmtest/osmtest.c | 2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/osmtest/osmtest.c b/osmtest/osmtest.c
index 68b0e40..4f56106 100644
--- a/osmtest/osmtest.c
+++ b/osmtest/osmtest.c
@@ -3068,7 +3068,7 @@ Exit:
  	return (status);
  }

-inline uint32_t osmtest_path_rec_key_get(IN const ib_path_rec_t * const p_rec)
+static uint32_t osmtest_path_rec_key_get(IN const ib_path_rec_t * const p_rec)
  {
  	return (p_rec->dlid << 16 | p_rec->slid);
  }
-- 
1.8.0

--967339439-2103473437-1355051246=:64779
Content-Type: TEXT/PLAIN; charset=US-ASCII; name=0003-Avoid-linker-error-with-clang-3.0.patch
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.BSF.2.00.1212090307250.64779-Fqwm7F1mg36Nj9Bq2fkWzw@public.gmane.org>
Content-Description: 
Content-Disposition: attachment; filename=0003-Avoid-linker-error-with-clang-3.0.patch

RnJvbSA5OThiNzVmZWFmZmU0MDY2ZDRjMTk2NzMxOTBlYzBiMWZkZmIwM2Rj
IE1vbiBTZXAgMTcgMDA6MDA6MDAgMjAwMQ0KRnJvbTogR2FycmV0dCBDb29w
ZXIgPHlhbmVnb21pQGdtYWlsLmNvbT4NCkRhdGU6IFN1biwgOSBEZWMgMjAx
MiAwMjo1Nzo0MyAtMDgwMA0KU3ViamVjdDogW1BBVENIIDMvM10gQXZvaWQg
bGlua2VyIGVycm9yIHdpdGggY2xhbmcgMy4wDQoNCkl0IHNlZW1zIHRoYXQg
dGhlcmUncyBhIGJ1ZyB3aGVuIGxpbmtpbmcgaW5saW5lZCBmdW5jdGlvbnMg
d2l0aCBjbGFuZzsgdGhpcw0KaXNzdWUgd2lsbCBuZWVkIHRvIGJlIHVwc3Ry
ZWFtZWQgYW5kIHJldmVyaWZpZWQgd2l0aCBjbGFuZyAzLjIuDQoNClNpZ25l
ZC1vZmYtYnk6IEdhcnJldHQgQ29vcGVyIDx5YW5lZ29taUBnbWFpbC5jb20+
DQotLS0NCiBvc210ZXN0L29zbXRlc3QuYyB8IDIgKy0NCiAxIGZpbGUgY2hh
bmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkNCg0KZGlmZiAt
LWdpdCBhL29zbXRlc3Qvb3NtdGVzdC5jIGIvb3NtdGVzdC9vc210ZXN0LmMN
CmluZGV4IDY4YjBlNDAuLjRmNTYxMDYgMTAwNjQ0DQotLS0gYS9vc210ZXN0
L29zbXRlc3QuYw0KKysrIGIvb3NtdGVzdC9vc210ZXN0LmMNCkBAIC0zMDY4
LDcgKzMwNjgsNyBAQCBFeGl0Og0KIAlyZXR1cm4gKHN0YXR1cyk7DQogfQ0K
IA0KLWlubGluZSB1aW50MzJfdCBvc210ZXN0X3BhdGhfcmVjX2tleV9nZXQo
SU4gY29uc3QgaWJfcGF0aF9yZWNfdCAqIGNvbnN0IHBfcmVjKQ0KK3N0YXRp
YyB1aW50MzJfdCBvc210ZXN0X3BhdGhfcmVjX2tleV9nZXQoSU4gY29uc3Qg
aWJfcGF0aF9yZWNfdCAqIGNvbnN0IHBfcmVjKQ0KIHsNCiAJcmV0dXJuIChw
X3JlYy0+ZGxpZCA8PCAxNiB8IHBfcmVjLT5zbGlkKTsNCiB9DQotLSANCjEu
OC4wDQoNCg==

--967339439-2103473437-1355051246=:64779--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

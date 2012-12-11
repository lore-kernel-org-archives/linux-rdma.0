From: Garrett Cooper <yanegomi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/3] Fixlinker error with clang with -O < 2
Date: Tue, 11 Dec 2012 02:09:13 -0800 (PST)
Message-ID: <alpine.BSF.2.00.1212110205390.71586@toaster.local>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="967339439-590691548-1355220559=:71586"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--967339439-590691548-1355220559=:71586
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII

The previous function definition was incorrect per c99 and is silently
ignored with gcc and is optimized away with clang and optimization
levels < 2.

Signed-off-by: Garrett Cooper <yanegomi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
  osmtest/osmtest.c | 3 ++-
  1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/osmtest/osmtest.c b/osmtest/osmtest.c
index 68b0e40..717c864 100644
--- a/osmtest/osmtest.c
+++ b/osmtest/osmtest.c
@@ -3068,7 +3068,8 @@ Exit:
  	return (status);
  }

-inline uint32_t osmtest_path_rec_key_get(IN const ib_path_rec_t * const p_rec)
+static inline uint32_t
+osmtest_path_rec_key_get(IN const ib_path_rec_t * const p_rec)
  {
  	return (p_rec->dlid << 16 | p_rec->slid);
  }
-- 
1.8.0
--967339439-590691548-1355220559=:71586
Content-Type: TEXT/PLAIN; charset=US-ASCII; name=0003-Fixlinker-error-with-clang-with-O-2.patch
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.BSF.2.00.1212110209130.71586-Fqwm7F1mg36Nj9Bq2fkWzw@public.gmane.org>
Content-Description: 
Content-Disposition: attachment; filename=0003-Fixlinker-error-with-clang-with-O-2.patch

RnJvbSBhNDYxYjY3ZWU0ZTU5M2FlYmZiOTYyZWRiZmJlMmVkZjYxZWI5ZWMw
IE1vbiBTZXAgMTcgMDA6MDA6MDAgMjAwMQ0KRnJvbTogR2FycmV0dCBDb29w
ZXIgPHlhbmVnb21pQGdtYWlsLmNvbT4NCkRhdGU6IFN1biwgOSBEZWMgMjAx
MiAwMjo1Nzo0MyAtMDgwMA0KU3ViamVjdDogW1BBVENIIDMvM10gRml4bGlu
a2VyIGVycm9yIHdpdGggY2xhbmcgd2l0aCAtTyA8IDINCg0KVGhlIHByZXZp
b3VzIGZ1bmN0aW9uIGRlZmluaXRpb24gd2FzIGluY29ycmVjdCBwZXIgYzk5
IGFuZCBpcyBzaWxlbnRseQ0KaWdub3JlZCB3aXRoIGdjYyBhbmQgaXMgb3B0
aW1pemVkIGF3YXkgd2l0aCBjbGFuZyBhbmQgb3B0aW1pemF0aW9uDQpsZXZl
bHMgPCAyLg0KDQpTaWduZWQtb2ZmLWJ5OiBHYXJyZXR0IENvb3BlciA8eWFu
ZWdvbWlAZ21haWwuY29tPg0KLS0tDQogb3NtdGVzdC9vc210ZXN0LmMgfCAz
ICsrLQ0KIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDEgZGVs
ZXRpb24oLSkNCg0KZGlmZiAtLWdpdCBhL29zbXRlc3Qvb3NtdGVzdC5jIGIv
b3NtdGVzdC9vc210ZXN0LmMNCmluZGV4IDY4YjBlNDAuLjcxN2M4NjQgMTAw
NjQ0DQotLS0gYS9vc210ZXN0L29zbXRlc3QuYw0KKysrIGIvb3NtdGVzdC9v
c210ZXN0LmMNCkBAIC0zMDY4LDcgKzMwNjgsOCBAQCBFeGl0Og0KIAlyZXR1
cm4gKHN0YXR1cyk7DQogfQ0KIA0KLWlubGluZSB1aW50MzJfdCBvc210ZXN0
X3BhdGhfcmVjX2tleV9nZXQoSU4gY29uc3QgaWJfcGF0aF9yZWNfdCAqIGNv
bnN0IHBfcmVjKQ0KK3N0YXRpYyBpbmxpbmUgdWludDMyX3QNCitvc210ZXN0
X3BhdGhfcmVjX2tleV9nZXQoSU4gY29uc3QgaWJfcGF0aF9yZWNfdCAqIGNv
bnN0IHBfcmVjKQ0KIHsNCiAJcmV0dXJuIChwX3JlYy0+ZGxpZCA8PCAxNiB8
IHBfcmVjLT5zbGlkKTsNCiB9DQotLSANCjEuOC4wDQoNCg==

--967339439-590691548-1355220559=:71586--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

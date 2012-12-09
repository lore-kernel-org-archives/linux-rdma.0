From: Garrett Cooper <yanegomi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] Fix -Wtautological-compare warnings with clang
Date: Sun, 9 Dec 2012 03:37:07 -0800 (PST)
Message-ID: <alpine.BSF.2.00.1212090335350.64779@toaster.local>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="967339439-181565276-1355053028=:64779"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--967339439-181565276-1355053028=:64779
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII

Signed-off-by: Garrett Cooper <yanegomi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
  src/ibportstate.c | 14 +++++++-------
  1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/src/ibportstate.c b/src/ibportstate.c
index 1d8dc81..9d90615 100644
--- a/src/ibportstate.c
+++ b/src/ibportstate.c
@@ -438,19 +438,19 @@ int main(int argc, char **argv)
  			val = strtoull(argv[i], 0, 0);
  			switch (j) {
  			case SPEED:
-				if (val < 0 || val > 15)
+				if (val > 15)
  					IBERROR("invalid speed value %ld", val);
  				break;
  			case ESPEED:
-				if (val < 0 || val > 31)
+				if (val > 31)
  					IBERROR("invalid extended speed value %ld", val);
  				break;
  			case FDR10SPEED:
-				if (val < 0 || val > 1)
+				if (val > 1)
  					IBERROR("invalid fdr10 speed value %ld", val);
  				break;
  			case WIDTH:
-				if (val < 0 || (val > 15 && val != 255))
+				if (val > 15 && val != 255)
  					IBERROR("invalid width value %ld", val);
  				break;
  			case VLS:
@@ -471,7 +471,7 @@ int main(int argc, char **argv)
  						val);
  				break;
  			case LMC:
-				if (val < 0 || val > 7)
+				if (val > 7)
  					IBERROR("invalid lmc value %ld", val);
  				break;
  			case MKEY:
@@ -488,11 +488,11 @@ int main(int argc, char **argv)
  				/* All 64-bit values are legal */
  				break;
  			case MKEYLEASE:
-				if (val < 0 || val > 0xFFFF)
+				if (val > 0xFFFF)
  					IBERROR("invalid mkey lease time %ld", val);
  				break;
  			case MKEYPROT:
-				if (val < 0 || val > 3)
+				if (val > 3)
  					IBERROR("invalid mkey protection bit setting %ld", val);
  			}
  			*port_args[j].val = val;
-- 
1.8.0

--967339439-181565276-1355053028=:64779
Content-Type: TEXT/PLAIN; charset=US-ASCII; name=0001-Fix-Wtautological-compare-warnings-with-clang.patch
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.BSF.2.00.1212090337070.64779-Fqwm7F1mg36Nj9Bq2fkWzw@public.gmane.org>
Content-Description: 
Content-Disposition: attachment; filename=0001-Fix-Wtautological-compare-warnings-with-clang.patch

RnJvbSAzY2Y1NTc2Nzg2OThkOTAyMTU4YzMyYzkyODZiNDkyYTNlOTc2YzUz
IE1vbiBTZXAgMTcgMDA6MDA6MDAgMjAwMQ0KRnJvbTogR2FycmV0dCBDb29w
ZXIgPHlhbmVnb21pQGdtYWlsLmNvbT4NCkRhdGU6IFN1biwgOSBEZWMgMjAx
MiAwMzozNDoxMSAtMDgwMA0KU3ViamVjdDogW1BBVENIXSBGaXggLVd0YXV0
b2xvZ2ljYWwtY29tcGFyZSB3YXJuaW5ncyB3aXRoIGNsYW5nDQoNClNpZ25l
ZC1vZmYtYnk6IEdhcnJldHQgQ29vcGVyIDx5YW5lZ29taUBnbWFpbC5jb20+
DQotLS0NCiBzcmMvaWJwb3J0c3RhdGUuYyB8IDE0ICsrKysrKystLS0tLS0t
DQogMSBmaWxlIGNoYW5nZWQsIDcgaW5zZXJ0aW9ucygrKSwgNyBkZWxldGlv
bnMoLSkNCg0KZGlmZiAtLWdpdCBhL3NyYy9pYnBvcnRzdGF0ZS5jIGIvc3Jj
L2licG9ydHN0YXRlLmMNCmluZGV4IDFkOGRjODEuLjlkOTA2MTUgMTAwNjQ0
DQotLS0gYS9zcmMvaWJwb3J0c3RhdGUuYw0KKysrIGIvc3JjL2licG9ydHN0
YXRlLmMNCkBAIC00MzgsMTkgKzQzOCwxOSBAQCBpbnQgbWFpbihpbnQgYXJn
YywgY2hhciAqKmFyZ3YpDQogCQkJdmFsID0gc3RydG91bGwoYXJndltpXSwg
MCwgMCk7DQogCQkJc3dpdGNoIChqKSB7DQogCQkJY2FzZSBTUEVFRDoNCi0J
CQkJaWYgKHZhbCA8IDAgfHwgdmFsID4gMTUpDQorCQkJCWlmICh2YWwgPiAx
NSkNCiAJCQkJCUlCRVJST1IoImludmFsaWQgc3BlZWQgdmFsdWUgJWxkIiwg
dmFsKTsNCiAJCQkJYnJlYWs7DQogCQkJY2FzZSBFU1BFRUQ6DQotCQkJCWlm
ICh2YWwgPCAwIHx8IHZhbCA+IDMxKQ0KKwkJCQlpZiAodmFsID4gMzEpDQog
CQkJCQlJQkVSUk9SKCJpbnZhbGlkIGV4dGVuZGVkIHNwZWVkIHZhbHVlICVs
ZCIsIHZhbCk7DQogCQkJCWJyZWFrOw0KIAkJCWNhc2UgRkRSMTBTUEVFRDoN
Ci0JCQkJaWYgKHZhbCA8IDAgfHwgdmFsID4gMSkNCisJCQkJaWYgKHZhbCA+
IDEpDQogCQkJCQlJQkVSUk9SKCJpbnZhbGlkIGZkcjEwIHNwZWVkIHZhbHVl
ICVsZCIsIHZhbCk7DQogCQkJCWJyZWFrOw0KIAkJCWNhc2UgV0lEVEg6DQot
CQkJCWlmICh2YWwgPCAwIHx8ICh2YWwgPiAxNSAmJiB2YWwgIT0gMjU1KSkN
CisJCQkJaWYgKHZhbCA+IDE1ICYmIHZhbCAhPSAyNTUpDQogCQkJCQlJQkVS
Uk9SKCJpbnZhbGlkIHdpZHRoIHZhbHVlICVsZCIsIHZhbCk7DQogCQkJCWJy
ZWFrOw0KIAkJCWNhc2UgVkxTOg0KQEAgLTQ3MSw3ICs0NzEsNyBAQCBpbnQg
bWFpbihpbnQgYXJnYywgY2hhciAqKmFyZ3YpDQogCQkJCQkJdmFsKTsNCiAJ
CQkJYnJlYWs7DQogCQkJY2FzZSBMTUM6DQotCQkJCWlmICh2YWwgPCAwIHx8
IHZhbCA+IDcpDQorCQkJCWlmICh2YWwgPiA3KQ0KIAkJCQkJSUJFUlJPUigi
aW52YWxpZCBsbWMgdmFsdWUgJWxkIiwgdmFsKTsNCiAJCQkJYnJlYWs7DQog
CQkJY2FzZSBNS0VZOg0KQEAgLTQ4OCwxMSArNDg4LDExIEBAIGludCBtYWlu
KGludCBhcmdjLCBjaGFyICoqYXJndikNCiAJCQkJLyogQWxsIDY0LWJpdCB2
YWx1ZXMgYXJlIGxlZ2FsICovDQogCQkJCWJyZWFrOw0KIAkJCWNhc2UgTUtF
WUxFQVNFOg0KLQkJCQlpZiAodmFsIDwgMCB8fCB2YWwgPiAweEZGRkYpDQor
CQkJCWlmICh2YWwgPiAweEZGRkYpDQogCQkJCQlJQkVSUk9SKCJpbnZhbGlk
IG1rZXkgbGVhc2UgdGltZSAlbGQiLCB2YWwpOw0KIAkJCQlicmVhazsNCiAJ
CQljYXNlIE1LRVlQUk9UOg0KLQkJCQlpZiAodmFsIDwgMCB8fCB2YWwgPiAz
KQ0KKwkJCQlpZiAodmFsID4gMykNCiAJCQkJCUlCRVJST1IoImludmFsaWQg
bWtleSBwcm90ZWN0aW9uIGJpdCBzZXR0aW5nICVsZCIsIHZhbCk7DQogCQkJ
fQ0KIAkJCSpwb3J0X2FyZ3Nbal0udmFsID0gdmFsOw0KLS0gDQoxLjguMA0K
DQo=

--967339439-181565276-1355053028=:64779--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

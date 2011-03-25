From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] infiniband-diags: saquery; clean up name/lid processing
Date: Thu, 24 Mar 2011 17:52:32 -0700
Message-ID: <20110324175232.844c38ae.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="Multipart=_Thu__24_Mar_2011_17_52_32_-0700_gP.5ziG1iUA=qR5r"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.

--Multipart=_Thu__24_Mar_2011_17_52_32_-0700_gP.5ziG1iUA=qR5r
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit



For NodeRecord querys in particular if a name was not found all NodeRecords
were printed.  Correct behavior is to report "node not found".

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 src/saquery.c |   27 +++++++++++++++++++--------
 1 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/src/saquery.c b/src/saquery.c
index 18c5a1c..532116f 100644
--- a/src/saquery.c
+++ b/src/saquery.c
@@ -48,7 +48,6 @@
 #include <ctype.h>
 #include <string.h>
 #include <errno.h>
-#include <assert.h>
 
 #define _GNU_SOURCE
 #include <getopt.h>
@@ -891,6 +890,7 @@ static int get_lid_from_name(bind_handle_t h, const char *name, uint16_t * lid)
 	if (ret)
 		return ret;
 
+	ret = IB_NOT_FOUND;
 	for (i = 0; i < result.result_cnt; i++) {
 		node_record = get_query_rec(result.p_result_madw, i);
 		p_ni = &(node_record->node_info);
@@ -899,11 +899,12 @@ static int get_lid_from_name(bind_handle_t h, const char *name, uint16_t * lid)
 			       sizeof(node_record->node_desc.description)) ==
 		    0) {
 			*lid = cl_ntoh16(node_record->lid);
+			ret = IB_SUCCESS;
 			break;
 		}
 	}
 	return_mad();
-	return 0;
+	return ret;
 }
 
 static uint16_t get_lid(bind_handle_t h, const char *name)
@@ -912,12 +913,22 @@ static uint16_t get_lid(bind_handle_t h, const char *name)
 
 	if (!name)
 		return 0;
-	if (isalpha(name[0]))
-		assert(get_lid_from_name(h, name, &rc_lid) == IB_SUCCESS);
-	else
-		rc_lid = (uint16_t) atoi(name);
-	if (rc_lid == 0)
-		fprintf(stderr, "Failed to find lid for \"%s\"\n", name);
+	if (isalpha(name[0])) {
+		if (get_lid_from_name(h, name, &rc_lid) != IB_SUCCESS) {
+			fprintf(stderr, "Failed to find lid for \"%s\"\n", name);
+			exit(EINVAL);
+		}
+	} else {
+		long val;
+		errno = 0;
+		val = strtol(name, NULL, 0);
+		if (errno != 0 || val <= 0 || val > UINT16_MAX) {
+			fprintf(stderr, "Invalid lid specified: \"%s\"\n", name);
+			exit(EINVAL);
+		}
+		rc_lid = (uint16_t)val;
+	}
+
 	return rc_lid;
 }
 
-- 
1.5.4.5


--Multipart=_Thu__24_Mar_2011_17_52_32_-0700_gP.5ziG1iUA=qR5r
Content-Type: application/octet-stream;
 name="0001-infiniband-diags-saquery-clean-up-name-lid-process.patch"
Content-Disposition: attachment;
 filename="0001-infiniband-diags-saquery-clean-up-name-lid-process.patch"
Content-Transfer-Encoding: base64

RnJvbSBmODQ2MjdkODc3NWQyNzg5ZTgyODc3N2NlODlkMTI4MTlmMDFjN2IwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBJcmEgV2VpbnkgPHdlaW55MkBsbG5sLmdvdj4KRGF0ZTogVGh1
LCAxNyBNYXIgMjAxMSAxNzozNDo1MiAtMDcwMApTdWJqZWN0OiBbUEFUQ0hdIGluZmluaWJhbmQt
ZGlhZ3M6IHNhcXVlcnk7IGNsZWFuIHVwIG5hbWUvbGlkIHByb2Nlc3NpbmcKCkZvciBOb2RlUmVj
b3JkIHF1ZXJ5cyBpbiBwYXJ0aWN1bGFyIGlmIGEgbmFtZSB3YXMgbm90IGZvdW5kIGFsbCBOb2Rl
UmVjb3Jkcwp3ZXJlIHByaW50ZWQuICBDb3JyZWN0IGJlaGF2aW9yIGlzIHRvIHJlcG9ydCAibm9k
ZSBub3QgZm91bmQiLgoKU2lnbmVkLW9mZi1ieTogSXJhIFdlaW55IDx3ZWlueTJAbGxubC5nb3Y+
Ci0tLQogc3JjL3NhcXVlcnkuYyB8ICAgMjcgKysrKysrKysrKysrKysrKysrKy0tLS0tLS0tCiAx
IGZpbGVzIGNoYW5nZWQsIDE5IGluc2VydGlvbnMoKyksIDggZGVsZXRpb25zKC0pCgpkaWZmIC0t
Z2l0IGEvc3JjL3NhcXVlcnkuYyBiL3NyYy9zYXF1ZXJ5LmMKaW5kZXggMThjNWExYy4uNTMyMTE2
ZiAxMDA2NDQKLS0tIGEvc3JjL3NhcXVlcnkuYworKysgYi9zcmMvc2FxdWVyeS5jCkBAIC00OCw3
ICs0OCw2IEBACiAjaW5jbHVkZSA8Y3R5cGUuaD4KICNpbmNsdWRlIDxzdHJpbmcuaD4KICNpbmNs
dWRlIDxlcnJuby5oPgotI2luY2x1ZGUgPGFzc2VydC5oPgogCiAjZGVmaW5lIF9HTlVfU09VUkNF
CiAjaW5jbHVkZSA8Z2V0b3B0Lmg+CkBAIC04OTEsNiArODkwLDcgQEAgc3RhdGljIGludCBnZXRf
bGlkX2Zyb21fbmFtZShiaW5kX2hhbmRsZV90IGgsIGNvbnN0IGNoYXIgKm5hbWUsIHVpbnQxNl90
ICogbGlkKQogCWlmIChyZXQpCiAJCXJldHVybiByZXQ7CiAKKwlyZXQgPSBJQl9OT1RfRk9VTkQ7
CiAJZm9yIChpID0gMDsgaSA8IHJlc3VsdC5yZXN1bHRfY250OyBpKyspIHsKIAkJbm9kZV9yZWNv
cmQgPSBnZXRfcXVlcnlfcmVjKHJlc3VsdC5wX3Jlc3VsdF9tYWR3LCBpKTsKIAkJcF9uaSA9ICYo
bm9kZV9yZWNvcmQtPm5vZGVfaW5mbyk7CkBAIC04OTksMTEgKzg5OSwxMiBAQCBzdGF0aWMgaW50
IGdldF9saWRfZnJvbV9uYW1lKGJpbmRfaGFuZGxlX3QgaCwgY29uc3QgY2hhciAqbmFtZSwgdWlu
dDE2X3QgKiBsaWQpCiAJCQkgICAgICAgc2l6ZW9mKG5vZGVfcmVjb3JkLT5ub2RlX2Rlc2MuZGVz
Y3JpcHRpb24pKSA9PQogCQkgICAgMCkgewogCQkJKmxpZCA9IGNsX250b2gxNihub2RlX3JlY29y
ZC0+bGlkKTsKKwkJCXJldCA9IElCX1NVQ0NFU1M7CiAJCQlicmVhazsKIAkJfQogCX0KIAlyZXR1
cm5fbWFkKCk7Ci0JcmV0dXJuIDA7CisJcmV0dXJuIHJldDsKIH0KIAogc3RhdGljIHVpbnQxNl90
IGdldF9saWQoYmluZF9oYW5kbGVfdCBoLCBjb25zdCBjaGFyICpuYW1lKQpAQCAtOTEyLDEyICs5
MTMsMjIgQEAgc3RhdGljIHVpbnQxNl90IGdldF9saWQoYmluZF9oYW5kbGVfdCBoLCBjb25zdCBj
aGFyICpuYW1lKQogCiAJaWYgKCFuYW1lKQogCQlyZXR1cm4gMDsKLQlpZiAoaXNhbHBoYShuYW1l
WzBdKSkKLQkJYXNzZXJ0KGdldF9saWRfZnJvbV9uYW1lKGgsIG5hbWUsICZyY19saWQpID09IElC
X1NVQ0NFU1MpOwotCWVsc2UKLQkJcmNfbGlkID0gKHVpbnQxNl90KSBhdG9pKG5hbWUpOwotCWlm
IChyY19saWQgPT0gMCkKLQkJZnByaW50ZihzdGRlcnIsICJGYWlsZWQgdG8gZmluZCBsaWQgZm9y
IFwiJXNcIlxuIiwgbmFtZSk7CisJaWYgKGlzYWxwaGEobmFtZVswXSkpIHsKKwkJaWYgKGdldF9s
aWRfZnJvbV9uYW1lKGgsIG5hbWUsICZyY19saWQpICE9IElCX1NVQ0NFU1MpIHsKKwkJCWZwcmlu
dGYoc3RkZXJyLCAiRmFpbGVkIHRvIGZpbmQgbGlkIGZvciBcIiVzXCJcbiIsIG5hbWUpOworCQkJ
ZXhpdChFSU5WQUwpOworCQl9CisJfSBlbHNlIHsKKwkJbG9uZyB2YWw7CisJCWVycm5vID0gMDsK
KwkJdmFsID0gc3RydG9sKG5hbWUsIE5VTEwsIDApOworCQlpZiAoZXJybm8gIT0gMCB8fCB2YWwg
PD0gMCB8fCB2YWwgPiBVSU5UMTZfTUFYKSB7CisJCQlmcHJpbnRmKHN0ZGVyciwgIkludmFsaWQg
bGlkIHNwZWNpZmllZDogXCIlc1wiXG4iLCBuYW1lKTsKKwkJCWV4aXQoRUlOVkFMKTsKKwkJfQor
CQlyY19saWQgPSAodWludDE2X3QpdmFsOworCX0KKwogCXJldHVybiByY19saWQ7CiB9CiAKLS0g
CjEuNS40LjUKCg==

--Multipart=_Thu__24_Mar_2011_17_52_32_-0700_gP.5ziG1iUA=qR5r--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

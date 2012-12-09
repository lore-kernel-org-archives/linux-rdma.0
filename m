From: Garrett Cooper <yanegomi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 1/3] Fix -Wtautological-compare warnings with clang
Date: Sun, 9 Dec 2012 12:14:12 -0800 (PST)
Message-ID: <alpine.BSF.2.00.1212091205060.64779@toaster.local>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="967339439-2143212571-1355084053=:64779"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--967339439-2143212571-1355084053=:64779
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII

>From 1f91aeca2d9fecd1301d6fe2731a79d8640b2072 Mon Sep 17 00:00:00 2001
From: Garrett Cooper <yanegomi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Date: Sun, 9 Dec 2012 02:44:32 -0800
Subject: [PATCH 1/3] Fix -Wtautological-compare warnings with clang

V1:

The noted branch conditions are true or false and hence not
tested/executed as designed.

Prune the always true/false conditional checks.

V2:

Fix the conditional check in osm_vendor_new by properly checking for
IB_SUCCESS instead of assuming that values < 0 denotes error as this
isn't possible given the enum definition.

Signed-off-by: Garrett Cooper <yanegomi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
  libvendor/osm_vendor_ibumad.c | 2 +-
  opensm/osm_qos_parser_y.y     | 6 ++----
  opensm/st.c                   | 2 --
  3 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/libvendor/osm_vendor_ibumad.c b/libvendor/osm_vendor_ibumad.c
index ca320a6..63b9594 100644
--- a/libvendor/osm_vendor_ibumad.c
+++ b/libvendor/osm_vendor_ibumad.c
@@ -574,7 +574,7 @@ osm_vendor_t *osm_vendor_new(IN osm_log_t * const p_log,

  	memset(p_vend, 0, sizeof(*p_vend));

-	if (osm_vendor_init(p_vend, p_log, timeout) < 0) {
+	if (osm_vendor_init(p_vend, p_log, timeout) != IB_SUCCESS) {
  		free(p_vend);
  		p_vend = NULL;
  	}
diff --git a/opensm/osm_qos_parser_y.y b/opensm/osm_qos_parser_y.y
index 4e01ed4..0b567c8 100644
--- a/opensm/osm_qos_parser_y.y
+++ b/opensm/osm_qos_parser_y.y
@@ -1648,8 +1648,7 @@ sl2vl_scope_from_list_of_ranges: list_of_ranges {
                                  num_pair = (uint64_t*)cl_list_obj(list_iterator);
                                  if (num_pair)
                                  {
-                                    if ( num_pair[0] < 0 ||
-                                         num_pair[1] >= OSM_QOS_POLICY_MAX_PORTS_ON_SWITCH )
+                                    if ( num_pair[1] >= OSM_QOS_POLICY_MAX_PORTS_ON_SWITCH )
                                      {
                                          yyerror("port number out of range 'from' list");
                                          free(num_pair);
@@ -1680,8 +1679,7 @@ sl2vl_scope_to_list_of_ranges: list_of_ranges {
                                  num_pair = (uint64_t*)cl_list_obj(list_iterator);
                                  if (num_pair)
                                  {
-                                    if ( num_pair[0] < 0 ||
-                                         num_pair[1] >= OSM_QOS_POLICY_MAX_PORTS_ON_SWITCH )
+                                    if ( num_pair[1] >= OSM_QOS_POLICY_MAX_PORTS_ON_SWITCH )
                                      {
                                          yyerror("port number out of range 'to' list");
                                          free(num_pair);
diff --git a/opensm/st.c b/opensm/st.c
index 754648c..14db456 100644
--- a/opensm/st.c
+++ b/opensm/st.c
@@ -196,8 +196,6 @@ size_t size;
  #endif

  	size = new_size(size);	/* round up to prime number */
-	if (size < 0)
-		return NULL;

  	tbl = alloc(st_table);
  	tbl->type = type;
-- 
1.8.0

--967339439-2143212571-1355084053=:64779
Content-Type: TEXT/PLAIN; charset=US-ASCII; name=0001-Fix-Wtautological-compare-warnings-with-clang.patch
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.BSF.2.00.1212091214120.64779-Fqwm7F1mg36Nj9Bq2fkWzw@public.gmane.org>
Content-Description: 
Content-Disposition: attachment; filename=0001-Fix-Wtautological-compare-warnings-with-clang.patch

RnJvbSAxZjkxYWVjYTJkOWZlY2QxMzAxZDZmZTI3MzFhNzlkODY0MGIyMDcy
IE1vbiBTZXAgMTcgMDA6MDA6MDAgMjAwMQ0KRnJvbTogR2FycmV0dCBDb29w
ZXIgPHlhbmVnb21pQGdtYWlsLmNvbT4NCkRhdGU6IFN1biwgOSBEZWMgMjAx
MiAwMjo0NDozMiAtMDgwMA0KU3ViamVjdDogW1BBVENIIHYyIDEvM10gRml4
IC1XdGF1dG9sb2dpY2FsLWNvbXBhcmUgd2FybmluZ3Mgd2l0aCBjbGFuZw0K
DQpWMToNCg0KVGhlIG5vdGVkIGJyYW5jaCBjb25kaXRpb25zIGFyZSB0cnVl
IG9yIGZhbHNlIGFuZCBoZW5jZSBub3QNCnRlc3RlZC9leGVjdXRlZCBhcyBk
ZXNpZ25lZC4NCg0KUHJ1bmUgdGhlIGFsd2F5cyB0cnVlL2ZhbHNlIGNvbmRp
dGlvbmFsIGNoZWNrcy4NCg0KVjI6DQoNCkZpeCB0aGUgY29uZGl0aW9uYWwg
Y2hlY2sgaW4gb3NtX3ZlbmRvcl9uZXcgYnkgcHJvcGVybHkgY2hlY2tpbmcg
Zm9yDQpJQl9TVUNDRVNTIGluc3RlYWQgb2YgYXNzdW1pbmcgdGhhdCB2YWx1
ZXMgPCAwIGRlbm90ZXMgZXJyb3IgYXMgdGhpcw0KaXNuJ3QgcG9zc2libGUg
Z2l2ZW4gdGhlIGVudW0gZGVmaW5pdGlvbi4NCg0KU2lnbmVkLW9mZi1ieTog
R2FycmV0dCBDb29wZXIgPHlhbmVnb21pQGdtYWlsLmNvbT4NCi0tLQ0KIGxp
YnZlbmRvci9vc21fdmVuZG9yX2lidW1hZC5jIHwgMiArLQ0KIG9wZW5zbS9v
c21fcW9zX3BhcnNlcl95LnkgICAgIHwgNiArKy0tLS0NCiBvcGVuc20vc3Qu
YyAgICAgICAgICAgICAgICAgICB8IDIgLS0NCiAzIGZpbGVzIGNoYW5nZWQs
IDMgaW5zZXJ0aW9ucygrKSwgNyBkZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdp
dCBhL2xpYnZlbmRvci9vc21fdmVuZG9yX2lidW1hZC5jIGIvbGlidmVuZG9y
L29zbV92ZW5kb3JfaWJ1bWFkLmMNCmluZGV4IGNhMzIwYTYuLjYzYjk1OTQg
MTAwNjQ0DQotLS0gYS9saWJ2ZW5kb3Ivb3NtX3ZlbmRvcl9pYnVtYWQuYw0K
KysrIGIvbGlidmVuZG9yL29zbV92ZW5kb3JfaWJ1bWFkLmMNCkBAIC01NzQs
NyArNTc0LDcgQEAgb3NtX3ZlbmRvcl90ICpvc21fdmVuZG9yX25ldyhJTiBv
c21fbG9nX3QgKiBjb25zdCBwX2xvZywNCiANCiAJbWVtc2V0KHBfdmVuZCwg
MCwgc2l6ZW9mKCpwX3ZlbmQpKTsNCiANCi0JaWYgKG9zbV92ZW5kb3JfaW5p
dChwX3ZlbmQsIHBfbG9nLCB0aW1lb3V0KSA8IDApIHsNCisJaWYgKG9zbV92
ZW5kb3JfaW5pdChwX3ZlbmQsIHBfbG9nLCB0aW1lb3V0KSAhPSBJQl9TVUND
RVNTKSB7DQogCQlmcmVlKHBfdmVuZCk7DQogCQlwX3ZlbmQgPSBOVUxMOw0K
IAl9DQpkaWZmIC0tZ2l0IGEvb3BlbnNtL29zbV9xb3NfcGFyc2VyX3kueSBi
L29wZW5zbS9vc21fcW9zX3BhcnNlcl95LnkNCmluZGV4IDRlMDFlZDQuLjBi
NTY3YzggMTAwNjQ0DQotLS0gYS9vcGVuc20vb3NtX3Fvc19wYXJzZXJfeS55
DQorKysgYi9vcGVuc20vb3NtX3Fvc19wYXJzZXJfeS55DQpAQCAtMTY0OCw4
ICsxNjQ4LDcgQEAgc2wydmxfc2NvcGVfZnJvbV9saXN0X29mX3Jhbmdlczog
bGlzdF9vZl9yYW5nZXMgew0KICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgbnVtX3BhaXIgPSAodWludDY0X3QqKWNsX2xpc3Rfb2JqKGxpc3Rf
aXRlcmF0b3IpOw0KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
aWYgKG51bV9wYWlyKQ0KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgew0KLSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGlm
ICggbnVtX3BhaXJbMF0gPCAwIHx8DQotICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICBudW1fcGFpclsxXSA+PSBPU01fUU9TX1BP
TElDWV9NQVhfUE9SVFNfT05fU1dJVENIICkNCisgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICBpZiAoIG51bV9wYWlyWzFdID49IE9TTV9R
T1NfUE9MSUNZX01BWF9QT1JUU19PTl9TV0lUQ0ggKQ0KICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIHsNCiAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgeXllcnJvcigicG9ydCBudW1iZXIg
b3V0IG9mIHJhbmdlICdmcm9tJyBsaXN0Iik7DQogICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIGZyZWUobnVtX3BhaXIpOw0KQEAg
LTE2ODAsOCArMTY3OSw3IEBAIHNsMnZsX3Njb3BlX3RvX2xpc3Rfb2ZfcmFu
Z2VzOiBsaXN0X29mX3JhbmdlcyB7DQogICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICBudW1fcGFpciA9ICh1aW50NjRfdCopY2xfbGlzdF9vYmoo
bGlzdF9pdGVyYXRvcik7DQogICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICBpZiAobnVtX3BhaXIpDQogICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICB7DQotICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgaWYgKCBudW1fcGFpclswXSA8IDAgfHwNCi0gICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIG51bV9wYWlyWzFdID49IE9TTV9R
T1NfUE9MSUNZX01BWF9QT1JUU19PTl9TV0lUQ0ggKQ0KKyAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIGlmICggbnVtX3BhaXJbMV0gPj0g
T1NNX1FPU19QT0xJQ1lfTUFYX1BPUlRTX09OX1NXSVRDSCApDQogICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgew0KICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICB5eWVycm9yKCJwb3J0IG51
bWJlciBvdXQgb2YgcmFuZ2UgJ3RvJyBsaXN0Iik7DQogICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIGZyZWUobnVtX3BhaXIpOw0K
ZGlmZiAtLWdpdCBhL29wZW5zbS9zdC5jIGIvb3BlbnNtL3N0LmMNCmluZGV4
IDc1NDY0OGMuLjE0ZGI0NTYgMTAwNjQ0DQotLS0gYS9vcGVuc20vc3QuYw0K
KysrIGIvb3BlbnNtL3N0LmMNCkBAIC0xOTYsOCArMTk2LDYgQEAgc2l6ZV90
IHNpemU7DQogI2VuZGlmDQogDQogCXNpemUgPSBuZXdfc2l6ZShzaXplKTsJ
Lyogcm91bmQgdXAgdG8gcHJpbWUgbnVtYmVyICovDQotCWlmIChzaXplIDwg
MCkNCi0JCXJldHVybiBOVUxMOw0KIA0KIAl0YmwgPSBhbGxvYyhzdF90YWJs
ZSk7DQogCXRibC0+dHlwZSA9IHR5cGU7DQotLSANCjEuOC4wDQoNCg==

--967339439-2143212571-1355084053=:64779--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

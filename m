From: Garrett Cooper <yanegomi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/3] Fix -Wtautological-compare warnings with clang
Date: Sun, 9 Dec 2012 03:05:08 -0800 (PST)
Message-ID: <alpine.BSF.2.00.1212090303280.64779@toaster.local>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="967339439-1046470703-1355051109=:64779"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--967339439-1046470703-1355051109=:64779
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII

These branch conditions are always > 0 (or false) and hence not executed
as designed.

Also, enum by definition is always > 0, so the error condition isn't
triggered ever.

Signed-off-by: Garrett Cooper <yanegomi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
  libvendor/osm_vendor_ibumad.c | 5 +----
  opensm/osm_qos_parser_y.y     | 6 ++----
  opensm/st.c                   | 2 --
  3 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/libvendor/osm_vendor_ibumad.c b/libvendor/osm_vendor_ibumad.c
index ca320a6..cdb18e9 100644
--- a/libvendor/osm_vendor_ibumad.c
+++ b/libvendor/osm_vendor_ibumad.c
@@ -574,10 +574,7 @@ osm_vendor_t *osm_vendor_new(IN osm_log_t * const p_log,

  	memset(p_vend, 0, sizeof(*p_vend));

-	if (osm_vendor_init(p_vend, p_log, timeout) < 0) {
-		free(p_vend);
-		p_vend = NULL;
-	}
+	osm_vendor_init(p_vend, p_log, timeout);

  Exit:
  	OSM_LOG_EXIT(p_log);
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

--967339439-1046470703-1355051109=:64779
Content-Type: TEXT/PLAIN; charset=US-ASCII; name=0001-Fix-Wtautological-compare-warnings-with-clang.patch
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.BSF.2.00.1212090305080.64779-Fqwm7F1mg36Nj9Bq2fkWzw@public.gmane.org>
Content-Description: 
Content-Disposition: attachment; filename=0001-Fix-Wtautological-compare-warnings-with-clang.patch

RnJvbSA1NzI4NzllZmNlYTBlOGI0ZDIyMGMwODdiYTVjYzJlMjA5MmY4YmQ3
IE1vbiBTZXAgMTcgMDA6MDA6MDAgMjAwMQ0KRnJvbTogR2FycmV0dCBDb29w
ZXIgPHlhbmVnb21pQGdtYWlsLmNvbT4NCkRhdGU6IFN1biwgOSBEZWMgMjAx
MiAwMjo0NDozMiAtMDgwMA0KU3ViamVjdDogW1BBVENIIDEvM10gRml4IC1X
dGF1dG9sb2dpY2FsLWNvbXBhcmUgd2FybmluZ3Mgd2l0aCBjbGFuZw0KDQpU
aGVzZSBicmFuY2ggY29uZGl0aW9ucyBhcmUgYWx3YXlzID4gMCAob3IgZmFs
c2UpIGFuZCBoZW5jZSBub3QgZXhlY3V0ZWQNCmFzIGRlc2lnbmVkLg0KDQpB
bHNvLCBlbnVtIGJ5IGRlZmluaXRpb24gaXMgYWx3YXlzID4gMCwgc28gdGhl
IGVycm9yIGNvbmRpdGlvbiBpc24ndA0KdHJpZ2dlcmVkIGV2ZXIuDQoNClNp
Z25lZC1vZmYtYnk6IEdhcnJldHQgQ29vcGVyIDx5YW5lZ29taUBnbWFpbC5j
b20+DQotLS0NCiBsaWJ2ZW5kb3Ivb3NtX3ZlbmRvcl9pYnVtYWQuYyB8IDUg
Ky0tLS0NCiBvcGVuc20vb3NtX3Fvc19wYXJzZXJfeS55ICAgICB8IDYgKyst
LS0tDQogb3BlbnNtL3N0LmMgICAgICAgICAgICAgICAgICAgfCAyIC0tDQog
MyBmaWxlcyBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDEwIGRlbGV0aW9u
cygtKQ0KDQpkaWZmIC0tZ2l0IGEvbGlidmVuZG9yL29zbV92ZW5kb3JfaWJ1
bWFkLmMgYi9saWJ2ZW5kb3Ivb3NtX3ZlbmRvcl9pYnVtYWQuYw0KaW5kZXgg
Y2EzMjBhNi4uY2RiMThlOSAxMDA2NDQNCi0tLSBhL2xpYnZlbmRvci9vc21f
dmVuZG9yX2lidW1hZC5jDQorKysgYi9saWJ2ZW5kb3Ivb3NtX3ZlbmRvcl9p
YnVtYWQuYw0KQEAgLTU3NCwxMCArNTc0LDcgQEAgb3NtX3ZlbmRvcl90ICpv
c21fdmVuZG9yX25ldyhJTiBvc21fbG9nX3QgKiBjb25zdCBwX2xvZywNCiAN
CiAJbWVtc2V0KHBfdmVuZCwgMCwgc2l6ZW9mKCpwX3ZlbmQpKTsNCiANCi0J
aWYgKG9zbV92ZW5kb3JfaW5pdChwX3ZlbmQsIHBfbG9nLCB0aW1lb3V0KSA8
IDApIHsNCi0JCWZyZWUocF92ZW5kKTsNCi0JCXBfdmVuZCA9IE5VTEw7DQot
CX0NCisJb3NtX3ZlbmRvcl9pbml0KHBfdmVuZCwgcF9sb2csIHRpbWVvdXQp
Ow0KIA0KIEV4aXQ6DQogCU9TTV9MT0dfRVhJVChwX2xvZyk7DQpkaWZmIC0t
Z2l0IGEvb3BlbnNtL29zbV9xb3NfcGFyc2VyX3kueSBiL29wZW5zbS9vc21f
cW9zX3BhcnNlcl95LnkNCmluZGV4IDRlMDFlZDQuLjBiNTY3YzggMTAwNjQ0
DQotLS0gYS9vcGVuc20vb3NtX3Fvc19wYXJzZXJfeS55DQorKysgYi9vcGVu
c20vb3NtX3Fvc19wYXJzZXJfeS55DQpAQCAtMTY0OCw4ICsxNjQ4LDcgQEAg
c2wydmxfc2NvcGVfZnJvbV9saXN0X29mX3JhbmdlczogbGlzdF9vZl9yYW5n
ZXMgew0KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgbnVtX3Bh
aXIgPSAodWludDY0X3QqKWNsX2xpc3Rfb2JqKGxpc3RfaXRlcmF0b3IpOw0K
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgaWYgKG51bV9wYWly
KQ0KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgew0KLSAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGlmICggbnVtX3BhaXJb
MF0gPCAwIHx8DQotICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICBudW1fcGFpclsxXSA+PSBPU01fUU9TX1BPTElDWV9NQVhfUE9S
VFNfT05fU1dJVENIICkNCisgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICBpZiAoIG51bV9wYWlyWzFdID49IE9TTV9RT1NfUE9MSUNZX01B
WF9QT1JUU19PTl9TV0lUQ0ggKQ0KICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgIHsNCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgeXllcnJvcigicG9ydCBudW1iZXIgb3V0IG9mIHJhbmdl
ICdmcm9tJyBsaXN0Iik7DQogICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgIGZyZWUobnVtX3BhaXIpOw0KQEAgLTE2ODAsOCArMTY3
OSw3IEBAIHNsMnZsX3Njb3BlX3RvX2xpc3Rfb2ZfcmFuZ2VzOiBsaXN0X29m
X3JhbmdlcyB7DQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBu
dW1fcGFpciA9ICh1aW50NjRfdCopY2xfbGlzdF9vYmoobGlzdF9pdGVyYXRv
cik7DQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBpZiAobnVt
X3BhaXIpDQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB7DQot
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgaWYgKCBudW1f
cGFpclswXSA8IDAgfHwNCi0gICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgIG51bV9wYWlyWzFdID49IE9TTV9RT1NfUE9MSUNZX01B
WF9QT1JUU19PTl9TV0lUQ0ggKQ0KKyAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgIGlmICggbnVtX3BhaXJbMV0gPj0gT1NNX1FPU19QT0xJ
Q1lfTUFYX1BPUlRTX09OX1NXSVRDSCApDQogICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgew0KICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICB5eWVycm9yKCJwb3J0IG51bWJlciBvdXQgb2Yg
cmFuZ2UgJ3RvJyBsaXN0Iik7DQogICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIGZyZWUobnVtX3BhaXIpOw0KZGlmZiAtLWdpdCBh
L29wZW5zbS9zdC5jIGIvb3BlbnNtL3N0LmMNCmluZGV4IDc1NDY0OGMuLjE0
ZGI0NTYgMTAwNjQ0DQotLS0gYS9vcGVuc20vc3QuYw0KKysrIGIvb3BlbnNt
L3N0LmMNCkBAIC0xOTYsOCArMTk2LDYgQEAgc2l6ZV90IHNpemU7DQogI2Vu
ZGlmDQogDQogCXNpemUgPSBuZXdfc2l6ZShzaXplKTsJLyogcm91bmQgdXAg
dG8gcHJpbWUgbnVtYmVyICovDQotCWlmIChzaXplIDwgMCkNCi0JCXJldHVy
biBOVUxMOw0KIA0KIAl0YmwgPSBhbGxvYyhzdF90YWJsZSk7DQogCXRibC0+
dHlwZSA9IHR5cGU7DQotLSANCjEuOC4wDQoNCg==

--967339439-1046470703-1355051109=:64779--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

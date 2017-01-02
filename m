From: Jinpu Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [PATCHv2 2/4] IB/core: export ib_get_cached_port_state
Date: Mon, 2 Jan 2017 13:19:24 +0100
Message-ID: <CAMGffEnBfwwCryZ3QGvuvE9-A9Gb6zCZ5-aVAHPYUb5NjEccNg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=f403045e357823fb4c05451b916d
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--f403045e357823fb4c05451b916d
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

>From 33f03b1f3a4e5a1f27b21378cd9e3e402e6e39fe Mon Sep 17 00:00:00 2001
From: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Date: Mon, 12 Dec 2016 10:12:39 +0100
Subject: [PATCH 2/4] IB/core: export ib_get_cached_port_state

Export function for rdma_cm, patch will follow.

Signed-off-by: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Reviewed-by: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Acked-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/cache.c | 18 ++++++++++++++++++
 include/rdma/ib_cache.h         | 13 +++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cach=
e.c
index 87fd7c3..f91886b 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -1021,6 +1021,24 @@ int ib_get_cached_lmc(struct ib_device *device,
 }
 EXPORT_SYMBOL(ib_get_cached_lmc);

+int ib_get_cached_port_state(struct ib_device   *device,
+                 u8                  port_num,
+                 enum ib_port_state *port_state)
+{
+    unsigned long flags;
+    int ret =3D 0;
+
+    if (port_num < rdma_start_port(device) || port_num > rdma_end_port(dev=
ice))
+        return -EINVAL;
+
+    read_lock_irqsave(&device->cache.lock, flags);
+    *port_state =3D device->cache.port_state_cache[port_num -
rdma_start_port(device)];
+    read_unlock_irqrestore(&device->cache.lock, flags);
+
+    return ret;
+}
+EXPORT_SYMBOL(ib_get_cached_port_state);
+
 static void ib_cache_update(struct ib_device *device,
                 u8                port)
 {
diff --git a/include/rdma/ib_cache.h b/include/rdma/ib_cache.h
index e30f19b..385ec88 100644
--- a/include/rdma/ib_cache.h
+++ b/include/rdma/ib_cache.h
@@ -165,4 +165,17 @@ int ib_get_cached_lmc(struct ib_device *device,
               u8                port_num,
               u8                *lmc);

+/**
+ * ib_get_cached_port_state - Returns a cached port state table entry
+ * @device: The device to query.
+ * @port_num: The port number of the device to query.
+ * @port_state: port_state for the specified port for that device.
+ *
+ * ib_get_cached_port_state() fetches the specified port_state table
entry stored in
+ * the local software cache.
+ */
+int ib_get_cached_port_state(struct ib_device *device,
+                  u8                port_num,
+                  enum ib_port_state *port_active);
+
 #endif /* _IB_CACHE_H */
--=20
2.7.4


--=20
Jinpu Wang
Linux Kernel Developer

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin

Tel:       +49 30 577 008  042
Fax:      +49 30 577 008 299
Email:    jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
URL:      https://www.profitbricks.de

Sitz der Gesellschaft: Berlin
Registergericht: Amtsgericht Charlottenburg, HRB 125506 B
Gesch=C3=A4ftsf=C3=BChrer: Achim Weiss

--f403045e357823fb4c05451b916d
Content-Type: text/x-patch; charset=US-ASCII;
	name="0002-IB-core-export-ib_get_cached_port_state.patch"
Content-Disposition: attachment;
	filename="0002-IB-core-export-ib_get_cached_port_state.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ixg1yic30

RnJvbSAzM2YwM2IxZjNhNGU1YTFmMjdiMjEzNzhjZDllM2U0MDJlNmUzOWZlIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBKYWNrIFdhbmcgPGppbnB1LndhbmdAcHJvZml0YnJpY2tzLmNv
bT4KRGF0ZTogTW9uLCAxMiBEZWMgMjAxNiAxMDoxMjozOSArMDEwMApTdWJqZWN0OiBbUEFUQ0gg
Mi80XSBJQi9jb3JlOiBleHBvcnQgaWJfZ2V0X2NhY2hlZF9wb3J0X3N0YXRlCgpFeHBvcnQgZnVu
Y3Rpb24gZm9yIHJkbWFfY20sIHBhdGNoIHdpbGwgZm9sbG93LgoKU2lnbmVkLW9mZi1ieTogSmFj
ayBXYW5nIDxqaW5wdS53YW5nQHByb2ZpdGJyaWNrcy5jb20+ClJldmlld2VkLWJ5OiBNaWNoYWVs
IFdhbmcgPHl1bi53YW5nQHByb2ZpdGJyaWNrcy5jb20+CkFja2VkLWJ5OiBTZWFuIEhlZnR5IDxz
ZWFuLmhlZnR5QGludGVsLmNvbT4KLS0tCiBkcml2ZXJzL2luZmluaWJhbmQvY29yZS9jYWNoZS5j
IHwgMTggKysrKysrKysrKysrKysrKysrCiBpbmNsdWRlL3JkbWEvaWJfY2FjaGUuaCAgICAgICAg
IHwgMTMgKysrKysrKysrKysrKwogMiBmaWxlcyBjaGFuZ2VkLCAzMSBpbnNlcnRpb25zKCspCgpk
aWZmIC0tZ2l0IGEvZHJpdmVycy9pbmZpbmliYW5kL2NvcmUvY2FjaGUuYyBiL2RyaXZlcnMvaW5m
aW5pYmFuZC9jb3JlL2NhY2hlLmMKaW5kZXggODdmZDdjMy4uZjkxODg2YiAxMDA2NDQKLS0tIGEv
ZHJpdmVycy9pbmZpbmliYW5kL2NvcmUvY2FjaGUuYworKysgYi9kcml2ZXJzL2luZmluaWJhbmQv
Y29yZS9jYWNoZS5jCkBAIC0xMDIxLDYgKzEwMjEsMjQgQEAgaW50IGliX2dldF9jYWNoZWRfbG1j
KHN0cnVjdCBpYl9kZXZpY2UgKmRldmljZSwKIH0KIEVYUE9SVF9TWU1CT0woaWJfZ2V0X2NhY2hl
ZF9sbWMpOwogCitpbnQgaWJfZ2V0X2NhY2hlZF9wb3J0X3N0YXRlKHN0cnVjdCBpYl9kZXZpY2Ug
ICAqZGV2aWNlLAorCQkJICAgICB1OCAgICAgICAgICAgICAgICAgIHBvcnRfbnVtLAorCQkJICAg
ICBlbnVtIGliX3BvcnRfc3RhdGUgKnBvcnRfc3RhdGUpCit7CisJdW5zaWduZWQgbG9uZyBmbGFn
czsKKwlpbnQgcmV0ID0gMDsKKworCWlmIChwb3J0X251bSA8IHJkbWFfc3RhcnRfcG9ydChkZXZp
Y2UpIHx8IHBvcnRfbnVtID4gcmRtYV9lbmRfcG9ydChkZXZpY2UpKQorCQlyZXR1cm4gLUVJTlZB
TDsKKworCXJlYWRfbG9ja19pcnFzYXZlKCZkZXZpY2UtPmNhY2hlLmxvY2ssIGZsYWdzKTsKKwkq
cG9ydF9zdGF0ZSA9IGRldmljZS0+Y2FjaGUucG9ydF9zdGF0ZV9jYWNoZVtwb3J0X251bSAtIHJk
bWFfc3RhcnRfcG9ydChkZXZpY2UpXTsKKwlyZWFkX3VubG9ja19pcnFyZXN0b3JlKCZkZXZpY2Ut
PmNhY2hlLmxvY2ssIGZsYWdzKTsKKworCXJldHVybiByZXQ7Cit9CitFWFBPUlRfU1lNQk9MKGli
X2dldF9jYWNoZWRfcG9ydF9zdGF0ZSk7CisKIHN0YXRpYyB2b2lkIGliX2NhY2hlX3VwZGF0ZShz
dHJ1Y3QgaWJfZGV2aWNlICpkZXZpY2UsCiAJCQkgICAgdTggICAgICAgICAgICAgICAgcG9ydCkK
IHsKZGlmZiAtLWdpdCBhL2luY2x1ZGUvcmRtYS9pYl9jYWNoZS5oIGIvaW5jbHVkZS9yZG1hL2li
X2NhY2hlLmgKaW5kZXggZTMwZjE5Yi4uMzg1ZWM4OCAxMDA2NDQKLS0tIGEvaW5jbHVkZS9yZG1h
L2liX2NhY2hlLmgKKysrIGIvaW5jbHVkZS9yZG1hL2liX2NhY2hlLmgKQEAgLTE2NSw0ICsxNjUs
MTcgQEAgaW50IGliX2dldF9jYWNoZWRfbG1jKHN0cnVjdCBpYl9kZXZpY2UgKmRldmljZSwKIAkJ
ICAgICAgdTggICAgICAgICAgICAgICAgcG9ydF9udW0sCiAJCSAgICAgIHU4ICAgICAgICAgICAg
ICAgICpsbWMpOwogCisvKioKKyAqIGliX2dldF9jYWNoZWRfcG9ydF9zdGF0ZSAtIFJldHVybnMg
YSBjYWNoZWQgcG9ydCBzdGF0ZSB0YWJsZSBlbnRyeQorICogQGRldmljZTogVGhlIGRldmljZSB0
byBxdWVyeS4KKyAqIEBwb3J0X251bTogVGhlIHBvcnQgbnVtYmVyIG9mIHRoZSBkZXZpY2UgdG8g
cXVlcnkuCisgKiBAcG9ydF9zdGF0ZTogcG9ydF9zdGF0ZSBmb3IgdGhlIHNwZWNpZmllZCBwb3J0
IGZvciB0aGF0IGRldmljZS4KKyAqCisgKiBpYl9nZXRfY2FjaGVkX3BvcnRfc3RhdGUoKSBmZXRj
aGVzIHRoZSBzcGVjaWZpZWQgcG9ydF9zdGF0ZSB0YWJsZSBlbnRyeSBzdG9yZWQgaW4KKyAqIHRo
ZSBsb2NhbCBzb2Z0d2FyZSBjYWNoZS4KKyAqLworaW50IGliX2dldF9jYWNoZWRfcG9ydF9zdGF0
ZShzdHJ1Y3QgaWJfZGV2aWNlICpkZXZpY2UsCisJCQkgICAgICB1OCAgICAgICAgICAgICAgICBw
b3J0X251bSwKKwkJCSAgICAgIGVudW0gaWJfcG9ydF9zdGF0ZSAqcG9ydF9hY3RpdmUpOworCiAj
ZW5kaWYgLyogX0lCX0NBQ0hFX0ggKi8KLS0gCjIuNy40Cgo=
--f403045e357823fb4c05451b916d--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

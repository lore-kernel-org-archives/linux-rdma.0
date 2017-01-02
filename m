From: Jinpu Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [PATCHv2 1/4] IB/core: add port state cache
Date: Mon, 2 Jan 2017 13:17:36 +0100
Message-ID: <CAMGffEmYeYeRVk84GY1CWekNHF7_V4Lo4PDxoGb5wAd8-Tnn7Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001a113d0e88b6cb5605451b8af8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--001a113d0e88b6cb5605451b8af8
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

To avoid gmail mangle the format, I also put it attached.

>From 83a45b0e34bb8515ec9db51629aa4e7e37dfc2e8 Mon Sep 17 00:00:00 2001
From: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Date: Mon, 12 Dec 2016 09:52:42 +0100
Subject: [PATCH 1/4] IB/core: add port state cache

We need a port state cache in ib_core, later we will use in rdma_cm.

Signed-off-by: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Reviewed-by: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Acked-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/cache.c | 10 +++++++++-
 include/rdma/ib_verbs.h         |  1 +
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cach=
e.c
index ae04826..87fd7c3 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -1105,6 +1105,8 @@ static void ib_cache_update(struct ib_device *device,
     }

     device->cache.lmc_cache[port - rdma_start_port(device)] =3D tprops->lm=
c;
+    device->cache.port_state_cache[port - rdma_start_port(device)] =3D
+        tprops->state;

     write_unlock_irq(&device->cache.lock);

@@ -1164,7 +1166,11 @@ int ib_cache_setup_one(struct ib_device *device)
                       (rdma_end_port(device) -
                        rdma_start_port(device) + 1),
                       GFP_KERNEL);
-    if (!device->cache.pkey_cache ||
+    device->cache.port_state_cache =3D kmalloc(sizeof
*device->cache.port_state_cache *
+                      (rdma_end_port(device) -
+                       rdma_start_port(device) + 1),
+                      GFP_KERNEL);
+    if (!device->cache.pkey_cache || !device->cache.port_state_cache ||
         !device->cache.lmc_cache) {
         err =3D -ENOMEM;
         goto free;
@@ -1190,6 +1196,7 @@ int ib_cache_setup_one(struct ib_device *device)
 free:
     kfree(device->cache.pkey_cache);
     kfree(device->cache.lmc_cache);
+    kfree(device->cache.port_state_cache);
     return err;
 }

@@ -1211,6 +1218,7 @@ void ib_cache_release_one(struct ib_device *device)
     gid_table_release_one(device);
     kfree(device->cache.pkey_cache);
     kfree(device->cache.lmc_cache);
+    kfree(device->cache.port_state_cache);
 }

 void ib_cache_cleanup_one(struct ib_device *device)
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 8029d2a..7115c0f 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1781,6 +1781,7 @@ struct ib_cache {
     struct ib_pkey_cache  **pkey_cache;
     struct ib_gid_table   **gid_cache;
     u8                     *lmc_cache;
+    enum ib_port_state     *port_state_cache;
 };

 struct ib_dma_mapping_ops {
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

--001a113d0e88b6cb5605451b8af8
Content-Type: text/x-patch; charset=US-ASCII;
	name="0001-IB-core-add-port-state-cache.patch"
Content-Disposition: attachment;
	filename="0001-IB-core-add-port-state-cache.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ixg1wydd0

RnJvbSA4M2E0NWIwZTM0YmI4NTE1ZWM5ZGI1MTYyOWFhNGU3ZTM3ZGZjMmU4IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBKYWNrIFdhbmcgPGppbnB1LndhbmdAcHJvZml0YnJpY2tzLmNv
bT4KRGF0ZTogTW9uLCAxMiBEZWMgMjAxNiAwOTo1Mjo0MiArMDEwMApTdWJqZWN0OiBbUEFUQ0gg
MS80XSBJQi9jb3JlOiBhZGQgcG9ydCBzdGF0ZSBjYWNoZQoKV2UgbmVlZCBhIHBvcnQgc3RhdGUg
Y2FjaGUgaW4gaWJfY29yZSwgbGF0ZXIgd2Ugd2lsbCB1c2UgaW4gcmRtYV9jbS4KClNpZ25lZC1v
ZmYtYnk6IEphY2sgV2FuZyA8amlucHUud2FuZ0Bwcm9maXRicmlja3MuY29tPgpSZXZpZXdlZC1i
eTogTWljaGFlbCBXYW5nIDx5dW4ud2FuZ0Bwcm9maXRicmlja3MuY29tPgpBY2tlZC1ieTogU2Vh
biBIZWZ0eSA8c2Vhbi5oZWZ0eUBpbnRlbC5jb20+Ci0tLQogZHJpdmVycy9pbmZpbmliYW5kL2Nv
cmUvY2FjaGUuYyB8IDEwICsrKysrKysrKy0KIGluY2x1ZGUvcmRtYS9pYl92ZXJicy5oICAgICAg
ICAgfCAgMSArCiAyIGZpbGVzIGNoYW5nZWQsIDEwIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24o
LSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL2luZmluaWJhbmQvY29yZS9jYWNoZS5jIGIvZHJpdmVy
cy9pbmZpbmliYW5kL2NvcmUvY2FjaGUuYwppbmRleCBhZTA0ODI2Li44N2ZkN2MzIDEwMDY0NAot
LS0gYS9kcml2ZXJzL2luZmluaWJhbmQvY29yZS9jYWNoZS5jCisrKyBiL2RyaXZlcnMvaW5maW5p
YmFuZC9jb3JlL2NhY2hlLmMKQEAgLTExMDUsNiArMTEwNSw4IEBAIHN0YXRpYyB2b2lkIGliX2Nh
Y2hlX3VwZGF0ZShzdHJ1Y3QgaWJfZGV2aWNlICpkZXZpY2UsCiAJfQogCiAJZGV2aWNlLT5jYWNo
ZS5sbWNfY2FjaGVbcG9ydCAtIHJkbWFfc3RhcnRfcG9ydChkZXZpY2UpXSA9IHRwcm9wcy0+bG1j
OworCWRldmljZS0+Y2FjaGUucG9ydF9zdGF0ZV9jYWNoZVtwb3J0IC0gcmRtYV9zdGFydF9wb3J0
KGRldmljZSldID0KKwkJdHByb3BzLT5zdGF0ZTsKIAogCXdyaXRlX3VubG9ja19pcnEoJmRldmlj
ZS0+Y2FjaGUubG9jayk7CiAKQEAgLTExNjQsNyArMTE2NiwxMSBAQCBpbnQgaWJfY2FjaGVfc2V0
dXBfb25lKHN0cnVjdCBpYl9kZXZpY2UgKmRldmljZSkKIAkJCQkJICAocmRtYV9lbmRfcG9ydChk
ZXZpY2UpIC0KIAkJCQkJICAgcmRtYV9zdGFydF9wb3J0KGRldmljZSkgKyAxKSwKIAkJCQkJICBH
RlBfS0VSTkVMKTsKLQlpZiAoIWRldmljZS0+Y2FjaGUucGtleV9jYWNoZSB8fAorCWRldmljZS0+
Y2FjaGUucG9ydF9zdGF0ZV9jYWNoZSA9IGttYWxsb2Moc2l6ZW9mICpkZXZpY2UtPmNhY2hlLnBv
cnRfc3RhdGVfY2FjaGUgKgorCQkJCQkgIChyZG1hX2VuZF9wb3J0KGRldmljZSkgLQorCQkJCQkg
ICByZG1hX3N0YXJ0X3BvcnQoZGV2aWNlKSArIDEpLAorCQkJCQkgIEdGUF9LRVJORUwpOworCWlm
ICghZGV2aWNlLT5jYWNoZS5wa2V5X2NhY2hlIHx8ICFkZXZpY2UtPmNhY2hlLnBvcnRfc3RhdGVf
Y2FjaGUgfHwKIAkgICAgIWRldmljZS0+Y2FjaGUubG1jX2NhY2hlKSB7CiAJCWVyciA9IC1FTk9N
RU07CiAJCWdvdG8gZnJlZTsKQEAgLTExOTAsNiArMTE5Niw3IEBAIGludCBpYl9jYWNoZV9zZXR1
cF9vbmUoc3RydWN0IGliX2RldmljZSAqZGV2aWNlKQogZnJlZToKIAlrZnJlZShkZXZpY2UtPmNh
Y2hlLnBrZXlfY2FjaGUpOwogCWtmcmVlKGRldmljZS0+Y2FjaGUubG1jX2NhY2hlKTsKKwlrZnJl
ZShkZXZpY2UtPmNhY2hlLnBvcnRfc3RhdGVfY2FjaGUpOwogCXJldHVybiBlcnI7CiB9CiAKQEAg
LTEyMTEsNiArMTIxOCw3IEBAIHZvaWQgaWJfY2FjaGVfcmVsZWFzZV9vbmUoc3RydWN0IGliX2Rl
dmljZSAqZGV2aWNlKQogCWdpZF90YWJsZV9yZWxlYXNlX29uZShkZXZpY2UpOwogCWtmcmVlKGRl
dmljZS0+Y2FjaGUucGtleV9jYWNoZSk7CiAJa2ZyZWUoZGV2aWNlLT5jYWNoZS5sbWNfY2FjaGUp
OworCWtmcmVlKGRldmljZS0+Y2FjaGUucG9ydF9zdGF0ZV9jYWNoZSk7CiB9CiAKIHZvaWQgaWJf
Y2FjaGVfY2xlYW51cF9vbmUoc3RydWN0IGliX2RldmljZSAqZGV2aWNlKQpkaWZmIC0tZ2l0IGEv
aW5jbHVkZS9yZG1hL2liX3ZlcmJzLmggYi9pbmNsdWRlL3JkbWEvaWJfdmVyYnMuaAppbmRleCA4
MDI5ZDJhLi43MTE1YzBmIDEwMDY0NAotLS0gYS9pbmNsdWRlL3JkbWEvaWJfdmVyYnMuaAorKysg
Yi9pbmNsdWRlL3JkbWEvaWJfdmVyYnMuaApAQCAtMTc4MSw2ICsxNzgxLDcgQEAgc3RydWN0IGli
X2NhY2hlIHsKIAlzdHJ1Y3QgaWJfcGtleV9jYWNoZSAgKipwa2V5X2NhY2hlOwogCXN0cnVjdCBp
Yl9naWRfdGFibGUgICAqKmdpZF9jYWNoZTsKIAl1OCAgICAgICAgICAgICAgICAgICAgICpsbWNf
Y2FjaGU7CisJZW51bSBpYl9wb3J0X3N0YXRlICAgICAqcG9ydF9zdGF0ZV9jYWNoZTsKIH07CiAK
IHN0cnVjdCBpYl9kbWFfbWFwcGluZ19vcHMgewotLSAKMi43LjQKCg==
--001a113d0e88b6cb5605451b8af8--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

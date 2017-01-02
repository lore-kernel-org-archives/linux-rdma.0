From: Jinpu Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [PATCHv2 3/4] cma: resolve to first active ib port
Date: Mon, 2 Jan 2017 13:20:44 +0100
Message-ID: <CAMGffE=B6v=Jat7=J1RrUFt-SYuwj2OPLgg-Q-j8W4pM4FhDLg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001a113cfa3ee9ccdb05451b951b
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--001a113cfa3ee9ccdb05451b951b
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

>From b52637c12a7805ee3e500dc3d97c2fe300c02ff8 Mon Sep 17 00:00:00 2001
From: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Date: Mon, 12 Dec 2016 10:23:55 +0100
Subject: [PATCH 3/4] cma: resolve to first active ib port

When resolve addr if we don't give src addr, cma core will try to resolve t=
o
ib device on itself, current logic is only check if it has same
subnet_prefix, which is not enough if we use default well known gid,
we should also check if port is active.

v3: use cached port_active state in ib_core.

Signed-off-by: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Reviewed-by: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Acked-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/cma.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 8c30e3d..fcd5047 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -709,6 +709,7 @@ static int cma_resolve_ib_dev(struct
rdma_id_private *id_priv)
     union ib_gid gid, sgid, *dgid;
     u16 pkey, index;
     u8 p;
+    enum ib_port_state port_state;
     int i;

     cma_dev =3D NULL;
@@ -724,6 +725,8 @@ static int cma_resolve_ib_dev(struct
rdma_id_private *id_priv)
             if (ib_find_cached_pkey(cur_dev->device, p, pkey, &index))
                 continue;

+            if (ib_get_cached_port_state(cur_dev->device, p, &port_state))
+                continue;
             for (i =3D 0; !ib_get_cached_gid(cur_dev->device, p, i,
                                &gid, NULL);
                  i++) {
@@ -735,7 +738,8 @@ static int cma_resolve_ib_dev(struct
rdma_id_private *id_priv)
                 }

                 if (!cma_dev && (gid.global.subnet_prefix =3D=3D
-                         dgid->global.subnet_prefix)) {
+                    dgid->global.subnet_prefix) &&
+                    port_state =3D=3D IB_PORT_ACTIVE) {
                     cma_dev =3D cur_dev;
                     sgid =3D gid;
                     id_priv->id.port_num =3D p;
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

--001a113cfa3ee9ccdb05451b951b
Content-Type: text/x-patch; charset=US-ASCII;
	name="0003-cma-resolve-to-first-active-ib-port.patch"
Content-Disposition: attachment;
	filename="0003-cma-resolve-to-first-active-ib-port.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ixg211wl0

RnJvbSBiNTI2MzdjMTJhNzgwNWVlM2U1MDBkYzNkOTdjMmZlMzAwYzAyZmY4IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBKYWNrIFdhbmcgPGppbnB1LndhbmdAcHJvZml0YnJpY2tzLmNv
bT4KRGF0ZTogTW9uLCAxMiBEZWMgMjAxNiAxMDoyMzo1NSArMDEwMApTdWJqZWN0OiBbUEFUQ0gg
My80XSBjbWE6IHJlc29sdmUgdG8gZmlyc3QgYWN0aXZlIGliIHBvcnQKCldoZW4gcmVzb2x2ZSBh
ZGRyIGlmIHdlIGRvbid0IGdpdmUgc3JjIGFkZHIsIGNtYSBjb3JlIHdpbGwgdHJ5IHRvIHJlc29s
dmUgdG8KaWIgZGV2aWNlIG9uIGl0c2VsZiwgY3VycmVudCBsb2dpYyBpcyBvbmx5IGNoZWNrIGlm
IGl0IGhhcyBzYW1lCnN1Ym5ldF9wcmVmaXgsIHdoaWNoIGlzIG5vdCBlbm91Z2ggaWYgd2UgdXNl
IGRlZmF1bHQgd2VsbCBrbm93biBnaWQsCndlIHNob3VsZCBhbHNvIGNoZWNrIGlmIHBvcnQgaXMg
YWN0aXZlLgoKdjM6IHVzZSBjYWNoZWQgcG9ydF9hY3RpdmUgc3RhdGUgaW4gaWJfY29yZS4KClNp
Z25lZC1vZmYtYnk6IEphY2sgV2FuZyA8amlucHUud2FuZ0Bwcm9maXRicmlja3MuY29tPgpSZXZp
ZXdlZC1ieTogTWljaGFlbCBXYW5nIDx5dW4ud2FuZ0Bwcm9maXRicmlja3MuY29tPgpBY2tlZC1i
eTogU2VhbiBIZWZ0eSA8c2Vhbi5oZWZ0eUBpbnRlbC5jb20+Ci0tLQogZHJpdmVycy9pbmZpbmli
YW5kL2NvcmUvY21hLmMgfCA2ICsrKysrLQogMSBmaWxlIGNoYW5nZWQsIDUgaW5zZXJ0aW9ucygr
KSwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvaW5maW5pYmFuZC9jb3JlL2Nt
YS5jIGIvZHJpdmVycy9pbmZpbmliYW5kL2NvcmUvY21hLmMKaW5kZXggOGMzMGUzZC4uZmNkNTA0
NyAxMDA2NDQKLS0tIGEvZHJpdmVycy9pbmZpbmliYW5kL2NvcmUvY21hLmMKKysrIGIvZHJpdmVy
cy9pbmZpbmliYW5kL2NvcmUvY21hLmMKQEAgLTcwOSw2ICs3MDksNyBAQCBzdGF0aWMgaW50IGNt
YV9yZXNvbHZlX2liX2RldihzdHJ1Y3QgcmRtYV9pZF9wcml2YXRlICppZF9wcml2KQogCXVuaW9u
IGliX2dpZCBnaWQsIHNnaWQsICpkZ2lkOwogCXUxNiBwa2V5LCBpbmRleDsKIAl1OCBwOworCWVu
dW0gaWJfcG9ydF9zdGF0ZSBwb3J0X3N0YXRlOwogCWludCBpOwogCiAJY21hX2RldiA9IE5VTEw7
CkBAIC03MjQsNiArNzI1LDggQEAgc3RhdGljIGludCBjbWFfcmVzb2x2ZV9pYl9kZXYoc3RydWN0
IHJkbWFfaWRfcHJpdmF0ZSAqaWRfcHJpdikKIAkJCWlmIChpYl9maW5kX2NhY2hlZF9wa2V5KGN1
cl9kZXYtPmRldmljZSwgcCwgcGtleSwgJmluZGV4KSkKIAkJCQljb250aW51ZTsKIAorCQkJaWYg
KGliX2dldF9jYWNoZWRfcG9ydF9zdGF0ZShjdXJfZGV2LT5kZXZpY2UsIHAsICZwb3J0X3N0YXRl
KSkKKwkJCQljb250aW51ZTsKIAkJCWZvciAoaSA9IDA7ICFpYl9nZXRfY2FjaGVkX2dpZChjdXJf
ZGV2LT5kZXZpY2UsIHAsIGksCiAJCQkJCQkgICAgICAgJmdpZCwgTlVMTCk7CiAJCQkgICAgIGkr
KykgewpAQCAtNzM1LDcgKzczOCw4IEBAIHN0YXRpYyBpbnQgY21hX3Jlc29sdmVfaWJfZGV2KHN0
cnVjdCByZG1hX2lkX3ByaXZhdGUgKmlkX3ByaXYpCiAJCQkJfQogCiAJCQkJaWYgKCFjbWFfZGV2
ICYmIChnaWQuZ2xvYmFsLnN1Ym5ldF9wcmVmaXggPT0KLQkJCQkJCSBkZ2lkLT5nbG9iYWwuc3Vi
bmV0X3ByZWZpeCkpIHsKKwkJCQkgICAgZGdpZC0+Z2xvYmFsLnN1Ym5ldF9wcmVmaXgpICYmCisJ
CQkJICAgIHBvcnRfc3RhdGUgPT0gSUJfUE9SVF9BQ1RJVkUpIHsKIAkJCQkJY21hX2RldiA9IGN1
cl9kZXY7CiAJCQkJCXNnaWQgPSBnaWQ7CiAJCQkJCWlkX3ByaXYtPmlkLnBvcnRfbnVtID0gcDsK
LS0gCjIuNy40Cgo=
--001a113cfa3ee9ccdb05451b951b--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

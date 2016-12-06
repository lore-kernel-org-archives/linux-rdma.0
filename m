From: Jinpu Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [PATCH] cma: resolve to first active IB port
Date: Tue, 6 Dec 2016 12:16:29 +0100
Message-ID: <CAMGffE=mSpm+zuG9wo-GV0HT4-ewg34uvOKCUrPRC61ATjxyVg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001a113aced86ff9360542fb8a1b
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--001a113aced86ff9360542fb8a1b
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Doug, Sean and Hal,

We have problem when connect connection from second port with AF_IB,
when first port is down.
We will fail when resovle route.

It turned out when resolve addr, in cma_resolve_ib_dev, we will choose
the first port if subnet_prefix is the same, in our case we use
default well known prefix.

I proposal fix below to resolve to first acrive IB port:
Note: I will attach another one for easily apply if the format mangled by g=
mail.
Patch created based on Linux 4.9-rc7.

>From b42e51deb8da3c1b596cb4332b6815e5ac8658a7 Mon Sep 17 00:00:00 2001
From: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Date: Tue, 6 Dec 2016 09:01:04 +0100
Subject: [PATCH] cma: resolve to first active ib_port

When resolve addr if we don't give src addr, cma core will try to resolve t=
o
ib device on itself, current logic is only check if it has same
subnet_prefix, which is not enough if we use default well known gid,
we should also check if port is active.

Signed-off-by: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 drivers/infiniband/core/cma.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 2a6fc47..9e46b42 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -684,6 +684,8 @@ static int cma_resolve_ib_dev(struct
rdma_id_private *id_priv)
             for (i =3D 0; !ib_get_cached_gid(cur_dev->device, p, i,
                                &gid, NULL);
                  i++) {
+                struct ib_port_attr attr;
+
                 if (!memcmp(&gid, dgid, sizeof(gid))) {
                     cma_dev =3D cur_dev;
                     sgid =3D gid;
@@ -692,7 +694,9 @@ static int cma_resolve_ib_dev(struct
rdma_id_private *id_priv)
                 }

                 if (!cma_dev && (gid.global.subnet_prefix =3D=3D
-                         dgid->global.subnet_prefix)) {
+                    dgid->global.subnet_prefix) &&
+                    (!ib_query_port(cur_dev->device, p, &attr) &&
+                    attr.state =3D=3D IB_PORT_ACTIVE)) {
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

--001a113aced86ff9360542fb8a1b
Content-Type: text/x-patch; charset=US-ASCII;
	name="0001-cma-resolve-to-first-active-ib_port.patch"
Content-Disposition: attachment;
	filename="0001-cma-resolve-to-first-active-ib_port.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_iwdestpr0

RnJvbSBiNDJlNTFkZWI4ZGEzYzFiNTk2Y2I0MzMyYjY4MTVlNWFjODY1OGE3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBKYWNrIFdhbmcgPGppbnB1LndhbmdAcHJvZml0YnJpY2tzLmNv
bT4KRGF0ZTogVHVlLCA2IERlYyAyMDE2IDA5OjAxOjA0ICswMTAwClN1YmplY3Q6IFtQQVRDSF0g
Y21hOiByZXNvbHZlIHRvIGZpcnN0IGFjdGl2ZSBpYl9wb3J0CgpXaGVuIHJlc29sdmUgYWRkciBp
ZiB3ZSBkb24ndCBnaXZlIHNyYyBhZGRyLCBjbWEgY29yZSB3aWxsIHRyeSB0byByZXNvbHZlIHRv
CmliIGRldmljZSBvbiBpdHNlbGYsIGN1cnJlbnQgbG9naWMgaXMgb25seSBjaGVjayBpZiBpdCBo
YXMgc2FtZQpzdWJuZXRfcHJlZml4LCB3aGljaCBpcyBub3QgZW5vdWdoIGlmIHdlIHVzZSBkZWZh
dWx0IHdlbGwga25vd24gZ2lkLAp3ZSBzaG91bGQgYWxzbyBjaGVjayBpZiBwb3J0IGlzIGFjdGl2
ZS4KClNpZ25lZC1vZmYtYnk6IEphY2sgV2FuZyA8amlucHUud2FuZ0Bwcm9maXRicmlja3MuY29t
PgotLS0KIGRyaXZlcnMvaW5maW5pYmFuZC9jb3JlL2NtYS5jIHwgNiArKysrKy0KIDEgZmlsZSBj
aGFuZ2VkLCA1IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9kcml2
ZXJzL2luZmluaWJhbmQvY29yZS9jbWEuYyBiL2RyaXZlcnMvaW5maW5pYmFuZC9jb3JlL2NtYS5j
CmluZGV4IDJhNmZjNDcuLjllNDZiNDIgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvaW5maW5pYmFuZC9j
b3JlL2NtYS5jCisrKyBiL2RyaXZlcnMvaW5maW5pYmFuZC9jb3JlL2NtYS5jCkBAIC02ODQsNiAr
Njg0LDggQEAgc3RhdGljIGludCBjbWFfcmVzb2x2ZV9pYl9kZXYoc3RydWN0IHJkbWFfaWRfcHJp
dmF0ZSAqaWRfcHJpdikKIAkJCWZvciAoaSA9IDA7ICFpYl9nZXRfY2FjaGVkX2dpZChjdXJfZGV2
LT5kZXZpY2UsIHAsIGksCiAJCQkJCQkgICAgICAgJmdpZCwgTlVMTCk7CiAJCQkgICAgIGkrKykg
eworCQkJCXN0cnVjdCBpYl9wb3J0X2F0dHIgYXR0cjsKKwogCQkJCWlmICghbWVtY21wKCZnaWQs
IGRnaWQsIHNpemVvZihnaWQpKSkgewogCQkJCQljbWFfZGV2ID0gY3VyX2RldjsKIAkJCQkJc2dp
ZCA9IGdpZDsKQEAgLTY5Miw3ICs2OTQsOSBAQCBzdGF0aWMgaW50IGNtYV9yZXNvbHZlX2liX2Rl
dihzdHJ1Y3QgcmRtYV9pZF9wcml2YXRlICppZF9wcml2KQogCQkJCX0KIAogCQkJCWlmICghY21h
X2RldiAmJiAoZ2lkLmdsb2JhbC5zdWJuZXRfcHJlZml4ID09Ci0JCQkJCQkgZGdpZC0+Z2xvYmFs
LnN1Ym5ldF9wcmVmaXgpKSB7CisJCQkJICAgIGRnaWQtPmdsb2JhbC5zdWJuZXRfcHJlZml4KSAm
JgorCQkJCSAgICAoIWliX3F1ZXJ5X3BvcnQoY3VyX2Rldi0+ZGV2aWNlLCBwLCAmYXR0cikgJiYK
KwkJCQkgICAgYXR0ci5zdGF0ZSA9PSBJQl9QT1JUX0FDVElWRSkpIHsKIAkJCQkJY21hX2RldiA9
IGN1cl9kZXY7CiAJCQkJCXNnaWQgPSBnaWQ7CiAJCQkJCWlkX3ByaXYtPmlkLnBvcnRfbnVtID0g
cDsKLS0gCjIuNy40Cgo=
--001a113aced86ff9360542fb8a1b--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Jinpu Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [PATCHv2 4/4] cma: use cached port state when bind loopback
Date: Mon, 2 Jan 2017 13:22:05 +0100
Message-ID: <CAMGffEmRdUb-ZjWvsUT-_KyESO18JF1hCx7tuPLnnEhr4mGzGQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001a1134e1e2bb89b705451b9aa5
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--001a1134e1e2bb89b705451b9aa5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

>From 3aba8b8413027835e9af9d0809a8eb33285bd673 Mon Sep 17 00:00:00 2001
From: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Date: Mon, 12 Dec 2016 10:29:00 +0100
Subject: [PATCH 4/4] cma: use cached port state when bind loopback

Signed-off-by: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Reviewed-by: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Acked-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/cma.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index fcd5047..8bbf306 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -2635,8 +2635,8 @@ static void cma_set_loopback(struct sockaddr *addr)
 static int cma_bind_loopback(struct rdma_id_private *id_priv)
 {
     struct cma_device *cma_dev, *cur_dev;
-    struct ib_port_attr port_attr;
     union ib_gid gid;
+    enum ib_port_state port_state;
     u16 pkey;
     int ret;
     u8 p;
@@ -2652,8 +2652,8 @@ static int cma_bind_loopback(struct
rdma_id_private *id_priv)
             cma_dev =3D cur_dev;

         for (p =3D 1; p <=3D cur_dev->device->phys_port_cnt; ++p) {
-            if (!ib_query_port(cur_dev->device, p, &port_attr) &&
-                port_attr.state =3D=3D IB_PORT_ACTIVE) {
+            if (!ib_get_cached_port_state(cur_dev->device, p, &port_state)=
 &&
+                port_state =3D=3D IB_PORT_ACTIVE) {
                 cma_dev =3D cur_dev;
                 goto port_found;
             }
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

--001a1134e1e2bb89b705451b9aa5
Content-Type: text/x-patch; charset=US-ASCII;
	name="0004-cma-use-cached-port-state-when-bind-loopback.patch"
Content-Disposition: attachment;
	filename="0004-cma-use-cached-port-state-when-bind-loopback.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ixg22k5t0

RnJvbSAzYWJhOGI4NDEzMDI3ODM1ZTlhZjlkMDgwOWE4ZWIzMzI4NWJkNjczIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBKYWNrIFdhbmcgPGppbnB1LndhbmdAcHJvZml0YnJpY2tzLmNv
bT4KRGF0ZTogTW9uLCAxMiBEZWMgMjAxNiAxMDoyOTowMCArMDEwMApTdWJqZWN0OiBbUEFUQ0gg
NC80XSBjbWE6IHVzZSBjYWNoZWQgcG9ydCBzdGF0ZSB3aGVuIGJpbmQgbG9vcGJhY2sKClNpZ25l
ZC1vZmYtYnk6IEphY2sgV2FuZyA8amlucHUud2FuZ0Bwcm9maXRicmlja3MuY29tPgpSZXZpZXdl
ZC1ieTogTWljaGFlbCBXYW5nIDx5dW4ud2FuZ0Bwcm9maXRicmlja3MuY29tPgpBY2tlZC1ieTog
U2VhbiBIZWZ0eSA8c2Vhbi5oZWZ0eUBpbnRlbC5jb20+Ci0tLQogZHJpdmVycy9pbmZpbmliYW5k
L2NvcmUvY21hLmMgfCA2ICsrKy0tLQogMSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwg
MyBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL2luZmluaWJhbmQvY29yZS9jbWEu
YyBiL2RyaXZlcnMvaW5maW5pYmFuZC9jb3JlL2NtYS5jCmluZGV4IGZjZDUwNDcuLjhiYmYzMDYg
MTAwNjQ0Ci0tLSBhL2RyaXZlcnMvaW5maW5pYmFuZC9jb3JlL2NtYS5jCisrKyBiL2RyaXZlcnMv
aW5maW5pYmFuZC9jb3JlL2NtYS5jCkBAIC0yNjM1LDggKzI2MzUsOCBAQCBzdGF0aWMgdm9pZCBj
bWFfc2V0X2xvb3BiYWNrKHN0cnVjdCBzb2NrYWRkciAqYWRkcikKIHN0YXRpYyBpbnQgY21hX2Jp
bmRfbG9vcGJhY2soc3RydWN0IHJkbWFfaWRfcHJpdmF0ZSAqaWRfcHJpdikKIHsKIAlzdHJ1Y3Qg
Y21hX2RldmljZSAqY21hX2RldiwgKmN1cl9kZXY7Ci0Jc3RydWN0IGliX3BvcnRfYXR0ciBwb3J0
X2F0dHI7CiAJdW5pb24gaWJfZ2lkIGdpZDsKKwllbnVtIGliX3BvcnRfc3RhdGUgcG9ydF9zdGF0
ZTsKIAl1MTYgcGtleTsKIAlpbnQgcmV0OwogCXU4IHA7CkBAIC0yNjUyLDggKzI2NTIsOCBAQCBz
dGF0aWMgaW50IGNtYV9iaW5kX2xvb3BiYWNrKHN0cnVjdCByZG1hX2lkX3ByaXZhdGUgKmlkX3By
aXYpCiAJCQljbWFfZGV2ID0gY3VyX2RldjsKIAogCQlmb3IgKHAgPSAxOyBwIDw9IGN1cl9kZXYt
PmRldmljZS0+cGh5c19wb3J0X2NudDsgKytwKSB7Ci0JCQlpZiAoIWliX3F1ZXJ5X3BvcnQoY3Vy
X2Rldi0+ZGV2aWNlLCBwLCAmcG9ydF9hdHRyKSAmJgotCQkJICAgIHBvcnRfYXR0ci5zdGF0ZSA9
PSBJQl9QT1JUX0FDVElWRSkgeworCQkJaWYgKCFpYl9nZXRfY2FjaGVkX3BvcnRfc3RhdGUoY3Vy
X2Rldi0+ZGV2aWNlLCBwLCAmcG9ydF9zdGF0ZSkgJiYKKwkJCSAgICBwb3J0X3N0YXRlID09IElC
X1BPUlRfQUNUSVZFKSB7CiAJCQkJY21hX2RldiA9IGN1cl9kZXY7CiAJCQkJZ290byBwb3J0X2Zv
dW5kOwogCQkJfQotLSAKMi43LjQKCg==
--001a1134e1e2bb89b705451b9aa5--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

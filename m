From: Jinpu Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [PATCH 4/4] cma: use cached port state when bind loopback
Date: Mon, 12 Dec 2016 12:49:24 +0100
Message-ID: <CAMGffEkCsD1_jAEjrCSuBSnGRZksup=Mjv_A=Nte=wcDKVJT0Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>From f2083c81f7738841cc696feda5f0ff5a96beeb01 Mon Sep 17 00:00:00 2001
From: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Date: Mon, 12 Dec 2016 10:29:00 +0100
Subject: [PATCH 4/4] cma: use cached port state when bind loopback

Signed-off-by: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Reviewed-by: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 drivers/infiniband/core/cma.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 3413aec..f57d017 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -2613,8 +2613,8 @@ static void cma_set_loopback(struct sockaddr *addr)
 static int cma_bind_loopback(struct rdma_id_private *id_priv)
 {
     struct cma_device *cma_dev, *cur_dev;
-    struct ib_port_attr port_attr;
     union ib_gid gid;
+    enum ib_port_state port_state;
     u16 pkey;
     int ret;
     u8 p;
@@ -2630,8 +2630,8 @@ static int cma_bind_loopback(struct
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
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Jinpu Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [PATCH 3/4] cma: resolve to first active ib port
Date: Mon, 12 Dec 2016 12:48:07 +0100
Message-ID: <CAMGffEm408nbzSqo-uSQGekenZfOX+HOeheRg1tvVGT8Y1=2XQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>From 77323a633072966e358c8f684e5ff4b665a27881 Mon Sep 17 00:00:00 2001
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
---
 drivers/infiniband/core/cma.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 2a6fc47..3413aec 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -666,6 +666,7 @@ static int cma_resolve_ib_dev(struct
rdma_id_private *id_priv)
     union ib_gid gid, sgid, *dgid;
     u16 pkey, index;
     u8 p;
+    enum ib_port_state port_state;
     int i;

     cma_dev =3D NULL;
@@ -681,6 +682,8 @@ static int cma_resolve_ib_dev(struct
rdma_id_private *id_priv)
             if (ib_find_cached_pkey(cur_dev->device, p, pkey, &index))
                 continue;

+            if (ib_get_cached_port_state(cur_dev->device, p, &port_state))
+                continue;
             for (i =3D 0; !ib_get_cached_gid(cur_dev->device, p, i,
                                &gid, NULL);
                  i++) {
@@ -692,7 +695,8 @@ static int cma_resolve_ib_dev(struct
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
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

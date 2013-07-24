From: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH for-3.11 1/3] [v2] RDMA/cma: silence GCC warning
Date: Wed, 24 Jul 2013 15:06:07 -0700
Message-ID: <1374703569-16668-2-git-send-email-sean.hefty@intel.com>
References: <1374703569-16668-1-git-send-email-sean.hefty@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1374703569-16668-1-git-send-email-sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Paul Bolle <pebolle-IWqWACnzNjzz+pZb47iToQ@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

=46rom: Paul Bolle <pebolle-IWqWACnzNjzz+pZb47iToQ@public.gmane.org>

Building cma.o triggers this GCC warning:
    drivers/infiniband/core/cma.c: In function =E2=80=98rdma_resolve_ad=
dr=E2=80=99:
    drivers/infiniband/core/cma.c:465:23: warning: =E2=80=98port=E2=80=99=
 may be used uninitialized in this function [-Wmaybe-uninitialized]
    drivers/infiniband/core/cma.c:426:5: note: =E2=80=98port=E2=80=99 w=
as declared here

This is a false positive, as "port" will always be initialized if we're
at "found". But if we assign to "id_priv->id.port_num" directly, we can
drop "port". That will, obviously, silence GCC.

Signed-off-by: Paul Bolle <pebolle-IWqWACnzNjzz+pZb47iToQ@public.gmane.org>
Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/cma.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cm=
a.c
index f1c279f..84487a2 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -423,7 +423,7 @@ static int cma_resolve_ib_dev(struct rdma_id_privat=
e *id_priv)
 	struct sockaddr_ib *addr;
 	union ib_gid gid, sgid, *dgid;
 	u16 pkey, index;
-	u8 port, p;
+	u8 p;
 	int i;
=20
 	cma_dev =3D NULL;
@@ -443,7 +443,7 @@ static int cma_resolve_ib_dev(struct rdma_id_privat=
e *id_priv)
 				if (!memcmp(&gid, dgid, sizeof(gid))) {
 					cma_dev =3D cur_dev;
 					sgid =3D gid;
-					port =3D p;
+					id_priv->id.port_num =3D p;
 					goto found;
 				}
=20
@@ -451,7 +451,7 @@ static int cma_resolve_ib_dev(struct rdma_id_privat=
e *id_priv)
 						 dgid->global.subnet_prefix)) {
 					cma_dev =3D cur_dev;
 					sgid =3D gid;
-					port =3D p;
+					id_priv->id.port_num =3D p;
 				}
 			}
 		}
@@ -462,7 +462,6 @@ static int cma_resolve_ib_dev(struct rdma_id_privat=
e *id_priv)
=20
 found:
 	cma_attach_to_dev(id_priv, cma_dev);
-	id_priv->id.port_num =3D port;
 	addr =3D (struct sockaddr_ib *) cma_src_addr(id_priv);
 	memcpy(&addr->sib_addr, &sgid, sizeof sgid);
 	cma_translate_ib(addr, &id_priv->id.route.addr.dev_addr);
--=20
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

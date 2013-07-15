From: Paul Bolle <pebolle-IWqWACnzNjzz+pZb47iToQ@public.gmane.org>
Subject: [PATCH] RDMA/cma: silence GCC warning
Date: Mon, 15 Jul 2013 13:03:59 +0200
Message-ID: <1373886239.2591.26.camel@x61.thuisdomein>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Building cma.o triggers this GCC warning:
    drivers/infiniband/core/cma.c: In function =E2=80=98rdma_resolve_ad=
dr=E2=80=99:
    drivers/infiniband/core/cma.c:465:23: warning: =E2=80=98port=E2=80=99=
 may be used uninitialized in this function [-Wmaybe-uninitialized]
    drivers/infiniband/core/cma.c:426:5: note: =E2=80=98port=E2=80=99 w=
as declared here

This is a false positive, as "port" will always be initialized if we're
at "found".

Help GCC by initializing "port" to 0. Since valid port numbers
apparently start at 1, this is an invalid value. That could help in
analyzing the code and tracking down errors.

Signed-off-by: Paul Bolle <pebolle-IWqWACnzNjzz+pZb47iToQ@public.gmane.org>
---
0) Compile tested only.

1) Perhaps a better way to silence GCC is to drop "port" entirely, and
assign to "id_priv->id.port_num" directly. Would that be acceptable?

 drivers/infiniband/core/cma.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cm=
a.c
index f1c279f..c6c0a5f 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -426,6 +426,7 @@ static int cma_resolve_ib_dev(struct rdma_id_privat=
e *id_priv)
 	u8 port, p;
 	int i;
=20
+	port =3D 0; /* silence GCC */
 	cma_dev =3D NULL;
 	addr =3D (struct sockaddr_ib *) cma_dst_addr(id_priv);
 	dgid =3D (union ib_gid *) &addr->sib_addr;
--=20
1.8.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

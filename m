From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [patch] RDMA/nes: silence compiler warning
Date: Mon, 17 Oct 2011 10:28:57 +0300
Message-ID: <20111017072857.GB7812@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

drivers/infiniband/hw/nes/nes_cm.c:3190:2: warning: format =E2=80=98%zu=
=E2=80=99
	expects argument of type =E2=80=98size_t=E2=80=99, but argument 11 has=
 type
	=E2=80=98int=E2=80=99 [-Wformat]

The warning says the type is "int" but actually it's unsigned short.

Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

diff --git a/drivers/infiniband/hw/nes/nes_cm.c b/drivers/infiniband/hw=
/nes/nes_cm.c
index 16667c7..b96ec43 100644
--- a/drivers/infiniband/hw/nes/nes_cm.c
+++ b/drivers/infiniband/hw/nes/nes_cm.c
@@ -3189,7 +3189,7 @@ int nes_accept(struct iw_cm_id *cm_id, struct iw_=
cm_conn_param *conn_param)
=20
 	nes_debug(NES_DBG_CM, "QP%u, Destination IP =3D 0x%08X:0x%04X, local =
=3D "
 		  "0x%08X:0x%04X, rcv_nxt=3D0x%08X, snd_nxt=3D0x%08X, mpa + "
-		  "private data length=3D%zu.\n", nesqp->hwqp.qp_id,
+		  "private data length=3D%d.\n", nesqp->hwqp.qp_id,
 		  ntohl(cm_id->remote_addr.sin_addr.s_addr),
 		  ntohs(cm_id->remote_addr.sin_port),
 		  ntohl(cm_id->local_addr.sin_addr.s_addr),
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

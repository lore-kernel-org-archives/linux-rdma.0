From: sebastien dugue <sebastien.dugue-6ktuUTfB/bM@public.gmane.org>
Subject: mlx4_ib XRC RCV: Fix mlx4_ib_reg_xrc_rcv_qp() locking
Date: Fri, 11 Feb 2011 16:58:17 +0100
Message-ID: <20110211165817.60540277@b012350-ux.fr.ad.bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


  In mlx4_ib_reg_xrc_rcv_qp(), we need to take the xrc_reg_list_lock sp=
inlock
when walking the xrc_reg_list.

  We've been hit by this on 2 customer sites.

  Also, I guess spin_lock_irqsave() could be replaced by spin_lock_irq(=
) in
that function as we know for sure we're in process context.

Signed-off-by: S=C3=A9bastien Dugu=C3=A9 <sebastien.dugue-6ktuUTfB/bM@public.gmane.org>

--

 qp.c |    3 +++
 1 file changed, 3 insertions(+)

dIndex: kernel-ib/drivers/infiniband/hw/mlx4/qp.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- kernel-ib.orig/drivers/infiniband/hw/mlx4/qp.c	2011-01-31 16:52:11.=
000000000 +0100
+++ kernel-ib/drivers/infiniband/hw/mlx4/qp.c	2011-02-11 15:24:27.00000=
0000 +0100
@@ -2549,13 +2549,16 @@
 	}
=20
 	mutex_lock(&mibqp->mutex);
+	spin_lock_irqsave(&mibqp->xrc_reg_list_lock, flags);
 	list_for_each_entry(tmp, &mibqp->xrc_reg_list, list)
 		if (tmp->context =3D=3D context) {
+			spin_unlock_irqrestore(&mibqp->xrc_reg_list_lock, flags);
 			mutex_unlock(&mibqp->mutex);
 			kfree(ctx_entry);
 			mutex_unlock(&to_mdev(xrcd->device)->xrc_reg_mutex);
 			return 0;
 		}
+	spin_unlock_irqrestore(&mibqp->xrc_reg_list_lock, flags);
=20
 	ctx_entry->context =3D context;
 	spin_lock_irqsave(&mibqp->xrc_reg_list_lock, flags);
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

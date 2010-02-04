From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] rdma/nes: change WQ overflow return code
Date: Thu, 4 Feb 2010 13:25:07 +0200 (IST)
Message-ID: <Pine.LNX.4.64.1002041323100.31229@zuben.voltaire.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

change the nes driver to return -ENOMEM on SQ/RQ overflow in the
manner done by other rdma hw drivers (e.g cxgb3, ehca, mlx4, mthca)

Signed-off-by: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>

Index: linux-2.6.33-rc4/drivers/infiniband/hw/nes/nes_verbs.c
===================================================================
--- linux-2.6.33-rc4.orig/drivers/infiniband/hw/nes/nes_verbs.c
+++ linux-2.6.33-rc4/drivers/infiniband/hw/nes/nes_verbs.c
@@ -228,7 +228,7 @@ static int nes_bind_mw(struct ib_qp *ibq
 	/* Check for SQ overflow */
 	if (((head + (2 * qsize) - nesqp->hwqp.sq_tail) % qsize) == (qsize - 1)) {
 		spin_unlock_irqrestore(&nesqp->lock, flags);
-		return -EINVAL;
+		return -ENOMEM;
 	}

 	wqe = &nesqp->hwqp.sq_vbase[head];
@@ -3294,7 +3294,7 @@ static int nes_post_send(struct ib_qp *i

 		/* Check for SQ overflow */
 		if (((head + (2 * qsize) - nesqp->hwqp.sq_tail) % qsize) == (qsize - 1)) {
-			err = -EINVAL;
+			err = -ENOMEM;
 			break;
 		}

@@ -3577,7 +3577,7 @@ static int nes_post_recv(struct ib_qp *i
 		}
 		/* Check for RQ overflow */
 		if (((head + (2 * qsize) - nesqp->hwqp.rq_tail) % qsize) == (qsize - 1)) {
-			err = -EINVAL;
+			err = -ENOMEM;
 			break;
 		}

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

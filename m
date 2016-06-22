From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 08/11] IB/mlx4: Fix error flow when sending mads under SRIOV
Date: Wed, 22 Jun 2016 17:27:29 +0300
Message-ID: <1466605652-24798-9-git-send-email-leonro@mellanox.com>
References: <1466605652-24798-1-git-send-email-leonro@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1466605652-24798-1-git-send-email-leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Fix mad send error flow to prevent double freeing address handles,
and leaking tx_ring entries when SRIOV is active.

If ib_mad_post_send fails, the address handle pointer in the tx_ring entry
must be set to NULL (or there will be a double-free) and tx_tail must be
incremented (or there will be a leak of tx_ring entries).
The tx_ring is handled the same way in the send-completion handler.

Fixes: 37bfc7c1e83f ("IB/mlx4: SR-IOV multiplex and demultiplex MADs")
Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/mad.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index d68f506..9c2e53d 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -527,7 +527,7 @@ int mlx4_ib_send_to_slave(struct mlx4_ib_dev *dev, int slave, u8 port,
 		tun_tx_ix = (++tun_qp->tx_ix_head) & (MLX4_NUM_TUNNEL_BUFS - 1);
 	spin_unlock(&tun_qp->tx_lock);
 	if (ret)
-		goto out;
+		goto end;
 
 	tun_mad = (struct mlx4_rcv_tunnel_mad *) (tun_qp->tx_ring[tun_tx_ix].buf.addr);
 	if (tun_qp->tx_ring[tun_tx_ix].ah)
@@ -596,9 +596,15 @@ int mlx4_ib_send_to_slave(struct mlx4_ib_dev *dev, int slave, u8 port,
 	wr.wr.send_flags = IB_SEND_SIGNALED;
 
 	ret = ib_post_send(src_qp, &wr.wr, &bad_wr);
-out:
-	if (ret)
-		ib_destroy_ah(ah);
+	if (!ret)
+		return 0;
+ out:
+	spin_lock(&tun_qp->tx_lock);
+	tun_qp->tx_ix_tail++;
+	spin_unlock(&tun_qp->tx_lock);
+	tun_qp->tx_ring[tun_tx_ix].ah = NULL;
+end:
+	ib_destroy_ah(ah);
 	return ret;
 }
 
@@ -1326,9 +1332,15 @@ int mlx4_ib_send_to_wire(struct mlx4_ib_dev *dev, int slave, u8 port,
 
 
 	ret = ib_post_send(send_qp, &wr.wr, &bad_wr);
+	if (!ret)
+		return 0;
+
+	spin_lock(&sqp->tx_lock);
+	sqp->tx_ix_tail++;
+	spin_unlock(&sqp->tx_lock);
+	sqp->tx_ring[wire_tx_ix].ah = NULL;
 out:
-	if (ret)
-		ib_destroy_ah(ah);
+	ib_destroy_ah(ah);
 	return ret;
 }
 
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

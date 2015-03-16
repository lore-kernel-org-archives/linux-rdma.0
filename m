From: Sebastian Ott <sebott-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH] infiniband/mlx4: check for mapping error
Date: Mon, 16 Mar 2015 18:49:59 +0100 (CET)
Message-ID: <alpine.LFD.2.11.1503161844400.1763@denkbrett>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Since ib_dma_map_single can fail use ib_dma_mapping_error to check
for errors.

Signed-off-by: Sebastian Ott <sebott-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/mad.c |    9 +++++++++
 drivers/infiniband/hw/mlx4/qp.c  |    4 ++++
 2 files changed, 13 insertions(+)

--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -1418,6 +1418,10 @@ static int mlx4_ib_alloc_pv_bufs(struct
 							tun_qp->ring[i].addr,
 							rx_buf_size,
 							DMA_FROM_DEVICE);
+		if (ib_dma_mapping_error(ctx->ib_dev, tun_qp->ring[i].map)) {
+			kfree(tun_qp->ring[i].addr);
+			goto err;
+		}
 	}
 
 	for (i = 0; i < MLX4_NUM_TUNNEL_BUFS; i++) {
@@ -1430,6 +1434,11 @@ static int mlx4_ib_alloc_pv_bufs(struct
 					  tun_qp->tx_ring[i].buf.addr,
 					  tx_buf_size,
 					  DMA_TO_DEVICE);
+		if (ib_dma_mapping_error(ctx->ib_dev,
+					 tun_qp->tx_ring[i].buf.map)) {
+			kfree(tun_qp->tx_ring[i].buf.addr);
+			goto tx_err;
+		}
 		tun_qp->tx_ring[i].ah = NULL;
 	}
 	spin_lock_init(&tun_qp->tx_lock);
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -566,6 +566,10 @@ static int alloc_proxy_bufs(struct ib_de
 			ib_dma_map_single(dev, qp->sqp_proxy_rcv[i].addr,
 					  sizeof (struct mlx4_ib_proxy_sqp_hdr),
 					  DMA_FROM_DEVICE);
+		if (ib_dma_mapping_error(dev, qp->sqp_proxy_rcv[i].map)) {
+			kfree(qp->sqp_proxy_rcv[i].addr);
+			goto err;
+		}
 	}
 	return 0;
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

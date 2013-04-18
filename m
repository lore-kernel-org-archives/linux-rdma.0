From: Jay Fenlason <fenlason-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH V2] Silence DMA mapping error warnings
Date: Thu, 18 Apr 2013 16:03:04 -0400
Message-ID: <20130418200304.GA9406@redhat.com>
References: <20130417183141.GC31671@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130417183141.GC31671-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On my Fedora Rawhide boxes, I noticed I was getting warnings saying
that Infiniband modules were not checking for DMA mapping errors.  I
wrote this patch to silence the warnings.

I tested it on a pair of x86_64 machines running
3.9.0-0.rc7.git2.1.fc20 with
InfiniBand: Mellanox Technologies MT25418 [ConnectX VPI PCIe 2.0 2.5GT/s - IB DDR / 10GigE] (rev a0)
cards in them.  It silences the warnings.

[V2 changed return values to -EIO]

Signed-off-by: Jay Fenlason <fenlason-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

--- vanilla-3.9-rc6-git2/drivers/infiniband/hw/mlx4/mad.c	2013-04-11 19:44:55.000000000 -0400
+++ linux-3.9.0-0.rc6.git2.1.bz951219.0.fc20.x86_64/drivers/infiniband/hw/mlx4/mad.c	2013-04-12 10:28:18.000000000 -0400
@@ -1318,6 +1318,10 @@ static int mlx4_ib_alloc_pv_bufs(struct 
 							tun_qp->ring[i].addr,
 							rx_buf_size,
 							DMA_FROM_DEVICE);
+		if (unlikely(ib_dma_mapping_error(ctx->ib_dev, tun_qp->ring[i].map))) {
+			WARN(1, "DMA mapping error in mlx4_ib_alloc_pv_bufs in ring");
+			goto err;
+		}
 	}
 
 	for (i = 0; i < MLX4_NUM_TUNNEL_BUFS; i++) {
@@ -1330,6 +1334,12 @@ static int mlx4_ib_alloc_pv_bufs(struct 
 					  tun_qp->tx_ring[i].buf.addr,
 					  tx_buf_size,
 					  DMA_TO_DEVICE);
+		if (unlikely(ib_dma_mapping_error(ctx->ib_dev, tun_qp->tx_ring[i].buf.map))) {
+			WARN(1, "DMA mapping error in mlx4_ib_alloc_pv_bufs in tx_ring");
+			goto tx_err;
+		}
+
+
 		tun_qp->tx_ring[i].ah = NULL;
 	}
 	spin_lock_init(&tun_qp->tx_lock);
--- vanilla-3.9-rc6-git2/drivers/infiniband/hw/mlx4/qp.c	2013-04-11 19:44:56.000000000 -0400
+++ linux-3.9.0-0.rc6.git2.1.bz951219.0.fc20.x86_64/drivers/infiniband/hw/mlx4/qp.c	2013-04-12 10:28:18.000000000 -0400
@@ -556,6 +556,12 @@ static int alloc_proxy_bufs(struct ib_de
 			ib_dma_map_single(dev, qp->sqp_proxy_rcv[i].addr,
 					  sizeof (struct mlx4_ib_proxy_sqp_hdr),
 					  DMA_FROM_DEVICE);
+		if (unlikely(ib_dma_mapping_error(dev, qp->sqp_proxy_rcv[i].map))) {
+			WARN(1, "DMA mapping error in mlx4_qp:alloc_proxy_bufs");
+			goto err;
+		}
+
+
 	}
 	return 0;
 
--- vanilla-3.9-rc6-git2/drivers/infiniband/core/mad.c	2013-02-18 18:58:34.000000000 -0500
+++ linux-3.9.0-0.rc6.git2.1.bz951219.0.fc20.x86_64/drivers/infiniband/core/mad.c	2013-04-15 12:57:39.000000000 -0400
@@ -1022,12 +1022,23 @@ int ib_send_mad(struct ib_mad_send_wr_pr
 					mad_send_wr->send_buf.mad,
 					sge[0].length,
 					DMA_TO_DEVICE);
+	if (unlikely(ib_dma_mapping_error(mad_agent->device, sge[0].addr))) {
+		WARN(1, "DMA mapping error in ib_send_mad on header");
+		return -EIO;
+	}
 	mad_send_wr->header_mapping = sge[0].addr;
 
 	sge[1].addr = ib_dma_map_single(mad_agent->device,
 					ib_get_payload(mad_send_wr),
 					sge[1].length,
 					DMA_TO_DEVICE);
+	if (unlikely(ib_dma_mapping_error(mad_agent->device, sge[1].addr))) {
+		WARN(1, "DMA mapping error in ib_send_mad on payload");
+		ib_dma_unmap_single(mad_agent->device,
+				    mad_send_wr->header_mapping,
+				    sge[0].length, DMA_TO_DEVICE);
+		return -EIO;
+	}
 	mad_send_wr->payload_mapping = sge[1].addr;
 
 	spin_lock_irqsave(&qp_info->send_queue.lock, flags);
@@ -2590,6 +2601,12 @@ static int ib_mad_post_receive_mads(stru
 						 sizeof *mad_priv -
 						   sizeof mad_priv->header,
 						 DMA_FROM_DEVICE);
+		if (unlikely(ib_dma_mapping_error(qp_info->port_priv->device, sg_list.addr))) {
+			WARN(1, "DMA mapping error in ib_mad_post_receive_mads");
+			ret = -EIO;
+			break;
+		}
+
 		mad_priv->header.mapping = sg_list.addr;
 		recv_wr.wr_id = (unsigned long)&mad_priv->header.mad_list;
 		mad_priv->header.mad_list.mad_queue = recv_queue;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

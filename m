From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 24/29] IB/mlx4: Delete unwanted spaces behind usages of the
 sizeof operator
Date: Sat, 18 Feb 2017 22:14:10 +0100
Message-ID: <8c59912d-c319-8f4d-a961-9ffa46ad84e3@users.sourceforge.net>
References: <1935365a-bd7c-461e-6a84-0c5d3a501fff@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1935365a-bd7c-461e-6a84-0c5d3a501fff@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Leon Romanovsky <leonro@mellanox.com>, Matan Barak <matanb@mellanox.com>, Sean Hefty <sean.hefty@intel.com>, Yishai Hadas <yishaih@mellanox.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 18 Feb 2017 18:33:00 +0100

* Replace the source code "sizeof (" by "sizeof("
  according to the Linux coding style convention.

* Adjust indentation at a few places.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/infiniband/hw/mlx4/qp.c | 128 ++++++++++++++++++++--------------------
 1 file changed, 63 insertions(+), 65 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index cc7bd257a1fd..47a647c1d94f 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -340,39 +340,39 @@ static int send_wqe_overhead(enum mlx4_ib_qp_type type, u32 flags)
 	 */
 	switch (type) {
 	case MLX4_IB_QPT_UD:
-		return sizeof (struct mlx4_wqe_ctrl_seg) +
-			sizeof (struct mlx4_wqe_datagram_seg) +
+		return sizeof(struct mlx4_wqe_ctrl_seg) +
+			sizeof(struct mlx4_wqe_datagram_seg) +
 			((flags & MLX4_IB_QP_LSO) ? MLX4_IB_LSO_HEADER_SPARE : 0);
 	case MLX4_IB_QPT_PROXY_SMI_OWNER:
 	case MLX4_IB_QPT_PROXY_SMI:
 	case MLX4_IB_QPT_PROXY_GSI:
-		return sizeof (struct mlx4_wqe_ctrl_seg) +
-			sizeof (struct mlx4_wqe_datagram_seg) + 64;
+		return sizeof(struct mlx4_wqe_ctrl_seg) +
+			sizeof(struct mlx4_wqe_datagram_seg) + 64;
 	case MLX4_IB_QPT_TUN_SMI_OWNER:
 	case MLX4_IB_QPT_TUN_GSI:
-		return sizeof (struct mlx4_wqe_ctrl_seg) +
-			sizeof (struct mlx4_wqe_datagram_seg);
+		return sizeof(struct mlx4_wqe_ctrl_seg) +
+			sizeof(struct mlx4_wqe_datagram_seg);
 
 	case MLX4_IB_QPT_UC:
-		return sizeof (struct mlx4_wqe_ctrl_seg) +
-			sizeof (struct mlx4_wqe_raddr_seg);
+		return sizeof(struct mlx4_wqe_ctrl_seg) +
+			sizeof(struct mlx4_wqe_raddr_seg);
 	case MLX4_IB_QPT_RC:
-		return sizeof (struct mlx4_wqe_ctrl_seg) +
-			sizeof (struct mlx4_wqe_masked_atomic_seg) +
-			sizeof (struct mlx4_wqe_raddr_seg);
+		return sizeof(struct mlx4_wqe_ctrl_seg) +
+			sizeof(struct mlx4_wqe_masked_atomic_seg) +
+			sizeof(struct mlx4_wqe_raddr_seg);
 	case MLX4_IB_QPT_SMI:
 	case MLX4_IB_QPT_GSI:
-		return sizeof (struct mlx4_wqe_ctrl_seg) +
+		return sizeof(struct mlx4_wqe_ctrl_seg) +
 			ALIGN(MLX4_IB_UD_HEADER_SIZE +
 			      DIV_ROUND_UP(MLX4_IB_UD_HEADER_SIZE,
 					   MLX4_INLINE_ALIGN) *
-			      sizeof (struct mlx4_wqe_inline_seg),
-			      sizeof (struct mlx4_wqe_data_seg)) +
+			      sizeof(struct mlx4_wqe_inline_seg),
+			      sizeof(struct mlx4_wqe_data_seg)) +
 			ALIGN(4 +
-			      sizeof (struct mlx4_wqe_inline_seg),
-			      sizeof (struct mlx4_wqe_data_seg));
+			      sizeof(struct mlx4_wqe_inline_seg),
+			      sizeof(struct mlx4_wqe_data_seg));
 	default:
-		return sizeof (struct mlx4_wqe_ctrl_seg);
+		return sizeof(struct mlx4_wqe_ctrl_seg);
 	}
 }
 
@@ -396,7 +396,8 @@ static int set_rq_size(struct mlx4_ib_dev *dev, struct ib_qp_cap *cap,
 
 		qp->rq.wqe_cnt	 = roundup_pow_of_two(max(1U, cap->max_recv_wr));
 		qp->rq.max_gs	 = roundup_pow_of_two(max(1U, cap->max_recv_sge));
-		qp->rq.wqe_shift = ilog2(qp->rq.max_gs * sizeof (struct mlx4_wqe_data_seg));
+		qp->rq.wqe_shift = ilog2(qp->rq.max_gs
+					 * sizeof(struct mlx4_wqe_data_seg));
 	}
 
 	/* leave userspace return values as they were, so as not to break ABI */
@@ -424,7 +425,7 @@ static int set_kernel_sq_size(struct mlx4_ib_dev *dev, struct ib_qp_cap *cap,
 	if (cap->max_send_wr  > (dev->dev->caps.max_wqes - MLX4_IB_SQ_MAX_SPARE) ||
 	    cap->max_send_sge > min(dev->dev->caps.max_sq_sg, dev->dev->caps.max_rq_sg) ||
 	    cap->max_inline_data + send_wqe_overhead(type, qp->flags) +
-	    sizeof (struct mlx4_wqe_inline_seg) > dev->dev->caps.max_sq_desc_sz)
+	    sizeof(struct mlx4_wqe_inline_seg) > dev->dev->caps.max_sq_desc_sz)
 		return -EINVAL;
 
 	/*
@@ -436,8 +437,8 @@ static int set_kernel_sq_size(struct mlx4_ib_dev *dev, struct ib_qp_cap *cap,
 	    cap->max_send_sge + 2 > dev->dev->caps.max_sq_sg)
 		return -EINVAL;
 
-	s = max(cap->max_send_sge * sizeof (struct mlx4_wqe_data_seg),
-		cap->max_inline_data + sizeof (struct mlx4_wqe_inline_seg)) +
+	s = max(cap->max_send_sge * sizeof(struct mlx4_wqe_data_seg),
+		cap->max_inline_data + sizeof(struct mlx4_wqe_inline_seg)) +
 		send_wqe_overhead(type, qp->flags);
 
 	if (s > dev->dev->caps.max_sq_desc_sz)
@@ -507,7 +508,7 @@ static int set_kernel_sq_size(struct mlx4_ib_dev *dev, struct ib_qp_cap *cap,
 	qp->sq.max_gs = (min(dev->dev->caps.max_sq_desc_sz,
 			     (qp->sq_max_wqes_per_wr << qp->sq.wqe_shift)) -
 			 send_wqe_overhead(type, qp->flags)) /
-		sizeof (struct mlx4_wqe_data_seg);
+		sizeof(struct mlx4_wqe_data_seg);
 
 	qp->buf_size = (qp->rq.wqe_cnt << qp->rq.wqe_shift) +
 		(qp->sq.wqe_cnt << qp->sq.wqe_shift);
@@ -561,13 +562,13 @@ static int alloc_proxy_bufs(struct ib_device *dev, struct mlx4_ib_qp *qp)
 		return -ENOMEM;
 	for (i = 0; i < qp->rq.wqe_cnt; i++) {
 		qp->sqp_proxy_rcv[i].addr =
-			kmalloc(sizeof (struct mlx4_ib_proxy_sqp_hdr),
+			kmalloc(sizeof(struct mlx4_ib_proxy_sqp_hdr),
 				GFP_KERNEL);
 		if (!qp->sqp_proxy_rcv[i].addr)
 			goto err;
 		qp->sqp_proxy_rcv[i].map =
 			ib_dma_map_single(dev, qp->sqp_proxy_rcv[i].addr,
-					  sizeof (struct mlx4_ib_proxy_sqp_hdr),
+					  sizeof(struct mlx4_ib_proxy_sqp_hdr),
 					  DMA_FROM_DEVICE);
 		if (ib_dma_mapping_error(dev, qp->sqp_proxy_rcv[i].map)) {
 			kfree(qp->sqp_proxy_rcv[i].addr);
@@ -580,7 +581,7 @@ static int alloc_proxy_bufs(struct ib_device *dev, struct mlx4_ib_qp *qp)
 	while (i > 0) {
 		--i;
 		ib_dma_unmap_single(dev, qp->sqp_proxy_rcv[i].map,
-				    sizeof (struct mlx4_ib_proxy_sqp_hdr),
+				    sizeof(struct mlx4_ib_proxy_sqp_hdr),
 				    DMA_FROM_DEVICE);
 		kfree(qp->sqp_proxy_rcv[i].addr);
 	}
@@ -595,7 +596,7 @@ static void free_proxy_bufs(struct ib_device *dev, struct mlx4_ib_qp *qp)
 
 	for (i = 0; i < qp->rq.wqe_cnt; i++) {
 		ib_dma_unmap_single(dev, qp->sqp_proxy_rcv[i].map,
-				    sizeof (struct mlx4_ib_proxy_sqp_hdr),
+				    sizeof(struct mlx4_ib_proxy_sqp_hdr),
 				    DMA_FROM_DEVICE);
 		kfree(qp->sqp_proxy_rcv[i].addr);
 	}
@@ -2318,7 +2319,7 @@ static int build_sriov_qp0_header(struct mlx4_ib_sqp *sqp,
 	/* for proxy-qp0 sends, need to add in size of tunnel header */
 	/* for tunnel-qp0 sends, tunnel header is already in s/g list */
 	if (sqp->qp.mlx4_ib_qp_type == MLX4_IB_QPT_PROXY_SMI_OWNER)
-		send_size += sizeof (struct mlx4_ib_tunnel_header);
+		send_size += sizeof(struct mlx4_ib_tunnel_header);
 
 	ib_ud_header_init(send_size, 1, 0, 0, 0, 0, 0, 0, &sqp->ud_header);
 
@@ -2400,7 +2401,7 @@ static int build_sriov_qp0_header(struct mlx4_ib_sqp *sqp,
 	}
 
 	*mlx_seg_len =
-	ALIGN(i * sizeof (struct mlx4_wqe_inline_seg) + header_size, 16);
+	ALIGN(i * sizeof(struct mlx4_wqe_inline_seg) + header_size, 16);
 	return 0;
 }
 
@@ -2678,7 +2679,7 @@ static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_ud_wr *wr,
 	}
 
 	*mlx_seg_len =
-		ALIGN(i * sizeof (struct mlx4_wqe_inline_seg) + header_size, 16);
+		ALIGN(i * sizeof(struct mlx4_wqe_inline_seg) + header_size, 16);
 	return 0;
 }
 
@@ -2769,7 +2770,7 @@ static void set_masked_atomic_seg(struct mlx4_wqe_masked_atomic_seg *aseg,
 static void set_datagram_seg(struct mlx4_wqe_datagram_seg *dseg,
 			     struct ib_ud_wr *wr)
 {
-	memcpy(dseg->av, &to_mah(wr->ah)->av, sizeof (struct mlx4_av));
+	memcpy(dseg->av, &to_mah(wr->ah)->av, sizeof(struct mlx4_av));
 	dseg->dqpn = cpu_to_be32(wr->remote_qpn);
 	dseg->qkey = cpu_to_be32(wr->remote_qkey);
 	dseg->vlan = to_mah(wr->ah)->av.eth.vlan;
@@ -2791,7 +2792,7 @@ static void set_tunnel_datagram_seg(struct mlx4_ib_dev *dev,
 	sqp_av.sl_tclass_flowlabel = av->ib.sl_tclass_flowlabel &
 			cpu_to_be32(0xf0000000);
 
-	memcpy(dseg->av, &sqp_av, sizeof (struct mlx4_av));
+	memcpy(dseg->av, &sqp_av, sizeof(struct mlx4_av));
 	if (qpt == MLX4_IB_QPT_PROXY_GSI)
 		dseg->dqpn = cpu_to_be32(dev->dev->caps.qp1_tunnel[port - 1]);
 	else
@@ -2817,10 +2818,10 @@ static void build_tunnel_header(struct ib_ud_wr *wr, void *wqe, unsigned *mlx_se
 
 	spc = MLX4_INLINE_ALIGN -
 		((unsigned long) (inl + 1) & (MLX4_INLINE_ALIGN - 1));
-	if (sizeof (hdr) <= spc) {
-		memcpy(inl + 1, &hdr, sizeof (hdr));
+	if (sizeof(hdr) <= spc) {
+		memcpy(inl + 1, &hdr, sizeof(hdr));
 		wmb();
-		inl->byte_count = cpu_to_be32(1 << 31 | sizeof (hdr));
+		inl->byte_count = cpu_to_be32(1 << 31 | sizeof(hdr));
 		i = 1;
 	} else {
 		memcpy(inl + 1, &hdr, spc);
@@ -2828,14 +2829,14 @@ static void build_tunnel_header(struct ib_ud_wr *wr, void *wqe, unsigned *mlx_se
 		inl->byte_count = cpu_to_be32(1 << 31 | spc);
 
 		inl = (void *) (inl + 1) + spc;
-		memcpy(inl + 1, (void *) &hdr + spc, sizeof (hdr) - spc);
+		memcpy(inl + 1, (void *) &hdr + spc, sizeof(hdr) - spc);
 		wmb();
-		inl->byte_count = cpu_to_be32(1 << 31 | (sizeof (hdr) - spc));
+		inl->byte_count = cpu_to_be32(1 << 31 | (sizeof(hdr) - spc));
 		i = 2;
 	}
 
 	*mlx_seg_len =
-		ALIGN(i * sizeof (struct mlx4_wqe_inline_seg) + sizeof (hdr), 16);
+		ALIGN(i * sizeof(struct mlx4_wqe_inline_seg) + sizeof(hdr), 16);
 }
 
 static void set_mlx_icrc_seg(void *dseg)
@@ -3022,27 +3023,23 @@ int mlx4_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 			case IB_WR_MASKED_ATOMIC_FETCH_AND_ADD:
 				set_raddr_seg(wqe, atomic_wr(wr)->remote_addr,
 					      atomic_wr(wr)->rkey);
-				wqe  += sizeof (struct mlx4_wqe_raddr_seg);
-
+				wqe  += sizeof(struct mlx4_wqe_raddr_seg);
 				set_atomic_seg(wqe, atomic_wr(wr));
-				wqe  += sizeof (struct mlx4_wqe_atomic_seg);
-
-				size += (sizeof (struct mlx4_wqe_raddr_seg) +
-					 sizeof (struct mlx4_wqe_atomic_seg)) / 16;
-
+				wqe  += sizeof(struct mlx4_wqe_atomic_seg);
+				size += (sizeof(struct mlx4_wqe_raddr_seg) +
+					 sizeof(struct mlx4_wqe_atomic_seg))
+					/ 16;
 				break;
 
 			case IB_WR_MASKED_ATOMIC_CMP_AND_SWP:
 				set_raddr_seg(wqe, atomic_wr(wr)->remote_addr,
 					      atomic_wr(wr)->rkey);
-				wqe  += sizeof (struct mlx4_wqe_raddr_seg);
-
+				wqe  += sizeof(struct mlx4_wqe_raddr_seg);
 				set_masked_atomic_seg(wqe, atomic_wr(wr));
-				wqe  += sizeof (struct mlx4_wqe_masked_atomic_seg);
-
-				size += (sizeof (struct mlx4_wqe_raddr_seg) +
-					 sizeof (struct mlx4_wqe_masked_atomic_seg)) / 16;
-
+				wqe  += sizeof(struct mlx4_wqe_masked_atomic_seg);
+				size += (sizeof(struct mlx4_wqe_raddr_seg) +
+					 sizeof(struct mlx4_wqe_masked_atomic_seg))
+					/ 16;
 				break;
 
 			case IB_WR_RDMA_READ:
@@ -3050,16 +3047,17 @@ int mlx4_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 			case IB_WR_RDMA_WRITE_WITH_IMM:
 				set_raddr_seg(wqe, rdma_wr(wr)->remote_addr,
 					      rdma_wr(wr)->rkey);
-				wqe  += sizeof (struct mlx4_wqe_raddr_seg);
-				size += sizeof (struct mlx4_wqe_raddr_seg) / 16;
+				wqe  += sizeof(struct mlx4_wqe_raddr_seg);
+				size += sizeof(struct mlx4_wqe_raddr_seg) / 16;
 				break;
 
 			case IB_WR_LOCAL_INV:
 				ctrl->srcrb_flags |=
 					cpu_to_be32(MLX4_WQE_CTRL_STRONG_ORDER);
 				set_local_inv_seg(wqe, wr->ex.invalidate_rkey);
-				wqe  += sizeof (struct mlx4_wqe_local_inval_seg);
-				size += sizeof (struct mlx4_wqe_local_inval_seg) / 16;
+				wqe  += sizeof(struct mlx4_wqe_local_inval_seg);
+				size += sizeof(struct mlx4_wqe_local_inval_seg)
+					/ 16;
 				break;
 
 			case IB_WR_REG_MR:
@@ -3092,13 +3090,13 @@ int mlx4_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 			set_datagram_seg(wqe, ud_wr(wr));
 			/* set the forced-loopback bit in the data seg av */
 			*(__be32 *) wqe |= cpu_to_be32(0x80000000);
-			wqe  += sizeof (struct mlx4_wqe_datagram_seg);
-			size += sizeof (struct mlx4_wqe_datagram_seg) / 16;
+			wqe  += sizeof(struct mlx4_wqe_datagram_seg);
+			size += sizeof(struct mlx4_wqe_datagram_seg) / 16;
 			break;
 		case MLX4_IB_QPT_UD:
 			set_datagram_seg(wqe, ud_wr(wr));
-			wqe  += sizeof (struct mlx4_wqe_datagram_seg);
-			size += sizeof (struct mlx4_wqe_datagram_seg) / 16;
+			wqe  += sizeof(struct mlx4_wqe_datagram_seg);
+			size += sizeof(struct mlx4_wqe_datagram_seg) / 16;
 
 			if (wr->opcode == IB_WR_LSO) {
 				err = build_lso_seg(wqe, ud_wr(wr), qp, &seglen,
@@ -3139,8 +3137,8 @@ int mlx4_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 			set_tunnel_datagram_seg(to_mdev(ibqp->device), wqe,
 						ud_wr(wr),
 						qp->mlx4_ib_qp_type);
-			wqe  += sizeof (struct mlx4_wqe_datagram_seg);
-			size += sizeof (struct mlx4_wqe_datagram_seg) / 16;
+			wqe  += sizeof(struct mlx4_wqe_datagram_seg);
+			size += sizeof(struct mlx4_wqe_datagram_seg) / 16;
 			build_tunnel_header(ud_wr(wr), wqe, &seglen);
 			wqe  += seglen;
 			size += seglen / 16;
@@ -3171,7 +3169,7 @@ int mlx4_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 
 		dseg = wqe;
 		dseg += wr->num_sge - 1;
-		size += wr->num_sge * (sizeof (struct mlx4_wqe_data_seg) / 16);
+		size += wr->num_sge * (sizeof(struct mlx4_wqe_data_seg) / 16);
 
 		/* Add one more inline data segment for ICRC for MLX sends */
 		if (unlikely(qp->mlx4_ib_qp_type == MLX4_IB_QPT_SMI ||
@@ -3179,7 +3177,7 @@ int mlx4_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 			     qp->mlx4_ib_qp_type &
 			     (MLX4_IB_QPT_PROXY_SMI_OWNER | MLX4_IB_QPT_TUN_SMI_OWNER))) {
 			set_mlx_icrc_seg(dseg + 1);
-			size += sizeof (struct mlx4_wqe_data_seg) / 16;
+			size += sizeof(struct mlx4_wqe_data_seg) / 16;
 		}
 
 		for (i = wr->num_sge - 1; i >= 0; --i, --dseg)
@@ -3304,10 +3302,10 @@ int mlx4_ib_post_recv(struct ib_qp *ibqp, struct ib_recv_wr *wr,
 		    MLX4_IB_QPT_PROXY_SMI | MLX4_IB_QPT_PROXY_GSI)) {
 			ib_dma_sync_single_for_device(ibqp->device,
 						      qp->sqp_proxy_rcv[ind].map,
-						      sizeof (struct mlx4_ib_proxy_sqp_hdr),
+						      sizeof(struct mlx4_ib_proxy_sqp_hdr),
 						      DMA_FROM_DEVICE);
 			scat->byte_count =
-				cpu_to_be32(sizeof (struct mlx4_ib_proxy_sqp_hdr));
+				cpu_to_be32(sizeof(struct mlx4_ib_proxy_sqp_hdr));
 			/* use dma lkey from upper layer entry */
 			scat->lkey = cpu_to_be32(wr->sg_list->lkey);
 			scat->addr = cpu_to_be64(qp->sqp_proxy_rcv[ind].map);
-- 
2.11.1

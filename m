From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 26/29] IB/mlx4: Enclose 14 expressions for the sizeof operator
 by parentheses
Date: Sat, 18 Feb 2017 22:16:11 +0100
Message-ID: <e309bc85-395b-3b81-15cf-dc2a5f8bf0ea@users.sourceforge.net>
References: <1935365a-bd7c-461e-6a84-0c5d3a501fff@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1935365a-bd7c-461e-6a84-0c5d3a501fff@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Leon Romanovsky <leonro@mellanox.com>, Matan Barak <matanb@mellanox.com>, Sean Hefty <sean.hefty@intel.com>, Yishai Hadas <yishaih@mellanox.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 18 Feb 2017 19:30:41 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The script "checkpatch.pl" pointed information out like the following.

WARNING: sizeof … should be sizeof(…)

Thus fix the affected source code places.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/infiniband/hw/mlx4/qp.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 16164ff09a86..3ffba8ebba7f 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -247,9 +247,10 @@ static void post_nop_wqe(struct mlx4_ib_qp *qp, int n, int size)
 	s = sizeof(struct mlx4_wqe_ctrl_seg);
 
 	if (qp->ibqp.qp_type == IB_QPT_UD) {
-		struct mlx4_wqe_datagram_seg *dgram = wqe + sizeof *ctrl;
+		struct mlx4_wqe_datagram_seg *dgram = wqe + sizeof(*ctrl);
 		struct mlx4_av *av = (struct mlx4_av *)dgram->av;
-		memset(dgram, 0, sizeof *dgram);
+
+		memset(dgram, 0, sizeof(*dgram));
 		av->port_pd = cpu_to_be32((qp->port << 24) | to_mpd(qp->ibqp.pd)->pdn);
 		s += sizeof(struct mlx4_wqe_datagram_seg);
 	}
@@ -257,7 +258,8 @@ static void post_nop_wqe(struct mlx4_ib_qp *qp, int n, int size)
 	/* Pad the remainder of the WQE with an inline data segment. */
 	if (size > s) {
 		inl = wqe + s;
-		inl->byte_count = cpu_to_be32(1 << 31 | (size - s - sizeof *inl));
+		inl->byte_count = cpu_to_be32(1 << 31
+					      | (size - s - sizeof(*inl)));
 	}
 	ctrl->srcrb_flags = 0;
 	ctrl->qpn_vlan.fence_size = size / 16;
@@ -727,7 +729,7 @@ static int create_qp_common(struct mlx4_ib_dev *dev, struct ib_pd *pd,
 	if (pd->uobject) {
 		struct mlx4_ib_create_qp ucmd;
 
-		if (ib_copy_from_udata(&ucmd, udata, sizeof ucmd)) {
+		if (ib_copy_from_udata(&ucmd, udata, sizeof(ucmd))) {
 			err = -EFAULT;
 			goto err;
 		}
@@ -1180,7 +1182,7 @@ static struct ib_qp *_mlx4_ib_create_qp(struct ib_pd *pd,
 	case IB_QPT_RC:
 	case IB_QPT_UC:
 	case IB_QPT_RAW_PACKET:
-		qp = kzalloc(sizeof *qp, gfp);
+		qp = kzalloc(sizeof(*qp), gfp);
 		if (!qp)
 			return ERR_PTR(-ENOMEM);
 		qp->pri.vid = 0xFFFF;
@@ -1635,7 +1637,7 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 	    IB_LINK_LAYER_ETHERNET)
 		return -ENOTSUPP;
 
-	context = kzalloc(sizeof *context, GFP_KERNEL);
+	context = kzalloc(sizeof(*context), GFP_KERNEL);
 	if (!context)
 		return -ENOMEM;
 
@@ -2299,7 +2301,7 @@ static int build_sriov_qp0_header(struct mlx4_ib_sqp *sqp,
 	struct mlx4_ib_dev *mdev = to_mdev(sqp->qp.ibqp.device);
 	struct ib_device *ib_dev = &mdev->ib_dev;
 	struct mlx4_wqe_mlx_seg *mlx = wqe;
-	struct mlx4_wqe_inline_seg *inl = wqe + sizeof *mlx;
+	struct mlx4_wqe_inline_seg *inl = wqe + sizeof(*mlx);
 	struct mlx4_ib_ah *ah = to_mah(wr->ah);
 	u16 pkey;
 	u32 qkey;
@@ -2428,7 +2430,7 @@ static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_ud_wr *wr,
 	struct ib_device *ib_dev = sqp->qp.ibqp.device;
 	struct mlx4_wqe_mlx_seg *mlx = wqe;
 	struct mlx4_wqe_ctrl_seg *ctrl = wqe;
-	struct mlx4_wqe_inline_seg *inl = wqe + sizeof *mlx;
+	struct mlx4_wqe_inline_seg *inl = wqe + sizeof(*mlx);
 	struct mlx4_ib_ah *ah = to_mah(wr->ah);
 	union ib_gid sgid;
 	u16 pkey;
@@ -2809,7 +2811,7 @@ static void build_tunnel_header(struct ib_ud_wr *wr, void *wqe, unsigned *mlx_se
 	int spc;
 	int i;
 
-	memcpy(&hdr.av, &ah->av, sizeof hdr.av);
+	memcpy(&hdr.av, &ah->av, sizeof(hdr.av));
 	hdr.remote_qpn = cpu_to_be32(wr->remote_qpn);
 	hdr.pkey_index = cpu_to_be16(wr->pkey_index);
 	hdr.qkey = cpu_to_be32(wr->remote_qkey);
@@ -2888,7 +2890,7 @@ static int build_lso_seg(struct mlx4_wqe_lso_seg *wqe, struct ib_ud_wr *wr,
 			 struct mlx4_ib_qp *qp, unsigned *lso_seg_len,
 			 __be32 *lso_hdr_sz, __be32 *blh)
 {
-	unsigned halign = ALIGN(sizeof *wqe + wr->hlen, 16);
+	unsigned int halign = ALIGN(sizeof(*wqe) + wr->hlen, 16);
 
 	if (unlikely(halign > MLX4_IB_CACHE_LINE_SIZE))
 		*blh = cpu_to_be32(1 << 6);
@@ -3010,9 +3012,8 @@ int mlx4_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 			qp->sq_signal_bits;
 
 		ctrl->imm = send_ieth(wr);
-
-		wqe += sizeof *ctrl;
-		size = sizeof *ctrl / 16;
+		wqe += sizeof(*ctrl);
+		size = sizeof(*ctrl) / 16;
 
 		switch (qp->mlx4_ib_qp_type) {
 		case MLX4_IB_QPT_RC:
@@ -3390,7 +3391,7 @@ static void to_ib_ah_attr(struct mlx4_ib_dev *ibdev, struct ib_ah_attr *ib_ah_at
 	struct mlx4_dev *dev = ibdev->dev;
 	int is_eth;
 
-	memset(ib_ah_attr, 0, sizeof *ib_ah_attr);
+	memset(ib_ah_attr, 0, sizeof(*ib_ah_attr));
 	ib_ah_attr->port_num	  = path->sched_queue & 0x40 ? 2 : 1;
 
 	if (ib_ah_attr->port_num == 0 || ib_ah_attr->port_num > dev->caps.num_ports)
@@ -3416,7 +3417,7 @@ static void to_ib_ah_attr(struct mlx4_ib_dev *ibdev, struct ib_ah_attr *ib_ah_at
 		ib_ah_attr->grh.flow_label =
 			be32_to_cpu(path->tclass_flowlabel) & 0xfffff;
 		memcpy(ib_ah_attr->grh.dgid.raw,
-			path->rgid, sizeof ib_ah_attr->grh.dgid.raw);
+			path->rgid, sizeof(ib_ah_attr->grh.dgid.raw));
 	}
 }
 
-- 
2.11.1

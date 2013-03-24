From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V4 for-next 2/5] IB/mlx4: Add support for RSS and TSS QP groups
Date: Sun, 24 Mar 2013 14:43:29 +0200
Message-ID: <1364129012-12198-3-git-send-email-ogerlitz@mellanox.com>
References: <1364129012-12198-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1364129012-12198-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Depending on the mlx4 device capabilities, support the RSS IB device
capability, using Topelitz or XOR hash functions according to what
available with the HW. Support creating QP groups where all RX and TX
QPs have contiguous QP numbers.

Signed-off-by: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c    |    5 +
 drivers/infiniband/hw/mlx4/mlx4_ib.h |   13 ++
 drivers/infiniband/hw/mlx4/qp.c      |  345 ++++++++++++++++++++++++++++++++-
 3 files changed, 352 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 23d7343..b29a4b6 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -145,6 +145,11 @@ static int mlx4_ib_query_device(struct ib_device *ibdev,
 		else
 			props->device_cap_flags |= IB_DEVICE_MEM_WINDOW_TYPE_2A;
 	}
+	props->device_cap_flags |= IB_DEVICE_QPG;
+	if (dev->dev->caps.flags2 & MLX4_DEV_CAP_FLAG2_RSS) {
+		props->device_cap_flags |= IB_DEVICE_UD_RSS;
+		props->max_rss_tbl_sz = dev->dev->caps.max_rss_tbl_sz;
+	}
 
 	props->vendor_id	   = be32_to_cpup((__be32 *) (out_mad->data + 36)) &
 		0xffffff;
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index f61ec26..48aeaab 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -232,6 +232,17 @@ struct mlx4_ib_proxy_sqp_hdr {
 	struct mlx4_rcv_tunnel_hdr tun;
 }  __packed;
 
+struct mlx4_ib_qpg_data {
+	unsigned long *tss_bitmap;
+	unsigned long *rss_bitmap;
+	struct mlx4_ib_qp *qpg_parent;
+	int tss_qpn_base;
+	int rss_qpn_base;
+	u32 tss_child_count;
+	u32 rss_child_count;
+	u32 qpg_tss_mask_sz;
+};
+
 struct mlx4_ib_qp {
 	struct ib_qp		ibqp;
 	struct mlx4_qp		mqp;
@@ -261,6 +272,8 @@ struct mlx4_ib_qp {
 	u8			sq_no_prefetch;
 	u8			state;
 	int			mlx_type;
+	enum ib_qpg_type	qpg_type;
+	struct mlx4_ib_qpg_data *qpg_data;
 	struct list_head	gid_list;
 	struct list_head	steering_rules;
 	struct mlx4_ib_buf	*sqp_proxy_rcv;
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index c58dbdc..e504e5f 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -34,6 +34,8 @@
 #include <linux/log2.h>
 #include <linux/slab.h>
 #include <linux/netdevice.h>
+#include <linux/bitmap.h>
+#include <linux/bitops.h>
 
 #include <rdma/ib_cache.h>
 #include <rdma/ib_pack.h>
@@ -593,6 +595,241 @@ static int qp_has_rq(struct ib_qp_init_attr *attr)
 	return !attr->srq;
 }
 
+static int init_qpg_parent(struct mlx4_ib_dev *dev, struct mlx4_ib_qp *pqp,
+			   struct ib_qp_init_attr *attr, int *qpn)
+{
+	struct mlx4_ib_qpg_data *qpg_data;
+	int tss_num, rss_num;
+	int tss_align_num, rss_align_num;
+	int tss_base, rss_base;
+	int err;
+
+	/* Parent is part of the TSS range (in SW TSS ARP is sent via parent) */
+	tss_num = 1 + attr->parent_attrib.tss_child_count;
+	tss_align_num = roundup_pow_of_two(tss_num);
+	rss_num = attr->parent_attrib.rss_child_count;
+	rss_align_num = roundup_pow_of_two(rss_num);
+
+	if (rss_num > 1) {
+		/* RSS is requested */
+		if (!(dev->dev->caps.flags2 & MLX4_DEV_CAP_FLAG2_RSS))
+			return -ENOSYS;
+		if (rss_align_num > dev->dev->caps.max_rss_tbl_sz)
+			return -EINVAL;
+		/* We must work with power of two */
+		attr->parent_attrib.rss_child_count = rss_align_num;
+	}
+
+	qpg_data = kzalloc(sizeof(*qpg_data), GFP_KERNEL);
+	if (!qpg_data)
+		return -ENOMEM;
+
+	err = mlx4_qp_reserve_range(dev->dev, tss_align_num,
+				    tss_align_num, &tss_base);
+	if (err)
+		goto err1;
+
+	if (tss_num > 1) {
+		u32 alloc = BITS_TO_LONGS(tss_align_num)  * sizeof(long);
+		qpg_data->tss_bitmap = kzalloc(alloc, GFP_KERNEL);
+		if (qpg_data->tss_bitmap == NULL) {
+			err = -ENOMEM;
+			goto err2;
+		}
+		bitmap_fill(qpg_data->tss_bitmap, tss_num);
+		/* Note parent takes first index */
+		clear_bit(0, qpg_data->tss_bitmap);
+	}
+
+	if (rss_num > 1) {
+		u32 alloc = BITS_TO_LONGS(rss_align_num) * sizeof(long);
+		err = mlx4_qp_reserve_range(dev->dev, rss_align_num,
+					    rss_align_num, &rss_base);
+		if (err)
+			goto err3;
+		qpg_data->rss_bitmap = kzalloc(alloc, GFP_KERNEL);
+		if (qpg_data->rss_bitmap == NULL) {
+			err = -ENOMEM;
+			goto err4;
+		}
+		bitmap_fill(qpg_data->rss_bitmap, rss_align_num);
+	}
+
+	qpg_data->tss_child_count = attr->parent_attrib.tss_child_count;
+	qpg_data->rss_child_count = attr->parent_attrib.rss_child_count;
+	qpg_data->qpg_parent = pqp;
+	qpg_data->qpg_tss_mask_sz = ilog2(tss_align_num);
+	qpg_data->tss_qpn_base = tss_base;
+	qpg_data->rss_qpn_base = rss_base;
+
+	pqp->qpg_data = qpg_data;
+	*qpn = tss_base;
+
+	return 0;
+
+err4:
+	mlx4_qp_release_range(dev->dev, rss_base, rss_align_num);
+
+err3:
+	if (tss_num > 1)
+		kfree(qpg_data->tss_bitmap);
+
+err2:
+	mlx4_qp_release_range(dev->dev, tss_base, tss_align_num);
+
+err1:
+	kfree(qpg_data);
+	return err;
+}
+
+static void free_qpg_parent(struct mlx4_ib_dev *dev, struct mlx4_ib_qp *pqp)
+{
+	struct mlx4_ib_qpg_data *qpg_data = pqp->qpg_data;
+	int align_num;
+
+	if (qpg_data->tss_child_count > 1)
+		kfree(qpg_data->tss_bitmap);
+
+	align_num = roundup_pow_of_two(1 + qpg_data->tss_child_count);
+	mlx4_qp_release_range(dev->dev, qpg_data->tss_qpn_base, align_num);
+
+	if (qpg_data->rss_child_count > 1) {
+		kfree(qpg_data->rss_bitmap);
+		align_num = roundup_pow_of_two(qpg_data->rss_child_count);
+		mlx4_qp_release_range(dev->dev, qpg_data->rss_qpn_base,
+				      align_num);
+	}
+
+	kfree(qpg_data);
+}
+
+static int alloc_qpg_qpn(struct ib_qp_init_attr *init_attr,
+			 struct mlx4_ib_qp *pqp, int *qpn)
+{
+	struct mlx4_ib_qp *mqp = to_mqp(init_attr->qpg_parent);
+	struct mlx4_ib_qpg_data *qpg_data = mqp->qpg_data;
+	u32 idx, old;
+
+	switch (init_attr->qpg_type) {
+	case IB_QPG_CHILD_TX:
+		if (qpg_data->tss_child_count == 0)
+			return -EINVAL;
+		do {
+			/* Parent took index 0 */
+			idx = find_first_bit(qpg_data->tss_bitmap,
+					     qpg_data->tss_child_count + 1);
+			if (idx >= qpg_data->tss_child_count + 1)
+				return -ENOMEM;
+			old = test_and_clear_bit(idx, qpg_data->tss_bitmap);
+		} while (old == 0);
+		idx += qpg_data->tss_qpn_base;
+		break;
+	case IB_QPG_CHILD_RX:
+		if (qpg_data->rss_child_count == 0)
+			return -EINVAL;
+		do {
+			idx = find_first_bit(qpg_data->rss_bitmap,
+					     qpg_data->rss_child_count);
+			if (idx >= qpg_data->rss_child_count)
+				return -ENOMEM;
+			old = test_and_clear_bit(idx, qpg_data->rss_bitmap);
+		} while (old == 0);
+		idx += qpg_data->rss_qpn_base;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	pqp->qpg_data = qpg_data;
+	*qpn = idx;
+
+	return 0;
+}
+
+static void free_qpg_qpn(struct mlx4_ib_qp *mqp, int qpn)
+{
+	struct mlx4_ib_qpg_data *qpg_data = mqp->qpg_data;
+
+	switch (mqp->qpg_type) {
+	case IB_QPG_CHILD_TX:
+		/* Do range check */
+		qpn -= qpg_data->tss_qpn_base;
+		set_bit(qpn, qpg_data->tss_bitmap);
+		break;
+	case IB_QPG_CHILD_RX:
+		qpn -= qpg_data->rss_qpn_base;
+		set_bit(qpn, qpg_data->rss_bitmap);
+		break;
+	default:
+		/* error */
+		pr_warn("wrong qpg type (%d)\n", mqp->qpg_type);
+		break;
+	}
+}
+
+static int alloc_qpn_common(struct mlx4_ib_dev *dev, struct mlx4_ib_qp *qp,
+			    struct ib_qp_init_attr *attr, int *qpn)
+{
+	int err = 0;
+
+	switch (attr->qpg_type) {
+	case IB_QPG_NONE:
+		/* Raw packet QPNs must be aligned to 8 bits. If not, the WQE
+		 * BlueFlame setup flow wrongly causes VLAN insertion. */
+		if (attr->qp_type == IB_QPT_RAW_PACKET)
+			err = mlx4_qp_reserve_range(dev->dev, 1, 1 << 8, qpn);
+		else
+			err = mlx4_qp_reserve_range(dev->dev, 1, 1, qpn);
+		break;
+	case IB_QPG_PARENT:
+		err = init_qpg_parent(dev, qp, attr, qpn);
+		break;
+	case IB_QPG_CHILD_TX:
+	case IB_QPG_CHILD_RX:
+		err = alloc_qpg_qpn(attr, qp, qpn);
+		break;
+	default:
+		qp->qpg_type = IB_QPG_NONE;
+		err = -EINVAL;
+		break;
+	}
+	if (err)
+		return err;
+	qp->qpg_type = attr->qpg_type;
+	return 0;
+}
+
+static void free_qpn_common(struct mlx4_ib_dev *dev, struct mlx4_ib_qp *qp,
+			enum ib_qpg_type qpg_type, int qpn)
+{
+	switch (qpg_type) {
+	case IB_QPG_NONE:
+		mlx4_qp_release_range(dev->dev, qpn, 1);
+		break;
+	case IB_QPG_PARENT:
+		free_qpg_parent(dev, qp);
+		break;
+	case IB_QPG_CHILD_TX:
+	case IB_QPG_CHILD_RX:
+		free_qpg_qpn(qp, qpn);
+		break;
+	default:
+		break;
+	}
+}
+
+/* Revert allocation on create_qp_common */
+static void unalloc_qpn_common(struct mlx4_ib_dev *dev, struct mlx4_ib_qp *qp,
+			       struct ib_qp_init_attr *attr, int qpn)
+{
+	free_qpn_common(dev, qp, attr->qpg_type, qpn);
+}
+
+static void release_qpn_common(struct mlx4_ib_dev *dev, struct mlx4_ib_qp *qp)
+{
+	free_qpn_common(dev, qp, qp->qpg_type, qp->mqp.qpn);
+}
+
 static int create_qp_common(struct mlx4_ib_dev *dev, struct ib_pd *pd,
 			    struct ib_qp_init_attr *init_attr,
 			    struct ib_udata *udata, int sqpn, struct mlx4_ib_qp **caller_qp)
@@ -760,12 +997,7 @@ static int create_qp_common(struct mlx4_ib_dev *dev, struct ib_pd *pd,
 			}
 		}
 	} else {
-		/* Raw packet QPNs must be aligned to 8 bits. If not, the WQE
-		 * BlueFlame setup flow wrongly causes VLAN insertion. */
-		if (init_attr->qp_type == IB_QPT_RAW_PACKET)
-			err = mlx4_qp_reserve_range(dev->dev, 1, 1 << 8, &qpn);
-		else
-			err = mlx4_qp_reserve_range(dev->dev, 1, 1, &qpn);
+		err = alloc_qpn_common(dev, qp, init_attr, &qpn);
 		if (err)
 			goto err_proxy;
 	}
@@ -790,8 +1022,8 @@ static int create_qp_common(struct mlx4_ib_dev *dev, struct ib_pd *pd,
 	return 0;
 
 err_qpn:
-	if (!sqpn)
-		mlx4_qp_release_range(dev->dev, qpn, 1);
+	unalloc_qpn_common(dev, qp, init_attr, qpn);
+
 err_proxy:
 	if (qp->mlx4_ib_qp_type == MLX4_IB_QPT_PROXY_GSI)
 		free_proxy_bufs(pd->device, qp);
@@ -933,7 +1165,7 @@ static void destroy_qp_common(struct mlx4_ib_dev *dev, struct mlx4_ib_qp *qp,
 	mlx4_qp_free(dev->dev, &qp->mqp);
 
 	if (!is_sqp(dev, qp) && !is_tunnel_qp(dev, qp))
-		mlx4_qp_release_range(dev->dev, qp->mqp.qpn, 1);
+		release_qpn_common(dev, qp);
 
 	mlx4_mtt_cleanup(dev->dev, &qp->mtt);
 
@@ -973,6 +1205,52 @@ static u32 get_sqp_num(struct mlx4_ib_dev *dev, struct ib_qp_init_attr *attr)
 		return dev->dev->caps.qp1_proxy[attr->port_num - 1];
 }
 
+static int check_qpg_attr(struct mlx4_ib_dev *dev,
+			  struct ib_qp_init_attr *attr)
+{
+	if (attr->qpg_type == IB_QPG_NONE)
+		return 0;
+
+	if (attr->qp_type != IB_QPT_UD)
+		return -EINVAL;
+
+	if (attr->qpg_type == IB_QPG_PARENT) {
+		if (attr->parent_attrib.tss_child_count == 1)
+			return -EINVAL; /* Doesn't make sense */
+		if (attr->parent_attrib.rss_child_count == 1)
+			return -EINVAL; /* Doesn't make sense */
+		if ((attr->parent_attrib.tss_child_count == 0) &&
+		    (attr->parent_attrib.rss_child_count == 0))
+			/* Should be called with IP_QPG_NONE */
+			return -EINVAL;
+		if (attr->parent_attrib.rss_child_count > 1) {
+			int rss_align_num;
+			if (!(dev->dev->caps.flags2 & MLX4_DEV_CAP_FLAG2_RSS))
+				return -ENOSYS;
+			rss_align_num = roundup_pow_of_two(
+					attr->parent_attrib.rss_child_count);
+			if (rss_align_num > dev->dev->caps.max_rss_tbl_sz)
+				return -EINVAL;
+		}
+	} else {
+		struct mlx4_ib_qpg_data *qpg_data;
+		if (attr->qpg_parent == NULL)
+			return -EINVAL;
+		if (IS_ERR(attr->qpg_parent))
+			return -EINVAL;
+		qpg_data = to_mqp(attr->qpg_parent)->qpg_data;
+		if (qpg_data == NULL)
+			return -EINVAL;
+		if (attr->qpg_type == IB_QPG_CHILD_TX &&
+		    !qpg_data->tss_child_count)
+			return -EINVAL;
+		if (attr->qpg_type == IB_QPG_CHILD_RX &&
+		    !qpg_data->rss_child_count)
+			return -EINVAL;
+	}
+	return 0;
+}
+
 struct ib_qp *mlx4_ib_create_qp(struct ib_pd *pd,
 				struct ib_qp_init_attr *init_attr,
 				struct ib_udata *udata)
@@ -998,8 +1276,9 @@ struct ib_qp *mlx4_ib_create_qp(struct ib_pd *pd,
 	      init_attr->qp_type > IB_QPT_GSI)))
 		return ERR_PTR(-EINVAL);
 
-	if (init_attr->qpg_type != IB_QPG_NONE)
-		return ERR_PTR(-ENOSYS);
+	err = check_qpg_attr(to_mdev(pd->device), init_attr);
+	if (err)
+		return ERR_PTR(err);
 
 	switch (init_attr->qp_type) {
 	case IB_QPT_XRC_TGT:
@@ -1470,6 +1749,43 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 	if (!ibqp->uobject && cur_state == IB_QPS_RESET && new_state == IB_QPS_INIT)
 		context->rlkey |= (1 << 4);
 
+	if ((attr_mask & IB_QP_GROUP_RSS) &&
+	    (qp->qpg_data->rss_child_count > 1)) {
+		struct mlx4_ib_qpg_data *qpg_data = qp->qpg_data;
+		void *rss_context_base = &context->pri_path;
+		struct mlx4_rss_context *rss_context =
+			(struct mlx4_rss_context *)(rss_context_base
+					+ MLX4_RSS_OFFSET_IN_QPC_PRI_PATH);
+
+		context->flags |= cpu_to_be32(1 << MLX4_RSS_QPC_FLAG_OFFSET);
+
+		/* This should be tbl_sz_base_qpn */
+		rss_context->base_qpn = cpu_to_be32(qpg_data->rss_qpn_base |
+				(ilog2(qpg_data->rss_child_count) << 24));
+		rss_context->default_qpn = cpu_to_be32(qpg_data->rss_qpn_base);
+		/* This should be flags_hash_fn */
+		rss_context->flags = MLX4_RSS_TCP_IPV6 |
+				     MLX4_RSS_TCP_IPV4;
+		if (dev->dev->caps.flags & MLX4_DEV_CAP_FLAG_UDP_RSS) {
+			rss_context->base_qpn_udp = rss_context->default_qpn;
+			rss_context->flags |= MLX4_RSS_IPV6 |
+					MLX4_RSS_IPV4     |
+					MLX4_RSS_UDP_IPV6 |
+					MLX4_RSS_UDP_IPV4;
+		}
+		if (dev->dev->caps.flags2 & MLX4_DEV_CAP_FLAG2_RSS_TOP) {
+			static const u32 rsskey[10] = { 0xD181C62C, 0xF7F4DB5B,
+				0x1983A2FC, 0x943E1ADB, 0xD9389E6B, 0xD1039C2C,
+				0xA74499AD, 0x593D56D9, 0xF3253C06, 0x2ADC1FFC};
+			rss_context->hash_fn = MLX4_RSS_HASH_TOP;
+			memcpy(rss_context->rss_key, rsskey,
+			       sizeof(rss_context->rss_key));
+		} else {
+			rss_context->hash_fn = MLX4_RSS_HASH_XOR;
+			memset(rss_context->rss_key, 0,
+			       sizeof(rss_context->rss_key));
+		}
+	}
 	/*
 	 * Before passing a kernel QP to the HW, make sure that the
 	 * ownership bits of the send queue are set and the SQ
@@ -2763,6 +3079,13 @@ done:
 		qp->sq_signal_bits == cpu_to_be32(MLX4_WQE_CTRL_CQ_UPDATE) ?
 		IB_SIGNAL_ALL_WR : IB_SIGNAL_REQ_WR;
 
+	qp_init_attr->qpg_type = qp->qpg_type;
+	if (qp->qpg_type == IB_QPG_PARENT)
+		qp_init_attr->cap.qpg_tss_mask_sz =
+			qp->qpg_data->qpg_tss_mask_sz;
+	else
+		qp_init_attr->cap.qpg_tss_mask_sz = 0;
+
 out:
 	mutex_unlock(&qp->mutex);
 	return err;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

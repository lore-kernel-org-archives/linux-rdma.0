From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next V3 8/8] IB/mlx4: Add support for CQ time-stamping
Date: Thu, 11 Jun 2015 16:35:27 +0300
Message-ID: <1434029727-6062-9-git-send-email-ogerlitz@mellanox.com>
References: <1434029727-6062-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1434029727-6062-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This includes:

* support allocation of CQ with the TIMESTAMP_COMPLETION creation flag.

* add timestamp_mask and hca_core_clock to query_device, reporting the
  number of supported timestamp bits (mask) and the hca_core_clock frequency.

* return hca core clock's offset in query_device vendor's data,
  this is needed in order to read the HCA's core clock.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/cq.c      |    9 +++++--
 drivers/infiniband/hw/mlx4/main.c    |   42 ++++++++++++++++++++++++++++++++-
 drivers/infiniband/hw/mlx4/mlx4_ib.h |   16 +++++++++++++
 3 files changed, 62 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/cq.c b/drivers/infiniband/hw/mlx4/cq.c
index 8e44aaa..36eb3d0 100644
--- a/drivers/infiniband/hw/mlx4/cq.c
+++ b/drivers/infiniband/hw/mlx4/cq.c
@@ -166,6 +166,7 @@ err_buf:
 	return err;
 }
 
+#define CQ_CREATE_FLAGS_SUPPORTED IB_CQ_FLAGS_TIMESTAMP_COMPLETION
 struct ib_cq *mlx4_ib_create_cq(struct ib_device *ibdev,
 				const struct ib_cq_init_attr *attr,
 				struct ib_ucontext *context,
@@ -178,10 +179,10 @@ struct ib_cq *mlx4_ib_create_cq(struct ib_device *ibdev,
 	struct mlx4_uar *uar;
 	int err;
 
-	if (attr->flags)
+	if (entries < 1 || entries > dev->dev->caps.max_cqes)
 		return ERR_PTR(-EINVAL);
 
-	if (entries < 1 || entries > dev->dev->caps.max_cqes)
+	if (attr->flags & ~CQ_CREATE_FLAGS_SUPPORTED)
 		return ERR_PTR(-EINVAL);
 
 	cq = kmalloc(sizeof *cq, GFP_KERNEL);
@@ -194,6 +195,7 @@ struct ib_cq *mlx4_ib_create_cq(struct ib_device *ibdev,
 	spin_lock_init(&cq->lock);
 	cq->resize_buf = NULL;
 	cq->resize_umem = NULL;
+	cq->create_flags = attr->flags;
 	INIT_LIST_HEAD(&cq->send_qp_list);
 	INIT_LIST_HEAD(&cq->recv_qp_list);
 
@@ -237,7 +239,8 @@ struct ib_cq *mlx4_ib_create_cq(struct ib_device *ibdev,
 		vector = dev->eq_table[vector % ibdev->num_comp_vectors];
 
 	err = mlx4_cq_alloc(dev->dev, entries, &cq->buf.mtt, uar,
-			    cq->db.dma, &cq->mcq, vector, 0, 0);
+			    cq->db.dma, &cq->mcq, vector, 0,
+			    !!(cq->create_flags & IB_CQ_FLAGS_TIMESTAMP_COMPLETION));
 	if (err)
 		goto err_dbmap;
 
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index a4abebf..37c2660 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -140,10 +140,27 @@ static int mlx4_ib_query_device(struct ib_device *ibdev,
 	struct ib_smp *out_mad = NULL;
 	int err = -ENOMEM;
 	int have_ib_ports;
+	struct mlx4_uverbs_ex_query_device cmd;
+	struct mlx4_uverbs_ex_query_device_resp resp = {.comp_mask = 0};
+	struct mlx4_clock_params clock_params;
 
-	if (uhw->inlen || uhw->outlen)
-		return -EINVAL;
+	if (uhw->inlen) {
+		if (uhw->inlen < sizeof(cmd))
+			return -EINVAL;
+
+		err = ib_copy_from_udata(&cmd, uhw, sizeof(cmd));
+		if (err)
+			return err;
+
+		if (cmd.comp_mask)
+			return -EINVAL;
+
+		if (cmd.reserved)
+			return -EINVAL;
+	}
 
+	resp.response_length = offsetof(typeof(resp), response_length) +
+		sizeof(resp.response_length);
 	in_mad  = kzalloc(sizeof *in_mad, GFP_KERNEL);
 	out_mad = kmalloc(sizeof *out_mad, GFP_KERNEL);
 	if (!in_mad || !out_mad)
@@ -233,7 +250,24 @@ static int mlx4_ib_query_device(struct ib_device *ibdev,
 	props->max_total_mcast_qp_attach = props->max_mcast_qp_attach *
 					   props->max_mcast_grp;
 	props->max_map_per_fmr = dev->dev->caps.max_fmr_maps;
+	props->hca_core_clock = dev->dev->caps.hca_core_clock * 1000UL;
+	props->timestamp_mask = 0xFFFFFFFFFFFFULL;
 
+	err = mlx4_get_internal_clock_params(dev->dev, &clock_params);
+	if (err)
+		goto out;
+
+	if (uhw->outlen >= resp.response_length + sizeof(resp.hca_core_clock_offset)) {
+		resp.hca_core_clock_offset = clock_params.offset % PAGE_SIZE;
+		resp.response_length += sizeof(resp.hca_core_clock_offset);
+		resp.comp_mask |= QUERY_DEVICE_RESP_MASK_TIMESTAMP;
+	}
+
+	if (uhw->outlen) {
+		err = ib_copy_to_udata(uhw, &resp, resp.response_length);
+		if (err)
+			goto out;
+	}
 out:
 	kfree(in_mad);
 	kfree(out_mad);
@@ -2322,6 +2356,10 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 			(1ull << IB_USER_VERBS_EX_CMD_DESTROY_FLOW);
 	}
 
+	ibdev->ib_dev.uverbs_ex_cmd_mask |=
+		(1ull << IB_USER_VERBS_EX_CMD_QUERY_DEVICE) |
+		(1ull << IB_USER_VERBS_EX_CMD_CREATE_CQ);
+
 	mlx4_ib_alloc_eqs(dev, ibdev);
 
 	spin_lock_init(&iboe->lock);
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index f127efc..8421e15 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -110,6 +110,7 @@ struct mlx4_ib_cq {
 	struct mutex		resize_mutex;
 	struct ib_umem	       *umem;
 	struct ib_umem	       *resize_umem;
+	int			create_flags;
 	/* List of qps that it serves.*/
 	struct list_head		send_qp_list;
 	struct list_head		recv_qp_list;
@@ -555,6 +556,21 @@ struct mlx4_ib_qp_tunnel_init_attr {
 	u8 port;
 };
 
+struct mlx4_uverbs_ex_query_device {
+	__u32 comp_mask;
+	__u32 reserved;
+};
+
+enum query_device_resp_mask {
+	QUERY_DEVICE_RESP_MASK_TIMESTAMP = 1UL << 0,
+};
+
+struct mlx4_uverbs_ex_query_device_resp {
+	__u32 comp_mask;
+	__u32 response_length;
+	__u64 hca_core_clock_offset;
+};
+
 static inline struct mlx4_ib_dev *to_mdev(struct ib_device *ibdev)
 {
 	return container_of(ibdev, struct mlx4_ib_dev, ib_dev);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

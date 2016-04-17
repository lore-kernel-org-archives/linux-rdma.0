From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V3 for-next 07/10] IB/mlx5: Add Receive Work Queue Indirection table operations
Date: Sun, 17 Apr 2016 17:27:14 +0300
Message-ID: <1460903237-16870-8-git-send-email-yishaih@mellanox.com>
References: <1460903237-16870-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1460903237-16870-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, alexv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Some mlx5 based hardwares support a RQ table object. This RQ table
points to a few RQ objects. We implement the receive work queue
indirection table API (create and destroy) by using this hardware
object.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c    |  6 ++-
 drivers/infiniband/hw/mlx5/mlx5_ib.h | 14 +++++++
 drivers/infiniband/hw/mlx5/qp.c      | 78 ++++++++++++++++++++++++++++++++++++
 drivers/infiniband/hw/mlx5/user.h    |  5 +++
 4 files changed, 102 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 4435958..bbe74e0 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -2386,12 +2386,16 @@ static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 		dev->ib_dev.create_wq	 = mlx5_ib_create_wq;
 		dev->ib_dev.modify_wq	 = mlx5_ib_modify_wq;
 		dev->ib_dev.destroy_wq	 = mlx5_ib_destroy_wq;
+		dev->ib_dev.create_rwq_ind_table = mlx5_ib_create_rwq_ind_table;
+		dev->ib_dev.destroy_rwq_ind_table = mlx5_ib_destroy_rwq_ind_table;
 		dev->ib_dev.uverbs_ex_cmd_mask |=
 			(1ull << IB_USER_VERBS_EX_CMD_CREATE_FLOW) |
 			(1ull << IB_USER_VERBS_EX_CMD_DESTROY_FLOW) |
 			(1ull << IB_USER_VERBS_EX_CMD_CREATE_WQ) |
 			(1ull << IB_USER_VERBS_EX_CMD_MODIFY_WQ) |
-			(1ull << IB_USER_VERBS_EX_CMD_DESTROY_WQ);
+			(1ull << IB_USER_VERBS_EX_CMD_DESTROY_WQ) |
+			(1ull << IB_USER_VERBS_EX_CMD_CREATE_RWQ_IND_TBL) |
+			(1ull << IB_USER_VERBS_EX_CMD_DESTROY_RWQ_IND_TBL);
 	}
 	err = init_node_data(dev);
 	if (err)
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 9a82a0a..7c4769a 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -245,6 +245,11 @@ enum {
 	MLX5_WQ_KERNEL
 };
 
+struct mlx5_ib_rwq_ind_table {
+	struct ib_rwq_ind_table ib_rwq_ind_tbl;
+	u32			rqtn;
+};
+
 /*
  * Connect-IB can trigger up to four concurrent pagefaults
  * per-QP.
@@ -654,6 +659,11 @@ static inline struct mlx5_ib_rwq *to_mrwq(struct ib_wq *ibwq)
 	return container_of(ibwq, struct mlx5_ib_rwq, ibwq);
 }
 
+static inline struct mlx5_ib_rwq_ind_table *to_mrwq_ind_table(struct ib_rwq_ind_table *ib_rwq_ind_tbl)
+{
+	return container_of(ib_rwq_ind_tbl, struct mlx5_ib_rwq_ind_table, ib_rwq_ind_tbl);
+}
+
 static inline struct mlx5_ib_srq *to_mibsrq(struct mlx5_core_srq *msrq)
 {
 	return container_of(msrq, struct mlx5_ib_srq, msrq);
@@ -795,6 +805,10 @@ struct ib_wq *mlx5_ib_create_wq(struct ib_pd *pd,
 int mlx5_ib_destroy_wq(struct ib_wq *wq);
 int mlx5_ib_modify_wq(struct ib_wq *wq, struct ib_wq_attr *wq_attr,
 		      u32 wq_attr_mask, struct ib_udata *udata);
+struct ib_rwq_ind_table *mlx5_ib_create_rwq_ind_table(struct ib_device *device,
+						      struct ib_rwq_ind_table_init_attr *init_attr,
+						      struct ib_udata *udata);
+int mlx5_ib_destroy_rwq_ind_table(struct ib_rwq_ind_table *wq_ind_table);
 
 #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
 extern struct workqueue_struct *mlx5_ib_page_fault_wq;
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index f9ae6b7..67c7ad3 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -4388,6 +4388,84 @@ int mlx5_ib_destroy_wq(struct ib_wq *wq)
 	return 0;
 }
 
+struct ib_rwq_ind_table *mlx5_ib_create_rwq_ind_table(struct ib_device *device,
+						      struct ib_rwq_ind_table_init_attr *init_attr,
+						      struct ib_udata *udata)
+{
+	struct mlx5_ib_dev *dev = to_mdev(device);
+	struct mlx5_ib_rwq_ind_table *rwq_ind_tbl;
+	int sz = 1 << init_attr->log_ind_tbl_size;
+	struct mlx5_ib_create_rwq_ind_tbl_resp resp = {};
+	size_t min_resp_len;
+	int inlen;
+	int err;
+	int i;
+	u32 *in;
+	void *rqtc;
+
+	if (udata->inlen > 0 &&
+	    !ib_is_udata_cleared(udata, 0,
+				 udata->inlen))
+		return ERR_PTR(-EOPNOTSUPP);
+
+	min_resp_len = offsetof(typeof(resp), reserved) + sizeof(resp.reserved);
+	if (udata->outlen && udata->outlen < min_resp_len)
+		return ERR_PTR(-EINVAL);
+
+	rwq_ind_tbl = kzalloc(sizeof(*rwq_ind_tbl), GFP_KERNEL);
+	if (!rwq_ind_tbl)
+		return ERR_PTR(-ENOMEM);
+
+	inlen = MLX5_ST_SZ_BYTES(create_rqt_in) + sizeof(u32) * sz;
+	in = mlx5_vzalloc(inlen);
+	if (!in) {
+		err = -ENOMEM;
+		goto err;
+	}
+
+	rqtc = MLX5_ADDR_OF(create_rqt_in, in, rqt_context);
+
+	MLX5_SET(rqtc, rqtc, rqt_actual_size, sz);
+	MLX5_SET(rqtc, rqtc, rqt_max_size, sz);
+
+	for (i = 0; i < sz; i++)
+		MLX5_SET(rqtc, rqtc, rq_num[i], init_attr->ind_tbl[i]->wq_num);
+
+	err = mlx5_core_create_rqt(dev->mdev, in, inlen, &rwq_ind_tbl->rqtn);
+	kvfree(in);
+
+	if (err)
+		goto err;
+
+	rwq_ind_tbl->ib_rwq_ind_tbl.ind_tbl_num = rwq_ind_tbl->rqtn;
+	if (udata->outlen) {
+		resp.response_length = offsetof(typeof(resp), response_length) +
+					sizeof(resp.response_length);
+		err = ib_copy_to_udata(udata, &resp, resp.response_length);
+		if (err)
+			goto err_copy;
+	}
+
+	return &rwq_ind_tbl->ib_rwq_ind_tbl;
+
+err_copy:
+	mlx5_core_destroy_rqt(dev->mdev, rwq_ind_tbl->rqtn);
+err:
+	kfree(rwq_ind_tbl);
+	return ERR_PTR(err);
+}
+
+int mlx5_ib_destroy_rwq_ind_table(struct ib_rwq_ind_table *ib_rwq_ind_tbl)
+{
+	struct mlx5_ib_rwq_ind_table *rwq_ind_tbl = to_mrwq_ind_table(ib_rwq_ind_tbl);
+	struct mlx5_ib_dev *dev = to_mdev(ib_rwq_ind_tbl->device);
+
+	mlx5_core_destroy_rqt(dev->mdev, rwq_ind_tbl->rqtn);
+
+	kfree(rwq_ind_tbl);
+	return 0;
+}
+
 int mlx5_ib_modify_wq(struct ib_wq *wq, struct ib_wq_attr *wq_attr,
 		      u32 wq_attr_mask, struct ib_udata *udata)
 {
diff --git a/drivers/infiniband/hw/mlx5/user.h b/drivers/infiniband/hw/mlx5/user.h
index 3e66f93..0f87955 100644
--- a/drivers/infiniband/hw/mlx5/user.h
+++ b/drivers/infiniband/hw/mlx5/user.h
@@ -179,6 +179,11 @@ struct mlx5_ib_create_wq_resp {
 	__u32	reserved;
 };
 
+struct mlx5_ib_create_rwq_ind_tbl_resp {
+	__u32	response_length;
+	__u32	reserved;
+};
+
 struct mlx5_ib_modify_wq {
 	__u32	comp_mask;
 	__u32	reserved;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next V1 2/4] IB/mlx4: Add support for WQ indirection table related verbs
Date: Tue,  4 Jul 2017 16:24:25 +0300
Message-ID: <20170704132427.25937-3-leon@kernel.org>
References: <20170704132427.25937-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170704132427.25937-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Guy Levi <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Guy Levi <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

To enable RSS functionality the IB indirection table object (i.e.
ib_rwq_ind_table) should be used.
This patch implements the related verbs as of create and destroy an
indirection table.

In downstream patches the indirection table will be used as part of RSS
QP creation.

Signed-off-by: Guy Levi <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c    | 12 +++++--
 drivers/infiniband/hw/mlx4/mlx4_ib.h |  6 ++++
 drivers/infiniband/hw/mlx4/qp.c      | 69 ++++++++++++++++++++++++++++++++++++
 include/uapi/rdma/mlx4-abi.h         |  4 +++
 4 files changed, 88 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index ddcc6afe41f5..0e1cb209b9cb 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -2738,10 +2738,16 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 		ibdev->ib_dev.create_wq		= mlx4_ib_create_wq;
 		ibdev->ib_dev.modify_wq		= mlx4_ib_modify_wq;
 		ibdev->ib_dev.destroy_wq	= mlx4_ib_destroy_wq;
+		ibdev->ib_dev.create_rwq_ind_table  =
+			mlx4_ib_create_rwq_ind_table;
+		ibdev->ib_dev.destroy_rwq_ind_table =
+			mlx4_ib_destroy_rwq_ind_table;
 		ibdev->ib_dev.uverbs_ex_cmd_mask |=
-			(1ull << IB_USER_VERBS_EX_CMD_CREATE_WQ) |
-			(1ull << IB_USER_VERBS_EX_CMD_MODIFY_WQ) |
-			(1ull << IB_USER_VERBS_EX_CMD_DESTROY_WQ);
+			(1ull << IB_USER_VERBS_EX_CMD_CREATE_WQ)	  |
+			(1ull << IB_USER_VERBS_EX_CMD_MODIFY_WQ)	  |
+			(1ull << IB_USER_VERBS_EX_CMD_DESTROY_WQ)	  |
+			(1ull << IB_USER_VERBS_EX_CMD_CREATE_RWQ_IND_TBL) |
+			(1ull << IB_USER_VERBS_EX_CMD_DESTROY_RWQ_IND_TBL);
 	}
 
 	if (!mlx4_is_slave(ibdev->dev)) {
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index ba4e78c064d2..85525bc400a0 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -916,4 +916,10 @@ int mlx4_ib_destroy_wq(struct ib_wq *wq);
 int mlx4_ib_modify_wq(struct ib_wq *wq, struct ib_wq_attr *wq_attr,
 		      u32 wq_attr_mask, struct ib_udata *udata);
 
+struct ib_rwq_ind_table
+*mlx4_ib_create_rwq_ind_table(struct ib_device *device,
+			      struct ib_rwq_ind_table_init_attr *init_attr,
+			      struct ib_udata *udata);
+int mlx4_ib_destroy_rwq_ind_table(struct ib_rwq_ind_table *wq_ind_table);
+
 #endif /* MLX4_IB_H */
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 2d4b7ffd3684..519919d15474 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -3944,3 +3944,72 @@ int mlx4_ib_destroy_wq(struct ib_wq *ibwq)
 	return 0;
 }
 
+struct ib_rwq_ind_table
+*mlx4_ib_create_rwq_ind_table(struct ib_device *device,
+			      struct ib_rwq_ind_table_init_attr *init_attr,
+			      struct ib_udata *udata)
+{
+	struct ib_rwq_ind_table *rwq_ind_table;
+	struct mlx4_ib_create_rwq_ind_tbl_resp resp = {};
+	unsigned int ind_tbl_size = 1 << init_attr->log_ind_tbl_size;
+	unsigned int base_wqn;
+	size_t min_resp_len;
+	int i;
+	int err;
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
+	if (ind_tbl_size >
+	    device->attrs.rss_caps.max_rwq_indirection_table_size) {
+		pr_debug("log_ind_tbl_size = %d is bigger than supported = %d\n",
+			 ind_tbl_size,
+			 device->attrs.rss_caps.max_rwq_indirection_table_size);
+		return ERR_PTR(-EINVAL);
+	}
+
+	base_wqn = init_attr->ind_tbl[0]->wq_num;
+
+	if (base_wqn % ind_tbl_size) {
+		pr_debug("WQN=0x%x isn't aligned with indirection table size\n",
+			 base_wqn);
+		return ERR_PTR(-EINVAL);
+	}
+
+	for (i = 1; i < ind_tbl_size; i++) {
+		if (++base_wqn != init_attr->ind_tbl[i]->wq_num) {
+			pr_debug("indirection table's WQNs aren't consecutive\n");
+			return ERR_PTR(-EINVAL);
+		}
+	}
+
+	rwq_ind_table = kzalloc(sizeof(*rwq_ind_table), GFP_KERNEL);
+	if (!rwq_ind_table)
+		return ERR_PTR(-ENOMEM);
+
+	if (udata->outlen) {
+		resp.response_length = offsetof(typeof(resp), response_length) +
+					sizeof(resp.response_length);
+		err = ib_copy_to_udata(udata, &resp, resp.response_length);
+		if (err)
+			goto err;
+	}
+
+	return rwq_ind_table;
+
+err:
+	kfree(rwq_ind_table);
+	return ERR_PTR(err);
+}
+
+int mlx4_ib_destroy_rwq_ind_table(struct ib_rwq_ind_table *ib_rwq_ind_tbl)
+{
+	kfree(ib_rwq_ind_tbl);
+	return 0;
+}
diff --git a/include/uapi/rdma/mlx4-abi.h b/include/uapi/rdma/mlx4-abi.h
index c9702a5f0bda..5591d955ba00 100644
--- a/include/uapi/rdma/mlx4-abi.h
+++ b/include/uapi/rdma/mlx4-abi.h
@@ -119,4 +119,8 @@ struct mlx4_ib_modify_wq {
 	__u32	reserved;
 };
 
+struct mlx4_ib_create_rwq_ind_tbl_resp {
+	__u32	response_length;
+	__u32	reserved;
+};
 #endif /* MLX4_ABI_USER_H */
-- 
2.13.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

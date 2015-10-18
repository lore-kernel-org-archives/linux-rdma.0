From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 for-next 5/7] IB: Introduce Receive Work Queue indirection table
Date: Sun, 18 Oct 2015 19:00:38 +0300
Message-ID: <1445184040-5306-6-git-send-email-yishaih@mellanox.com>
References: <1445184040-5306-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1445184040-5306-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, alexv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Introduce Receive Work Queue indirection table.
This object can be used to spread incoming traffic to different
receieve Work Queues.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/verbs.c |   66 +++++++++++++++++++++++++++++++++++++++
 include/rdma/ib_verbs.h         |   24 ++++++++++++++
 2 files changed, 90 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 076d5ce..ae3ebab 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1520,6 +1520,72 @@ int ib_modify_wq(struct ib_wq *wq, struct ib_wq_attr *wq_attr,
 }
 EXPORT_SYMBOL(ib_modify_wq);
 
+/*
+ * ib_create_rwq_ind_table - Creates a RQ Indirection Table.
+ * @device: The device on which to create the rwq indirection table.
+ * @ib_rwq_ind_table_init_attr: A list of initial attributes required to
+ * create the Indirection Table.
+ *
+ * Note: The life time of ib_rwq_ind_table_init_attr->ind_tbl is not less
+ *	than the created ib_rwq_ind_table object and the caller is responsible
+ *	for its memory allocation/free.
+ */
+struct ib_rwq_ind_table *ib_create_rwq_ind_table(struct ib_device *device,
+						 struct ib_rwq_ind_table_init_attr*
+						 init_attr)
+{
+	struct ib_rwq_ind_table *rwq_ind_table;
+	int i;
+	u32 table_size;
+
+	if (!device->create_rwq_ind_table)
+		return ERR_PTR(-ENOSYS);
+
+	table_size = (1 << init_attr->log_ind_tbl_size);
+	rwq_ind_table = device->create_rwq_ind_table(device,
+				init_attr, NULL);
+	if (IS_ERR(rwq_ind_table))
+		return rwq_ind_table;
+
+	rwq_ind_table->ind_tbl = init_attr->ind_tbl;
+	rwq_ind_table->log_ind_tbl_size = init_attr->log_ind_tbl_size;
+	rwq_ind_table->device = device;
+	rwq_ind_table->uobject = NULL;
+	atomic_set(&rwq_ind_table->usecnt, 0);
+
+	for (i = 0; i < table_size; i++)
+		atomic_inc(&rwq_ind_table->ind_tbl[i]->usecnt);
+
+	return rwq_ind_table;
+}
+EXPORT_SYMBOL(ib_create_rwq_ind_table);
+
+/*
+ * ib_destroy_rwq_ind_table - Destroys the specified Indirection Table.
+ * @wq_ind_table: The Indirection Table to destroy.
+*/
+int ib_destroy_rwq_ind_table(struct ib_rwq_ind_table *rwq_ind_table)
+{
+	int err, i;
+	u32 table_size = (1 << rwq_ind_table->log_ind_tbl_size);
+	struct ib_wq **ind_tbl = rwq_ind_table->ind_tbl;
+
+	if (!rwq_ind_table->device->destroy_rwq_ind_table)
+		return -ENOSYS;
+
+	if (atomic_read(&rwq_ind_table->usecnt))
+		return -EBUSY;
+
+	err = rwq_ind_table->device->destroy_rwq_ind_table(rwq_ind_table);
+	if (!err) {
+		for (i = 0; i < table_size; i++)
+			atomic_dec(&ind_tbl[i]->usecnt);
+	}
+
+	return err;
+}
+EXPORT_SYMBOL(ib_destroy_rwq_ind_table);
+
 struct ib_flow *ib_create_flow(struct ib_qp *qp,
 			       struct ib_flow_attr *flow_attr,
 			       int domain)
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 7436773..995a328 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1355,6 +1355,21 @@ struct ib_wq_attr {
 	enum	ib_wq_state	curr_wq_state;
 };
 
+struct ib_rwq_ind_table {
+	struct ib_device	*device;
+	struct ib_uobject      *uobject;
+	atomic_t		usecnt;
+	u32		ind_tbl_num;
+	u32		log_ind_tbl_size;
+	struct ib_wq	**ind_tbl;
+};
+
+struct ib_rwq_ind_table_init_attr {
+	u32		log_ind_tbl_size;
+	/* Each entry is a pointer to Receive Work Queue */
+	struct ib_wq	**ind_tbl;
+};
+
 struct ib_qp {
 	struct ib_device       *device;
 	struct ib_pd	       *pd;
@@ -1824,6 +1839,11 @@ struct ib_device {
 						struct ib_wq_attr *attr,
 						enum ib_wq_attr_mask attr_mask,
 						struct ib_udata *udata);
+	struct ib_rwq_ind_table *  (*create_rwq_ind_table)(struct ib_device *device,
+							   struct ib_rwq_ind_table_init_attr *init_attr,
+							   struct ib_udata *udata);
+	int			   (*destroy_rwq_ind_table)(struct ib_rwq_ind_table *wq_ind_table);
+
 
 	struct ib_dma_mapping_ops   *dma_ops;
 
@@ -3081,5 +3101,9 @@ struct ib_wq *ib_create_wq(struct ib_pd *pd,
 int ib_destroy_wq(struct ib_wq *wq);
 int ib_modify_wq(struct ib_wq *wq, struct ib_wq_attr *attr,
 		 enum ib_wq_attr_mask attr_mask);
+struct ib_rwq_ind_table *ib_create_rwq_ind_table(struct ib_device *device,
+						 struct ib_rwq_ind_table_init_attr*
+						 wq_ind_table_init_attr);
+int ib_destroy_rwq_ind_table(struct ib_rwq_ind_table *wq_ind_table);
 
 #endif /* IB_VERBS_H */
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

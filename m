From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-next 09/16] IB/core: Add support for flow counter set
Date: Thu, 19 Oct 2017 17:41:51 +0300
Message-ID: <1508424118-27205-10-git-send-email-yishaih@mellanox.com>
References: <1508424118-27205-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1508424118-27205-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, raeds-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Raed Salem <raeds-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

A counter set object could be attached to flow on creation
by providing the counter specification action.

Signed-off-by: Raed Salem <raeds-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/verbs.c |  8 +++++++-
 include/rdma/ib_verbs.h         | 14 +++++++++++---
 2 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index ffe51fd..8e82249 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1941,6 +1941,8 @@ struct ib_flow *ib_create_flow(struct ib_qp *qp,
 	if (!IS_ERR(flow_id)) {
 		atomic_inc(&qp->usecnt);
 		flow_id->qp = qp;
+		if (flow_id->counter_set)
+			atomic_inc(&flow_id->counter_set->usecnt);
 	}
 	return flow_id;
 }
@@ -1950,10 +1952,14 @@ int ib_destroy_flow(struct ib_flow *flow_id)
 {
 	int err;
 	struct ib_qp *qp = flow_id->qp;
+	struct ib_counter_set *counter_set = flow_id->counter_set;
 
 	err = qp->device->destroy_flow(flow_id);
-	if (!err)
+	if (!err) {
 		atomic_dec(&qp->usecnt);
+		if (counter_set)
+			atomic_dec(&counter_set->usecnt);
+	}
 	return err;
 }
 EXPORT_SYMBOL(ib_destroy_flow);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index bc33bc2..d394e24 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1811,6 +1811,7 @@ enum ib_flow_spec_type {
 	/* Actions */
 	IB_FLOW_SPEC_ACTION_TAG         = 0x1000,
 	IB_FLOW_SPEC_ACTION_DROP        = 0x1001,
+	IB_FLOW_SPEC_ACTION_COUNT       = 0x1002,
 };
 #define IB_FLOW_SPEC_LAYER_MASK	0xF0
 #define IB_FLOW_SPEC_SUPPORT_LAYERS 8
@@ -1944,6 +1945,12 @@ struct ib_flow_spec_action_drop {
 	u16			      size;
 };
 
+struct ib_flow_spec_action_count {
+	enum ib_flow_spec_type type;
+	u16 size;
+	struct ib_counter_set *counter_set;
+};
+
 union ib_flow_spec {
 	struct {
 		u32			type;
@@ -1957,6 +1964,7 @@ struct ib_flow_spec_action_drop {
 	struct ib_flow_spec_tunnel      tunnel;
 	struct ib_flow_spec_action_tag  flow_tag;
 	struct ib_flow_spec_action_drop drop;
+	struct ib_flow_spec_action_count flow_count;
 };
 
 struct ib_flow_attr {
@@ -1975,6 +1983,7 @@ struct ib_flow_attr {
 struct ib_flow {
 	struct ib_qp		*qp;
 	struct ib_uobject	*uobject;
+	struct ib_counter_set	*counter_set;
 };
 
 struct ib_mad_hdr;
@@ -3671,6 +3680,8 @@ struct ib_rwq_ind_table *ib_create_rwq_ind_table(struct ib_device *device,
 						 wq_ind_table_init_attr);
 int ib_destroy_rwq_ind_table(struct ib_rwq_ind_table *wq_ind_table);
 
+int ib_map_mr_sg(struct ib_mr *mr, struct scatterlist *sg, int sg_nents,
+		 unsigned int *sg_offset, unsigned int page_size);
 int ib_describe_counter_set(struct ib_device *device,
 			    u16 cs_id,
 			    struct ib_counter_set_describe_attr *cs_describe_attr);
@@ -3680,9 +3691,6 @@ struct ib_counter_set *ib_create_counter_set(struct ib_device *device,
 int ib_query_counter_set(struct ib_counter_set *cs,
 			 struct ib_counter_set_query_attr *cs_query_attr);
 
-int ib_map_mr_sg(struct ib_mr *mr, struct scatterlist *sg, int sg_nents,
-		 unsigned int *sg_offset, unsigned int page_size);
-
 static inline int
 ib_map_mr_sg_zbva(struct ib_mr *mr, struct scatterlist *sg, int sg_nents,
 		  unsigned int *sg_offset, unsigned int page_size)
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

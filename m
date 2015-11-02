From: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Subject: [PATCH 1/4] RDMA/libocrdma:sync qp-state with hw state
Date: Mon,  2 Nov 2015 01:37:22 -0500
Message-ID: <1446446245-534-2-git-send-email-devesh.sharma@avagotech.com>
References: <1446446245-534-1-git-send-email-devesh.sharma@avagotech.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1446446245-534-1-git-send-email-devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Padmanabh Ratnakar <padmanabh.ratnakar-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Padmanabh Ratnakar <padmanabh.ratnakar-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>

This patch sync up the QP state with the underlying h/w
QP state and reports the same to user application.

Signed-off-by: Padmanabh Ratnakar <padmanabh.ratnakar-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Signed-off-by: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
---
 src/ocrdma_verbs.c | 33 +++++++++++++++++++--------------
 1 file changed, 19 insertions(+), 14 deletions(-)

diff --git a/src/ocrdma_verbs.c b/src/ocrdma_verbs.c
index cf2ecd2..ab90b4f 100644
--- a/src/ocrdma_verbs.c
+++ b/src/ocrdma_verbs.c
@@ -651,20 +651,6 @@ mbx_err:
 	return NULL;
 }
 
-/*
- * ocrdma_query_qp
- */
-int ocrdma_query_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
-		    int attr_mask, struct ibv_qp_init_attr *init_attr)
-{
-	struct ibv_query_qp cmd;
-	int status;
-
-	status =
-	    ibv_cmd_query_qp(qp, attr, attr_mask, init_attr, &cmd, sizeof(cmd));
-	return status;
-}
-
 enum ocrdma_qp_state get_ocrdma_qp_state(enum ibv_qp_state qps)
 {
 	switch (qps) {
@@ -896,6 +882,25 @@ int ocrdma_modify_qp(struct ibv_qp *ibqp, struct ibv_qp_attr *attr,
 	return status;
 }
 
+/*
+ * ocrdma_query_qp
+ */
+int ocrdma_query_qp(struct ibv_qp *ibqp, struct ibv_qp_attr *attr,
+		    int attr_mask, struct ibv_qp_init_attr *init_attr)
+{
+	struct ibv_query_qp cmd;
+	struct ocrdma_qp *qp = get_ocrdma_qp(ibqp);
+	int status;
+
+	status = ibv_cmd_query_qp(ibqp, attr, attr_mask,
+				  init_attr, &cmd, sizeof(cmd));
+
+	if (!status)
+		ocrdma_qp_state_machine(qp, attr->qp_state);
+
+	return status;
+}
+
 static void ocrdma_srq_toggle_bit(struct ocrdma_srq *srq, int idx)
 {
 	int i = idx / 32;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] IB/libipathverbs: update function signatures for
	libibverbs-1.1.3
Date: Fri, 6 Nov 2009 11:05:26 -0800
Message-ID: <1257534326.992.211.camel@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch changes the function signatures to match the API
changes in libibverbs-1.1.3.
    
Signed-off-by: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

diff --git a/src/ipathverbs.h b/src/ipathverbs.h
index 3493807..5ebd79d 100644
--- a/src/ipathverbs.h
+++ b/src/ipathverbs.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2006-2007 QLogic Corp. All rights reserved.
+ * Copyright (c) 2006-2009 QLogic Corp. All rights reserved.
  * Copyright (c) 2005. PathScale, Inc. All rights reserved.
  *
  * This software is available to you under a choice of one of two
@@ -188,7 +188,7 @@ struct ibv_pd *ipath_alloc_pd(struct ibv_context *pd);
 int ipath_free_pd(struct ibv_pd *pd);
 
 struct ibv_mr *ipath_reg_mr(struct ibv_pd *pd, void *addr,
-			    size_t length, enum ibv_access_flags access);
+			    size_t length, int access);
 
 int ipath_dereg_mr(struct ibv_mr *mr);
 
@@ -217,11 +217,11 @@ struct ibv_qp *ipath_create_qp_v1(struct ibv_pd *pd,
 				  struct ibv_qp_init_attr *attr);
 
 int ipath_query_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
-		   enum ibv_qp_attr_mask attr_mask,
+		   int attr_mask,
 		   struct ibv_qp_init_attr *init_attr);
 
 int ipath_modify_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
-		    enum ibv_qp_attr_mask attr_mask);
+		    int attr_mask);
 
 int ipath_destroy_qp(struct ibv_qp *qp);
 
@@ -241,11 +241,11 @@ struct ibv_srq *ipath_create_srq_v1(struct ibv_pd *pd,
 
 int ipath_modify_srq(struct ibv_srq *srq,
 		     struct ibv_srq_attr *attr, 
-		     enum ibv_srq_attr_mask attr_mask);
+		     int attr_mask);
 
 int ipath_modify_srq_v1(struct ibv_srq *srq,
 			struct ibv_srq_attr *attr, 
-			enum ibv_srq_attr_mask attr_mask);
+			int attr_mask);
 
 int ipath_query_srq(struct ibv_srq *srq, struct ibv_srq_attr *attr);
 
diff --git a/src/verbs.c b/src/verbs.c
index b73b7f7..17d54cd 100644
--- a/src/verbs.c
+++ b/src/verbs.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2006-2007 QLogic Corp. All rights reserved.
+ * Copyright (c) 2006-2009 QLogic Corp. All rights reserved.
  * Copyright (c) 2005. PathScale, Inc. All rights reserved.
  *
  * This software is available to you under a choice of one of two
@@ -113,7 +113,7 @@ int ipath_free_pd(struct ibv_pd *pd)
 }
 
 struct ibv_mr *ipath_reg_mr(struct ibv_pd *pd, void *addr,
-			    size_t length, enum ibv_access_flags access)
+			    size_t length, int access)
 {
 	struct ibv_mr *mr;
 	struct ibv_reg_mr cmd;
@@ -372,7 +372,7 @@ struct ibv_qp *ipath_create_qp_v1(struct ibv_pd *pd,
 }
 
 int ipath_query_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
-		   enum ibv_qp_attr_mask attr_mask,
+		   int attr_mask,
 		   struct ibv_qp_init_attr *init_attr)
 {
 	struct ibv_query_qp cmd;
@@ -382,7 +382,7 @@ int ipath_query_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
 }
 
 int ipath_modify_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
-		    enum ibv_qp_attr_mask attr_mask)
+		    int attr_mask)
 {
 	struct ibv_modify_qp cmd;
 
@@ -567,7 +567,7 @@ struct ibv_srq *ipath_create_srq_v1(struct ibv_pd *pd,
 
 int ipath_modify_srq(struct ibv_srq *ibsrq,
 		     struct ibv_srq_attr *attr, 
-		     enum ibv_srq_attr_mask attr_mask)
+		     int attr_mask)
 {
 	struct ipath_srq            *srq = to_isrq(ibsrq);
 	struct ipath_modify_srq_cmd  cmd;
@@ -611,7 +611,7 @@ int ipath_modify_srq(struct ibv_srq *ibsrq,
 
 int ipath_modify_srq_v1(struct ibv_srq *ibsrq,
 			struct ibv_srq_attr *attr, 
-			enum ibv_srq_attr_mask attr_mask)
+			int attr_mask)
 {
 	struct ibv_modify_srq cmd;
 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

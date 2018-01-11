From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: [PATCH rdma-core 11/17] verbs: Use kernel uapi header for ibv_create_ah_resp
Date: Thu, 11 Jan 2018 15:13:34 -0700
Message-ID: <20180111221340.965-12-jgg@ziepe.ca>
References: <20180111221340.965-1-jgg@ziepe.ca>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180111221340.965-1-jgg-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

kern-abi.h has a different spelling for 'ah_handle'

Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibverbs/cmd.c                | 4 ++--
 libibverbs/driver.h             | 2 +-
 libibverbs/kern-abi.h           | 4 ----
 providers/bnxt_re/verbs.c       | 2 +-
 providers/hfi1verbs/verbs.c     | 2 +-
 providers/ipathverbs/verbs.c    | 2 +-
 providers/mlx5/mlx5-abi.h       | 2 +-
 providers/ocrdma/ocrdma_verbs.c | 2 +-
 providers/rxe/rxe.c             | 2 +-
 9 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/libibverbs/cmd.c b/libibverbs/cmd.c
index 62ac7df0dfc57b..51366f05cfc9c5 100644
--- a/libibverbs/cmd.c
+++ b/libibverbs/cmd.c
@@ -1621,7 +1621,7 @@ int ibv_cmd_post_srq_recv(struct ibv_srq *srq, struct ibv_recv_wr *wr,
 
 int ibv_cmd_create_ah(struct ibv_pd *pd, struct ibv_ah *ah,
 		      struct ibv_ah_attr *attr,
-		      struct ibv_create_ah_resp *resp,
+		      struct ib_uverbs_create_ah_resp *resp,
 		      size_t resp_size)
 {
 	struct ibv_create_ah      cmd;
@@ -1646,7 +1646,7 @@ int ibv_cmd_create_ah(struct ibv_pd *pd, struct ibv_ah *ah,
 
 	(void) VALGRIND_MAKE_MEM_DEFINED(resp, resp_size);
 
-	ah->handle  = resp->handle;
+	ah->handle  = resp->ah_handle;
 	ah->context = pd->context;
 
 	return 0;
diff --git a/libibverbs/driver.h b/libibverbs/driver.h
index f9adf80df76cb0..7a26f7ed2d0e23 100644
--- a/libibverbs/driver.h
+++ b/libibverbs/driver.h
@@ -451,7 +451,7 @@ int ibv_cmd_post_srq_recv(struct ibv_srq *srq, struct ibv_recv_wr *wr,
 			  struct ibv_recv_wr **bad_wr);
 int ibv_cmd_create_ah(struct ibv_pd *pd, struct ibv_ah *ah,
 		      struct ibv_ah_attr *attr,
-		      struct ibv_create_ah_resp *resp,
+		      struct ib_uverbs_create_ah_resp *resp,
 		      size_t resp_size);
 int ibv_cmd_destroy_ah(struct ibv_ah *ah);
 int ibv_cmd_attach_mcast(struct ibv_qp *qp, const union ibv_gid *gid, uint16_t lid);
diff --git a/libibverbs/kern-abi.h b/libibverbs/kern-abi.h
index a9e6b5461abd83..5d332f7b22c3f7 100644
--- a/libibverbs/kern-abi.h
+++ b/libibverbs/kern-abi.h
@@ -560,10 +560,6 @@ struct ibv_create_ah {
 	struct ib_uverbs_ah_attr attr;
 };
 
-struct ibv_create_ah_resp {
-	__u32 handle;
-};
-
 struct ibv_destroy_ah {
 	__u32 command;
 	__u16 in_words;
diff --git a/providers/bnxt_re/verbs.c b/providers/bnxt_re/verbs.c
index bab2d732d71fa3..09ac33351db7e9 100644
--- a/providers/bnxt_re/verbs.c
+++ b/providers/bnxt_re/verbs.c
@@ -1390,7 +1390,7 @@ struct ibv_ah *bnxt_re_create_ah(struct ibv_pd *ibvpd, struct ibv_ah_attr *attr)
 {
 	struct bnxt_re_context *uctx;
 	struct bnxt_re_ah *ah;
-	struct ibv_create_ah_resp resp;
+	struct ib_uverbs_create_ah_resp resp;
 	int status;
 
 	uctx = to_bnxt_re_context(ibvpd->context);
diff --git a/providers/hfi1verbs/verbs.c b/providers/hfi1verbs/verbs.c
index 8e616b8b2198b8..957354b06b218c 100644
--- a/providers/hfi1verbs/verbs.c
+++ b/providers/hfi1verbs/verbs.c
@@ -678,7 +678,7 @@ int hfi1_post_srq_recv(struct ibv_srq *ibsrq, struct ibv_recv_wr *wr,
 struct ibv_ah *hfi1_create_ah(struct ibv_pd *pd, struct ibv_ah_attr *attr)
 {
 	struct ibv_ah *ah;
-	struct ibv_create_ah_resp resp;
+	struct ib_uverbs_create_ah_resp resp;
 
 	ah = malloc(sizeof *ah);
 	if (ah == NULL)
diff --git a/providers/ipathverbs/verbs.c b/providers/ipathverbs/verbs.c
index e0b247bf337583..440e3dd622bad3 100644
--- a/providers/ipathverbs/verbs.c
+++ b/providers/ipathverbs/verbs.c
@@ -654,7 +654,7 @@ int ipath_post_srq_recv(struct ibv_srq *ibsrq, struct ibv_recv_wr *wr,
 struct ibv_ah *ipath_create_ah(struct ibv_pd *pd, struct ibv_ah_attr *attr)
 {
 	struct ibv_ah *ah;
-	struct ibv_create_ah_resp resp;
+	struct ib_uverbs_create_ah_resp resp;
 
 	ah = malloc(sizeof *ah);
 	if (ah == NULL)
diff --git a/providers/mlx5/mlx5-abi.h b/providers/mlx5/mlx5-abi.h
index 661c774c7553ea..1205fe75c4d022 100644
--- a/providers/mlx5/mlx5-abi.h
+++ b/providers/mlx5/mlx5-abi.h
@@ -107,7 +107,7 @@ struct mlx5_alloc_ucontext_resp {
 };
 
 struct mlx5_create_ah_resp {
-	struct ibv_create_ah_resp	ibv_resp;
+	struct ib_uverbs_create_ah_resp	ibv_resp;
 	__u32				response_length;
 	__u8				dmac[ETHERNET_LL_SIZE];
 	__u8				reserved[6];
diff --git a/providers/ocrdma/ocrdma_verbs.c b/providers/ocrdma/ocrdma_verbs.c
index 5b8da32b1bdcdd..dd7035ddc28d86 100644
--- a/providers/ocrdma/ocrdma_verbs.c
+++ b/providers/ocrdma/ocrdma_verbs.c
@@ -2099,7 +2099,7 @@ struct ibv_ah *ocrdma_create_ah(struct ibv_pd *ibpd, struct ibv_ah_attr *attr)
 	int ahtbl_idx;
 	struct ocrdma_pd *pd;
 	struct ocrdma_ah *ah;
-	struct ibv_create_ah_resp resp;
+	struct ib_uverbs_create_ah_resp resp;
 
 	pd = get_ocrdma_pd(ibpd);
 	ah = malloc(sizeof *ah);
diff --git a/providers/rxe/rxe.c b/providers/rxe/rxe.c
index ebdef7a73e83a6..c6ec95c2bcf80d 100644
--- a/providers/rxe/rxe.c
+++ b/providers/rxe/rxe.c
@@ -783,7 +783,7 @@ static struct ibv_ah *rxe_create_ah(struct ibv_pd *pd, struct ibv_ah_attr *attr)
 	struct rxe_ah *ah;
 	struct rxe_av *av;
 	union ibv_gid sgid;
-	struct ibv_create_ah_resp resp;
+	struct ib_uverbs_create_ah_resp resp;
 
 	err = ibv_query_gid(pd->context, attr->port_num, attr->grh.sgid_index,
 			    &sgid);
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

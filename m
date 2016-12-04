From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 rdma-core 1/2] ibverbs: Allow vendor data response in create_ah command
Date: Sun,  4 Dec 2016 17:53:25 +0200
Message-ID: <1480866806-5052-2-git-send-email-yishaih@mellanox.com>
References: <1480866806-5052-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1480866806-5052-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Let caller pass response buffer and response size to ibv_cmd_create_ah
to enable kernel driver to return some private vendor data.

Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibverbs/cmd.c                | 11 ++++++-----
 libibverbs/driver.h             |  4 +++-
 libibverbs/libibverbs.map       |  6 +++++-
 providers/hfi1verbs/verbs.c     |  4 +++-
 providers/ipathverbs/verbs.c    |  4 +++-
 providers/ocrdma/ocrdma_verbs.c |  4 +++-
 providers/rxe/rxe.c             |  4 +++-
 7 files changed, 26 insertions(+), 11 deletions(-)

diff --git a/libibverbs/cmd.c b/libibverbs/cmd.c
index 06a017b..eaf7164 100644
--- a/libibverbs/cmd.c
+++ b/libibverbs/cmd.c
@@ -1492,12 +1492,13 @@ int ibv_cmd_post_srq_recv(struct ibv_srq *srq, struct ibv_recv_wr *wr,
 }
 
 int ibv_cmd_create_ah(struct ibv_pd *pd, struct ibv_ah *ah,
-		      struct ibv_ah_attr *attr)
+		      struct ibv_ah_attr *attr,
+		      struct ibv_create_ah_resp *resp,
+		      size_t resp_size)
 {
 	struct ibv_create_ah      cmd;
-	struct ibv_create_ah_resp resp;
 
-	IBV_INIT_CMD_RESP(&cmd, sizeof cmd, CREATE_AH, &resp, sizeof resp);
+	IBV_INIT_CMD_RESP(&cmd, sizeof cmd, CREATE_AH, resp, resp_size);
 	cmd.user_handle            = (uintptr_t) ah;
 	cmd.pd_handle              = pd->handle;
 	cmd.attr.dlid              = attr->dlid;
@@ -1515,9 +1516,9 @@ int ibv_cmd_create_ah(struct ibv_pd *pd, struct ibv_ah *ah,
 	if (write(pd->context->cmd_fd, &cmd, sizeof cmd) != sizeof cmd)
 		return errno;
 
-	(void) VALGRIND_MAKE_MEM_DEFINED(&resp, sizeof resp);
+	(void) VALGRIND_MAKE_MEM_DEFINED(resp, resp_size);
 
-	ah->handle  = resp.handle;
+	ah->handle  = resp->handle;
 	ah->context = pd->context;
 
 	return 0;
diff --git a/libibverbs/driver.h b/libibverbs/driver.h
index ea3dade..c170169 100644
--- a/libibverbs/driver.h
+++ b/libibverbs/driver.h
@@ -233,7 +233,9 @@ int ibv_cmd_post_recv(struct ibv_qp *ibqp, struct ibv_recv_wr *wr,
 int ibv_cmd_post_srq_recv(struct ibv_srq *srq, struct ibv_recv_wr *wr,
 			  struct ibv_recv_wr **bad_wr);
 int ibv_cmd_create_ah(struct ibv_pd *pd, struct ibv_ah *ah,
-		      struct ibv_ah_attr *attr);
+		      struct ibv_ah_attr *attr,
+		      struct ibv_create_ah_resp *resp,
+		      size_t resp_size);
 int ibv_cmd_destroy_ah(struct ibv_ah *ah);
 int ibv_cmd_attach_mcast(struct ibv_qp *qp, const union ibv_gid *gid, uint16_t lid);
 int ibv_cmd_detach_mcast(struct ibv_qp *qp, const union ibv_gid *gid, uint16_t lid);
diff --git a/libibverbs/libibverbs.map b/libibverbs/libibverbs.map
index 33cd6b6..7858e19 100644
--- a/libibverbs/libibverbs.map
+++ b/libibverbs/libibverbs.map
@@ -64,7 +64,6 @@ IBVERBS_1.0 {
 		ibv_cmd_post_send;
 		ibv_cmd_post_recv;
 		ibv_cmd_post_srq_recv;
-		ibv_cmd_create_ah;
 		ibv_cmd_destroy_ah;
 		ibv_cmd_attach_mcast;
 		ibv_cmd_detach_mcast;
@@ -131,3 +130,8 @@ IBVERBS_1.3 {
 		ibv_cmd_destroy_rwq_ind_table;
 		ibv_query_gid_type;
 } IBVERBS_1.1;
+
+IBVERBS_1.4 {
+	global:
+		ibv_cmd_create_ah;
+} IBVERBS_1.3;
diff --git a/providers/hfi1verbs/verbs.c b/providers/hfi1verbs/verbs.c
index 06ddbb7..d39a4d0 100644
--- a/providers/hfi1verbs/verbs.c
+++ b/providers/hfi1verbs/verbs.c
@@ -678,12 +678,14 @@ int hfi1_post_srq_recv(struct ibv_srq *ibsrq, struct ibv_recv_wr *wr,
 struct ibv_ah *hfi1_create_ah(struct ibv_pd *pd, struct ibv_ah_attr *attr)
 {
 	struct ibv_ah *ah;
+	struct ibv_create_ah_resp resp;
 
 	ah = malloc(sizeof *ah);
 	if (ah == NULL)
 		return NULL;
 
-	if (ibv_cmd_create_ah(pd, ah, attr)) {
+	memset(&resp, 0, sizeof(resp));
+	if (ibv_cmd_create_ah(pd, ah, attr, &resp, sizeof(resp))) {
 		free(ah);
 		return NULL;
 	}
diff --git a/providers/ipathverbs/verbs.c b/providers/ipathverbs/verbs.c
index 35b2162..2145b15 100644
--- a/providers/ipathverbs/verbs.c
+++ b/providers/ipathverbs/verbs.c
@@ -653,12 +653,14 @@ int ipath_post_srq_recv(struct ibv_srq *ibsrq, struct ibv_recv_wr *wr,
 struct ibv_ah *ipath_create_ah(struct ibv_pd *pd, struct ibv_ah_attr *attr)
 {
 	struct ibv_ah *ah;
+	struct ibv_create_ah_resp resp;
 
 	ah = malloc(sizeof *ah);
 	if (ah == NULL)
 		return NULL;
 
-	if (ibv_cmd_create_ah(pd, ah, attr)) {
+	memset(&resp, 0, sizeof(resp));
+	if (ibv_cmd_create_ah(pd, ah, attr, &resp, sizeof(resp))) {
 		free(ah);
 		return NULL;
 	}
diff --git a/providers/ocrdma/ocrdma_verbs.c b/providers/ocrdma/ocrdma_verbs.c
index 7e066dc..dce833b 100644
--- a/providers/ocrdma/ocrdma_verbs.c
+++ b/providers/ocrdma/ocrdma_verbs.c
@@ -2099,6 +2099,7 @@ struct ibv_ah *ocrdma_create_ah(struct ibv_pd *ibpd, struct ibv_ah_attr *attr)
 	int ahtbl_idx;
 	struct ocrdma_pd *pd;
 	struct ocrdma_ah *ah;
+	struct ibv_create_ah_resp resp;
 
 	pd = get_ocrdma_pd(ibpd);
 	ah = malloc(sizeof *ah);
@@ -2111,7 +2112,8 @@ struct ibv_ah *ocrdma_create_ah(struct ibv_pd *ibpd, struct ibv_ah_attr *attr)
 	if (ahtbl_idx < 0)
 		goto tbl_err;
 	attr->dlid = ahtbl_idx;
-	status = ibv_cmd_create_ah(ibpd, &ah->ibv_ah, attr);
+	memset(&resp, 0, sizeof(resp));
+	status = ibv_cmd_create_ah(ibpd, &ah->ibv_ah, attr, &resp, sizeof(resp));
 	if (status)
 		goto cmd_err;
 
diff --git a/providers/rxe/rxe.c b/providers/rxe/rxe.c
index d23ef3d..1dd30ea 100644
--- a/providers/rxe/rxe.c
+++ b/providers/rxe/rxe.c
@@ -781,6 +781,7 @@ static struct ibv_ah *rxe_create_ah(struct ibv_pd *pd, struct ibv_ah_attr *attr)
 	struct rxe_ah *ah;
 	struct rxe_av *av;
 	union ibv_gid sgid;
+	struct ibv_create_ah_resp resp;
 
 	err = ibv_query_gid(pd->context, attr->port_num, attr->grh.sgid_index,
 			    &sgid);
@@ -803,7 +804,8 @@ static struct ibv_ah *rxe_create_ah(struct ibv_pd *pd, struct ibv_ah_attr *attr)
 	rdma_gid2ip(&av->sgid_addr._sockaddr, &sgid);
 	rdma_gid2ip(&av->dgid_addr._sockaddr, &attr->grh.dgid);
 
-	if (ibv_cmd_create_ah(pd, &ah->ibv_ah, attr)) {
+	memset(&resp, 0, sizeof(resp));
+	if (ibv_cmd_create_ah(pd, &ah->ibv_ah, attr, &resp, sizeof(resp))) {
 		free(ah);
 		return NULL;
 	}
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

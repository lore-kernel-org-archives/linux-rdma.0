From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [RESEND rdma-core v4 2/8] libbnxt_re: Add support for user memory regions
Date: Fri, 21 Apr 2017 14:57:06 -0400
Message-ID: <1492801032-17587-3-git-send-email-devesh.sharma@broadcom.com>
References: <1492801032-17587-1-git-send-email-devesh.sharma@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1492801032-17587-1-git-send-email-devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch adds code to allow user applications to register and
unregister memory buffers with the HCA. Following functions are
now supported:
 - ibv_reg_mr()
 - ibv_dereg_mr()

Signed-off-by: Sriharsha Basavapatna <sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 providers/bnxt_re/bnxt_re-abi.h |  4 ++++
 providers/bnxt_re/verbs.c       | 26 ++++++++++++++++++++++++--
 2 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/providers/bnxt_re/bnxt_re-abi.h b/providers/bnxt_re/bnxt_re-abi.h
index 05a0888..53645d5 100644
--- a/providers/bnxt_re/bnxt_re-abi.h
+++ b/providers/bnxt_re/bnxt_re-abi.h
@@ -56,4 +56,8 @@ struct bnxt_re_pd_resp {
 	__u64 dbr;
 };
 
+struct bnxt_re_mr_resp {
+	struct ibv_reg_mr_resp resp;
+};
+
 #endif
diff --git a/providers/bnxt_re/verbs.c b/providers/bnxt_re/verbs.c
index 3993c61..f67e37d 100644
--- a/providers/bnxt_re/verbs.c
+++ b/providers/bnxt_re/verbs.c
@@ -131,12 +131,34 @@ int bnxt_re_free_pd(struct ibv_pd *ibvpd)
 struct ibv_mr *bnxt_re_reg_mr(struct ibv_pd *ibvpd, void *sva, size_t len,
 			      int access)
 {
-	return NULL;
+	struct bnxt_re_mr *mr;
+	struct ibv_reg_mr cmd;
+	struct bnxt_re_mr_resp resp;
+
+	mr = calloc(1, sizeof(*mr));
+	if (!mr)
+		return NULL;
+
+	if (ibv_cmd_reg_mr(ibvpd, sva, len, (uintptr_t)sva, access, &mr->ibvmr,
+			   &cmd, sizeof(cmd), &resp.resp, sizeof(resp))) {
+		free(mr);
+		return NULL;
+	}
+
+	return &mr->ibvmr;
 }
 
 int bnxt_re_dereg_mr(struct ibv_mr *ibvmr)
 {
-	return -ENOSYS;
+	struct bnxt_re_mr *mr = (struct bnxt_re_mr *)ibvmr;
+	int status;
+
+	status = ibv_cmd_dereg_mr(ibvmr);
+	if (status)
+		return status;
+	free(mr);
+
+	return 0;
 }
 
 struct ibv_cq *bnxt_re_create_cq(struct ibv_context *ibvctx, int ncqe,
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

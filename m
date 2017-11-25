From: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH V2 rdma-core] libhns: Add rereg mr interface in userspace
Date: Sat, 25 Nov 2017 11:09:56 +0800
Message-ID: <1511579396-43112-1-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch adds the rereg mr verbs in userspace.

Signed-off-by: Shaobo Xu <xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
Change from V1:
1. Remove the if statement
---
 providers/hns/hns_roce_u.c       |  1 +
 providers/hns/hns_roce_u.h       |  2 ++
 providers/hns/hns_roce_u_verbs.c | 11 +++++++++++
 3 files changed, 14 insertions(+)

diff --git a/providers/hns/hns_roce_u.c b/providers/hns/hns_roce_u.c
index ababd9c..9b5de44 100644
--- a/providers/hns/hns_roce_u.c
+++ b/providers/hns/hns_roce_u.c
@@ -118,6 +118,7 @@ static struct ibv_context *hns_roce_alloc_context(struct ibv_device *ibdev,
 	context->ibv_ctx.ops.alloc_pd	   = hns_roce_u_alloc_pd;
 	context->ibv_ctx.ops.dealloc_pd    = hns_roce_u_free_pd;
 	context->ibv_ctx.ops.reg_mr	   = hns_roce_u_reg_mr;
+	context->ibv_ctx.ops.rereg_mr	   = hns_roce_u_rereg_mr;
 	context->ibv_ctx.ops.dereg_mr	   = hns_roce_u_dereg_mr;
 
 	context->ibv_ctx.ops.create_cq     = hns_roce_u_create_cq;
diff --git a/providers/hns/hns_roce_u.h b/providers/hns/hns_roce_u.h
index 0e98f22..2f4f3dc 100644
--- a/providers/hns/hns_roce_u.h
+++ b/providers/hns/hns_roce_u.h
@@ -254,6 +254,8 @@ int hns_roce_u_free_pd(struct ibv_pd *pd);
 
 struct ibv_mr *hns_roce_u_reg_mr(struct ibv_pd *pd, void *addr, size_t length,
 				 int access);
+int hns_roce_u_rereg_mr(struct ibv_mr *mr, int flags, struct ibv_pd *pd,
+			void *addr, size_t length, int access);
 int hns_roce_u_dereg_mr(struct ibv_mr *mr);
 
 struct ibv_cq *hns_roce_u_create_cq(struct ibv_context *context, int cqe,
diff --git a/providers/hns/hns_roce_u_verbs.c b/providers/hns/hns_roce_u_verbs.c
index d0ab10a..046f0a4 100644
--- a/providers/hns/hns_roce_u_verbs.c
+++ b/providers/hns/hns_roce_u_verbs.c
@@ -150,6 +150,17 @@ struct ibv_mr *hns_roce_u_reg_mr(struct ibv_pd *pd, void *addr, size_t length,
 	return mr;
 }
 
+int hns_roce_u_rereg_mr(struct ibv_mr *mr, int flags, struct ibv_pd *pd,
+			void *addr, size_t length, int access)
+{
+	struct ibv_rereg_mr cmd;
+	struct ibv_rereg_mr_resp resp;
+
+	return ibv_cmd_rereg_mr(mr, flags, addr, length, (uintptr_t)addr,
+				access, pd, &cmd, sizeof(cmd), &resp,
+				sizeof(resp));
+}
+
 int hns_roce_u_dereg_mr(struct ibv_mr *mr)
 {
 	int ret;
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

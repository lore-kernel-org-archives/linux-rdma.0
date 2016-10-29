From: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 rdma-core 3/7] libhns: Add verbs of pd and mr support
Date: Sat, 29 Oct 2016 17:03:42 +0800
Message-ID: <1477731826-10787-4-git-send-email-oulijun@huawei.com>
References: <1477731826-10787-1-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1477731826-10787-1-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch mainly introduces the verbs with pd and mr,
included alloc_pd, dealloc_pd, reg_mr and dereg_mr.

Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Wei Hu <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
v2:
- No change over v1

v1:
- The initial submit
---
 providers/hns/hns_roce_u.c       |  4 ++
 providers/hns/hns_roce_u.h       | 18 +++++++++
 providers/hns/hns_roce_u_abi.h   |  6 +++
 providers/hns/hns_roce_u_verbs.c | 79 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 107 insertions(+)

diff --git a/providers/hns/hns_roce_u.c b/providers/hns/hns_roce_u.c
index c0f6fe9..53e2720 100644
--- a/providers/hns/hns_roce_u.c
+++ b/providers/hns/hns_roce_u.c
@@ -97,6 +97,10 @@ static struct ibv_context *hns_roce_alloc_context(struct ibv_device *ibdev,
 
 	context->ibv_ctx.ops.query_device  = hns_roce_u_query_device;
 	context->ibv_ctx.ops.query_port    = hns_roce_u_query_port;
+	context->ibv_ctx.ops.alloc_pd	   = hns_roce_u_alloc_pd;
+	context->ibv_ctx.ops.dealloc_pd    = hns_roce_u_free_pd;
+	context->ibv_ctx.ops.reg_mr	   = hns_roce_u_reg_mr;
+	context->ibv_ctx.ops.dereg_mr	   = hns_roce_u_dereg_mr;
 
 	if (hns_roce_u_query_device(&context->ibv_ctx, &dev_attrs))
 		goto tptr_free;
diff --git a/providers/hns/hns_roce_u.h b/providers/hns/hns_roce_u.h
index aa58ee6..5b73794 100644
--- a/providers/hns/hns_roce_u.h
+++ b/providers/hns/hns_roce_u.h
@@ -73,6 +73,11 @@ struct hns_roce_context {
 	int				max_cqe;
 };
 
+struct hns_roce_pd {
+	struct ibv_pd			ibv_pd;
+	unsigned int			pdn;
+};
+
 static inline struct hns_roce_device *to_hr_dev(struct ibv_device *ibv_dev)
 {
 	return container_of(ibv_dev, struct hns_roce_device, ibv_dev);
@@ -83,8 +88,21 @@ static inline struct hns_roce_context *to_hr_ctx(struct ibv_context *ibv_ctx)
 	return container_of(ibv_ctx, struct hns_roce_context, ibv_ctx);
 }
 
+static inline struct hns_roce_pd *to_hr_pd(struct ibv_pd *ibv_pd)
+{
+	return container_of(ibv_pd, struct hns_roce_pd, ibv_pd);
+}
+
 int hns_roce_u_query_device(struct ibv_context *context,
 			    struct ibv_device_attr *attr);
 int hns_roce_u_query_port(struct ibv_context *context, uint8_t port,
 			  struct ibv_port_attr *attr);
+
+struct ibv_pd *hns_roce_u_alloc_pd(struct ibv_context *context);
+int hns_roce_u_free_pd(struct ibv_pd *pd);
+
+struct ibv_mr *hns_roce_u_reg_mr(struct ibv_pd *pd, void *addr, size_t length,
+				 int access);
+int hns_roce_u_dereg_mr(struct ibv_mr *mr);
+
 #endif /* _HNS_ROCE_U_H */
diff --git a/providers/hns/hns_roce_u_abi.h b/providers/hns/hns_roce_u_abi.h
index 4bfc8fa..0a0cd0c 100644
--- a/providers/hns/hns_roce_u_abi.h
+++ b/providers/hns/hns_roce_u_abi.h
@@ -40,4 +40,10 @@ struct hns_roce_alloc_ucontext_resp {
 	__u32				qp_tab_size;
 };
 
+struct hns_roce_alloc_pd_resp {
+	struct ibv_alloc_pd_resp	ibv_resp;
+	__u32				pdn;
+	__u32				reserved;
+};
+
 #endif /* _HNS_ROCE_U_ABI_H */
diff --git a/providers/hns/hns_roce_u_verbs.c b/providers/hns/hns_roce_u_verbs.c
index be55fe8..249d1aa 100644
--- a/providers/hns/hns_roce_u_verbs.c
+++ b/providers/hns/hns_roce_u_verbs.c
@@ -71,3 +71,82 @@ int hns_roce_u_query_port(struct ibv_context *context, uint8_t port,
 
 	return ibv_cmd_query_port(context, port, attr, &cmd, sizeof(cmd));
 }
+
+struct ibv_pd *hns_roce_u_alloc_pd(struct ibv_context *context)
+{
+	struct ibv_alloc_pd cmd;
+	struct hns_roce_pd *pd;
+	struct hns_roce_alloc_pd_resp resp;
+
+	pd = (struct hns_roce_pd *)malloc(sizeof(*pd));
+	if (!pd)
+		return NULL;
+
+	if (ibv_cmd_alloc_pd(context, &pd->ibv_pd, &cmd, sizeof(cmd),
+			     &resp.ibv_resp, sizeof(resp))) {
+		free(pd);
+		return NULL;
+	}
+
+	pd->pdn = resp.pdn;
+
+	return &pd->ibv_pd;
+}
+
+int hns_roce_u_free_pd(struct ibv_pd *pd)
+{
+	int ret;
+
+	ret = ibv_cmd_dealloc_pd(pd);
+	if (ret)
+		return ret;
+
+	free(to_hr_pd(pd));
+
+	return ret;
+}
+
+struct ibv_mr *hns_roce_u_reg_mr(struct ibv_pd *pd, void *addr, size_t length,
+				 int access)
+{
+	int ret;
+	struct ibv_mr *mr;
+	struct ibv_reg_mr cmd;
+	struct ibv_reg_mr_resp resp;
+
+	if (addr == NULL) {
+		fprintf(stderr, "2nd parm addr is NULL!\n");
+		return NULL;
+	}
+
+	if (length == 0) {
+		fprintf(stderr, "3st parm length is 0!\n");
+		return NULL;
+	}
+
+	mr = malloc(sizeof(*mr));
+	if (mr)
+		return NULL;
+
+	ret = ibv_cmd_reg_mr(pd, addr, length, (uintptr_t) addr, access, mr,
+			     &cmd, sizeof(cmd), &resp, sizeof(resp));
+	if (ret) {
+		free(mr);
+		return NULL;
+	}
+
+	return mr;
+}
+
+int hns_roce_u_dereg_mr(struct ibv_mr *mr)
+{
+	int ret;
+
+	ret = ibv_cmd_dereg_mr(mr);
+	if (ret)
+		return ret;
+
+	free(mr);
+
+	return ret;
+}
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

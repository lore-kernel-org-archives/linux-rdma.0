From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: [PATCH 7/8] verbs: Remove dead _HAS_ defines for providers
Date: Tue,  5 Dec 2017 16:17:20 -0700
Message-ID: <20171205231721.19410-8-jgg@ziepe.ca>
References: <20171205231721.19410-1-jgg@ziepe.ca>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171205231721.19410-1-jgg-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Nothing looks at these anymore.

Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibverbs/driver.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/libibverbs/driver.h b/libibverbs/driver.h
index 04071a73583406..4f2a9486880e11 100644
--- a/libibverbs/driver.h
+++ b/libibverbs/driver.h
@@ -247,7 +247,6 @@ int ibv_cmd_open_xrcd(struct ibv_context *context, struct verbs_xrcd *xrcd,
 		      struct ibv_open_xrcd *cmd, size_t cmd_size,
 		      struct ibv_open_xrcd_resp *resp, size_t resp_size);
 int ibv_cmd_close_xrcd(struct verbs_xrcd *xrcd);
-#define IBV_CMD_REG_MR_HAS_RESP_PARAMS
 int ibv_cmd_reg_mr(struct ibv_pd *pd, void *addr, size_t length,
 		   uint64_t hca_va, int access,
 		   struct ibv_mr *mr, struct ibv_reg_mr *cmd,
@@ -281,7 +280,6 @@ int ibv_cmd_create_cq_ex(struct ibv_context *context,
 			 size_t resp_size);
 int ibv_cmd_poll_cq(struct ibv_cq *cq, int ne, struct ibv_wc *wc);
 int ibv_cmd_req_notify_cq(struct ibv_cq *cq, int solicited_only);
-#define IBV_CMD_RESIZE_CQ_HAS_RESP_PARAMS
 int ibv_cmd_resize_cq(struct ibv_cq *cq, int cqe,
 		      struct ibv_resize_cq *cmd, size_t cmd_size,
 		      struct ibv_resize_cq_resp *resp, size_t resp_size);
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

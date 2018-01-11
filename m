From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: [PATCH rdma-core 08/17] verbs: Use kernel uapi header for ibv_cq_moderation_caps_resp
Date: Thu, 11 Jan 2018 15:13:31 -0700
Message-ID: <20180111221340.965-9-jgg@ziepe.ca>
References: <20180111221340.965-1-jgg@ziepe.ca>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180111221340.965-1-jgg-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

For some reason the struct member names do not match the kernel version,
fix it.

Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibverbs/cmd.c      | 4 ++--
 libibverbs/kern-abi.h | 8 +-------
 2 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/libibverbs/cmd.c b/libibverbs/cmd.c
index a675bfb7d02fd3..ad0e0dc3736756 100644
--- a/libibverbs/cmd.c
+++ b/libibverbs/cmd.c
@@ -257,8 +257,8 @@ int ibv_cmd_query_device_ex(struct ibv_context *context,
 		if (resp->response_length >=
 		    offsetof(struct ibv_query_device_resp_ex, cq_mod_caps) +
 		    sizeof(resp->cq_mod_caps)) {
-			attr->cq_mod_caps.max_cq_count = resp->cq_mod_caps.cq_count;
-			attr->cq_mod_caps.max_cq_period = resp->cq_mod_caps.cq_period;
+			attr->cq_mod_caps.max_cq_count = resp->cq_mod_caps.max_cq_moderation_count;
+			attr->cq_mod_caps.max_cq_period = resp->cq_mod_caps.max_cq_moderation_period;
 		}
 	}
 
diff --git a/libibverbs/kern-abi.h b/libibverbs/kern-abi.h
index 3468e5497c3531..6a697987799c68 100644
--- a/libibverbs/kern-abi.h
+++ b/libibverbs/kern-abi.h
@@ -110,12 +110,6 @@ struct ibv_query_device_ex {
 	__u32		reserved;
 };
 
-struct ibv_cq_moderation_caps_resp {
-	__u16  cq_count;
-	__u16  cq_period;
-	__u32  reserved;
-};
-
 struct ibv_query_device_resp_ex {
 	struct ib_uverbs_query_device_resp base;
 	__u32 comp_mask;
@@ -128,7 +122,7 @@ struct ibv_query_device_resp_ex {
 	__u32  max_wq_type_rq;
 	__u32 raw_packet_caps;
 	struct ib_uverbs_tm_caps tm_caps;
-	struct ibv_cq_moderation_caps_resp cq_mod_caps;
+	struct ib_uverbs_cq_moderation_caps cq_mod_caps;
 };
 
 struct ibv_query_port {
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

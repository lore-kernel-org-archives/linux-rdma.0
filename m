From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: [PATCH rdma-core 04/17] verbs: Remove unused structs
Date: Thu, 11 Jan 2018 15:13:27 -0700
Message-ID: <20180111221340.965-5-jgg@ziepe.ca>
References: <20180111221340.965-1-jgg@ziepe.ca>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180111221340.965-1-jgg-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Some of these structs are renamed duplicates from the kernel header, others
are just perplexing. In any case we don't use them in rdma-core

Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibverbs/kern-abi.h | 21 ---------------------
 1 file changed, 21 deletions(-)

diff --git a/libibverbs/kern-abi.h b/libibverbs/kern-abi.h
index f67ddb10548880..92d750e1d26b09 100644
--- a/libibverbs/kern-abi.h
+++ b/libibverbs/kern-abi.h
@@ -64,16 +64,6 @@
  *    different between 32-bit and 64-bit architectures.
  */
 
-struct hdr {
-	__u32 command;
-	__u16 in_words;
-	__u16 out_words;
-};
-
-struct response_hdr {
-	__u64 response;
-};
-
 struct ex_hdr {
 	struct {
 		__u32 command;
@@ -108,17 +98,6 @@ struct ibv_comp_event {
  * the rest of the command struct based on these value.
  */
 
-struct ibv_query_params {
-	__u32 command;
-	__u16 in_words;
-	__u16 out_words;
-	__u64 response;
-};
-
-struct ibv_query_params_resp {
-	__u32 num_cq_events;
-};
-
 struct ibv_get_context {
 	__u32 command;
 	__u16 in_words;
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

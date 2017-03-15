From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 6/6] verbs: Consistently apply __attribute_const
Date: Wed, 15 Mar 2017 16:12:07 -0600
Message-ID: <1489615927-12117-7-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1489615927-12117-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1489615927-12117-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Put it on the prototype and the declaration. Sparse complains if the
attribute is not in exactly the same spot, so always put it in the usual
place for declarations.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 libibverbs/verbs.c | 8 ++++----
 libibverbs/verbs.h | 8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/libibverbs/verbs.c b/libibverbs/verbs.c
index 6a5b2a52da3c5b..8f7cb43a220b86 100644
--- a/libibverbs/verbs.c
+++ b/libibverbs/verbs.c
@@ -51,7 +51,7 @@
 #include "neigh.h"
 #endif
 
-int ibv_rate_to_mult(enum ibv_rate rate)
+int __attribute__((const)) ibv_rate_to_mult(enum ibv_rate rate)
 {
 	switch (rate) {
 	case IBV_RATE_2_5_GBPS: return  1;
@@ -67,7 +67,7 @@ int ibv_rate_to_mult(enum ibv_rate rate)
 	}
 }
 
-enum ibv_rate mult_to_ibv_rate(int mult)
+enum ibv_rate __attribute__((const)) mult_to_ibv_rate(int mult)
 {
 	switch (mult) {
 	case 1:  return IBV_RATE_2_5_GBPS;
@@ -83,7 +83,7 @@ enum ibv_rate mult_to_ibv_rate(int mult)
 	}
 }
 
-int ibv_rate_to_mbps(enum ibv_rate rate)
+int  __attribute__((const)) ibv_rate_to_mbps(enum ibv_rate rate)
 {
 	switch (rate) {
 	case IBV_RATE_2_5_GBPS: return 2500;
@@ -107,7 +107,7 @@ int ibv_rate_to_mbps(enum ibv_rate rate)
 	}
 }
 
-enum ibv_rate mbps_to_ibv_rate(int mbps)
+enum ibv_rate __attribute__((const)) mbps_to_ibv_rate(int mbps)
 {
 	switch (mbps) {
 	case 2500:   return IBV_RATE_2_5_GBPS;
diff --git a/libibverbs/verbs.h b/libibverbs/verbs.h
index 25f4ededdb6d63..ee0fac42e68a77 100644
--- a/libibverbs/verbs.h
+++ b/libibverbs/verbs.h
@@ -584,26 +584,26 @@ enum ibv_rate {
  * converted to 2, since 5 Gbit/sec is 2 * 2.5 Gbit/sec.
  * @rate: rate to convert.
  */
-int ibv_rate_to_mult(enum ibv_rate rate) __attribute_const;
+int  __attribute_const ibv_rate_to_mult(enum ibv_rate rate);
 
 /**
  * mult_to_ibv_rate - Convert a multiple of 2.5 Gbit/sec to an IB rate enum.
  * @mult: multiple to convert.
  */
-enum ibv_rate mult_to_ibv_rate(int mult) __attribute_const;
+enum ibv_rate __attribute_const mult_to_ibv_rate(int mult);
 
 /**
  * ibv_rate_to_mbps - Convert the IB rate enum to Mbit/sec.
  * For example, IBV_RATE_5_GBPS will return the value 5000.
  * @rate: rate to convert.
  */
-int ibv_rate_to_mbps(enum ibv_rate rate) __attribute_const;
+int __attribute_const ibv_rate_to_mbps(enum ibv_rate rate);
 
 /**
  * mbps_to_ibv_rate - Convert a Mbit/sec value to an IB rate enum.
  * @mbps: value to convert.
  */
-enum ibv_rate mbps_to_ibv_rate(int mbps) __attribute_const;
+enum ibv_rate __attribute_const mbps_to_ibv_rate(int mbps) __attribute_const;
 
 struct ibv_ah_attr {
 	struct ibv_global_route	grh;
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

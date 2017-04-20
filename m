From: Boris Pismenny <borisp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC 1/2] Introduce egress IB flow steering flag
Date: Thu, 20 Apr 2017 14:00:09 +0300
Message-ID: <8539540c4130ea91bbd128f2ec2845082d6000f8.1492685328.git.borisp@mellanox.com>
References: <cover.1492685328.git.borisp@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1492685328.git.borisp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
In-Reply-To: <cover.1492685328.git.borisp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
References: <cover.1492685328.git.borisp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, borisp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ronye-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, aviadye-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: borisp <borisp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This commit introduces egress flow steering. Egress flow steering
is useful for specifying actions that might be applied by hardware
to outgoing flows on a specific QP.

Signed-off-by: borisp <borisp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/rdma/ib_verbs.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 99e4423..6c1c867 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1679,7 +1679,8 @@ enum ib_flow_domain {
 
 enum ib_flow_flags {
 	IB_FLOW_ATTR_FLAGS_DONT_TRAP = 1UL << 1, /* Continue match, no steal */
-	IB_FLOW_ATTR_FLAGS_RESERVED  = 1UL << 2  /* Must be last */
+	IB_FLOW_ATTR_FLAGS_EGRESS = 1UL << 2, /* Egress steering rule */
+	IB_FLOW_ATTR_FLAGS_RESERVED  = 1UL << 3  /* Must be last */
 };
 
 struct ib_flow_eth_filter {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

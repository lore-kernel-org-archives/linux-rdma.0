From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libibverbs 1/2] Add support for don't trap steering rule
Date: Tue, 15 Mar 2016 19:03:55 +0200
Message-ID: <1458061436-15911-2-git-send-email-yishaih@mellanox.com>
References: <1458061436-15911-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1458061436-15911-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, marinav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Marina Varshaver <marinav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add an option to create a normal flow steering rule that doesn't trap
received packets, allowing them to match lower prioritized rules.

When the don't trap rule exists and matches a packet, the underlying HCA
should pass the packet to the rule's assigned QP(s). However, the HCA
will continue looking for other matches at lower priority rules, which
may be assigned to other QPs. This will let them get the traffic as
well.

Signed-off-by: Marina Varshaver <marinav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/infiniband/verbs.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index d0c2969..0c29f1a 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -840,7 +840,8 @@ struct ibv_ah {
 };
 
 enum ibv_flow_flags {
-	IBV_FLOW_ATTR_FLAGS_ALLOW_LOOP_BACK = 1,
+	IBV_FLOW_ATTR_FLAGS_ALLOW_LOOP_BACK = 1 << 0,
+	IBV_FLOW_ATTR_FLAGS_DONT_TRAP = 1 << 1,
 };
 
 enum ibv_flow_attr_type {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

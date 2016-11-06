From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 4/5] ibverbs: Introduce sniffer flow steering rule type
Date: Sun,  6 Nov 2016 16:42:48 +0200
Message-ID: <1478443369-8208-5-git-send-email-yishaih@mellanox.com>
References: <1478443369-8208-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1478443369-8208-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add support to receive all port traffic - both RX and TX.
In order to use sniffer, user should use IBV_FLOW_ATTR_SNIFFER
rule type.
No specifications are needed.

Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibverbs/verbs.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/libibverbs/verbs.h b/libibverbs/verbs.h
index de06edd..29f287b 100644
--- a/libibverbs/verbs.h
+++ b/libibverbs/verbs.h
@@ -1172,6 +1172,8 @@ enum ibv_flow_attr_type {
 	 * receive all Eth multicast traffic which isn't steered to any QP
 	 */
 	IBV_FLOW_ATTR_MC_DEFAULT	= 0x2,
+	/* sniffer rule - receive all port traffic */
+	IBV_FLOW_ATTR_SNIFFER		= 0x3,
 };
 
 enum ibv_flow_spec_type {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

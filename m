From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-next 2/6] IB/core: Align structure ib_flow_spec_type
Date: Mon, 14 Nov 2016 19:04:48 +0200
Message-ID: <1479143092-11723-3-git-send-email-leonro@mellanox.com>
References: <1479143092-11723-1-git-send-email-leonro@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1479143092-11723-1-git-send-email-leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moses Reuben <mosesr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Moses Reuben <mosesr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Aligned the structure ib_flow_spec_type indentation,
after adding a new definition.

Signed-off-by: Moses Reuben <mosesr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 include/rdma/ib_verbs.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 9dd8309..81c5c80 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1592,14 +1592,14 @@ enum ib_flow_attr_type {
 /* Supported steering header types */
 enum ib_flow_spec_type {
 	/* L2 headers*/
-	IB_FLOW_SPEC_ETH	= 0x20,
-	IB_FLOW_SPEC_IB		= 0x22,
+	IB_FLOW_SPEC_ETH		= 0x20,
+	IB_FLOW_SPEC_IB			= 0x22,
 	/* L3 header*/
-	IB_FLOW_SPEC_IPV4	= 0x30,
-	IB_FLOW_SPEC_IPV6	= 0x31,
+	IB_FLOW_SPEC_IPV4		= 0x30,
+	IB_FLOW_SPEC_IPV6		= 0x31,
 	/* L4 headers*/
-	IB_FLOW_SPEC_TCP	= 0x40,
-	IB_FLOW_SPEC_UDP	= 0x41,
+	IB_FLOW_SPEC_TCP		= 0x40,
+	IB_FLOW_SPEC_UDP		= 0x41,
 	IB_FLOW_SPEC_VXLAN_TUNNEL	= 0x50,
 };
 #define IB_FLOW_SPEC_LAYER_MASK	0xF0
--
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

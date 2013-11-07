From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 2/6] IB/core: Add support for IB L2 device managed steering
Date: Thu,  7 Nov 2013 15:25:13 +0200
Message-ID: <1383830717-17312-3-git-send-email-ogerlitz@mellanox.com>
References: <1383830717-17312-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1383830717-17312-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This patch adds preliminary support for IB L2 device managed steering,
currently exposed only in the kernel.

This flow spec can be used by low level drivers that need to indicate
the link layer type when creating device managed flow rules.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/rdma/ib_verbs.h |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index bb81c37..887e096 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1098,13 +1098,14 @@ enum ib_flow_attr_type {
 enum ib_flow_spec_type {
 	/* L2 headers*/
 	IB_FLOW_SPEC_ETH	= 0x20,
+	IB_FLOW_SPEC_IB		= 0x22,
 	/* L3 header*/
 	IB_FLOW_SPEC_IPV4	= 0x30,
 	/* L4 headers*/
 	IB_FLOW_SPEC_TCP	= 0x40,
 	IB_FLOW_SPEC_UDP	= 0x41
 };
-
+#define IB_FLOW_SPEC_LAYER_MASK	0xF0
 #define IB_FLOW_SPEC_SUPPORT_LAYERS 4
 
 /* Flow steering rule priority is set according to it's domain.
@@ -1132,6 +1133,18 @@ struct ib_flow_spec_eth {
 	struct ib_flow_eth_filter mask;
 };
 
+struct ib_flow_ib_filter {
+	__be16 dlid;
+	__u8   sl;
+};
+
+struct ib_flow_spec_ib {
+	enum ib_flow_spec_type	 type;
+	u16			 size;
+	struct ib_flow_ib_filter val;
+	struct ib_flow_ib_filter mask;
+};
+
 struct ib_flow_ipv4_filter {
 	__be32	src_ip;
 	__be32	dst_ip;
@@ -1162,6 +1175,7 @@ union ib_flow_spec {
 		u16			size;
 	};
 	struct ib_flow_spec_eth		eth;
+	struct ib_flow_spec_ib		ib;
 	struct ib_flow_spec_ipv4        ipv4;
 	struct ib_flow_spec_tcp_udp	tcp_udp;
 };
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

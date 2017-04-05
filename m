From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 2/5] ibverbs: Add inner flow specification support
Date: Wed,  5 Apr 2017 18:19:21 +0300
Message-ID: <1491405564-19735-3-git-send-email-yishaih@mellanox.com>
References: <1491405564-19735-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1491405564-19735-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Moses Reuben <mosesr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

When one of the L2/L3/L4 flow specification types is or-combined
with IBV_FLOW_SPEC_INNER, then the filter is applied on the inner
packet header. The flow specifications can contain inner and outer
parts for the inner and outer protocol header respectively.

Signed-off-by: Moses Reuben <mosesr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibverbs/cmd.c                 | 11 +++++++++--
 libibverbs/man/ibv_create_flow.3 |  1 +
 libibverbs/verbs.h               |  3 ++-
 3 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/libibverbs/cmd.c b/libibverbs/cmd.c
index 8814142..6bdd1c4 100644
--- a/libibverbs/cmd.c
+++ b/libibverbs/cmd.c
@@ -1747,8 +1747,9 @@ static int ib_spec_to_kern_spec(struct ibv_flow_spec *ib_spec,
 
 	kern_spec->hdr.type = ib_spec->hdr.type;
 
-	switch (ib_spec->hdr.type) {
+	switch (kern_spec->hdr.type) {
 	case IBV_FLOW_SPEC_ETH:
+	case IBV_FLOW_SPEC_ETH | IBV_FLOW_SPEC_INNER:
 		kern_spec->eth.size = sizeof(struct ibv_kern_spec_eth);
 		memcpy(&kern_spec->eth.val, &ib_spec->eth.val,
 		       sizeof(struct ibv_flow_eth_filter));
@@ -1756,6 +1757,7 @@ static int ib_spec_to_kern_spec(struct ibv_flow_spec *ib_spec,
 		       sizeof(struct ibv_flow_eth_filter));
 		break;
 	case IBV_FLOW_SPEC_IPV4:
+	case IBV_FLOW_SPEC_IPV4 | IBV_FLOW_SPEC_INNER:
 		kern_spec->ipv4.size = sizeof(struct ibv_kern_spec_ipv4);
 		memcpy(&kern_spec->ipv4.val, &ib_spec->ipv4.val,
 		       sizeof(struct ibv_flow_ipv4_filter));
@@ -1763,13 +1765,15 @@ static int ib_spec_to_kern_spec(struct ibv_flow_spec *ib_spec,
 		       sizeof(struct ibv_flow_ipv4_filter));
 		break;
 	case IBV_FLOW_SPEC_IPV4_EXT:
+	case IBV_FLOW_SPEC_IPV4_EXT | IBV_FLOW_SPEC_INNER:
 		ret = get_filters_size(ib_spec, kern_spec,
 				       &ib_filter_size, &kern_filter_size,
 				       IBV_FLOW_SPEC_IPV4_EXT);
 		if (ret)
 			return ret;
 
-		kern_spec->hdr.type = IBV_FLOW_SPEC_IPV4;
+		kern_spec->hdr.type = IBV_FLOW_SPEC_IPV4 |
+				     (IBV_FLOW_SPEC_INNER & ib_spec->hdr.type);
 		kern_spec->ipv4_ext.size = sizeof(struct
 						  ibv_kern_spec_ipv4_ext);
 		memcpy(&kern_spec->ipv4_ext.val, &ib_spec->ipv4_ext.val,
@@ -1778,6 +1782,7 @@ static int ib_spec_to_kern_spec(struct ibv_flow_spec *ib_spec,
 		       + ib_filter_size, kern_filter_size);
 		break;
 	case IBV_FLOW_SPEC_IPV6:
+	case IBV_FLOW_SPEC_IPV6 | IBV_FLOW_SPEC_INNER:
 		ret = get_filters_size(ib_spec, kern_spec,
 				       &ib_filter_size, &kern_filter_size,
 				       IBV_FLOW_SPEC_IPV6);
@@ -1792,6 +1797,8 @@ static int ib_spec_to_kern_spec(struct ibv_flow_spec *ib_spec,
 		break;
 	case IBV_FLOW_SPEC_TCP:
 	case IBV_FLOW_SPEC_UDP:
+	case IBV_FLOW_SPEC_TCP | IBV_FLOW_SPEC_INNER:
+	case IBV_FLOW_SPEC_UDP | IBV_FLOW_SPEC_INNER:
 		kern_spec->tcp_udp.size = sizeof(struct ibv_kern_spec_tcp_udp);
 		memcpy(&kern_spec->tcp_udp.val, &ib_spec->tcp_udp.val,
 		       sizeof(struct ibv_flow_ipv4_filter));
diff --git a/libibverbs/man/ibv_create_flow.3 b/libibverbs/man/ibv_create_flow.3
index 3056972..32a7572 100644
--- a/libibverbs/man/ibv_create_flow.3
+++ b/libibverbs/man/ibv_create_flow.3
@@ -67,6 +67,7 @@ IBV_FLOW_SPEC_IPV4_EXT                  = 0x32,   /* Extended flow specification
 IBV_FLOW_SPEC_TCP                       = 0x40,   /* Flow specification of TCP header */
 IBV_FLOW_SPEC_UDP                       = 0x41,   /* Flow specification of UDP header */
 IBV_FLOW_SPEC_VXLAN_TUNNEL             	= 0x50,   /* Flow specification of VXLAN header */
+IBV_FLOW_SPEC_INNER                    	= 0x100,  /* Flag making L2/L3/L4 specifications to be applied on the inner header */
 .in -8
 };
 .br
diff --git a/libibverbs/verbs.h b/libibverbs/verbs.h
index b41a116..225ab81 100644
--- a/libibverbs/verbs.h
+++ b/libibverbs/verbs.h
@@ -1223,7 +1223,8 @@ enum ibv_flow_spec_type {
 	IBV_FLOW_SPEC_IPV4_EXT		= 0x32,
 	IBV_FLOW_SPEC_TCP		= 0x40,
 	IBV_FLOW_SPEC_UDP		= 0x41,
-	IBV_FLOW_SPEC_VXLAN_TUNNEL	= 0x50
+	IBV_FLOW_SPEC_VXLAN_TUNNEL	= 0x50,
+	IBV_FLOW_SPEC_INNER		= 0x100
 };
 
 struct ibv_flow_eth_filter {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 5/5] ibverbs: Update ibv_create_flow man page
Date: Sun,  6 Nov 2016 16:42:49 +0200
Message-ID: <1478443369-8208-6-git-send-email-yishaih@mellanox.com>
References: <1478443369-8208-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1478443369-8208-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

1) Add ibv_flow_spec_type enumeration description.
2) Introduce IBV_FLOW_ATTR_SNIFFER flow type.
3) Update NOTES with some clarifications.

Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibverbs/man/ibv_create_flow.3 | 41 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 39 insertions(+), 2 deletions(-)

diff --git a/libibverbs/man/ibv_create_flow.3 b/libibverbs/man/ibv_create_flow.3
index df6ddd3..9e0377f 100644
--- a/libibverbs/man/ibv_create_flow.3
+++ b/libibverbs/man/ibv_create_flow.3
@@ -42,6 +42,7 @@ enum ibv_flow_attr_type {
 IBV_FLOW_ATTR_NORMAL		= 0x0,		/* Steering according to rule specifications */
 IBV_FLOW_ATTR_ALL_DEFAULT	= 0x1,		/* Default unicast and multicast rule - receive all Eth traffic which isn't steered to any QP */
 IBV_FLOW_ATTR_MC_DEFAULT 	= 0x2,		/* Default multicast rule - receive all Eth multicast traffic which isn't steered to any QP */
+IBV_FLOW_ATTR_SNIFFER		= 0x3,		/* Sniffer rule - receive all port traffic */
 .in -8
 };
 .sp
@@ -53,6 +54,31 @@ IBV_FLOW_ATTR_FLAGS_DONT_TRAP       = 1 << 1,	/* Rule doesn't trap received pack
 .in -8
 };
 .fi
+.nf
+.br
+
+enum ibv_flow_spec_type {
+.in +8
+IBV_FLOW_SPEC_ETH                       = 0x20,   /* Flow specification of L2 header */
+IBV_FLOW_SPEC_IPV4                      = 0x30,   /* Flow specification of IPv4 header */
+IBV_FLOW_SPEC_IPV6                      = 0x31,   /* Flow specification of IPv6 header */
+IBV_FLOW_SPEC_IPV4_EXT                  = 0x32,   /* Extended flow specification of IPv4 */
+IBV_FLOW_SPEC_TCP                       = 0x40,   /* Flow specification of TCP header */
+IBV_FLOW_SPEC_UDP                       = 0x41,   /* Flow specification of UDP header */
+.in -8
+};
+.br
+
+Flow specification general structure:
+.BR
+struct ibv_flow_spec_xxx {
+.in +8
+enum ibv_flow_spec_type  type;
+uint16_t  size;                  /* Flow specification size = sizeof(struct ibv_flow_spec_xxx) */
+struct ibv_flow_xxx_filter val;
+struct ibv_flow_xxx_filter mask; /* Defines which bits from the filter value are applicable when looking for a match in the incoming packet */
+.in -8
+};
 .PP
 Each spec struct holds the relevant network layer parameters for matching. To enforce the match, the user sets a mask for each parameter.
 .br
@@ -96,12 +122,21 @@ Device managed flow steering isn't currently supported
 .SS EPERM
 No permissions to add the flow steering rule
 .SH "NOTES"
-These verbs are available only for devices supporting
+1. These verbs are available only for devices supporting
 .br
-IBV_DEVICE_MANAGED_FLOW_STEERING and only for QPs of Transport Service Type
+   IBV_DEVICE_MANAGED_FLOW_STEERING and only for QPs of Transport Service Type
 .BR IBV_QPT_UD
 or
 .BR IBV_QPT_RAW_PACKET
+.br
+2. User must memset the spec struct with zeros before using it.
+.br
+3. ether_type field in ibv_flow_eth_filter is the ethertype following the last VLAN tag of the packet.
+.br
+4. Only rule type IBV_FLOW_ATTR_NORMAL supports IBV_FLOW_ATTR_FLAGS_DONT_TRAP flag.
+.br
+5. No specifications are needed for IBV_FLOW_ATTR_SNIFFER rule type.
+.br
 .PP
 .SH EXAMPLE
 .br
@@ -172,3 +207,5 @@ Hadar Hen Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
 Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
 .TP
 Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
+.TP
+Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

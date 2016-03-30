From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libibverbs 1/3] Add an example to ibv_create_flow man page
Date: Wed, 30 Mar 2016 18:39:18 +0300
Message-ID: <1459352360-32663-2-git-send-email-yishaih@mellanox.com>
References: <1459352360-32663-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1459352360-32663-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add an example rule to show typical usage of
the API.

Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 man/ibv_create_flow.3 | 62 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)

diff --git a/man/ibv_create_flow.3 b/man/ibv_create_flow.3
index 4ba6ee7..df6ddd3 100644
--- a/man/ibv_create_flow.3
+++ b/man/ibv_create_flow.3
@@ -103,6 +103,68 @@ IBV_DEVICE_MANAGED_FLOW_STEERING and only for QPs of Transport Service Type
 or
 .BR IBV_QPT_RAW_PACKET
 .PP
+.SH EXAMPLE
+.br
+Below flow_attr defines a rule in priority 0 to match a destination
+mac address and a source ipv4 address. For that, L2 and L3 specs are used.
+.br
+If there is a hit on this rule, means the
+received packet has destination mac: 66:11:22:33:44:55 and source ip: 0x0B86C806,
+the packet is steered to its attached qp.
+.sp
+.nf
+struct raw_eth_flow_attr {
+.in +8
+struct ibv_flow_attr            attr;
+struct ibv_flow_spec_eth        spec_eth;
+struct ibv_flow_spec_ipv4       spec_ipv4;
+.in -8
+} __attribute__((packed));
+.sp
+.nf
+struct raw_eth_flow_attr flow_attr = {
+.in +8
+        .attr = {
+                .comp_mask      = 0,
+                .type           = IBV_FLOW_ATTR_NORMAL,
+                .size           = sizeof(flow_attr),
+                .priority       = 0,
+                .num_of_specs   = 2,
+                .port           = 1,
+                .flags          = 0,
+        },
+        .spec_eth = {
+                .type   = IBV_FLOW_SPEC_ETH,
+                .size   = sizeof(struct ibv_flow_spec_eth),
+                .val = {
+                        .dst_mac = {0x66, 0x11, 0x22, 0x33, 0x44, 0x55},
+                        .src_mac = { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00},
+                        .ether_type = 0,
+                        .vlan_tag = 0,
+                },
+                .mask = {
+                        .dst_mac = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF},
+                        .src_mac = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF},
+                        .ether_type = 0,
+                        .vlan_tag = 0,
+                }
+        },
+        .spec_ipv4 = {
+                .type   = IBV_FLOW_SPEC_IPV4,
+                .size   = sizeof(struct ibv_flow_spec_ipv4),
+                .val = {
+                        .src_ip = 0x0B86C806,
+                        .dst_ip = 0,
+                },
+                .mask = {
+                        .src_ip = 0xFFFFFFFF,
+                        .dst_ip = 0,
+                }
+        }
+.in -8
+};
+.sp
+.nf
 .SH "AUTHORS"
 .TP
 Hadar Hen Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

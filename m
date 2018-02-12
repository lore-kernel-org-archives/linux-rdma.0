From: Alex Rosenbaum <rosenbaumalex-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH RFC 1/3] Add Verbs GRE flow specification filter
Date: Mon, 12 Feb 2018 17:20:12 +0200
Message-ID: <CAFgAxU_DrTydoiuQvQ+7mvBdcntUg=Jmq4sC0mupdh-W-YQs6A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ariel Levkovich <lariel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Alex @ Mellanox" <alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Allow verbs applications packet steering of GRE tunneled traffic.

Adding GRE flow specification based on RFC 2890.
GRE consists of flags, protocol and key fields.

IPv4 protocol 47 (IPPROTO_GRE) can be used when GRE packets are
encapsulated in IPv4.

Signed-off-by: Alex Rosenbaum <alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibverbs/man/ibv_create_flow.3 |  1 +
 libibverbs/verbs.h               | 16 ++++++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/libibverbs/man/ibv_create_flow.3 b/libibverbs/man/ibv_create_flow.3
index 48bbb14..a59cbe5 100644
--- a/libibverbs/man/ibv_create_flow.3
+++ b/libibverbs/man/ibv_create_flow.3
@@ -67,6 +67,7 @@ IBV_FLOW_SPEC_IPV4_EXT                  = 0x32,   /*
Extended flow specification
 IBV_FLOW_SPEC_TCP                       = 0x40,   /* Flow
specification of TCP header */
 IBV_FLOW_SPEC_UDP                       = 0x41,   /* Flow
specification of UDP header */
 IBV_FLOW_SPEC_VXLAN_TUNNEL                     = 0x50,   /* Flow
specification of VXLAN header */
+IBV_FLOW_SPEC_GRE                       = 0x51,   /* Flow
specification of GRE header */
 IBV_FLOW_SPEC_INNER                            = 0x100,  /* Flag
making L2/L3/L4 specifications to be applied on the inner header */
 IBV_FLOW_SPEC_ACTION_TAG                = 0x1000, /* Action tagging
matched packet */
 IBV_FLOW_SPEC_ACTION_DROP               = 0x1001, /* Action dropping
matched packet */
diff --git a/libibverbs/verbs.h b/libibverbs/verbs.h
index 5325f8f..ec0504f 100644
--- a/libibverbs/verbs.h
+++ b/libibverbs/verbs.h
@@ -1373,6 +1373,7 @@ enum ibv_flow_spec_type {
        IBV_FLOW_SPEC_TCP               = 0x40,
        IBV_FLOW_SPEC_UDP               = 0x41,
        IBV_FLOW_SPEC_VXLAN_TUNNEL      = 0x50,
+       IBV_FLOW_SPEC_GRE               = 0x51,
        IBV_FLOW_SPEC_INNER             = 0x100,
        IBV_FLOW_SPEC_ACTION_TAG        = 0x1000,
        IBV_FLOW_SPEC_ACTION_DROP       = 0x1001,
@@ -1451,6 +1452,20 @@ struct ibv_flow_spec_tcp_udp {
        struct ibv_flow_tcp_udp_filter mask;
 };

+struct ibv_flow_gre_filter {
+       uint16_t c_ks_res0_ver;
+       uint16_t protocol;
+       uint32_t key;
+};
+
+struct ibv_flow_spec_gre {
+       enum ibv_flow_spec_type  type;
+       uint16_t  size;
+       struct ibv_flow_gre_filter val;
+       struct ibv_flow_gre_filter mask;
+};
+
 struct ibv_flow_tunnel_filter {
        uint32_t tunnel_id;
 };
@@ -1485,6 +1500,7 @@ struct ibv_flow_spec {
                struct ibv_flow_spec_ipv4_ext ipv4_ext;
                struct ibv_flow_spec_ipv6 ipv6;
                struct ibv_flow_spec_tunnel tunnel;
+               struct ibv_flow_spec_gre gre;
                struct ibv_flow_spec_action_tag flow_tag;
                struct ibv_flow_spec_action_drop drop;
        };
-- 
1.8.3.1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

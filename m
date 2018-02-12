From: Alex Rosenbaum <rosenbaumalex-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH RFC 3/3] Add Verbs MPLS flow specification filter
Date: Mon, 12 Feb 2018 17:20:18 +0200
Message-ID: <CAFgAxU_hQr86H1FtxrJ4fpZrbmMOqyCf5Hn-SN96sKbtj3ueMQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ariel Levkovich <lariel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Alex @ Mellanox" <alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add MPLS flow specification based on RFC 3032.
MPLS spec defined with tag field.

A MPLS allows stacking multiple labels in sequance.
In addition, the MPLS header can be encapsulted on top of different
layers, e.g.: ETH, IP (rfc4023), UDP (rfc7510), GRE (rfc4023).

Application should use the IBV_FLOW_ATTR_FLAGS_ORDERED_SPEC_LIST to define
the order in which the MPLS headers are encapsulated, as well as stacking
multiple such spec in sequance.

Signed-off-by: Alex Rosenbaum <alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibverbs/man/ibv_create_flow.3 |  5 ++++-
 libibverbs/verbs.h               | 11 +++++++++++
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/libibverbs/man/ibv_create_flow.3 b/libibverbs/man/ibv_create_flow.3
index ee801fc..1519715 100644
--- a/libibverbs/man/ibv_create_flow.3
+++ b/libibverbs/man/ibv_create_flow.3
@@ -69,6 +69,7 @@ IBV_FLOW_SPEC_TCP                       = 0x40,   /*
Flow specification of TCP h
 IBV_FLOW_SPEC_UDP                       = 0x41,   /* Flow
specification of UDP header */
 IBV_FLOW_SPEC_VXLAN_TUNNEL                     = 0x50,   /* Flow
specification of VXLAN header */
 IBV_FLOW_SPEC_GRE                       = 0x51,   /* Flow
specification of GRE header */
+IBV_FLOW_SPEC_MPLS                      = 0x60,   /* Flow
specification of MPLS header */
 IBV_FLOW_SPEC_INNER                            = 0x100,  /* Flag
making L2/L3/L4 specifications to be applied on the inner header */
 IBV_FLOW_SPEC_ACTION_TAG                = 0x1000, /* Action tagging
matched packet */
 IBV_FLOW_SPEC_ACTION_DROP               = 0x1001, /* Action dropping
matched packet */
@@ -112,7 +113,9 @@ Alternatively, if an ibv_flow is created with flag
 .BR IBV_FLOW_ATTR_FLAGS_ORDERED_SPEC_LIST\fR,
 then the ibv_flow_spec_xxx rules order will be matched as a stricted pattern.
 This mode allows the application to define a very precise network
header structure. This is very useful to represent many of the
encapsulation tunnel protocols.
-
+.br
+.B NOTE:
+IBV_FLOW_SPEC_MPLS flow spec type should be used with the
IBV_FLOW_ATTR_FLAGS_ORDERED_SPEC_LIST flag in order to strictly define
it's location in the protocol stack.
 .SS ibv_destroy_flow()
 destroys the flow
 .I flow_id\fR.
diff --git a/libibverbs/verbs.h b/libibverbs/verbs.h
index 4f03bc9..04de6ea 100644
--- a/libibverbs/verbs.h
+++ b/libibverbs/verbs.h
@@ -1375,6 +1375,7 @@ enum ibv_flow_spec_type {
        IBV_FLOW_SPEC_UDP               = 0x41,
        IBV_FLOW_SPEC_VXLAN_TUNNEL      = 0x50,
        IBV_FLOW_SPEC_GRE               = 0x51,
+       IBV_FLOW_SPEC_MPLS              = 0x60,
        IBV_FLOW_SPEC_INNER             = 0x100,
        IBV_FLOW_SPEC_ACTION_TAG        = 0x1000,
        IBV_FLOW_SPEC_ACTION_DROP       = 0x1001,
@@ -1466,6 +1467,16 @@ struct ibv_flow_spec_gre {
        struct ibv_flow_gre_filter mask;
 };

+struct ibv_mpls_filter {
+       uint32_t tag;
+};
+
+struct ibv_flow_spec_mpls {
+       enum ibv_flow_spec_type  type;
+       uint16_t  size;
+       struct ibv_mpls_filter val;
+       struct ibv_mpls_filter mask;
+};

 struct ibv_flow_tunnel_filter {
        uint32_t tunnel_id;
-- 
1.8.3.1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

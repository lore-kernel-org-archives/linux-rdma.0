From: Boris Pismenny <borisp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC 2/2] IB/core: ESP AES-GCM crypto offload action
Date: Thu, 20 Apr 2017 14:00:10 +0300
Message-ID: <3850eaa87caf22b358f1cb31849028e3545d1e0d.1492685328.git.borisp@mellanox.com>
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

This patch introduces the flow steering specification for IPsec
AES-GCM crypto offload to HW. If a user creates a flow with
this specification, then all packets that hit this flow will
have their payload encrypted and authenticated according to
the key and the salt in this specification as defined in RFC4303.

Signed-off-by: borisp <borisp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/rdma/ib_verbs.h | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 6c1c867..e4e33e4 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1658,10 +1658,12 @@ enum ib_flow_spec_type {
 	/* L4 headers*/
 	IB_FLOW_SPEC_TCP		= 0x40,
 	IB_FLOW_SPEC_UDP		= 0x41,
+	IB_FLOW_SPEC_ESP		= 0x42,
 	IB_FLOW_SPEC_VXLAN_TUNNEL	= 0x50,
 	IB_FLOW_SPEC_INNER		= 0x100,
 	/* Actions */
 	IB_FLOW_SPEC_ACTION_TAG         = 0x1000,
+	IB_FLOW_SPEC_ACTION_ESP_AES_GCM         = 0x1001,
 };
 #define IB_FLOW_SPEC_LAYER_MASK	0xF0
 #define IB_FLOW_SPEC_SUPPORT_LAYERS 8
@@ -1770,6 +1772,20 @@ struct ib_flow_spec_tcp_udp {
 	struct ib_flow_tcp_udp_filter mask;
 };
 
+struct ib_flow_esp_filter {
+		__be32	spi;
+		__be32  seq;
+		/* Must be last */
+		u8	real_sz[0];
+};
+
+struct ib_flow_spec_esp {
+	u32                           type;
+	u16			      size;
+	struct ib_flow_esp_filter     val;
+	struct ib_flow_esp_filter     mask;
+};
+
 struct ib_flow_tunnel_filter {
 	__be32	tunnel_id;
 	u8	real_sz[0];
@@ -1791,6 +1807,16 @@ struct ib_flow_spec_action_tag {
 	u32                           tag_id;
 };
 
+struct ib_flow_spec_action_esp_aes_gcm {
+	enum ib_flow_spec_type	      type;
+	u16			      size;
+	__u8                          key[32];
+	__u8                          key_length; /* 16, 24 or 32 bytes */
+	__u8                          salt[4]; /* salt according to RFC4106 */
+	__u8                          seqiv_salt[8];
+	__u8			      seq_hi[4];
+};
+
 union ib_flow_spec {
 	struct {
 		u32			type;
@@ -1802,7 +1828,9 @@ struct ib_flow_spec_action_tag {
 	struct ib_flow_spec_tcp_udp	tcp_udp;
 	struct ib_flow_spec_ipv6        ipv6;
 	struct ib_flow_spec_tunnel      tunnel;
+	struct ib_flow_spec_esp		esp;
 	struct ib_flow_spec_action_tag  flow_tag;
+	struct ib_flow_spec_action_esp_aes_gcm  esp_aes_gcm;
 };
 
 struct ib_flow_attr {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

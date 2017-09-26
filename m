From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-rc 7/7] IB/opa_vnic: Add routing control information
Date: Tue, 26 Sep 2017 06:44:26 -0700
Message-ID: <20170926134425.11429.98659.stgit@scvm10.sc.intel.com>
References: <20170926134250.11429.58329.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170926134250.11429.58329.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Scott Franco <safranco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sudeep Dutt <sudeep.dutt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Add protocol specific routing control information in the encapsulation
header as per the configuration.

Reviewed-by: Sudeep Dutt <sudeep.dutt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Scott Franco <safranco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.c   |   41 +++++++++++++++++++-
 drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.h   |   16 +++++++-
 .../infiniband/ulp/opa_vnic/opa_vnic_internal.h    |    4 +-
 .../infiniband/ulp/opa_vnic/opa_vnic_vema_iface.c  |    4 ++
 4 files changed, 61 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.c b/drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.c
index a72278e..4be3aef 100644
--- a/drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.c
+++ b/drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.c
@@ -406,6 +406,42 @@ u8 opa_vnic_get_vl(struct opa_vnic_adapter *adapter, struct sk_buff *skb)
 	return vl;
 }
 
+/* opa_vnic_get_rc - return the routing control */
+static u8 opa_vnic_get_rc(struct __opa_veswport_info *info,
+			  struct sk_buff *skb)
+{
+	u8 proto, rout_ctrl;
+
+	switch (vlan_get_protocol(skb)) {
+	case htons(ETH_P_IPV6):
+		proto = ipv6_hdr(skb)->nexthdr;
+		if (proto == IPPROTO_TCP)
+			rout_ctrl = OPA_VNIC_ENCAP_RC_EXT(info->vesw.rc,
+							  IPV6_TCP);
+		else if (proto == IPPROTO_UDP)
+			rout_ctrl = OPA_VNIC_ENCAP_RC_EXT(info->vesw.rc,
+							  IPV6_UDP);
+		else
+			rout_ctrl = OPA_VNIC_ENCAP_RC_EXT(info->vesw.rc, IPV6);
+		break;
+	case htons(ETH_P_IP):
+		proto = ip_hdr(skb)->protocol;
+		if (proto == IPPROTO_TCP)
+			rout_ctrl = OPA_VNIC_ENCAP_RC_EXT(info->vesw.rc,
+							  IPV4_TCP);
+		else if (proto == IPPROTO_UDP)
+			rout_ctrl = OPA_VNIC_ENCAP_RC_EXT(info->vesw.rc,
+							  IPV4_UDP);
+		else
+			rout_ctrl = OPA_VNIC_ENCAP_RC_EXT(info->vesw.rc, IPV4);
+		break;
+	default:
+		rout_ctrl = OPA_VNIC_ENCAP_RC_EXT(info->vesw.rc, DEFAULT);
+	}
+
+	return rout_ctrl;
+}
+
 /* opa_vnic_calc_entropy - calculate the packet entropy */
 u8 opa_vnic_calc_entropy(struct opa_vnic_adapter *adapter, struct sk_buff *skb)
 {
@@ -448,7 +484,7 @@ void opa_vnic_encap_skb(struct opa_vnic_adapter *adapter, struct sk_buff *skb)
 {
 	struct __opa_veswport_info *info = &adapter->info;
 	struct opa_vnic_skb_mdata *mdata;
-	u8 def_port, sc, entropy, *hdr;
+	u8 def_port, sc, rc, entropy, *hdr;
 	u16 len, l4_hdr;
 	u32 dlid;
 
@@ -459,6 +495,7 @@ void opa_vnic_encap_skb(struct opa_vnic_adapter *adapter, struct sk_buff *skb)
 	len = opa_vnic_wire_length(skb);
 	dlid = opa_vnic_get_dlid(adapter, skb, def_port);
 	sc = opa_vnic_get_sc(info, skb);
+	rc = opa_vnic_get_rc(info, skb);
 	l4_hdr = info->vesw.vesw_id;
 
 	mdata = skb_push(skb, sizeof(*mdata));
@@ -471,6 +508,6 @@ void opa_vnic_encap_skb(struct opa_vnic_adapter *adapter, struct sk_buff *skb)
 	}
 
 	opa_vnic_make_header(hdr, info->vport.encap_slid, dlid, len,
-			     info->vesw.pkey, entropy, sc, 0,
+			     info->vesw.pkey, entropy, sc, rc,
 			     OPA_VNIC_L4_ETHR, l4_hdr);
 }
diff --git a/drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.h b/drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.h
index be45697..e4c9bf2 100644
--- a/drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.h
+++ b/drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.h
@@ -103,6 +103,17 @@
 #define OPA_VNIC_ETH_LINK_UP     1
 #define OPA_VNIC_ETH_LINK_DOWN   2
 
+/* routing control */
+#define OPA_VNIC_ENCAP_RC_DEFAULT   0
+#define OPA_VNIC_ENCAP_RC_IPV4      4
+#define OPA_VNIC_ENCAP_RC_IPV4_UDP  8
+#define OPA_VNIC_ENCAP_RC_IPV4_TCP  12
+#define OPA_VNIC_ENCAP_RC_IPV6      16
+#define OPA_VNIC_ENCAP_RC_IPV6_TCP  20
+#define OPA_VNIC_ENCAP_RC_IPV6_UDP  24
+
+#define OPA_VNIC_ENCAP_RC_EXT(w, b) (((w) >> OPA_VNIC_ENCAP_RC_ ## b) & 0x7)
+
 /**
  * struct opa_vesw_info - OPA vnic switch information
  * @fabric_id: 10-bit fabric id
@@ -111,6 +122,7 @@
  * @pkey: partition key
  * @u_mcast_dlid: unknown multicast dlid
  * @u_ucast_dlid: array of unknown unicast dlids
+ * @rc: routing control
  * @eth_mtu: Ethernet MTU
  */
 struct opa_vesw_info {
@@ -127,7 +139,9 @@ struct opa_vesw_info {
 	__be32  u_mcast_dlid;
 	__be32  u_ucast_dlid[OPA_VESW_MAX_NUM_DEF_PORT];
 
-	u8      rsvd3[60];
+	__be32  rc;
+
+	u8      rsvd3[56];
 	__be16  eth_mtu;
 	u8      rsvd4[2];
 } __packed;
diff --git a/drivers/infiniband/ulp/opa_vnic/opa_vnic_internal.h b/drivers/infiniband/ulp/opa_vnic/opa_vnic_internal.h
index a90c631..afd95f4 100644
--- a/drivers/infiniband/ulp/opa_vnic/opa_vnic_internal.h
+++ b/drivers/infiniband/ulp/opa_vnic/opa_vnic_internal.h
@@ -89,7 +89,9 @@ struct __opa_vesw_info {
 	u32  u_mcast_dlid;
 	u32  u_ucast_dlid[OPA_VESW_MAX_NUM_DEF_PORT];
 
-	u8   rsvd3[60];
+	u32  rc;
+
+	u8   rsvd3[56];
 	u16  eth_mtu;
 	u8   rsvd4[2];
 } __packed;
diff --git a/drivers/infiniband/ulp/opa_vnic/opa_vnic_vema_iface.c b/drivers/infiniband/ulp/opa_vnic/opa_vnic_vema_iface.c
index 5553900..868b5ae 100644
--- a/drivers/infiniband/ulp/opa_vnic/opa_vnic_vema_iface.c
+++ b/drivers/infiniband/ulp/opa_vnic/opa_vnic_vema_iface.c
@@ -176,6 +176,8 @@ void opa_vnic_get_vesw_info(struct opa_vnic_adapter *adapter,
 	for (i = 0; i < OPA_VESW_MAX_NUM_DEF_PORT; i++)
 		info->u_ucast_dlid[i] = cpu_to_be32(src->u_ucast_dlid[i]);
 
+	info->rc = cpu_to_be32(src->rc);
+
 	memcpy(info->rsvd3, src->rsvd3, ARRAY_SIZE(src->rsvd3));
 	info->eth_mtu = cpu_to_be16(src->eth_mtu);
 	memcpy(info->rsvd4, src->rsvd4, ARRAY_SIZE(src->rsvd4));
@@ -208,6 +210,8 @@ void opa_vnic_set_vesw_info(struct opa_vnic_adapter *adapter,
 	for (i = 0; i < OPA_VESW_MAX_NUM_DEF_PORT; i++)
 		dst->u_ucast_dlid[i] = be32_to_cpu(info->u_ucast_dlid[i]);
 
+	dst->rc = be32_to_cpu(info->rc);
+
 	memcpy(dst->rsvd3, info->rsvd3, ARRAY_SIZE(info->rsvd3));
 	dst->eth_mtu = be16_to_cpu(info->eth_mtu);
 	memcpy(dst->rsvd4, info->rsvd4, ARRAY_SIZE(info->rsvd4));

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>
Subject: [PATCH net-next 4/4] OVS: remove use of VLAN_TAG_PRESENT
Date: Thu, 08 Nov 2018 18:44:50 +0100
Message-ID: <1e645509b36eb1a3c434bf0a8183dc597472c408.1541698641.git.mirq-linux@rere.qmqm.pl>
References: <cover.1541698641.git.mirq-linux@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <cover.1541698641.git.mirq-linux@rere.qmqm.pl>
Sender: netdev-owner@vger.kernel.org
To: netdev@vger.kernel.org
Cc: Pravin B Shelar <pshelar@ovn.org>, Claudiu Manoil <claudiu.manoil@nxp.com>, Faisal Latif <faisal.latif@intel.com>, Shiraz Saleem <shiraz.saleem@intel.com>, dev@openvswitch.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

This is a minimal change to allow removing of VLAN_TAG_PRESENT.
It leaves OVS unable to use CFI bit, as fixing this would need
a deeper surgery involving userspace interface.

Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
---
 net/openvswitch/actions.c      | 13 +++++++++----
 net/openvswitch/flow.c         |  4 ++--
 net/openvswitch/flow.h         |  2 +-
 net/openvswitch/flow_netlink.c | 22 +++++++++++-----------
 4 files changed, 23 insertions(+), 18 deletions(-)

diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
index 85ae53d8fd09..e47ebbbe71b8 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -301,7 +301,7 @@ static int push_vlan(struct sk_buff *skb, struct sw_flow_key *key,
 		key->eth.vlan.tpid = vlan->vlan_tpid;
 	}
 	return skb_vlan_push(skb, vlan->vlan_tpid,
-			     ntohs(vlan->vlan_tci) & ~VLAN_TAG_PRESENT);
+			     ntohs(vlan->vlan_tci) & ~VLAN_CFI_MASK);
 }
 
 /* 'src' is already properly masked. */
@@ -822,8 +822,10 @@ static int ovs_vport_output(struct net *net, struct sock *sk, struct sk_buff *sk
 	__skb_dst_copy(skb, data->dst);
 	*OVS_CB(skb) = data->cb;
 	skb->inner_protocol = data->inner_protocol;
-	skb->vlan_tci = data->vlan_tci;
-	skb->vlan_proto = data->vlan_proto;
+	if (data->vlan_tci & VLAN_CFI_MASK)
+		__vlan_hwaccel_put_tag(skb, data->vlan_proto, data->vlan_tci & ~VLAN_CFI_MASK);
+	else
+		__vlan_hwaccel_clear_tag(skb);
 
 	/* Reconstruct the MAC header.  */
 	skb_push(skb, data->l2_len);
@@ -867,7 +869,10 @@ static void prepare_frag(struct vport *vport, struct sk_buff *skb,
 	data->cb = *OVS_CB(skb);
 	data->inner_protocol = skb->inner_protocol;
 	data->network_offset = orig_network_offset;
-	data->vlan_tci = skb->vlan_tci;
+	if (skb_vlan_tag_present(skb))
+		data->vlan_tci = skb_vlan_tag_get(skb) | VLAN_CFI_MASK;
+	else
+		data->vlan_tci = 0;
 	data->vlan_proto = skb->vlan_proto;
 	data->mac_proto = mac_proto;
 	data->l2_len = hlen;
diff --git a/net/openvswitch/flow.c b/net/openvswitch/flow.c
index 35966da84769..fa393815991e 100644
--- a/net/openvswitch/flow.c
+++ b/net/openvswitch/flow.c
@@ -325,7 +325,7 @@ static int parse_vlan_tag(struct sk_buff *skb, struct vlan_head *key_vh,
 		return -ENOMEM;
 
 	vh = (struct vlan_head *)skb->data;
-	key_vh->tci = vh->tci | htons(VLAN_TAG_PRESENT);
+	key_vh->tci = vh->tci | htons(VLAN_CFI_MASK);
 	key_vh->tpid = vh->tpid;
 
 	if (unlikely(untag_vlan)) {
@@ -358,7 +358,7 @@ static int parse_vlan(struct sk_buff *skb, struct sw_flow_key *key)
 	int res;
 
 	if (skb_vlan_tag_present(skb)) {
-		key->eth.vlan.tci = htons(skb->vlan_tci);
+		key->eth.vlan.tci = htons(skb->vlan_tci) | htons(VLAN_CFI_MASK);
 		key->eth.vlan.tpid = skb->vlan_proto;
 	} else {
 		/* Parse outer vlan tag in the non-accelerated case. */
diff --git a/net/openvswitch/flow.h b/net/openvswitch/flow.h
index c670dd24b8b7..ba01fc4270bd 100644
--- a/net/openvswitch/flow.h
+++ b/net/openvswitch/flow.h
@@ -60,7 +60,7 @@ struct ovs_tunnel_info {
 
 struct vlan_head {
 	__be16 tpid; /* Vlan type. Generally 802.1q or 802.1ad.*/
-	__be16 tci;  /* 0 if no VLAN, VLAN_TAG_PRESENT set otherwise. */
+	__be16 tci;  /* 0 if no VLAN, VLAN_CFI_MASK set otherwise. */
 };
 
 #define OVS_SW_FLOW_KEY_METADATA_SIZE			\
diff --git a/net/openvswitch/flow_netlink.c b/net/openvswitch/flow_netlink.c
index 865ecef68196..435a4bdf8f89 100644
--- a/net/openvswitch/flow_netlink.c
+++ b/net/openvswitch/flow_netlink.c
@@ -990,9 +990,9 @@ static int validate_vlan_from_nlattrs(const struct sw_flow_match *match,
 	if (a[OVS_KEY_ATTR_VLAN])
 		tci = nla_get_be16(a[OVS_KEY_ATTR_VLAN]);
 
-	if (!(tci & htons(VLAN_TAG_PRESENT))) {
+	if (!(tci & htons(VLAN_CFI_MASK))) {
 		if (tci) {
-			OVS_NLERR(log, "%s TCI does not have VLAN_TAG_PRESENT bit set.",
+			OVS_NLERR(log, "%s TCI does not have VLAN_CFI_MASK bit set.",
 				  (inner) ? "C-VLAN" : "VLAN");
 			return -EINVAL;
 		} else if (nla_len(a[OVS_KEY_ATTR_ENCAP])) {
@@ -1013,9 +1013,9 @@ static int validate_vlan_mask_from_nlattrs(const struct sw_flow_match *match,
 	__be16 tci = 0;
 	__be16 tpid = 0;
 	bool encap_valid = !!(match->key->eth.vlan.tci &
-			      htons(VLAN_TAG_PRESENT));
+			      htons(VLAN_CFI_MASK));
 	bool i_encap_valid = !!(match->key->eth.cvlan.tci &
-				htons(VLAN_TAG_PRESENT));
+				htons(VLAN_CFI_MASK));
 
 	if (!(key_attrs & (1 << OVS_KEY_ATTR_ENCAP))) {
 		/* Not a VLAN. */
@@ -1039,8 +1039,8 @@ static int validate_vlan_mask_from_nlattrs(const struct sw_flow_match *match,
 			  (inner) ? "C-VLAN" : "VLAN", ntohs(tpid));
 		return -EINVAL;
 	}
-	if (!(tci & htons(VLAN_TAG_PRESENT))) {
-		OVS_NLERR(log, "%s TCI mask does not have exact match for VLAN_TAG_PRESENT bit.",
+	if (!(tci & htons(VLAN_CFI_MASK))) {
+		OVS_NLERR(log, "%s TCI mask does not have exact match for VLAN_CFI_MASK bit.",
 			  (inner) ? "C-VLAN" : "VLAN");
 		return -EINVAL;
 	}
@@ -1095,7 +1095,7 @@ static int parse_vlan_from_nlattrs(struct sw_flow_match *match,
 	if (err)
 		return err;
 
-	encap_valid = !!(match->key->eth.vlan.tci & htons(VLAN_TAG_PRESENT));
+	encap_valid = !!(match->key->eth.vlan.tci & htons(VLAN_CFI_MASK));
 	if (encap_valid) {
 		err = __parse_vlan_from_nlattrs(match, key_attrs, true, a,
 						is_mask, log);
@@ -2943,7 +2943,7 @@ static int __ovs_nla_copy_actions(struct net *net, const struct nlattr *attr,
 			vlan = nla_data(a);
 			if (!eth_type_vlan(vlan->vlan_tpid))
 				return -EINVAL;
-			if (!(vlan->vlan_tci & htons(VLAN_TAG_PRESENT)))
+			if (!(vlan->vlan_tci & htons(VLAN_CFI_MASK)))
 				return -EINVAL;
 			vlan_tci = vlan->vlan_tci;
 			break;
@@ -2959,7 +2959,7 @@ static int __ovs_nla_copy_actions(struct net *net, const struct nlattr *attr,
 			/* Prohibit push MPLS other than to a white list
 			 * for packets that have a known tag order.
 			 */
-			if (vlan_tci & htons(VLAN_TAG_PRESENT) ||
+			if (vlan_tci & htons(VLAN_CFI_MASK) ||
 			    (eth_type != htons(ETH_P_IP) &&
 			     eth_type != htons(ETH_P_IPV6) &&
 			     eth_type != htons(ETH_P_ARP) &&
@@ -2971,7 +2971,7 @@ static int __ovs_nla_copy_actions(struct net *net, const struct nlattr *attr,
 		}
 
 		case OVS_ACTION_ATTR_POP_MPLS:
-			if (vlan_tci & htons(VLAN_TAG_PRESENT) ||
+			if (vlan_tci & htons(VLAN_CFI_MASK) ||
 			    !eth_p_mpls(eth_type))
 				return -EINVAL;
 
@@ -3036,7 +3036,7 @@ static int __ovs_nla_copy_actions(struct net *net, const struct nlattr *attr,
 		case OVS_ACTION_ATTR_POP_ETH:
 			if (mac_proto != MAC_PROTO_ETHERNET)
 				return -EINVAL;
-			if (vlan_tci & htons(VLAN_TAG_PRESENT))
+			if (vlan_tci & htons(VLAN_CFI_MASK))
 				return -EINVAL;
 			mac_proto = MAC_PROTO_NONE;
 			break;
-- 
2.19.1

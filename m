From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-next 5/6] IB/core: Introduce inner flow steering
Date: Mon, 14 Nov 2016 19:04:51 +0200
Message-ID: <1479143092-11723-6-git-send-email-leonro@mellanox.com>
References: <1479143092-11723-1-git-send-email-leonro@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1479143092-11723-1-git-send-email-leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moses Reuben <mosesr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Moses Reuben <mosesr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

For a tunneled packet which contains external and internal headers,
we refer to the external headers as "outer fields" and the internal
headers as "inner fields".

Example of a tunneled packet:

{ L2 | L3 | L4 | tunnel header | L2 | L3 | l4 | data }
  |     |    |         |         |    |    |
{       outer fields           }{ inner fields }

This patch introduces a new flag for flow steering rules
- IB_FLOW_SPEC_INNER - which specifies that the rule applies
to the inner fields, rather than to the outer fields of the packet.

Signed-off-by: Moses Reuben <mosesr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c |  4 +++-
 include/rdma/ib_verbs.h              | 17 +++++++++--------
 2 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 561010a..10fb325 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -3124,8 +3124,10 @@ static int kern_spec_to_ib_spec(struct ib_uverbs_flow_spec *kern_spec,
 	kern_spec_val = (void *)kern_spec +
 		sizeof(struct ib_uverbs_flow_spec_hdr);
 	kern_spec_mask = kern_spec_val + kern_filter_sz;
+	if (ib_spec->type == (IB_FLOW_SPEC_INNER | IB_FLOW_SPEC_VXLAN_TUNNEL))
+		return -EINVAL;

-	switch (ib_spec->type) {
+	switch (ib_spec->type & ~IB_FLOW_SPEC_INNER) {
 	case IB_FLOW_SPEC_ETH:
 		ib_filter_sz = offsetof(struct ib_flow_eth_filter, real_sz);
 		actual_filter_sz = spec_filter_size(kern_spec_mask,
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 81c5c80..195a03e 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1601,9 +1601,10 @@ enum ib_flow_spec_type {
 	IB_FLOW_SPEC_TCP		= 0x40,
 	IB_FLOW_SPEC_UDP		= 0x41,
 	IB_FLOW_SPEC_VXLAN_TUNNEL	= 0x50,
+	IB_FLOW_SPEC_INNER		= 0x100,
 };
 #define IB_FLOW_SPEC_LAYER_MASK	0xF0
-#define IB_FLOW_SPEC_SUPPORT_LAYERS 4
+#define IB_FLOW_SPEC_SUPPORT_LAYERS 8

 /* Flow steering rule priority is set according to it's domain.
  * Lower domain value means higher priority.
@@ -1631,7 +1632,7 @@ struct ib_flow_eth_filter {
 };

 struct ib_flow_spec_eth {
-	enum ib_flow_spec_type	  type;
+	u32			  type;
 	u16			  size;
 	struct ib_flow_eth_filter val;
 	struct ib_flow_eth_filter mask;
@@ -1645,7 +1646,7 @@ struct ib_flow_ib_filter {
 };

 struct ib_flow_spec_ib {
-	enum ib_flow_spec_type	 type;
+	u32			 type;
 	u16			 size;
 	struct ib_flow_ib_filter val;
 	struct ib_flow_ib_filter mask;
@@ -1670,7 +1671,7 @@ struct ib_flow_ipv4_filter {
 };

 struct ib_flow_spec_ipv4 {
-	enum ib_flow_spec_type	   type;
+	u32			   type;
 	u16			   size;
 	struct ib_flow_ipv4_filter val;
 	struct ib_flow_ipv4_filter mask;
@@ -1688,7 +1689,7 @@ struct ib_flow_ipv6_filter {
 };

 struct ib_flow_spec_ipv6 {
-	enum ib_flow_spec_type	   type;
+	u32			   type;
 	u16			   size;
 	struct ib_flow_ipv6_filter val;
 	struct ib_flow_ipv6_filter mask;
@@ -1702,7 +1703,7 @@ struct ib_flow_tcp_udp_filter {
 };

 struct ib_flow_spec_tcp_udp {
-	enum ib_flow_spec_type	      type;
+	u32			      type;
 	u16			      size;
 	struct ib_flow_tcp_udp_filter val;
 	struct ib_flow_tcp_udp_filter mask;
@@ -1717,7 +1718,7 @@ struct ib_flow_tunnel_filter {
  * the tunnel_id from val has the vni value
  */
 struct ib_flow_spec_tunnel {
-	enum ib_flow_spec_type	      type;
+	u32			      type;
 	u16			      size;
 	struct ib_flow_tunnel_filter  val;
 	struct ib_flow_tunnel_filter  mask;
@@ -1725,7 +1726,7 @@ struct ib_flow_spec_tunnel {

 union ib_flow_spec {
 	struct {
-		enum ib_flow_spec_type	type;
+		u32			type;
 		u16			size;
 	};
 	struct ib_flow_spec_eth		eth;
--
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

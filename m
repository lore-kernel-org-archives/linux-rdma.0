From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 6/9] IB/core: Add receive Flow Steering support
Date: Wed, 24 Apr 2013 16:58:49 +0300
Message-ID: <1366811932-28199-7-git-send-email-ogerlitz@mellanox.com>
References: <1366811932-28199-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1366811932-28199-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Rosenbaum <alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Rony Efraim <ronye-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Hadar Hen Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The RDMA stack allows for applications to create IB_QPT_RAW_PACKET QPs,
for which plain Ethernet packets are used, specifically packets which
don't carry any QPN to be matched by the receiving side.

Applications using these QPs must be provided with a method to
program some steering rule with the HW so packets arriving at
the local port can be routed to them.

This patch adds ib_create_flow which allow to provide a flow specification
for a QP, such that when there's a match between the specification and the
received packet, it can be forwarded to that QP, in a similar manner
one needs to use ib_attach_multicast for IB UD multicast handling.

Flow specifications are provided as instances of struct ib_flow_spec_yyy
which describe L2, L3 and L4 headers, currently specs for Ethernet, IPv4,
TCP, UDP and IB are defined. Flow specs are made of values and masks.

The input to ib_create_flow is instance of struct ib_flow_attr which
contain few mandatory control elements and optional flow specs.

struct ib_flow_attr {
	enum ib_flow_attr_type type;
	u16      size;
	u16      priority;
	u8       num_of_specs;
	u8       port;
	u32      flags;
	/* Following are the optional layers according to user request
	 * struct ib_flow_spec_yyy
	 * struct ib_flow_spec_zzz
	 */
};

As these specs are eventually coming from user space, they are defined and
used in a way which allows adding new spec types without kernel/user ABI
change, and with a little API enhancement which defines the newly added spec.

The flow spec structures are defined in a TLV (Type-Length-Value) manner,
which allows to call ib_create_flow with a list of variable length of
optional specs.

For the actual processing of ib_flow_attr the driver uses the number of
specs and the size mandatory fields along with the TLV nature of the specs.

Steering rules processing order is according to rules priority. The user
sets the 12 low-order bits from the priority field and the remaining
4 high-order bits are set by the kernel according to a domain the
application or the layer that created the rule belongs to. Lower
priority numerical value means higher priority.

The returned value from ib_create_flow is instance of struct ib_flow
which contains a database pointer (handle) provided by the HW driver
to be used when calling ib_destroy_flow.

Applications that offload TCP/IP traffic could be written also over IB UD QPs.
As such, the ib_create_flow / ib_destroy_flow API is designed to support UD QPs
too, the HW driver sets IB_DEVICE_MANAGED_FLOW_STEERING to denote support
of flow steering.

The ib_flow_attr enum type relates to usage of flow steering for promiscuous
and sniffer purposes:

IB_FLOW_ATTR_NORMAL - "regular" rule, steering according to rule specification

IB_FLOW_ATTR_ALL_DEFAULT - default unicast and multicast rule, receive
all Ethernet traffic which isn't steered to any QP

IB_FLOW_ATTR_MC_DEFAULT - same as IB_FLOW_ATTR_ALL_DEFAULT but only for multicast

IB_FLOW_ATTR_SNIFFER - sniffer rule, receive all port traffic

ALL_DEFAULT and MC_DEFAULT rules options are valid only for Ethernet link type.

Signed-off-by: Hadar Hen Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/verbs.c |   30 +++++++++
 include/rdma/ib_verbs.h         |  136 ++++++++++++++++++++++++++++++++++++++-
 2 files changed, 164 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 22192de..932f4a7 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1254,3 +1254,33 @@ int ib_dealloc_xrcd(struct ib_xrcd *xrcd)
 	return xrcd->device->dealloc_xrcd(xrcd);
 }
 EXPORT_SYMBOL(ib_dealloc_xrcd);
+
+struct ib_flow *ib_create_flow(struct ib_qp *qp,
+			       struct ib_flow_attr *flow_attr,
+			       int domain)
+{
+	struct ib_flow *flow_id;
+	if (!qp->device->create_flow)
+		return ERR_PTR(-ENOSYS);
+
+	flow_id = qp->device->create_flow(qp, flow_attr, domain);
+	if (!IS_ERR(flow_id))
+		atomic_inc(&qp->usecnt);
+	return flow_id;
+}
+EXPORT_SYMBOL(ib_create_flow);
+
+int ib_destroy_flow(struct ib_flow *flow_id)
+{
+	int err;
+	struct ib_qp *qp = flow_id->qp;
+
+	if (!flow_id->qp->device->destroy_flow)
+		return -ENOSYS;
+
+	err = qp->device->destroy_flow(flow_id);
+	if (!err)
+		atomic_dec(&qp->usecnt);
+	return err;
+}
+EXPORT_SYMBOL(ib_destroy_flow);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 98cc4b2..6f76d62 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -116,7 +116,8 @@ enum ib_device_cap_flags {
 	IB_DEVICE_MEM_MGT_EXTENSIONS	= (1<<21),
 	IB_DEVICE_BLOCK_MULTICAST_LOOPBACK = (1<<22),
 	IB_DEVICE_MEM_WINDOW_TYPE_2A	= (1<<23),
-	IB_DEVICE_MEM_WINDOW_TYPE_2B	= (1<<24)
+	IB_DEVICE_MEM_WINDOW_TYPE_2B	= (1<<24),
+	IB_DEVICE_MANAGED_FLOW_STEERING = (1<<29)
 };
 
 enum ib_atomic_cap {
@@ -1002,7 +1003,8 @@ struct ib_qp {
 	struct ib_srq	       *srq;
 	struct ib_xrcd	       *xrcd; /* XRC TGT QPs only */
 	struct list_head	xrcd_list;
-	atomic_t		usecnt; /* count times opened, mcast attaches */
+	/* count times opened, mcast attaches, flow attaches */
+	atomic_t		usecnt;
 	struct list_head	open_list;
 	struct ib_qp           *real_qp;
 	struct ib_uobject      *uobject;
@@ -1037,6 +1039,127 @@ struct ib_fmr {
 	u32			rkey;
 };
 
+/* Supported steering options */
+enum ib_flow_attr_type {
+	/* steering according to rule specifications */
+	IB_FLOW_ATTR_NORMAL		= 0x0,
+	/* default unicast and multicast rule -
+	 * receive all Eth traffic which isn't steered to any QP
+	 */
+	IB_FLOW_ATTR_ALL_DEFAULT	= 0x1,
+	/* default multicast rule -
+	 * receive all Eth multicast traffic which isn't steered to any QP
+	 */
+	IB_FLOW_ATTR_MC_DEFAULT		= 0x2,
+	/* sniffer rule - receive all port traffic */
+	IB_FLOW_ATTR_SNIFFER		= 0x3
+};
+
+/* Supported steering header types */
+enum ib_flow_spec_type {
+	/* L2 headers*/
+	IB_FLOW_SPEC_ETH	= 0x20,
+	IB_FLOW_SPEC_IB		= 0x21,
+	/* L3 header*/
+	IB_FLOW_SPEC_IPV4	= 0x30,
+	/* L4 headers*/
+	IB_FLOW_SPEC_TCP	= 0x40,
+	IB_FLOW_SPEC_UDP	= 0x41
+};
+
+/* Flow steering rule priority is set according to it's domain.
+ * Lower domain value means higher priority.
+ */
+enum ib_flow_domain {
+	IB_FLOW_DOMAIN_USER,
+	IB_FLOW_DOMAIN_ETHTOOL,
+	IB_FLOW_DOMAIN_RFS,
+	IB_FLOW_DOMAIN_NIC,
+	IB_FLOW_DOMAIN_NUM /* Must be last */
+};
+
+struct ib_flow_eth_filter {
+	u8	dst_mac[6];
+	u8	src_mac[6];
+	__be16	ether_type;
+	__be16	vlan_tag;
+};
+
+struct ib_flow_spec_eth {
+	enum ib_flow_spec_type	  type;
+	u16			  size;
+	struct ib_flow_eth_filter val;
+	struct ib_flow_eth_filter mask;
+};
+
+struct ib_flow_ib_filter {
+	__be32	l3_type_qpn;
+	u8	dst_gid[16];
+};
+
+struct ib_flow_spec_ib {
+	enum ib_flow_spec_type	 type;
+	u16			 size;
+	struct ib_flow_ib_filter val;
+	struct ib_flow_ib_filter mask;
+};
+
+struct ib_flow_ipv4_filter {
+	__be32	src_ip;
+	__be32	dst_ip;
+};
+
+struct ib_flow_spec_ipv4 {
+	enum ib_flow_spec_type	   type;
+	u16			   size;
+	struct ib_flow_ipv4_filter val;
+	struct ib_flow_ipv4_filter mask;
+};
+
+struct ib_flow_tcp_udp_filter {
+	__be16	dst_port;
+	__be16	src_port;
+};
+
+struct ib_flow_spec_tcp_udp {
+	enum ib_flow_spec_type	      type;
+	u16			      size;
+	struct ib_flow_tcp_udp_filter val;
+	struct ib_flow_tcp_udp_filter mask;
+};
+
+struct _ib_flow_spec {
+	union {
+		struct {
+			enum ib_flow_spec_type	type;
+			u16			size;
+		};
+		struct ib_flow_spec_ib ib;
+		struct ib_flow_spec_eth eth;
+		struct ib_flow_spec_ipv4 ipv4;
+		struct ib_flow_spec_tcp_udp tcp_udp;
+	};
+};
+
+struct ib_flow_attr {
+	enum ib_flow_attr_type type;
+	u16	     size;
+	u16	     priority;
+	u8	     num_of_specs;
+	u8	     port;
+	u32	     flags;
+	/* Following are the optional layers according to user request
+	 * struct ib_flow_spec_xxx
+	 * struct ib_flow_spec_yyy
+	 */
+};
+
+struct ib_flow {
+	struct ib_qp		*qp;
+	struct ib_uobject	*uobject;
+	void			*flow_context;
+};
+
 struct ib_mad;
 struct ib_grh;
 
@@ -1269,6 +1392,11 @@ struct ib_device {
 						 struct ib_ucontext *ucontext,
 						 struct ib_udata *udata);
 	int			   (*dealloc_xrcd)(struct ib_xrcd *xrcd);
+	struct ib_flow *	   (*create_flow)(struct ib_qp *qp,
+						  struct ib_flow_attr
+						  *flow_attr,
+						  int domain);
+	int			   (*destroy_flow)(struct ib_flow *flow_id);
 
 	struct ib_dma_mapping_ops   *dma_ops;
 
@@ -2229,4 +2357,8 @@ struct ib_xrcd *ib_alloc_xrcd(struct ib_device *device);
  */
 int ib_dealloc_xrcd(struct ib_xrcd *xrcd);
 
+struct ib_flow *ib_create_flow(struct ib_qp *qp,
+			       struct ib_flow_attr *flow_attr, int domain);
+int ib_destroy_flow(struct ib_flow *flow_id);
+
 #endif /* IB_VERBS_H */
-- 
1.7.1

Cc: Alex Rosenbaum <alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Rony Efraim <ronye-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

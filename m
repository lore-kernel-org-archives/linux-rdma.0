From: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCHv7 1/9] ib core: Add link layer property to ports
Date: Tue, 5 Jan 2010 12:32:26 +0200
Message-ID: <20100105103226.GC31480@mtls03>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch adds the infrastructure for querying the link layer of a port, which
can be either IB_LINK_LAYER_INFINIBAND or IB_LINK_LAYER_ETHERNET. This is
required for adding RoCEE support to Infiniband drivers so that branching
decisions can be made according to the value of this property. For devices that
do not provide an implementation for querying the link layer property of a
port, the returned value depends on the node transport such that
RMA_TRANSPORT_IB nodes will return IB_LINK_LAYER_INFINIBAND and
RDMA_TRANSPORT_IWARP nodes will return IB_LINK_LAYER_ETHERNET.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 drivers/infiniband/core/verbs.c |   16 ++++++++++++++++
 include/rdma/ib_verbs.h         |   12 ++++++++++++
 2 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index a7da9be..f9cbdb6 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -94,6 +94,22 @@ rdma_node_get_transport(enum rdma_node_type node_type)
 }
 EXPORT_SYMBOL(rdma_node_get_transport);
 
+enum rdma_link_layer rdma_port_link_layer(struct ib_device *device, u8 port_num)
+{
+	if (device->get_link_layer)
+		return device->get_link_layer(device, port_num);
+
+	switch (rdma_node_get_transport(device->node_type)) {
+	case RDMA_TRANSPORT_IB:
+		return IB_LINK_LAYER_INFINIBAND;
+	case RDMA_TRANSPORT_IWARP:
+		return IB_LINK_LAYER_ETHERNET;
+	default:
+		return IB_LINK_LAYER_UNSPECIFIED;
+	}
+}
+EXPORT_SYMBOL(rdma_port_link_layer);
+
 /* Protection domains */
 
 struct ib_pd *ib_alloc_pd(struct ib_device *device)
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 09509ed..bbfe315 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -75,6 +75,12 @@ enum rdma_transport_type {
 enum rdma_transport_type
 rdma_node_get_transport(enum rdma_node_type node_type) __attribute_const__;
 
+enum rdma_link_layer {
+	IB_LINK_LAYER_UNSPECIFIED,
+	IB_LINK_LAYER_INFINIBAND,
+	IB_LINK_LAYER_ETHERNET,
+};
+
 enum ib_device_cap_flags {
 	IB_DEVICE_RESIZE_MAX_WR		= 1,
 	IB_DEVICE_BAD_PKEY_CNTR		= (1<<1),
@@ -298,6 +304,7 @@ struct ib_port_attr {
 	u8			active_width;
 	u8			active_speed;
 	u8                      phys_state;
+	enum rdma_link_layer	link_layer;
 };
 
 enum ib_device_modify_flags {
@@ -1003,6 +1010,8 @@ struct ib_device {
 	int		           (*query_port)(struct ib_device *device,
 						 u8 port_num,
 						 struct ib_port_attr *port_attr);
+	enum rdma_link_layer	   (*get_link_layer)(struct ib_device *device,
+						     u8 port_num);
 	int		           (*query_gid)(struct ib_device *device,
 						u8 port_num, int index,
 						union ib_gid *gid);
@@ -1213,6 +1222,9 @@ int ib_query_device(struct ib_device *device,
 int ib_query_port(struct ib_device *device,
 		  u8 port_num, struct ib_port_attr *port_attr);
 
+enum rdma_link_layer rdma_port_link_layer(struct ib_device *device,
+					  u8 port_num);
+
 int ib_query_gid(struct ib_device *device,
 		 u8 port_num, int index, union ib_gid *gid);
 
-- 
1.6.6

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

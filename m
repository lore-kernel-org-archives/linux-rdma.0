From: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCHv7 1/4] libibverbs: Add link layer field to ibv_port_attr
Date: Tue, 5 Jan 2010 12:33:55 +0200
Message-ID: <20100105103355.GL31480@mtls03>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This field can have one of the values - IBV_LINK_LAYER_UNSPECIFIED,
IBV_LINK_LAYER_INFINIBAND, IBV_LINK_LAYER_ETHERNET. It can be used by
applications to know the link layer used by the port, which can be either
Infiniband or Ethernet. The addition of the new field does not change the size
of struct ibv_port_attr due to alignment of the preceding field. Binary
compatibility is not compromised either since new apps with old libraries will
determine the link layer as IB while old applications with new a new library do
not read this field.

Solution suggested by:
               Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
               Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 include/infiniband/verbs.h |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index 0f1cb2e..17df3ff 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -161,6 +161,12 @@ enum ibv_port_state {
 	IBV_PORT_ACTIVE_DEFER	= 5
 };
 
+enum {
+	IBV_LINK_LAYER_UNSPECIFIED,
+	IBV_LINK_LAYER_INFINIBAND,
+	IBV_LINK_LAYER_ETHERNET,
+};
+
 struct ibv_port_attr {
 	enum ibv_port_state	state;
 	enum ibv_mtu		max_mtu;
@@ -181,6 +187,8 @@ struct ibv_port_attr {
 	uint8_t			active_width;
 	uint8_t			active_speed;
 	uint8_t			phys_state;
+	uint8_t			link_layer;
+	uint8_t			pad;
 };
 
 enum ibv_event_type {
@@ -693,6 +701,16 @@ struct ibv_context {
 	void		       *abi_compat;
 };
 
+static inline int ___ibv_query_port(struct ibv_context *context,
+				    uint8_t port_num,
+				    struct ibv_port_attr *port_attr)
+{
+	port_attr->link_layer = IBV_LINK_LAYER_UNSPECIFIED;
+	port_attr->pad = 0;
+
+	return context->ops.query_port(context, port_num, port_attr);
+}
+
 /**
  * ibv_get_device_list - Get list of IB devices currently available
  * @num_devices: optional.  if non-NULL, set to the number of devices
@@ -1097,4 +1115,7 @@ END_C_DECLS
 
 #  undef __attribute_const
 
+#define ibv_query_port(context, port_num, port_attr) \
+	___ibv_query_port(context, port_num, port_attr)
+
 #endif /* INFINIBAND_VERBS_H */
-- 
1.6.6

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

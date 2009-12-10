From: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCH] rdmaoe/libibverbs: handle binary compatibility
Date: Thu, 10 Dec 2009 19:05:36 +0200
Message-ID: <20091210170536.GA3229@mtls03>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ewg <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,
here is the patch I prepared based on the discussions we had. The patch is based on the last
rdmaoe/libibverbs patch I sent. libmlx4 was modified too, a trivial
change that changes name. Both fixes were push to OFED. I will send a
new patch set in a few days.

The introduction of a new field to struct ibv_port_attr to distinguish between
the different link layers supported (IB or Ethernet), which is located in the
padding area of the struct, poses a binary compatibilty issue between new
applications (compiled against the new version of the struct) and older
libraries, becuase old libraries do not initialize the padding area. To
overcome this, ibv_query_port is redefined to call an inline function that sets
the link_layer field to a predefined value which is interpreted as IB (the
previous only value for this field). The patch also clears any padding left
should we need this in the future. This patch also changes the previous field
name from protocol to link_layer, and also modifies all the examples to adapt
to the change.

Solution suggested by:
	Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
	Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 examples/devinfo.c            |   15 +++++++--------
 examples/rc_pingpong.c        |    2 +-
 examples/srq_pingpong.c       |    2 +-
 examples/uc_pingpong.c        |    2 +-
 examples/ud_pingpong.c        |    2 +-
 include/infiniband/kern-abi.h |    2 +-
 include/infiniband/verbs.h    |   33 ++++++++++++++++++++++++---------
 src/cmd.c                     |    2 +-
 src/verbs.c                   |    1 +
 9 files changed, 38 insertions(+), 23 deletions(-)

diff --git a/examples/devinfo.c b/examples/devinfo.c
index 88e0557..393ec04 100644
--- a/examples/devinfo.c
+++ b/examples/devinfo.c
@@ -184,15 +184,14 @@ static int print_all_port_gids(struct ibv_context *ctx, uint8_t port_num, int tb
 	return rc;
 }
 
-static const char *transport_type_str(enum rdma_transport_type type)
+static const char *link_layer_str(uint8_t link_layer)
 {
-	switch (type) {
-	case RDMA_TRANSPORT_IB:
+	switch (link_layer) {
+	case IBV_LINK_LAYER_UNSPECIFIED:
+	case IBV_LINK_LAYER_INFINIBAND:
 		return "IB";
-	case RDMA_TRANSPORT_IWARP:
-		return "IWARP";
-	case RDMA_TRANSPORT_RDMAOE:
-		return "RDMAOE";
+	case IBV_LINK_LAYER_ETHERNET:
+		return "Ethernet";
 	default:
 		return "Unknown";
 	}
@@ -298,7 +297,7 @@ static int print_hca_cap(struct ibv_device *ib_dev, uint8_t ib_port)
 		printf("\t\t\tsm_lid:\t\t\t%d\n", port_attr.sm_lid);
 		printf("\t\t\tport_lid:\t\t%d\n", port_attr.lid);
 		printf("\t\t\tport_lmc:\t\t0x%02x\n", port_attr.lmc);
-		printf("\t\t\ttrasnport_type:\t\t%s\n", transport_type_str(port_attr.transport));
+		printf("\t\t\tlink_layer:\t\t%s\n", link_layer_str(port_attr.link_layer));
 
 		if (verbose) {
 			printf("\t\t\tmax_msg_sz:\t\t0x%x\n", port_attr.max_msg_sz);
diff --git a/examples/rc_pingpong.c b/examples/rc_pingpong.c
index e0cde29..4d0bd0d 100644
--- a/examples/rc_pingpong.c
+++ b/examples/rc_pingpong.c
@@ -653,7 +653,7 @@ int main(int argc, char *argv[])
 	}
 
 	my_dest.lid = ctx->portinfo.lid;
-	if (ctx->portinfo.transport == RDMA_TRANSPORT_RDMAOE) {
+	if (ctx->portinfo.link_layer == IBV_LINK_LAYER_ETHERNET) {
 		if (!grh) {
 			fprintf(stderr, "Must supply remote gid\n");
 			return 1;
diff --git a/examples/srq_pingpong.c b/examples/srq_pingpong.c
index bd10f90..eda9013 100644
--- a/examples/srq_pingpong.c
+++ b/examples/srq_pingpong.c
@@ -744,7 +744,7 @@ int main(int argc, char *argv[])
 	for (i = 0; i < num_qp; ++i) {
 		my_dest[i].qpn = ctx->qp[i]->qp_num;
 		my_dest[i].psn = lrand48() & 0xffffff;
-		if (ctx->portinfo.transport == RDMA_TRANSPORT_RDMAOE) {
+		if (ctx->portinfo.link_layer == IBV_LINK_LAYER_ETHERNET) {
 			if (!grh) {
 				fprintf(stderr, "Must supply remote gid\n");
 				return 1;
diff --git a/examples/uc_pingpong.c b/examples/uc_pingpong.c
index 6cfffd2..2bc7da5 100644
--- a/examples/uc_pingpong.c
+++ b/examples/uc_pingpong.c
@@ -641,7 +641,7 @@ int main(int argc, char *argv[])
 	}
 
 	my_dest.lid = ctx->portinfo.lid;
-	if (ctx->portinfo.transport == RDMA_TRANSPORT_RDMAOE) {
+	if (ctx->portinfo.link_layer == IBV_LINK_LAYER_ETHERNET) {
 		if (!grh) {
 			fprintf(stderr, "Must supply remote gid\n");
 			return 1;
diff --git a/examples/ud_pingpong.c b/examples/ud_pingpong.c
index 33601a3..e30d6d6 100644
--- a/examples/ud_pingpong.c
+++ b/examples/ud_pingpong.c
@@ -641,7 +641,7 @@ int main(int argc, char *argv[])
 
 	my_dest.qpn = ctx->qp->qp_num;
 	my_dest.psn = lrand48() & 0xffffff;
-	if (ctx->portinfo.transport == RDMA_TRANSPORT_IB) {
+	if (ctx->portinfo.link_layer == IBV_LINK_LAYER_ETHERNET) {
 		if (!my_dest.lid) {
 			fprintf(stderr, "Couldn't get local LID\n");
 			return 1;
diff --git a/include/infiniband/kern-abi.h b/include/infiniband/kern-abi.h
index f5879db..8ef8844 100644
--- a/include/infiniband/kern-abi.h
+++ b/include/infiniband/kern-abi.h
@@ -224,7 +224,7 @@ struct ibv_query_port_resp {
 	__u8  active_width;
 	__u8  active_speed;
 	__u8  phys_state;
-	__u8  transport;
+	__u8  link_layer;
 	__u8  reserved[2];
 };
 
diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index f7fe68d..aea25fa 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -38,6 +38,7 @@
 
 #include <stdint.h>
 #include <pthread.h>
+#include <string.h>
 
 #ifdef __cplusplus
 #  define BEGIN_C_DECLS extern "C" {
@@ -162,14 +163,10 @@ enum ibv_port_state {
 	IBV_PORT_ACTIVE_DEFER	= 5
 };
 
-enum rdma_transport_type {
-	RDMA_TRANSPORT_IB,
-	RDMA_TRANSPORT_IWARP,
-	RDMA_TRANSPORT_RDMAOE
-};
-enum ibv_port_link_type {
-	PORT_LINK_IB,
-	PORT_LINK_ETH
+enum {
+	IBV_LINK_LAYER_UNSPECIFIED,
+	IBV_LINK_LAYER_INFINIBAND,
+	IBV_LINK_LAYER_ETHERNET,
 };
 
 struct ibv_port_attr {
@@ -192,7 +189,7 @@ struct ibv_port_attr {
 	uint8_t			active_width;
 	uint8_t			active_speed;
 	uint8_t			phys_state;
-	uint8_t			transport;
+	uint8_t			link_layer;
 };
 
 enum ibv_event_type {
@@ -705,6 +702,21 @@ struct ibv_context {
 	void		       *abi_compat;
 };
 
+static inline int ___ibv_query_port(struct ibv_context *context,
+				    uint8_t port_num,
+				    struct ibv_port_attr *port_attr)
+{
+	uint8_t *padp;
+	int padsize;
+
+	port_attr->link_layer = IBV_LINK_LAYER_UNSPECIFIED;
+	padp = &port_attr->link_layer + sizeof port_attr->link_layer;
+	padsize = sizeof(int) - ((unsigned long)padp & (sizeof(int) - 1));
+	memset(padp, 0, padsize);
+
+	return context->ops.query_port(context, port_num, port_attr);
+}
+
 /**
  * ibv_get_device_list - Get list of IB devices currently available
  * @num_devices: optional.  if non-NULL, set to the number of devices
@@ -1109,4 +1121,7 @@ END_C_DECLS
 
 #  undef __attribute_const
 
+#define ibv_query_port(context, port_num, port_attr) \
+	___ibv_query_port(context, port_num, port_attr)
+
 #endif /* INFINIBAND_VERBS_H */
diff --git a/src/cmd.c b/src/cmd.c
index 2a36d91..5183d59 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -197,7 +197,7 @@ int ibv_cmd_query_port(struct ibv_context *context, uint8_t port_num,
 	port_attr->active_width    = resp.active_width;
 	port_attr->active_speed    = resp.active_speed;
 	port_attr->phys_state      = resp.phys_state;
-	port_attr->transport       = resp.transport;
+	port_attr->link_layer      = resp.link_layer;
 
 	return 0;
 }
diff --git a/src/verbs.c b/src/verbs.c
index ba3c0a4..2b175b6 100644
--- a/src/verbs.c
+++ b/src/verbs.c
@@ -86,6 +86,7 @@ default_symver(__ibv_query_device, ibv_query_device);
 int __ibv_query_port(struct ibv_context *context, uint8_t port_num,
 		     struct ibv_port_attr *port_attr)
 {
+	port_attr->link_layer = IBV_LINK_LAYER_UNSPECIFIED;
 	return context->ops.query_port(context, port_num, port_attr);
 }
 default_symver(__ibv_query_port, ibv_query_port);
-- 
1.6.5.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

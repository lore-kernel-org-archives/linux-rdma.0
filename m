From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 1/7] libibverbs: Add link layer field port attribute
Date: Wed, 20 Jul 2011 22:37:24 +0300
Message-ID: <alpine.LRH.2.00.1107202235510.12424@ogerlitz.voltaire.com>
References: <alpine.LRH.2.00.1107191223460.5580@ogerlitz.voltaire.com> <alpine.LRH.2.00.1107191226210.5580@ogerlitz.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LRH.2.00.1107191226210.5580-VYr5/9ddeaGSIdy2EShu12Xnswh1EIUO@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The new field has one of three values - IBV_LINK_LAYER_UNSPECIFIED,
IBV_LINK_LAYER_INFINIBAND, IBV_LINK_LAYER_ETHERNET. It can be used
by applications to know the link layer used by the port, which
can be either Infiniband or Ethernet.

The addition of the new field does not change the size of struct
ibv_port_attr due to alignment of the preceding fields. As such
binary compatibility between the library to applications is kept,
since old apps running over new library do not read this field,
and new apps running over old library will determine the link
layer as unspecified and hence take their IB code path.

The solution was suggested by: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
and Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
changes from V0:

- applied feedback from Jason, made the ___ibv_query_port trick
  clearer to header file readers

 include/infiniband/verbs.h |   23 +++++++++++++++++++++++
 man/ibv_query_port.3       |    4 ++++
 2 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index 0f1cb2e..d1a3e47 100644
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
@@ -767,6 +775,20 @@ int ibv_query_device(struct ibv_context *context,
 int ibv_query_port(struct ibv_context *context, uint8_t port_num,
 		   struct ibv_port_attr *port_attr);

+static inline int ___ibv_query_port(struct ibv_context *context,
+				    uint8_t port_num,
+				    struct ibv_port_attr *port_attr)
+{
+	/* For compatability linking with old libibverbs */
+	port_attr->link_layer = IBV_LINK_LAYER_UNSPECIFIED;
+	port_attr->pad = 0;
+
+	return ibv_query_port(context, port_num, port_attr);
+}
+
+#define ibv_query_port(context, port_num, port_attr) \
+	___ibv_query_port(context, port_num, port_attr)
+
 /**
  * ibv_query_gid - Get a GID table entry
  */
@@ -1097,4 +1119,5 @@ END_C_DECLS

 #  undef __attribute_const

+
 #endif /* INFINIBAND_VERBS_H */
diff --git a/man/ibv_query_port.3 b/man/ibv_query_port.3
index 882470d..9bedd90 100644
--- a/man/ibv_query_port.3
+++ b/man/ibv_query_port.3
@@ -44,9 +44,13 @@ uint8_t                 init_type_reply;/* Type of initialization performed by S
 uint8_t                 active_width;   /* Currently active link width */
 uint8_t                 active_speed;   /* Currently active link speed */
 uint8_t                 phys_state;     /* Physical port state */
+uint8_t                 link_layer;     /* link layer protocol of the port */
 .in -8
 };
 .sp
+possible values for the link layer field are IBV_LINK_LAYER_INFINIBAND,
+IBV_LINK_LAYER_ETHERNET, or IBV_LINK_LAYER_UNSPECIFIED.
+.sp
 .fi
 .SH "RETURN VALUE"
 .B ibv_query_port()
-- 
1.5.5


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

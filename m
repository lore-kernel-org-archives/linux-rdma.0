From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libibverbs] Align Flow Steering API to the extension verbs scheme
Date: Wed, 14 May 2014 16:44:50 +0300
Message-ID: <1400075090-14296-2-git-send-email-ogerlitz@mellanox.com>
References: <1400075090-14296-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1400075090-14296-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The receive flow steering API didn't conform with the extension
verbs:
1. It introduced VERBS_CONTEXT_CREATE_FLOW and
   VERBS_CONTEXT_DESTROY_FLOW, even though the structures
   aren't allocated by the provider.
2. It introduces drv_ functions, which was dropped in one
   of the design phases of the extension verbs.

This patch fixes the above. It replaces VERBS_CONTEXT_CREATE_FLOW
and VERBS_CONTEXT_DESTROY_FLOW with VERBS_CONTEXT_RESERVED[12] and
replaces the drv_function with a reserved stub.

Also add man page for the two new verbs

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 Makefile.am                |    6 ++-
 include/infiniband/verbs.h |   29 +++++++--------
 man/ibv_create_flow.3      |   86 ++++++++++++++++++++++++++++++++++++++++++++
 src/device.c               |    4 --
 4 files changed, 103 insertions(+), 22 deletions(-)
 create mode 100644 man/ibv_create_flow.3

diff --git a/Makefile.am b/Makefile.am
index a6767de..3a40f3e 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -58,7 +58,7 @@ man_MANS = man/ibv_asyncwatch.1 man/ibv_devices.1 man/ibv_devinfo.1	\
     man/ibv_query_srq.3 man/ibv_rate_to_mult.3 man/ibv_reg_mr.3		\
     man/ibv_req_notify_cq.3 man/ibv_resize_cq.3 man/ibv_rate_to_mbps.3  \
     man/ibv_create_qp_ex.3 man/ibv_create_srq_ex.3 man/ibv_open_xrcd.3  \
-    man/ibv_get_srq_num.3 man/ibv_open_qp.3
+    man/ibv_get_srq_num.3 man/ibv_open_qp.3 man/ibv_create_flow.3
 
 DEBIAN = debian/changelog debian/compat debian/control debian/copyright \
     debian/ibverbs-utils.install debian/libibverbs1.install \
@@ -94,6 +94,7 @@ install-data-hook:
 	$(RM) ibv_port_state_str.3 && \
 	$(RM) mbps_to_ibv_rate.3 && \
 	$(RM) ibv_close_xrcd.3 && \
+	$(RM) ibv_destroy_flow.3 && \
 	$(LN_S) ibv_get_async_event.3 ibv_ack_async_event.3 && \
 	$(LN_S) ibv_get_cq_event.3 ibv_ack_cq_events.3 && \
 	$(LN_S) ibv_open_device.3 ibv_close_device.3 && \
@@ -111,4 +112,5 @@ install-data-hook:
 	$(LN_S) ibv_event_type_str.3 ibv_node_type_str.3 && \
 	$(LN_S) ibv_event_type_str.3 ibv_port_state_str.3 && \
 	$(LN_S) ibv_rate_to_mbps.3 mbps_to_ibv_rate.3 && \
-	$(LN_S) ibv_open_xrcd.3 ibv_close_xrcd.3
+	$(LN_S) ibv_open_xrcd.3 ibv_close_xrcd.3 && \
+	$(LN_S) ibv_create_flow.3 ibv_destroy_flow.3
diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index cfa1156..57a05fb 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -944,21 +944,18 @@ enum verbs_context_mask {
 	VERBS_CONTEXT_XRCD	= 1 << 0,
 	VERBS_CONTEXT_SRQ	= 1 << 1,
 	VERBS_CONTEXT_QP	= 1 << 2,
-	VERBS_CONTEXT_CREATE_FLOW = 1 << 3,
-	VERBS_CONTEXT_DESTROY_FLOW = 1 << 4,
+	VERBS_CONTEXT_RESERVED1 = 1 << 3,
+	VERBS_CONTEXT_RESERVED2 = 1 << 4,
 	VERBS_CONTEXT_RESERVED	= 1 << 5
 };
 
 struct verbs_context {
 	/*  "grows up" - new fields go here */
-	int (*drv_ibv_destroy_flow) (struct ibv_flow *flow);
-	int (*lib_ibv_destroy_flow) (struct ibv_flow *flow);
-	struct ibv_flow * (*drv_ibv_create_flow) (struct ibv_qp *qp,
-						  struct ibv_flow_attr
-						  *flow_attr);
-	struct ibv_flow * (*lib_ibv_create_flow) (struct ibv_qp *qp,
-						  struct ibv_flow_attr
-						  *flow_attr);
+	void (*_reserved_2)(void);
+	int (*destroy_flow)(struct ibv_flow *flow);
+	void (*_reserved_1)(void);
+	struct ibv_flow * (*create_flow)(struct ibv_qp *qp,
+					 struct ibv_flow_attr *flow_attr);
 	struct ibv_qp *(*open_qp)(struct ibv_context *context,
 			struct ibv_qp_open_attr *attr);
 	struct ibv_qp *(*create_qp_ex)(struct ibv_context *context,
@@ -1111,20 +1108,20 @@ static inline struct ibv_flow *ibv_create_flow(struct ibv_qp *qp,
 					       struct ibv_flow_attr *flow)
 {
 	struct verbs_context *vctx = verbs_get_ctx_op(qp->context,
-						      lib_ibv_create_flow);
-	if (!vctx || !vctx->lib_ibv_create_flow)
+						      create_flow);
+	if (!vctx)
 		return NULL;
 
-	return vctx->lib_ibv_create_flow(qp, flow);
+	return vctx->create_flow(qp, flow);
 }
 
 static inline int ibv_destroy_flow(struct ibv_flow *flow_id)
 {
 	struct verbs_context *vctx = verbs_get_ctx_op(flow_id->context,
-						      lib_ibv_destroy_flow);
-	if (!vctx || !vctx->lib_ibv_destroy_flow)
+						      destroy_flow);
+	if (!vctx)
 		return -ENOSYS;
-	return vctx->lib_ibv_destroy_flow(flow_id);
+	return vctx->destroy_flow(flow_id);
 }
 
 /**
diff --git a/man/ibv_create_flow.3 b/man/ibv_create_flow.3
new file mode 100644
index 0000000..f7c767e
--- /dev/null
+++ b/man/ibv_create_flow.3
@@ -0,0 +1,86 @@
+.TH IBV_CREATE_FLOW 3 2013-08-21 libibverbs "Libibverbs Programmer's Manual"
+.SH "NAME"
+ibv_create_flow, ibv_destroy_flow \- create or destroy flow steering rules
+.SH "SYNOPSIS"
+.nf
+.B #include <infiniband/verbs.h>
+.sp
+.BI "struct ibv_flow *ibv_create_flow(struct ibv_qp " "*qp" ,
+.BI "                                 struct ibv_flow_attr " "*flow");
+.BI "int ibv_destroy_flow(struct ibv_flow " "*flow_id");
+.sp
+.fi
+.SH "DESCRIPTION"
+.SS ibv_create_flow()
+allows a user application QP
+.I qp
+to be attached into a specified flow
+.I flow
+which is defined in
+.I <infiniband/verbs.h>
+.PP
+.nf
+struct ibv_flow_attr {
+.in +8
+uint32_t comp_mask;						/* Future extendibility */
+enum ibv_flow_attr_type type;				/* Rule type - see below */
+uint16_t size;							/* Size of command */
+uint16_t priority;						/* Rule priority - See below */
+uint8_t num_of_specs;					/* Number of ibv_flow_spec_xxx */
+uint8_t port;							/* The uplink port number */
+uint32_t flags;						/* Extra flags for rule - see below */
+/* Following are the optional layers according to user request
+ * struct ibv_flow_spec_xxx
+ * struct ibv_flow_spec_yyy
+ */
+.in -8
+};
+.sp
+.nf
+enum ibv_flow_attr_type {
+.in +8
+IBV_FLOW_ATTR_NORMAL		= 0x0,		/* steering according to rule specifications */
+IBV_FLOW_ATTR_ALL_DEFAULT	= 0x1,		/* default unicast and multicast rule - receive all Eth traffic which isn't steered to any QP */
+IBV_FLOW_ATTR_MC_DEFAULT		= 0x2,		/* default multicast rule - receive all Eth multicast traffic which isn't steered to any QP */
+.in -8
+};
+.sp
+.nf
+enum ibv_flow_flags {
+.in +8
+IBV_FLOW_ATTR_FLAGS_ALLOW_LOOP_BACK = 1,	/* Apply the rules on packets that were sent from the attached QP through loopback. IB only.*/
+.in -8
+};
+.fi
+.PP
+Each header struct holds the relevant network layer parameters for matching.To enforce the match, the
+user sets a mask for each parameter. If the bit is set in the mask, the corresponding bit in the value should be matched.
+.br
+Note that most vendors support either full mask (all "1"s) or zero mask (all "0"s).
+.br
+.B Network paramters in the relevant network structs should be given in network order (big endian).
+
+.SS Flow domains and priority
+Flow steering defines the concept of domain and priority. Each domain represents a user agent that can attach a flow. The domains are prioritized. A higher priority domain will always supersede a lower priority domain when their flow specifications overlap. In addition to the domain, there is priority within each of the domains. Each domain has at most 2^12 priorities. A lower priority numeric value (higher priority) takes precedence over matching rules with higher numeric priority value (lower priority). It is important to note that the priority value of a flow spec is used not only to establish the precedence of conflicting flow matches but also as a way to abstract the order on which flow specs are tested for matches. Flows with higher priorities will be tested before flows with lower 
 priorities.
+.br
+.B IB verbs have the higher priority domain.
+.PP
+.SS ibv_destroy_flow()
+destroys the flow
+.I flow_id\fR.
+.SH "RETURN VALUE"
+.B ibv_create_flow()
+returns a pointer to the flow, or NULL if the request fails.
+.PP
+.B ibv_destroy_flow()
+returns 0 on success, or the value of errno on failure (which indicates the failure reason).
+.SH "NOTES"
+These verbs are available only for devices supporting IBV_DEVICE_MANAGED_FLOW_STEERING and
+only for QPs of Transport Service Type
+.BR IBV_QPT_UD
+or
+.BR IBV_QPT_RAW_PACKET
+.PP
+.SH "AUTHORS"
+.TP
+Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>         Hadar Hen Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
diff --git a/src/device.c b/src/device.c
index 9642ead..beb7b3c 100644
--- a/src/device.c
+++ b/src/device.c
@@ -169,10 +169,6 @@ struct ibv_context *__ibv_open_device(struct ibv_device *device)
 		 * context_ex->lib_new_func1 = __verbs_new_func1;
 		 * context_ex->lib_new_func2 = __verbs_new_func2;
 		 */
-		 context_ex->lib_ibv_create_flow =
-			 context_ex->drv_ibv_create_flow;
-		 context_ex->lib_ibv_destroy_flow =
-			 context_ex->drv_ibv_destroy_flow;
 	}
 
 	context->device = device;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

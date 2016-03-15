From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libibverbs 2/2] Add man page for flow steering verbs
Date: Tue, 15 Mar 2016 19:03:56 +0200
Message-ID: <1458061436-15911-3-git-send-email-yishaih@mellanox.com>
References: <1458061436-15911-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1458061436-15911-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, marinav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add man page for ibv_create_flow/ibv_destroy_flow verbs, it includes
the new dont_trap flag.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Marina Varshaver <marinav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 Makefile.am           |   6 ++-
 man/ibv_create_flow.3 | 112 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 116 insertions(+), 2 deletions(-)
 create mode 100644 man/ibv_create_flow.3

diff --git a/Makefile.am b/Makefile.am
index eefda4a..7296c46 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -53,7 +53,7 @@ man_MANS = man/ibv_asyncwatch.1 man/ibv_devices.1 man/ibv_devinfo.1	\
     man/ibv_create_ah.3 man/ibv_create_ah_from_wc.3			\
     man/ibv_create_comp_channel.3 man/ibv_create_cq.3			\
     man/ibv_create_qp.3 man/ibv_create_srq.3 man/ibv_event_type_str.3	\
-    man/ibv_fork_init.3 man/ibv_get_async_event.3			\
+    man/ibv_fork_init.3 man/ibv_get_async_event.3 man/ibv_create_flow.3 \
     man/ibv_get_cq_event.3 man/ibv_get_device_guid.3			\
     man/ibv_get_device_list.3 man/ibv_get_device_name.3			\
     man/ibv_modify_qp.3 man/ibv_modify_srq.3 man/ibv_open_device.3	\
@@ -101,6 +101,7 @@ install-data-hook:
 	$(RM) mbps_to_ibv_rate.3 && \
 	$(RM) ibv_close_xrcd.3 && \
 	$(RM) ibv_dealloc_mw.3 && \
+	$(RM) ibv_destroy_flow.3 && \
 	$(LN_S) ibv_get_async_event.3 ibv_ack_async_event.3 && \
 	$(LN_S) ibv_get_cq_event.3 ibv_ack_cq_events.3 && \
 	$(LN_S) ibv_open_device.3 ibv_close_device.3 && \
@@ -119,4 +120,5 @@ install-data-hook:
 	$(LN_S) ibv_event_type_str.3 ibv_port_state_str.3 && \
 	$(LN_S) ibv_rate_to_mbps.3 mbps_to_ibv_rate.3 && \
 	$(LN_S) ibv_open_xrcd.3 ibv_close_xrcd.3 && \
-	$(LN_S) ibv_alloc_mw.3 ibv_dealloc_mw.3
+	$(LN_S) ibv_alloc_mw.3 ibv_dealloc_mw.3 && \
+	$(LN_S) ibv_create_flow.3 ibv_destroy_flow.3
diff --git a/man/ibv_create_flow.3 b/man/ibv_create_flow.3
new file mode 100644
index 0000000..4ba6ee7
--- /dev/null
+++ b/man/ibv_create_flow.3
@@ -0,0 +1,112 @@
+.TH IBV_CREATE_FLOW 3 2016-03-15 libibverbs "Libibverbs Programmer's Manual"
+.SH "NAME"
+ibv_create_flow, ibv_destroy_flow \- create or destroy flow steering rules
+.SH "SYNOPSIS"
+.nf
+.B #include <infiniband/verbs.h>
+.sp
+.BI "struct ibv_flow *ibv_create_flow(struct ibv_qp " "*qp" ,
+.BI "                                 struct ibv_flow_attr " "*flow_attr");
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
+uint32_t comp_mask;                     /* Future extendibility */
+enum ibv_flow_attr_type type;           /* Rule type - see below */
+uint16_t size;                          /* Size of command */
+uint16_t priority;                      /* Rule priority - see below */
+uint8_t num_of_specs;                   /* Number of ibv_flow_spec_xxx */
+uint8_t port;                           /* The uplink port number */
+uint32_t flags;                         /* Extra flags for rule - see below */
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
+IBV_FLOW_ATTR_NORMAL		= 0x0,		/* Steering according to rule specifications */
+IBV_FLOW_ATTR_ALL_DEFAULT	= 0x1,		/* Default unicast and multicast rule - receive all Eth traffic which isn't steered to any QP */
+IBV_FLOW_ATTR_MC_DEFAULT 	= 0x2,		/* Default multicast rule - receive all Eth multicast traffic which isn't steered to any QP */
+.in -8
+};
+.sp
+.nf
+enum ibv_flow_flags {
+.in +8
+IBV_FLOW_ATTR_FLAGS_ALLOW_LOOP_BACK = 1 << 0,	/* Apply the rules on packets that were sent from the attached QP through loopback */
+IBV_FLOW_ATTR_FLAGS_DONT_TRAP       = 1 << 1,	/* Rule doesn't trap received packets, allowing them to match lower prioritized rules */
+.in -8
+};
+.fi
+.PP
+Each spec struct holds the relevant network layer parameters for matching. To enforce the match, the user sets a mask for each parameter.
+.br
+If the bit is set in the mask, the corresponding bit in the value should be matched.
+.br
+Note that most vendors support either full mask (all "1"s) or zero mask (all "0"s).
+.br
+.B Network parameters in the relevant network structs should be given in network order (big endian).
+
+.SS Flow domains and priority
+Flow steering defines the concept of domain and priority. Each domain represents an application that can attach a flow.
+Domains are prioritized. A higher priority domain will always supersede a lower priority domain when their flow specifications overlap.
+.br
+.B IB verbs have the higher priority domain.
+.br
+In addition to the domain, there is priority within each of the domains.
+A lower priority numeric value (higher priority) takes precedence over matching rules with higher numeric priority value (lower priority).
+It is important to note that the priority value of a flow spec is used not only to establish the precedence of conflicting flow matches
+but also as a way to abstract the order on which flow specs are tested for matches. Flows with higher priorities will be tested before flows with lower priorities.
+.PP
+.SS ibv_destroy_flow()
+destroys the flow
+.I flow_id\fR.
+.SH "RETURN VALUE"
+.B ibv_create_flow()
+returns a pointer to the flow, or NULL if the request fails. In case of an error, errno is updated.
+.PP
+.B ibv_destroy_flow()
+returns 0 on success, or the value of errno on failure (which indicates the failure reason).
+.SH "ERRORS"
+.SS EINVAL
+.B ibv_create_flow()
+flow specification, QP or priority are invalid
+.PP
+.B ibv_destroy_flow()
+flow_id is invalid
+.SS ENOMEM
+Couldn't create/destroy flow, not enough memory
+.SS ENXIO
+Device managed flow steering isn't currently supported
+.SS EPERM
+No permissions to add the flow steering rule
+.SH "NOTES"
+These verbs are available only for devices supporting
+.br
+IBV_DEVICE_MANAGED_FLOW_STEERING and only for QPs of Transport Service Type
+.BR IBV_QPT_UD
+or
+.BR IBV_QPT_RAW_PACKET
+.PP
+.SH "AUTHORS"
+.TP
+Hadar Hen Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
+.TP
+Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
+.TP
+Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

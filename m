From: Alex Rosenbaum <rosenbaumalex-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH RFC v2] Introduce verbs API for traffic and event counters
Date: Wed, 27 Dec 2017 17:46:53 +0200
Message-ID: <CAFgAxU8j9xFR8uM3fg-nov9Ut3AGN6TP685Chy4BDWBUp4qVAA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Raed Salem <raeds-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Alex @ Mellanox" <alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This API allows applications to monitor real time traffic activity and
events of the verbs objects it manages, e.g.: ibv_qp, ibv_wq, ibv_flow

With this API, an application can read counters and monitoring the entire
life cycle of object activity, defined here as a static counter attachment.
This API also allows dynamic counters monitoring of measurement points
for a partial period in the verbs object life cycle.

The API includes:
1. create and destroyed API of a new ibv_coutners objects
2. attaching and detaching API to allow application to define the
ibv_counters measurement points per objects
3. read the ibv_coutners values from HW

This RFC patch includes man pages and verbs.h API.
The man pages include an example application.

Signed-off-by: Alex Rosenbaum <alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibverbs/man/ibv_attach_counters_point_qp.3 | 148 +++++++++++++++++
 libibverbs/man/ibv_create_counters.3          | 100 +++++++++++
 libibverbs/man/ibv_create_flow.3              |   3 +
 libibverbs/man/ibv_create_qp_ex.3             |   4 +-
 libibverbs/man/ibv_create_wq.3                |   4 +-
 libibverbs/man/ibv_read_counters.3            | 229 ++++++++++++++++++++++++++
 libibverbs/verbs.h                            |  62 ++++++-
 7 files changed, 546 insertions(+), 4 deletions(-)
 create mode 100644 libibverbs/man/ibv_attach_counters_point_qp.3
 create mode 100644 libibverbs/man/ibv_create_counters.3
 create mode 100644 libibverbs/man/ibv_read_counters.3

diff --git a/libibverbs/man/ibv_attach_counters_point_qp.3
b/libibverbs/man/ibv_attach_counters_point_qp.3
new file mode 100644
index 0000000..4319fe6
--- /dev/null
+++ b/libibverbs/man/ibv_attach_counters_point_qp.3
@@ -0,0 +1,148 @@
+.\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See
COPYING.md
+.\"
+.TH IBV_ATTACH_COUNTERS_POINT 3 2017-11-06 libibverbs "Libibverbs
Programmer's Manual"
+.SH "NAME"
+ibv_attach_counters_point \- attach individual counter definition
and/or attached them to a verbs object
+.sp
+ibv_detach_counters_point \- detach individual counter definition
+.SH "SYNOPSIS"
+.nf
+.B #include <infiniband/verbs.h>
+.sp
+.BI "int ibv_attach_counters_point_qp(struct ibv_counters "
"*counters" ", struct ibv_counter_attach_attr " "*counter_attach_attr"
", struct ibv_qp " "*qp");
+.sp
+.BI "int ibv_attach_counters_point_wq(struct ibv_counters "
"*counters" ", struct ibv_counter_attach_attr " "*counter_attach_attr"
", struct ibv_wq " "*wp");
+.sp
+.BI "int ibv_attach_counters_point_flow(struct ibv_counters "
"*counters" ", struct ibv_counter_attach_attr " "*counter_attach_attr"
", struct ibv_flow " "*flow");
+.sp
+.BI "int ibv_detach_counters_point(struct ibv_counters " "*counters"
", int " "index");
+.fi
+.SH "DESCRIPTION"
+Attach counters point family of API's will start collecting values of
counter type
+.I counter_type\fR,
+which are reported from the relevant verbs object, into location
+.I index
+in the
+.I counters
+object. Each counters
+.I index
+location is a monotonically increasing value.
+.sp
+The argument
+.I counter_attach_attr
+is an ibv_counter_attach_attr struct, as defined in verbs.h:
+.sp
+.PP
+.nf
+struct ibv_counter_attach_attr {
+.in +8
+enum ibv_counter_type counter_type;
+int index;
+int comp_mask;
+.in -8
+};
+.fi
+.PP
+.sp
+.B ibv_attach_counters_point_qp()
+will start collecting values which are reported from the
+.I qp\fR.
+This allows dynamic attaching and detaching of counters measurement
points. See the specific attach counters point API's for: WQ and flow.
+.sp
+A static attach can be created when NULL is provided instead of the
referance to the verbs object (e.g.: NULL instead of
+.I qp\fR,
+.I wq\fR
+or
+.I flow\fR).
+In this case, this
+.I counters
+object will only start collecting values after it is bound to the
verbs resource. For QP, this is when referencing the
+.I counters
+handle when creating a QP with
+.B ibv_create_qp_ex()\fR.
+Similarly, when referencing the
+.I counters
+handle when calling verbs create and/or modify API's for: WQ and flow.
+Once an ibv_counters is bound statically to a verbs resource, no additional
+.I counter_type
+can be attached or index's detached from it until it is unbound from
all verbs resource.
+.sp
+The argument
+.I counter_type
+specifies which counter value should be collected. It is defined in
verbs.h as one of the enum
+.I ibv_counter_type
+options. Additional
+.I counter_type
+values can be found for each specific provider header file.
+.sp
+Supported capabilties of specific
+.I counter_type\fR's
+values per verbs object can be tested by checking the return value
for success or ENOSUP errno.
+.sp
+Attaching a
+.I counters
+hanlde to multiple objects of the same type will accumulate the
values into a single index. e.g.: creating several ibv_flow's with the
same ibv_counters handle will collect the values from all relevant
flows into the relevant
+.I index
+locaiton when reading the values from
+.B ibv_read_counters()\fR.
+.sp
+The runtime values of
+.I counters
+can be read from the hardware by calling
+.B ibv_read_counters()\fR.
+.sp
+.B ibv_detach_counters_point()
+on a dynamically attached ibv_counters will detaches the location
+.I index
+of the
+.I counters
+object from the respectful verbs object.
+.sp
+Detaching a counters point clears the value reported, the counter_type in that
+.I index
+location.
+.SH "RETURN VALUE"
+.B ibv_attach_counters_point_qp()\fR,
+.B ibv_attach_counters_point_wq()\fR,
+.B ibv_attach_counters_point_flow()\fR,
+and
+.B ibv_detach_counters_point()
+returns 0 on success, or the value of errno on failure (which
indicates the failure reason).
+.SH "ERRORS"
+.SS EINVAL
+counters is invalid
+.SS ENOSUP
+counter_type is not supported on the requested object
+.SS ENOMEM
+Couldn't attach counters point to
+.I counters
+at location
+.I index\fR,
+not enough memory
+.SH "NOTES"
+Counter values in each
+.I index
+location are cleared upon creation when calling
+.B ibv_create_counters()\fR.
+Attaching and detaching counters points will only increase these
value accordingly.
+.sp
+.B ibv_destroy_counters()
+can be called to release all
+.I counters
+indexes at once instead of iterating with
+.B ibv_detach_counters_point()\fR.
+.SH EXAMPLE
+An example of the use of
+.I ibv_counters
+is shown in
+.BR ibv_read_counters (3).
+.SH "SEE ALSO"
+.BR ibv_create_counters (3),
+.BR ibv_destroy_counters (3),
+.BR ibv_read_counters (3),
+.BR ibv_create_flow (3),
+.BR ibv_create_qp_ex (3),
+.SH "AUTHORS"
+.TP
+Alex Rosenbaum <alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
diff --git a/libibverbs/man/ibv_create_counters.3
b/libibverbs/man/ibv_create_counters.3
new file mode 100644
index 0000000..de432d7
--- /dev/null
+++ b/libibverbs/man/ibv_create_counters.3
@@ -0,0 +1,100 @@
+.\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See
COPYING.md
+.\"
+.TH IBV_CREATE_COUNTERS 3 2017-11-06 libibverbs "Libibverbs
Programmer's Manual"
+.SH "NAME"
+ibv_create_counters, ibv_destroy_counters \- create or destroy a
counters handle
+.SH "SYNOPSIS"
+.nf
+.B #include <infiniband/verbs.h>
+.sp
+.BI "struct ibv_counters *ibv_create_counters(struct ibv_context "
"*context" ", struct ibv_counter_init_attr " "*counter_init_attr");
+.sp
+.BI "int ibv_destroy_counters(struct ibv_counters " "*counters");
+.fi
+.SH "DESCRIPTION"
+.B ibv_create_counters()
+creates a new counters handle for the RDMA device context
+.I context\fR.
+.sp
+The argument
+.I counter_init_attr
+is an ibv_counter_init_attr struct, as defined in verbs.h:
+.sp
+.PP
+.nf
+struct ibv_counter_init_attr {
+.in +8
+int comp_mask;
+.in -8
+};
+.fi
+.PP
+.sp
+
+.sp
+An
+.I ibv_counters
+handle can be attached to a verbs resource (e.g.: QP, WQ, flow)
statically when these are created, or it can be attached and detached
dynamically to a verbs resource during the active life cycle of that
object.
+.sp
+Attach an
+.I ibv_counters
+statically to a QP  (
+.I struct ibv_qp\fR)
+during creation of a new QP by calling
+.B ibv_create_qp_ex()\fR.
+Similarly, there are verbs to create and/or modify API's for: WQ and flow.
+.sp
+Alternatively, the
+.I ibv_counters
+handle can be attached dynamically with a valid QP
+via the
+.B ibv_attach_counters_point_qp()\fR,
+or attached to a valid WQ with
+.B ibv_attach_counters_point_wq()\fR,
+or attached to a valid flow with
+.B ibv_attach_counters_point_flow()\fR.
+These can be dynamically detached with
+.B ibv_detach_counters_point()\fR.
+.sp
+Counters are cleared upon creation and values will be monotonically increasing.
+.sp
+.B ibv_destroy_counters()
+releases the counters handle
+.I counters\fR.
+User should detach all
+.I index\fR's
+before destorying this counter.
+.SH "RETURN VALUE"
+.B ibv_create_counters()
+returns a pointer to the allocated ibv_counters object, or NULL if
the request fails (and sets errno to indicates the failure reason).
+.sp
+.B ibv_destroy_counters()
+returns 0 on success, or the value of errno on failure (which
indicates the failure reason).
+.SH "ERRORS"
+.SS ENXIO
+.B ibv_create_counters()
+isn't currently supported on this device
+.SS ENOMEM
+.B ibv_create_counters()
+couldn't create ibv_counters object, not enough memory
+.SS EINVAL
+.B ibv_destroy_counters()
+counters is invalid
+.SH EXAMPLE
+An example of the use of
+.I ibv_counters
+is shown in
+.BR ibv_read_counters (3).
+.SH "SEE ALSO"
+.BR ibv_attach_counters_point_qp (3),
+.BR ibv_attach_counters_point_wq (3),
+.BR ibv_attach_counters_point_flow (3),
+.sp
+.BR ibv_detach_counters_point (3),
+.BR ibv_read_counters (3),
+.BR ibv_create_flow (3),
+.BR ibv_create_qp_ex (3),
+.SH "AUTHORS"
+.TP
+Alex Rosenbaum <alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
diff --git a/libibverbs/man/ibv_create_flow.3 b/libibverbs/man/ibv_create_flow.3
index 48bbb14..97ab6ca 100644
--- a/libibverbs/man/ibv_create_flow.3
+++ b/libibverbs/man/ibv_create_flow.3
@@ -70,6 +70,7 @@ IBV_FLOW_SPEC_VXLAN_TUNNEL              = 0x50,   /*
Flow specification of VXLAN
 IBV_FLOW_SPEC_INNER                    = 0x100,  /* Flag making
L2/L3/L4 specifications to be applied on the inner header */
 IBV_FLOW_SPEC_ACTION_TAG                = 0x1000, /* Action tagging
matched packet */
 IBV_FLOW_SPEC_ACTION_DROP               = 0x1001, /* Action dropping
matched packet */
+IBV_FLOW_SPEC_ACTION_COUNT              = 0x1002, /* Action count
matched packet with a ibv_counters handle */
 .in -8
 };
 .br
@@ -205,6 +206,8 @@ struct raw_eth_flow_attr flow_attr = {
 };
 .sp
 .nf
+.SH "SEE ALSO"
+.BR ibv_create_counters (3)
 .SH "AUTHORS"
 .TP
 Hadar Hen Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
diff --git a/libibverbs/man/ibv_create_qp_ex.3
b/libibverbs/man/ibv_create_qp_ex.3
index bb2d1b6..ea0bfea 100644
--- a/libibverbs/man/ibv_create_qp_ex.3
+++ b/libibverbs/man/ibv_create_qp_ex.3
@@ -31,7 +31,7 @@ struct ibv_srq         *srq;            /* SRQ
handle if QP is to be associated
 struct ibv_qp_cap       cap;            /* QP capabilities */
 enum ibv_qp_type        qp_type;        /* QP Transport Service Type:
IBV_QPT_RC, IBV_QPT_UC, IBV_QPT_UD or IBV_QPT_RAW_PACKET */
 int                     sq_sig_all;     /* If set, each Work Request
(WR) submitted to the SQ generates a completion entry */
-uint32_t                comp_mask; /* Identifies valid fields */
+uint32_t                comp_mask; /* Identifies valid fields as
defined in ibv_qp_init_attr_mask */
 struct ibv_pd          *pd; /* PD to be associated with the QP */
 struct ibv_xrcd        *xrcd; /* XRC domain to be associated with the
target QP */
 enum ibv_qp_create_flags create_flags; /* Creation flags for this QP */
@@ -39,6 +39,7 @@ uint16_t                max_tso_header; /* Maximum
TSO header size */
 struct ibv_rwq_ind_table *rwq_ind_tbl;  /* Indirection table to be
associated with the QP */
 struct ibv_rx_hash_conf  rx_hash_conf;  /* RX hash configuration to be used */
 uint32_t                source_qpn;     /* Source QP number, creation
flag IBV_QP_CREATE_SOURCE_QPN should be set, few NOTEs below */
+struct ibv_counters    *counters;       /* attach an ibv_counters
object to this QP */
 .in -8
 };
 .sp
@@ -125,6 +126,7 @@ fails if the QP is attached to a multicast group.
 .BR ibv_modify_qp (3),
 .BR ibv_query_qp (3),
 .BR ibv_create_rwq_ind_table (3)
+.BR ibv_create_counters (3)
 .SH "AUTHORS"
 .TP
 Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
diff --git a/libibverbs/man/ibv_create_wq.3 b/libibverbs/man/ibv_create_wq.3
index 10fe965..166794a 100644
--- a/libibverbs/man/ibv_create_wq.3
+++ b/libibverbs/man/ibv_create_wq.3
@@ -31,7 +31,8 @@ uint32_t                   max_sge;       /*
Requested max number of scatter/gat
 struct  ibv_pd            *pd;            /* PD to be associated with the WQ */
 struct  ibv_cq            *cq;            /* CQ to be associated with the WQ */
 uint32_t                   comp_mask;     /* Identifies valid fields.
Use ibv_wq_init_attr_mask */
-uint32_t                   create_flags    /* Creation flags for this
WQ, use enum ibv_wq_flags */
+uint32_t                   create_flags;  /* Creation flags for this
WQ, use enum ibv_wq_flags */
+struct ibv_counters       *counters;      /* Attach an ibv_counters
object to this WQ */
 .in -8
 };

@@ -69,6 +70,7 @@ returns a pointer to the created WQ, or NULL if the
request fails.
 returns 0 on success, or the value of errno on failure (which
indicates the failure reason).
 .SH "SEE ALSO"
 .BR ibv_modify_wq (3),
+.BR ibv_create_counters (3)
 .SH "AUTHORS"
 .TP
 Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
diff --git a/libibverbs/man/ibv_read_counters.3
b/libibverbs/man/ibv_read_counters.3
new file mode 100644
index 0000000..617b69d
--- /dev/null
+++ b/libibverbs/man/ibv_read_counters.3
@@ -0,0 +1,229 @@
+.\" -*- nroff -*-
+.\" Licensed under the OpenIB.org BSD license (FreeBSD Variant) - See
COPYING.md
+.\"
+.TH IBV_READ_COUNTERS 3 2017-11-06 libibverbs "Libibverbs Programmer's Manual"
+.SH "NAME"
+ibv_read_counters \- read counter values
+.SH "SYNOPSIS"
+.nf
+.B #include <infiniband/verbs.h>
+.sp
+.BI "int ibv_read_counters(struct ibv_counters " "*counters" ",
size_t " "ncounters" ", uint64_t " "counters_value[]" ", int "
"attr_flags" );
+.fi
+.SH "DESCRIPTION"
+.B ibv_read_counters()
+returns the values of the chosen
+.I counters
+into
+.I counter_values
+array of size
+.I ncounters\fR.
+The values are filled according to the configuration defined by user in the
+.B ibv_attach_counters_point
+functions.
+.sp
+The argument
+.I attr_flags
+can have the following flag:
+.sp
+.B IBV_COUNTER_READ_ATTR_PREFER_CACHED
+will prefer reading the values from driver cache, else it will do
volatile hardware access which is the default.
+.SH "RETURN VALUE"
+.B ibv_read_counters()
+returns 0 on success, or the value of errno on failure (which
indicates the failure reason).
+.sp
+.SH EXAMPLE
+.B Example 1: Statically attach counters to a new flow
+.sp
+This first example demonstrates the use of counters which are
attached staticcally with the creation of a new flow. The counters are
read from hardware periodically, and finally all resources are
released.
+.PP
+.nf
+/* create counters object and define its counters points        */
+/* create simple L2 flow with hardcoded MAC, and a count action */
+/* read counters periodically, every 1sec, until loop ends      */
+/* assumes user prepared a RAW_PACKET QP as input               */
+/* only limited error checking in run time for code simplicity  */
+
+#define __STDC_FORMAT_MACROS
+#include <inttypes.h>
+#include <infiniband/verbs.h>
+
+/* the below MAC should be replaced by user */
+#define FLOW_SPEC_ETH_MAC_VAL {
+        .dst_mac = { 0x00, 0x01, 0x02, 0x03, 0x04, 0x05},
+        .src_mac = { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00},
+        .ether_type = 0, .vlan_tag = 0, }
+#define FLOW_SPEC_ETH_MAC_MASK {
+        .dst_mac = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF},
+        .src_mac = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF},
+        .ether_type = 0, .vlan_tag = 0, }
+
+void example_create_flow_with_counters_on_raw_qp(struct ibv_qp *qp)
+{
+.in +8
+int idx = 0;
+int loop = 1000;
+struct ibv_flow* flow = NULL;
+struct ibv_counters* counters = NULL;
+struct ibv_coun&ter_init_attr init_attr = {0};
+struct ibv_counter_attach_attr attach_attr = {0};
+
+/* create single coutners handle */
+counters = ibv_create_counters(qp->context, &init_attr);
+
+/* define counters counters meansurement points */
+attach_attr.counter_type = IBV_COUNTER_RX_PACKETS;
+attach_attr.index = idx++;
+ret = ibv_attach_counters_point_flow(counters, &attach_attr, NULL);
+if (ret == ENOTSUP) {
+ fprintf(stderr, "Attaching IBV_COUNTER_RX_PACKETS to flow is not
supported\en");
+ exit(1);
+}
+attach_attr.counter_type = IBV_COUNTER_RX_BYTES;
+attach_attr.index = idx++;
+ibv_attach_counters_point_flow(counters, idx++, NULL, IBV_COUNTER_RX_BYTES);
+if (ret == ENOTSUP) {
+ fprintf(stderr, "Attaching IBV_COUNTER_RX_BYTES to flow is not supported\en");
+ exit(1);
+}
+
+/* define a new flow attr that includes the counters handle */
+struct raw_eth_flow_attr {
+ struct ibv_flow_attr              attr;
+ struct ibv_flow_spec_eth          spec_eth;
+ struct ibv_flow_spec_action_count spec_count;
+} __attribute__((packed)) flow_attr = {
+ .attr = {
+ .comp_mask  = 0,
+ .type       = IBV_FLOW_ATTR_NORMAL,
+ .size       = sizeof(flow_attr),
+ .priority   = 0,
+ .num_of_specs = 2, /* ETH + COUNT */
+ .port       = 1,
+ .flags      = 0,
+ },
+ .spec_eth = {
+ .type = IBV_EXP_FLOW_SPEC_ETH,
+ .size = sizeof(struct ibv_flow_spec_eth),
+ .val  = FLOW_SPEC_ETH_MAC_VAL,
+ .mask = FLOW_SPEC_ETH_MAC_MASK,
+ },
+ .spec_count = {
+ .type   = IBV_FLOW_SPEC_ACTION_COUNT,
+ .size   = sizeof(struct ibv_flow_spec_action_count),
+ .counters = counters, /* attached this counters handle to the newly
created ibv_flow */
+ }
+};
+
+/* create the flow */
+flow = ibv_create_flow(qp, &flow_attr.attr);
+
+/* allocate array for counters value reading */
+uint64_t *counters_value = malloc(sizeof(uint64_t) * idx);
+
+/* periodical read and print of flow counters */
+while (--loop) {
+ sleep(1);
+
+ /* read hardware counters values */
+ ibv_read_counters(counters, idx, counters_value, 0);
+
+ printf("RX_PACKETS = %"PRIu64", RX_BYTES = %"PRIu64", TX_PACKETS =
%"PRIu64", TX_BYTES = %"PRIu64" \en",
+ counters_value[0], counters_value[1], counters_value[2], counters_value[3] );
+}
+
+/* all done, release all */
+free(counters_value);
+
+/* destory flow and detach counters */
+ibv_destroy_flow(flow);
+
+/* destroy counters handle */
+ibv_destroy_counters(counters);
+
+return;
+.in -8
+}
+.fi
+.PP
+.sp
+.SS Example 2: Dynamically attach counters with QP's
+The second example demostates how to dynamically attach and detach a
counter with active multiple QP's.
+.sp
+.PP
+.nf
+/* attach counters to all QP's with defined counters points  */
+/* read counters periodically, every 1sec, until loop ends   */
+/* assumes user prepared few QP's as input                   */
+/* no error checking in run time for example code simplicity */
+
+#define __STDC_FORMAT_MACROS
+#include <inttypes.h>
+#include <infiniband/verbs.h>
+
+void example_monitor_all_qps(int num_qps, struct ibv_qp** qp, enum
ibv_counter_type counter_type)
+{
+.in +8
+int idx = 0;
+int loop = 1000;
+
+struct ibv_counter_init_attr init_attr = {0};
+struct ibv_counter_attach_attr attach_attr = {0}
+struct ibv_counters* counters = NULL;
+
+/* create single coutners handle */
+counters = ibv_create_counters(qp[0]->context, &init_attr);
+
+/* attach counters measurement points on all qp's */
+for (idx=0; idx<num_qps; idx++) {
+ if (qp[idx]->context != qp[0]->context)
+ exit(1);
+
+ attach_attr.counter_type = counter_type;
+ attach_attr.index = idx;
+ ibv_attach_counters_point_qp(counters, &attach_attr, qp[idx]);
+}
+
+/* allocate array for counters value reading */
+uint64_t *counters_value = malloc(sizeof(uint64_t) * num_qps);
+
+/* periodical read and print of qp counters */
+while (--loop) {
+ sleep(1);
+
+ /* read hardware counters values */
+ ibv_read_counters(counters, idx, counters_value, 0);
+
+ printf("Counter %d: \en", counter_type);
+ for (idx=0; idx<num_qps; idx++) {
+ printf("QP[%d] = %"PRIu64" \en", idx, counters_value[idx]);
+ }
+ printf("======================\en");
+}
+
+/* all done, release all */
+free(counters_value);
+
+/* destroy counters handle */
+ibv_destroy_counters(counters);
+
+return;
+.in -8
+}
+.fi
+.PP
+.sp
+.SH "SEE ALSO"
+.BR ibv_create_counters (3),
+.BR ibv_destroy_counters (3),
+.sp
+.BR ibv_attach_counters_point_qp (3),
+.BR ibv_attach_counters_point_wq (3),
+.BR ibv_attach_counters_point_flow (3),
+.sp
+.BR ibv_detach_counters_point (3),
+.BR ibv_create_flow (3),
+.BR ibv_create_qp_ex (3),
+.SH "AUTHORS"
+.TP
+Alex Rosenbaum <alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
diff --git a/libibverbs/verbs.h b/libibverbs/verbs.h
index 775bad5..9acbd9c 100644
--- a/libibverbs/verbs.h
+++ b/libibverbs/verbs.h
@@ -716,7 +716,8 @@ enum ibv_wq_type {

 enum ibv_wq_init_attr_mask {
  IBV_WQ_INIT_ATTR_FLAGS = 1 << 0,
- IBV_WQ_INIT_ATTR_RESERVED = 1 << 1,
+ IBV_WQ_INIT_ATTR_ATTACH_COUNTERS= 1 << 1,
+ IBV_WQ_INIT_ATTR_RESERVED = 1 << 2,
 };

 enum ibv_wq_flags {
@@ -736,6 +737,7 @@ struct ibv_wq_init_attr {
  struct ibv_cq        *cq;
  uint32_t comp_mask; /* Use ibv_wq_init_attr_mask */
  uint32_t create_flags; /* use ibv_wq_flags */
+ struct ibv_counters    *counters;
 };

 enum ibv_wq_state {
@@ -825,7 +827,8 @@ enum ibv_qp_init_attr_mask {
  IBV_QP_INIT_ATTR_MAX_TSO_HEADER = 1 << 3,
  IBV_QP_INIT_ATTR_IND_TABLE = 1 << 4,
  IBV_QP_INIT_ATTR_RX_HASH = 1 << 5,
- IBV_QP_INIT_ATTR_RESERVED = 1 << 6
+ IBV_QP_INIT_ATTR_ATTACH_COUNTERS= 1 << 6,
+ IBV_QP_INIT_ATTR_RESERVED = 1 << 7
 };

 enum ibv_qp_create_flags {
@@ -862,6 +865,7 @@ struct ibv_qp_init_attr_ex {
  struct ibv_rwq_ind_table       *rwq_ind_tbl;
  struct ibv_rx_hash_conf rx_hash_conf;
  uint32_t source_qpn;
+ struct ibv_counters    *counters;
 };

 enum ibv_qp_open_attr_mask {
@@ -1359,6 +1363,7 @@ enum ibv_flow_spec_type {
  IBV_FLOW_SPEC_INNER = 0x100,
  IBV_FLOW_SPEC_ACTION_TAG = 0x1000,
  IBV_FLOW_SPEC_ACTION_DROP = 0x1001,
+ IBV_FLOW_SPEC_ACTION_COUNT = 0x1002,
 };

 struct ibv_flow_eth_filter {
@@ -1456,6 +1461,12 @@ struct ibv_flow_spec_action_drop {
  uint16_t  size;
 };

+struct ibv_flow_spec_action_count {
+ enum ibv_flow_spec_type  type;
+ uint16_t  size;
+ struct ibv_counters* counters;
+};
+
 struct ibv_flow_spec {
  union {
  struct {
@@ -2510,6 +2521,53 @@ static inline int ibv_is_qpt_supported(uint32_t
caps, enum ibv_qp_type qpt)
  return !!(caps & (1 << qpt));
 }

+struct ibv_counters {
+ struct ibv_context *context;
+};
+
+
+enum ibv_counter_type {
+ /* good events */
+ IBV_COUNTER_TX_PACKETS,
+ IBV_COUNTER_TX_BYTES,
+ IBV_COUNTER_RX_PACKETS,
+ IBV_COUNTER_RX_BYTES,
+ IBV_COUNTER_RX_READ_REQUESTS,
+ IBV_COUNTER_RX_WRITE_REQUESTS,
+ IBV_COUNTER_RX_ATOMIC_REQUESTS,
+
+ /* error events */
+ IBV_COUNTER_OUT_OF_BUFFER_EVENTS,
+ IBV_COUNTER_CQ_OVERFLOW_EVENTS,
+ IBV_COUNTER_RNR_NAK_RETRY_ERR,
+ IBV_COUNTER_RESP_RNR_NAK,
+ /* need to complete list for IB spec complient, and the rest should
go into vendor specific headers */
+};
+
+struct ibv_counter_init_attr {
+ int comp_mask;
+};
+
+struct ibv_counter_attach_attr {
+ enum ibv_counter_type counter_type;
+ int index;
+ int comp_mask;
+};
+
+struct ibv_counters *ibv_create_counters(struct ibv_context *context,
struct ibv_counter_init_attr *attr);
+
+int ibv_destroy_counters(struct ibv_counters *counters);
+
+int ibv_attach_counters_point_qp(struct ibv_counters *counters,
struct ibv_counter_attach_attr *attr, struct ibv_qp *qp);
+
+int ibv_attach_counters_point_wq(struct ibv_counters *counters,
struct ibv_counter_attach_attr *attr, struct ibv_wq *wq);
+
+int ibv_attach_counters_point_flow(struct ibv_counters *counters,
struct ibv_counter_attach_attr *attr, struct ibv_flow *flow);
+
+int ibv_detach_counters_point(struct ibv_counters *counters, int index);
+
+int ibv_read_counters(struct ibv_counters *counters, size_t
ncounters, uint64_t counters_value[], int attr_flags);
+
 #ifdef __cplusplus
 }
 #endif
-- 
1.8.3.1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH] Support optional performance counters, including
	congestion control performance counters.
Date: Wed, 20 Jul 2011 17:04:43 -0700
Message-ID: <1311206683.6898.184.camel@auk59.llnl.gov>
References: <1311113629.6898.139.camel@auk59.llnl.gov>
	 <4E26DBEF.1030205@dev.mellanox.co.il>
	 <1311183503.6898.153.camel@auk59.llnl.gov>
	 <4E271FE9.7080508@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-Sp1zsCt1SawyO62cQ5Y+"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4E271FE9.7080508-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-Sp1zsCt1SawyO62cQ5Y+
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hey everyone,

Here's a new patch series for the optional performance counters.  It
fixes up the issues brought up by Hal.  I also include a new patch that
fixes up the incorrect BITSOFFS for other fields in libibmad.

Al

On Wed, 2011-07-20 at 11:35 -0700, Hal Rosenstock wrote:
> Hi again Al,
> 
> On 7/20/2011 1:38 PM, Albert Chu wrote:
> > Hey Hal,
> > 
> > Thanks for the nit-catches.  As for
> > 
> >> +     {32, 2, "PortVLXmitFlowCtlUpdateErrors0", mad_dump_uint},
> >>> +     {34, 2, "PortVLXmitFlowCtlUpdateErrors1", mad_dump_uint},
> >>> +     {36, 2, "PortVLXmitFlowCtlUpdateErrors2", mad_dump_uint},
> >>> +     {38, 2, "PortVLXmitFlowCtlUpdateErrors3", mad_dump_uint},
> >>> +     {40, 2, "PortVLXmitFlowCtlUpdateErrors4", mad_dump_uint},
> >>> +     {42, 2, "PortVLXmitFlowCtlUpdateErrors5", mad_dump_uint},
> >>> +     {44, 2, "PortVLXmitFlowCtlUpdateErrors6", mad_dump_uint},
> >>> +     {46, 2, "PortVLXmitFlowCtlUpdateErrors7", mad_dump_uint},
> >>> +     {48, 2, "PortVLXmitFlowCtlUpdateErrors8", mad_dump_uint},
> >>> +     {50, 2, "PortVLXmitFlowCtlUpdateErrors9", mad_dump_uint},
> >>> +     {52, 2, "PortVLXmitFlowCtlUpdateErrors10", mad_dump_uint},
> >>> +     {54, 2, "PortVLXmitFlowCtlUpdateErrors11", mad_dump_uint},
> >>> +     {56, 2, "PortVLXmitFlowCtlUpdateErrors12", mad_dump_uint},
> >>> +     {58, 2, "PortVLXmitFlowCtlUpdateErrors13", mad_dump_uint},
> >>> +     {60, 2, "PortVLXmitFlowCtlUpdateErrors14", mad_dump_uint},
> >>> +     {62, 2, "PortVLXmitFlowCtlUpdateErrors15", mad_dump_uint},
> >>
> >> Don't these need to be BITSOFFS(nn, 2)  ?
> > 
> > Perhaps there's a subtlety I'm missing.  If these require BITSOFFS, then
> > wouldn't the 16 bit fields require them too?  There are many places
> > amongst the performance counters that BITSOFFS isn't used w/ 16 bit
> > fields.
> 
> Yes; it looks like any field less than 32 bits should use BITSOFFS so I
> think that there are some existing things to fix in fields.c (the 16 bit
> fields that are not using the macro).
> 
> -- Hal
> 
> > Al
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Albert Chu
chu11-i2BcT+NCU+M@public.gmane.org
Computer Scientist
High Performance Systems Division
Lawrence Livermore National Laboratory


--=-Sp1zsCt1SawyO62cQ5Y+
Content-Disposition: attachment; filename*0=0001-perfquery-support-many-optional-performance-counters.pat; filename*1=ch
Content-Type: message/rfc822; name=0001-perfquery-support-many-optional-performance-counters.patch

From: Albert L. Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Date: Thu, 14 Jul 2011 17:10:52 -0700
Subject: [PATCH] perfquery: support many optional performance counters,
	including congestion control counters
Message-Id: <1311206274.6898.180.camel-akkeaxHeDKRliZ7u+bvwcg@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit

Signed-off-by: Albert L. Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 man/perfquery.8 |   46 ++++++++++++-
 src/perfquery.c |  197 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 238 insertions(+), 5 deletions(-)

diff --git a/man/perfquery.8 b/man/perfquery.8
index e01dc2f..7acc60c 100644
--- a/man/perfquery.8
+++ b/man/perfquery.8
@@ -6,10 +6,12 @@ perfquery \- query InfiniBand port counters
 .SH SYNOPSIS
 .B perfquery
 [\-d(ebug)] [\-G(uid)] [\-x|\-\-extended] [\-X|\-\-xmtsl] [\-S|\-\-rcvsl]
-[\-D|\-\-xmtdisc] [\-E|\-\-rcverr] [\-c|\-\-smplctl]
-[-a(ll_ports)] [-l(oop_ports)] [-r(eset_after_read)] [-R(eset_only)]
-[\-C ca_name] [\-P ca_port] [\-t(imeout) timeout_ms] [\-V(ersion)] [\-h(elp)]
-[<lid|guid> [[port] [reset_mask]]]
+[\-D|\-\-xmtdisc] [\-E|\-\-rcverr] [\-\-oprcvcounters] [\-\-flowctlcounters]
+[\-\-vloppackets] [\-\-vlopdata] [\-\-vlxmitflowctlerrors] [\-\-vlxmitcounters]
+[\-\-swportvlcong] [\-\-rcvcc] [\-\-slrcvfecn] [\-\-slrcvbecn] [\-\-xmitcc]
+[\-\-vlxmittimecc] [\-c|\-\-smplctl] [-a(ll_ports)] [-l(oop_ports)]
+[-r(eset_after_read)] [-R(eset_only)] [\-C ca_name] [\-P ca_port] [\-t(imeout) timeout_ms]
+[\-V(ersion)] [\-h(elp)] [<lid|guid> [[port] [reset_mask]]]
 
 .SH DESCRIPTION
 .PP
@@ -49,6 +51,42 @@ show receive error details. This is an optional counter.
 \fB\-D\fR, \fB\-\-xmtdisc\fR
 show transmit discard details. This is an optional counter.
 .TP
+\fB\-\-oprcvcounters\fR
+show Rcv Counters per Op code. This is an optional counter.
+.TP
+\fB\-\-flowctlcounters\fR
+show flow control counters. This is an optional counter.
+.TP
+\fB\-\-vloppackets\fR
+show packets received per Op code per VL. This is an optional counter.
+.TP
+\fB\-\-vlopdata\fR
+show data received per Op code per VL. This is an optional counter.
+.TP
+\fB\-\-vlxmitflowctlerrors\fR
+show flow control update errors per VL. This is an optional counter.
+.TP
+\fB\-\-vlxmitcounters\fR
+show ticks waiting to transmit counters per VL. This is an optional counter.
+.TP
+\fB\-\-swportvlcong\fR
+show sw port VL congestion. This is an optional counter.
+.TP
+\fB\-\-rcvcc\fR
+show Rcv congestion control counters. This is an optional counter.
+.TP
+\fB\-\-slrcvfecn\fR
+show SL Rcv FECN counters. This is an optional counter.
+.TP
+\fB\-\-slrcvbecn\fR
+show SL Rcv BECN counters. This is an optional counter.
+.TP
+\fB\-\-xmitcc\fR
+show Xmit congestion control counters. This is an optional counter.
+.TP
+\fB\-\-vlxmittimecc\fR
+show VL Xmit Time congestion control counters. This is an optional counter.
+.TP
 \fB\-c\fR, \fB\-\-smplctl\fR
 show port samples control.
 .TP
diff --git a/src/perfquery.c b/src/perfquery.c
index 8923654..0ea68aa 100644
--- a/src/perfquery.c
+++ b/src/perfquery.c
@@ -368,7 +368,9 @@ static void reset_counters(int extended, int timeout, int mask,
 }
 
 static int reset, reset_only, all_ports, loop_ports, port, extended, xmt_sl,
-    rcv_sl, xmt_disc, rcv_err, smpl_ctl;
+    rcv_sl, xmt_disc, rcv_err, smpl_ctl, oprcvcounters, flowctlcounters,
+    vloppackets, vlopdata, vlxmitflowctlerrors, vlxmitcounters, swportvlcong,
+    rcvcc, slrcvfecn, slrcvbecn, xmitcc, vlxmittimecc;
 
 static void common_func(ib_portid_t * portid, int port_num, int mask,
 			unsigned query, unsigned reset,
@@ -423,6 +425,90 @@ static void rcv_err_query(ib_portid_t * portid, int port, int mask)
 		    mad_dump_perfcounters_rcv_err);
 }
 
+static void oprcvcounters_query(ib_portid_t * portid, int port, int mask)
+{
+	common_func(portid, port, mask, !reset_only, (reset_only || reset),
+		    "PortOpRcvCounters", IB_GSI_PORT_PORT_OP_RCV_COUNTERS,
+		    mad_dump_perfcounters_port_op_rcv_counters);
+}
+
+static void flowctlcounters_query(ib_portid_t * portid, int port, int mask)
+{
+	common_func(portid, port, mask, !reset_only, (reset_only || reset),
+		    "PortFlowCtlCounters", IB_GSI_PORT_PORT_FLOW_CTL_COUNTERS,
+		    mad_dump_perfcounters_port_flow_ctl_counters);
+}
+
+static void vloppackets_query(ib_portid_t * portid, int port, int mask)
+{
+	common_func(portid, port, mask, !reset_only, (reset_only || reset),
+		    "PortVLOpPackets", IB_GSI_PORT_PORT_VL_OP_PACKETS,
+		    mad_dump_perfcounters_port_vl_op_packet);
+}
+
+static void vlopdata_query(ib_portid_t * portid, int port, int mask)
+{
+	common_func(portid, port, mask, !reset_only, (reset_only || reset),
+		    "PortVLOpData", IB_GSI_PORT_PORT_VL_OP_DATA,
+		    mad_dump_perfcounters_port_vl_op_data);
+}
+
+static void vlxmitflowctlerrors_query(ib_portid_t * portid, int port, int mask)
+{
+	common_func(portid, port, mask, !reset_only, (reset_only || reset),
+		    "PortVLXmitFlowCtlUpdateErrors", IB_GSI_PORT_PORT_VL_XMIT_FLOW_CTL_UPDATE_ERRORS,
+		    mad_dump_perfcounters_port_vl_xmit_flow_ctl_update_errors);
+}
+
+static void vlxmitcounters_query(ib_portid_t * portid, int port, int mask)
+{
+	common_func(portid, port, mask, !reset_only, (reset_only || reset),
+		    "PortVLXmitWaitCounters", IB_GSI_PORT_PORT_VL_XMIT_WAIT_COUNTERS,
+		    mad_dump_perfcounters_port_vl_xmit_wait_counters);
+}
+
+static void swportvlcong_query(ib_portid_t * portid, int port, int mask)
+{
+	common_func(portid, port, mask, !reset_only, (reset_only || reset),
+		    "SwPortVLCongestion", IB_GSI_SW_PORT_VL_CONGESTION,
+		    mad_dump_perfcounters_sw_port_vl_congestion);
+}
+
+static void rcvcc_query(ib_portid_t * portid, int port, int mask)
+{
+	common_func(portid, port, mask, !reset_only, (reset_only || reset),
+		    "PortRcvConCtrl", IB_GSI_PORT_RCV_CON_CTRL,
+		    mad_dump_perfcounters_rcv_con_ctrl);
+}
+
+static void slrcvfecn_query(ib_portid_t * portid, int port, int mask)
+{
+	common_func(portid, port, mask, !reset_only, (reset_only || reset),
+		    "PortSLRcvFECN", IB_GSI_PORT_SL_RCV_FECN,
+		    mad_dump_perfcounters_sl_rcv_fecn);
+}
+
+static void slrcvbecn_query(ib_portid_t * portid, int port, int mask)
+{
+	common_func(portid, port, mask, !reset_only, (reset_only || reset),
+		    "PortSLRcvBECN", IB_GSI_PORT_SL_RCV_BECN,
+		    mad_dump_perfcounters_sl_rcv_becn);
+}
+
+static void xmitcc_query(ib_portid_t * portid, int port, int mask)
+{
+	common_func(portid, port, mask, !reset_only, (reset_only || reset),
+		    "PortXmitConCtrl", IB_GSI_PORT_XMIT_CON_CTRL,
+		    mad_dump_perfcounters_xmit_con_ctrl);
+}
+
+static void vlxmittimecc_query(ib_portid_t * portid, int port, int mask)
+{
+	common_func(portid, port, mask, !reset_only, (reset_only || reset),
+		    "PortVLXmitTimeCong", IB_GSI_PORT_VL_XMIT_TIME_CONG,
+		    mad_dump_perfcounters_vl_xmit_time_cong);
+}
+
 void dump_portsamples_control(ib_portid_t * portid, int port)
 {
 	char buf[1024];
@@ -458,6 +544,42 @@ static int process_opt(void *context, int ch, char *optarg)
 	case 'c':
 		smpl_ctl = 1;
 		break;
+	case 1:
+		oprcvcounters = 1;
+		break;
+	case 2:
+		flowctlcounters = 1;
+		break;
+	case 3:
+		vloppackets = 1;
+		break;
+	case 4:
+		vlopdata = 1;
+		break;
+	case 5:
+		vlxmitflowctlerrors = 1;
+		break;
+	case 6:
+		vlxmitcounters = 1;
+		break;
+	case 7:
+		swportvlcong = 1;
+		break;
+	case 8:
+		rcvcc = 1;
+		break;
+	case 9:
+		slrcvfecn = 1;
+		break;
+	case 10:
+		slrcvbecn = 1;
+		break;
+	case 11:
+		xmitcc = 1;
+		break;
+	case 12:
+		vlxmittimecc = 1;
+		break;
 	case 'a':
 		all_ports++;
 		port = ALL_PORTS;
@@ -498,6 +620,18 @@ int main(int argc, char **argv)
 		{"rcvsl", 'S', 0, NULL, "show Rcv SL port counters"},
 		{"xmtdisc", 'D', 0, NULL, "show Xmt Discard Details"},
 		{"rcverr", 'E', 0, NULL, "show Rcv Error Details"},
+		{"oprcvcounters", 1, 0, NULL, "show Rcv Counters per Op code"},
+		{"flowctlcounters", 2, 0, NULL, "show flow control counters"},
+		{"vloppackets", 3, 0, NULL, "show packets received per Op code per VL"},
+		{"vlopdata", 4, 0, NULL, "show data received per Op code per VL"},
+		{"vlxmitflowctlerrors", 5, 0, NULL, "show flow control update errors per VL"},
+		{"vlxmitcounters", 6, 0, NULL, "show ticks waiting to transmit counters per VL"},
+		{"swportvlcong", 7, 0, NULL, "show sw port VL congestion"},
+		{"rcvcc", 8, 0, NULL, "show Rcv congestion control counters"},
+		{"slrcvfecn", 9, 0, NULL, "show SL Rcv FECN counters"},
+		{"slrcvbecn", 10, 0, NULL, "show SL Rcv BECN counters"},
+		{"xmitcc", 11, 0, NULL, "show Xmit congestion control counters"},
+		{"vlxmittimecc", 12, 0, NULL, "show VL Xmit Time congestion control counters"},
 		{"smplctl", 'c', 0, NULL, "show samples control"},
 		{"all_ports", 'a', 0, NULL, "show aggregated counters"},
 		{"loop_ports", 'l', 0, NULL, "iterate through each port"},
@@ -579,11 +713,72 @@ int main(int argc, char **argv)
 		goto done;
 	}
 
+	if (oprcvcounters) {
+		oprcvcounters_query(&portid, port, mask);
+		goto done;
+	}
+
+	if (flowctlcounters) {
+		flowctlcounters_query(&portid, port, mask);
+		goto done;
+	}
+
+	if (vloppackets) {
+		vloppackets_query(&portid, port, mask);
+		goto done;
+	}
+
+	if (vlopdata) {
+		vlopdata_query(&portid, port, mask);
+		goto done;
+	}
+
+	if (vlxmitflowctlerrors) {
+		vlxmitflowctlerrors_query(&portid, port, mask);
+		goto done;
+	}
+
+	if (vlxmitcounters) {
+		vlxmitcounters_query(&portid, port, mask);
+		goto done;
+	}
+
+	if (swportvlcong) {
+		swportvlcong_query(&portid, port, mask);
+		goto done;
+	}
+
+	if (rcvcc) {
+		rcvcc_query(&portid, port, mask);
+		goto done;
+	}
+
+	if (slrcvfecn) {
+		slrcvfecn_query(&portid, port, mask);
+		goto done;
+	}
+
+	if (slrcvbecn) {
+		slrcvbecn_query(&portid, port, mask);
+		goto done;
+	}
+
+	if (xmitcc) {
+		xmitcc_query(&portid, port, mask);
+		goto done;
+	}
+
+	if (vlxmittimecc) {
+		vlxmittimecc_query(&portid, port, mask);
+		goto done;
+	}
+
 	if (smpl_ctl) {
 		dump_portsamples_control(&portid, port);
 		goto done;
 	}
 
+
 	if (all_ports_loop || (loop_ports && (all_ports || port == ALL_PORTS))) {
 		if (smp_query_via(data, &portid, IB_ATTR_NODE_INFO, 0, 0,
 				  srcport) < 0)
-- 
1.7.1


--=-Sp1zsCt1SawyO62cQ5Y+
Content-Disposition: attachment; filename*0=0001-Support-optional-performance-counters-including-cong.pat; filename*1=ch
Content-Type: message/rfc822; name=0001-Support-optional-performance-counters-including-cong.patch

From: Albert L. Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Date: Thu, 14 Jul 2011 15:03:38 -0700
Subject: [PATCH 1/2] Support optional performance counters, including
	congestion control performance counters.
Message-Id: <1311206274.6898.181.camel-akkeaxHeDKRliZ7u+bvwcg@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit

Signed-off-by: Albert L. Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 include/infiniband/mad.h |  226 +++++++++++++++++++++++++++++++++++++++++++++-
 src/dump.c               |  121 +++++++++++++++++++++++++
 src/fields.c             |  194 +++++++++++++++++++++++++++++++++++++++
 src/libibmad.map         |   12 +++
 4 files changed, 552 insertions(+), 1 deletions(-)

diff --git a/include/infiniband/mad.h b/include/infiniband/mad.h
index f00bf7a..084834b 100644
--- a/include/infiniband/mad.h
+++ b/include/infiniband/mad.h
@@ -174,8 +174,20 @@ enum GSI_ATTR_ID {
 	IB_GSI_PORT_COUNTERS = 0x12,
 	IB_GSI_PORT_RCV_ERROR_DETAILS = 0x15,
 	IB_GSI_PORT_XMIT_DISCARD_DETAILS = 0x16,
+	IB_GSI_PORT_PORT_OP_RCV_COUNTERS = 0x17,
+	IB_GSI_PORT_PORT_FLOW_CTL_COUNTERS = 0x18,
+	IB_GSI_PORT_PORT_VL_OP_PACKETS = 0x19,
+	IB_GSI_PORT_PORT_VL_OP_DATA = 0x1A,
+	IB_GSI_PORT_PORT_VL_XMIT_FLOW_CTL_UPDATE_ERRORS = 0x1B,
+	IB_GSI_PORT_PORT_VL_XMIT_WAIT_COUNTERS = 0x1C,
 	IB_GSI_PORT_COUNTERS_EXT = 0x1D,
 	IB_GSI_PORT_EXT_SPEEDS_COUNTERS = 0x1F,
+	IB_GSI_SW_PORT_VL_CONGESTION = 0x30,
+	IB_GSI_PORT_RCV_CON_CTRL = 0x31,
+	IB_GSI_PORT_SL_RCV_FECN = 0x32,
+	IB_GSI_PORT_SL_RCV_BECN = 0x33,
+	IB_GSI_PORT_XMIT_CON_CTRL = 0x34,
+	IB_GSI_PORT_VL_XMIT_TIME_CONG = 0x35,
 	IB_GSI_PORT_XMIT_DATA_SL = 0x36,
 	IB_GSI_PORT_RCV_DATA_SL = 0x37,
 	IB_GSI_ATTR_LAST
@@ -805,6 +817,212 @@ enum MAD_FIELDS {
 	IB_PESC_FEC_UNCORR_BLOCK_CTR_LANE11_F,
 	IB_PESC_LAST_F,
 
+	/*
+ 	 * PortOpRcvCounters fields
+ 	 */
+	IB_PC_PORT_OP_RCV_COUNTERS_FIRST_F,
+	IB_PC_PORT_OP_RCV_PKTS = IB_PC_PORT_OP_RCV_COUNTERS_FIRST_F,
+	IB_PC_PORT_OP_RCV_DATA,
+	IB_PC_PORT_OP_RCV_COUNTERS_LAST_F,
+
+	/*
+ 	 * PortFlowCtlCounters fields
+ 	 */
+	IB_PC_PORT_FLOW_CTL_COUNTERS_FIRST_F,
+	IB_PC_PORT_XMIT_FLOW_PKTS = IB_PC_PORT_FLOW_CTL_COUNTERS_FIRST_F,
+	IB_PC_PORT_RCV_FLOW_PKTS,
+	IB_PC_PORT_FLOW_CTL_COUNTERS_LAST_F,
+
+	/*
+ 	 * PortVLOpPackets fields
+ 	 */
+	IB_PC_PORT_VL_OP_PACKETS_FIRST_F,
+	IB_PC_PORT_VL_OP_PACKETS0 = IB_PC_PORT_VL_OP_PACKETS_FIRST_F,
+	IB_PC_PORT_VL_OP_PACKETS1,
+	IB_PC_PORT_VL_OP_PACKETS2,
+	IB_PC_PORT_VL_OP_PACKETS3,
+	IB_PC_PORT_VL_OP_PACKETS4,
+	IB_PC_PORT_VL_OP_PACKETS5,
+	IB_PC_PORT_VL_OP_PACKETS6,
+	IB_PC_PORT_VL_OP_PACKETS7,
+	IB_PC_PORT_VL_OP_PACKETS8,
+	IB_PC_PORT_VL_OP_PACKETS9,
+	IB_PC_PORT_VL_OP_PACKETS10,
+	IB_PC_PORT_VL_OP_PACKETS11,
+	IB_PC_PORT_VL_OP_PACKETS12,
+	IB_PC_PORT_VL_OP_PACKETS13,
+	IB_PC_PORT_VL_OP_PACKETS14,
+	IB_PC_PORT_VL_OP_PACKETS15,
+	IB_PC_PORT_VL_OP_PACKETS_LAST_F,
+
+	/*
+ 	 * PortVLOpData fields
+ 	 */
+	IB_PC_PORT_VL_OP_DATA_FIRST_F,
+	IB_PC_PORT_VL_OP_DATA0 = IB_PC_PORT_VL_OP_DATA_FIRST_F,
+	IB_PC_PORT_VL_OP_DATA1,
+	IB_PC_PORT_VL_OP_DATA2,
+	IB_PC_PORT_VL_OP_DATA3,
+	IB_PC_PORT_VL_OP_DATA4,
+	IB_PC_PORT_VL_OP_DATA5,
+	IB_PC_PORT_VL_OP_DATA6,
+	IB_PC_PORT_VL_OP_DATA7,
+	IB_PC_PORT_VL_OP_DATA8,
+	IB_PC_PORT_VL_OP_DATA9,
+	IB_PC_PORT_VL_OP_DATA10,
+	IB_PC_PORT_VL_OP_DATA11,
+	IB_PC_PORT_VL_OP_DATA12,
+	IB_PC_PORT_VL_OP_DATA13,
+	IB_PC_PORT_VL_OP_DATA14,
+	IB_PC_PORT_VL_OP_DATA15,
+	IB_PC_PORT_VL_OP_DATA_LAST_F,
+
+	/*
+ 	 * PortVLXmitFlowCtlUpdateErrors fields
+ 	 */
+	IB_PC_PORT_VL_XMIT_FLOW_CTL_UPDATE_ERRORS_FIRST_F,
+	IB_PC_PORT_VL_XMIT_FLOW_CTL_UPDATE_ERRORS0 = IB_PC_PORT_VL_XMIT_FLOW_CTL_UPDATE_ERRORS_FIRST_F,
+	IB_PC_PORT_VL_XMIT_FLOW_CTL_UPDATE_ERRORS1,
+	IB_PC_PORT_VL_XMIT_FLOW_CTL_UPDATE_ERRORS2,
+	IB_PC_PORT_VL_XMIT_FLOW_CTL_UPDATE_ERRORS3,
+	IB_PC_PORT_VL_XMIT_FLOW_CTL_UPDATE_ERRORS4,
+	IB_PC_PORT_VL_XMIT_FLOW_CTL_UPDATE_ERRORS5,
+	IB_PC_PORT_VL_XMIT_FLOW_CTL_UPDATE_ERRORS6,
+	IB_PC_PORT_VL_XMIT_FLOW_CTL_UPDATE_ERRORS7,
+	IB_PC_PORT_VL_XMIT_FLOW_CTL_UPDATE_ERRORS8,
+	IB_PC_PORT_VL_XMIT_FLOW_CTL_UPDATE_ERRORS9,
+	IB_PC_PORT_VL_XMIT_FLOW_CTL_UPDATE_ERRORS10,
+	IB_PC_PORT_VL_XMIT_FLOW_CTL_UPDATE_ERRORS11,
+	IB_PC_PORT_VL_XMIT_FLOW_CTL_UPDATE_ERRORS12,
+	IB_PC_PORT_VL_XMIT_FLOW_CTL_UPDATE_ERRORS13,
+	IB_PC_PORT_VL_XMIT_FLOW_CTL_UPDATE_ERRORS14,
+	IB_PC_PORT_VL_XMIT_FLOW_CTL_UPDATE_ERRORS15,
+        IB_PC_PORT_VL_XMIT_FLOW_CTL_UPDATE_ERRORS_LAST_F,
+
+	/*
+ 	 * PortVLXmitWaitCounters fields
+ 	 */
+	IB_PC_PORT_VL_XMIT_WAIT_COUNTERS_FIRST_F,
+	IB_PC_PORT_VL_XMIT_WAIT0 = IB_PC_PORT_VL_XMIT_WAIT_COUNTERS_FIRST_F,
+	IB_PC_PORT_VL_XMIT_WAIT1,
+	IB_PC_PORT_VL_XMIT_WAIT2,
+	IB_PC_PORT_VL_XMIT_WAIT3,
+	IB_PC_PORT_VL_XMIT_WAIT4,
+	IB_PC_PORT_VL_XMIT_WAIT5,
+	IB_PC_PORT_VL_XMIT_WAIT6,
+	IB_PC_PORT_VL_XMIT_WAIT7,
+	IB_PC_PORT_VL_XMIT_WAIT8,
+	IB_PC_PORT_VL_XMIT_WAIT9,
+	IB_PC_PORT_VL_XMIT_WAIT10,
+	IB_PC_PORT_VL_XMIT_WAIT11,
+	IB_PC_PORT_VL_XMIT_WAIT12,
+	IB_PC_PORT_VL_XMIT_WAIT13,
+	IB_PC_PORT_VL_XMIT_WAIT14,
+	IB_PC_PORT_VL_XMIT_WAIT15,
+	IB_PC_PORT_VL_XMIT_WAIT_COUNTERS_LAST_F,
+
+	/*
+ 	 * SwPortVLCongestion fields
+ 	 */
+	IB_PC_SW_PORT_VL_CONGESTION_FIRST_F,
+	IB_PC_SW_PORT_VL_CONGESTION0 = IB_PC_SW_PORT_VL_CONGESTION_FIRST_F,
+	IB_PC_SW_PORT_VL_CONGESTION1,
+	IB_PC_SW_PORT_VL_CONGESTION2,
+	IB_PC_SW_PORT_VL_CONGESTION3,
+	IB_PC_SW_PORT_VL_CONGESTION4,
+	IB_PC_SW_PORT_VL_CONGESTION5,
+	IB_PC_SW_PORT_VL_CONGESTION6,
+	IB_PC_SW_PORT_VL_CONGESTION7,
+	IB_PC_SW_PORT_VL_CONGESTION8,
+	IB_PC_SW_PORT_VL_CONGESTION9,
+	IB_PC_SW_PORT_VL_CONGESTION10,
+	IB_PC_SW_PORT_VL_CONGESTION11,
+	IB_PC_SW_PORT_VL_CONGESTION12,
+	IB_PC_SW_PORT_VL_CONGESTION13,
+	IB_PC_SW_PORT_VL_CONGESTION14,
+	IB_PC_SW_PORT_VL_CONGESTION15,
+	IB_PC_SW_PORT_VL_CONGESTION_LAST_F,
+
+	/*
+	 * PortRcvConCtrl fields
+	 */
+	IB_PC_RCV_CON_CTRL_FIRST_F,
+	IB_PC_RCV_CON_CTRL_PKT_RCV_FECN = IB_PC_RCV_CON_CTRL_FIRST_F,
+	IB_PC_RCV_CON_CTRL_PKT_RCV_BECN,
+	IB_PC_RCV_CON_CTRL_LAST_F,
+
+	/*
+	 * PortSLRcvFECN fields
+	 */
+	IB_PC_SL_RCV_FECN_FIRST_F,
+	IB_PC_SL_RCV_FECN0 = IB_PC_SL_RCV_FECN_FIRST_F,
+	IB_PC_SL_RCV_FECN1,
+	IB_PC_SL_RCV_FECN2,
+	IB_PC_SL_RCV_FECN3,
+	IB_PC_SL_RCV_FECN4,
+	IB_PC_SL_RCV_FECN5,
+	IB_PC_SL_RCV_FECN6,
+	IB_PC_SL_RCV_FECN7,
+	IB_PC_SL_RCV_FECN8,
+	IB_PC_SL_RCV_FECN9,
+	IB_PC_SL_RCV_FECN10,
+	IB_PC_SL_RCV_FECN11,
+	IB_PC_SL_RCV_FECN12,
+	IB_PC_SL_RCV_FECN13,
+	IB_PC_SL_RCV_FECN14,
+	IB_PC_SL_RCV_FECN15,
+	IB_PC_SL_RCV_FECN_LAST_F,
+
+	/*
+	 * PortSLRcvBECN fields
+	 */
+	IB_PC_SL_RCV_BECN_FIRST_F,
+	IB_PC_SL_RCV_BECN0 = IB_PC_SL_RCV_BECN_FIRST_F,
+	IB_PC_SL_RCV_BECN1,
+	IB_PC_SL_RCV_BECN2,
+	IB_PC_SL_RCV_BECN3,
+	IB_PC_SL_RCV_BECN4,
+	IB_PC_SL_RCV_BECN5,
+	IB_PC_SL_RCV_BECN6,
+	IB_PC_SL_RCV_BECN7,
+	IB_PC_SL_RCV_BECN8,
+	IB_PC_SL_RCV_BECN9,
+	IB_PC_SL_RCV_BECN10,
+	IB_PC_SL_RCV_BECN11,
+	IB_PC_SL_RCV_BECN12,
+	IB_PC_SL_RCV_BECN13,
+	IB_PC_SL_RCV_BECN14,
+	IB_PC_SL_RCV_BECN15,
+	IB_PC_SL_RCV_BECN_LAST_F,
+
+	/*
+	 * PortXmitConCtrl fields
+	 */
+	IB_PC_XMIT_CON_CTRL_FIRST_F,
+	IB_PC_XMIT_CON_CTRL_TIME_CONG = IB_PC_XMIT_CON_CTRL_FIRST_F,
+	IB_PC_XMIT_CON_CTRL_LAST_F,
+
+	/*
+	 * PortVLXmitTimeCong fields
+	 */
+	IB_PC_VL_XMIT_TIME_CONG_FIRST_F,
+	IB_PC_VL_XMIT_TIME_CONG0 = IB_PC_VL_XMIT_TIME_CONG_FIRST_F,
+	IB_PC_VL_XMIT_TIME_CONG1,
+	IB_PC_VL_XMIT_TIME_CONG2,
+	IB_PC_VL_XMIT_TIME_CONG3,
+	IB_PC_VL_XMIT_TIME_CONG4,
+	IB_PC_VL_XMIT_TIME_CONG5,
+	IB_PC_VL_XMIT_TIME_CONG6,
+	IB_PC_VL_XMIT_TIME_CONG7,
+	IB_PC_VL_XMIT_TIME_CONG8,
+	IB_PC_VL_XMIT_TIME_CONG9,
+	IB_PC_VL_XMIT_TIME_CONG10,
+	IB_PC_VL_XMIT_TIME_CONG11,
+	IB_PC_VL_XMIT_TIME_CONG12,
+	IB_PC_VL_XMIT_TIME_CONG13,
+	IB_PC_VL_XMIT_TIME_CONG14,
+	IB_PC_VL_XMIT_TIME_CONG_LAST_F,
+
 	IB_FIELD_LAST_		/* must be last */
 };
 
@@ -1137,7 +1355,13 @@ MAD_EXPORT ib_mad_dump_fn
     mad_dump_switchinfo, mad_dump_perfcounters, mad_dump_perfcounters_ext,
     mad_dump_perfcounters_xmt_sl, mad_dump_perfcounters_rcv_sl,
     mad_dump_perfcounters_xmt_disc, mad_dump_perfcounters_rcv_err,
-    mad_dump_portsamples_control, mad_dump_port_ext_speeds_counters;
+    mad_dump_portsamples_control, mad_dump_port_ext_speeds_counters,
+    mad_dump_perfcounters_port_op_rcv_counters, mad_dump_perfcounters_port_flow_ctl_counters,
+    mad_dump_perfcounters_port_vl_op_packet, mad_dump_perfcounters_port_vl_op_data,
+    mad_dump_perfcounters_port_vl_xmit_flow_ctl_update_errors, mad_dump_perfcounters_port_vl_xmit_wait_counters,
+    mad_dump_perfcounters_sw_port_vl_congestion, mad_dump_perfcounters_rcv_con_ctrl,
+    mad_dump_perfcounters_sl_rcv_fecn, mad_dump_perfcounters_sl_rcv_becn,
+    mad_dump_perfcounters_xmit_con_ctrl, mad_dump_perfcounters_vl_xmit_time_cong;
 
 MAD_EXPORT void mad_dump_fields(char *buf, int bufsz, void *val, int valsz,
 				int start, int end);
diff --git a/src/dump.c b/src/dump.c
index 4b4279d..52b2010 100644
--- a/src/dump.c
+++ b/src/dump.c
@@ -836,6 +836,127 @@ void mad_dump_port_ext_speeds_counters(char *buf, int bufsz, void *val, int vals
 	_dump_fields(buf, bufsz, val, IB_PESC_PORT_SELECT_F, IB_PESC_LAST_F);
 }
 
+void mad_dump_perfcounters_port_op_rcv_counters(char *buf, int bufsz, void *val, int valsz)
+{
+	int cnt;
+
+	cnt = _dump_fields(buf, bufsz, val, IB_PC_EXT_PORT_SELECT_F,
+			   IB_PC_EXT_XMT_BYTES_F);
+	_dump_fields(buf + cnt, bufsz - cnt, val, IB_PC_PORT_OP_RCV_COUNTERS_FIRST_F,
+		     IB_PC_PORT_OP_RCV_COUNTERS_LAST_F);
+}
+
+void mad_dump_perfcounters_port_flow_ctl_counters(char *buf, int bufsz, void *val, int valsz)
+{
+	int cnt;
+
+	cnt = _dump_fields(buf, bufsz, val, IB_PC_EXT_PORT_SELECT_F,
+			   IB_PC_EXT_XMT_BYTES_F);
+	_dump_fields(buf + cnt, bufsz - cnt, val, IB_PC_PORT_FLOW_CTL_COUNTERS_FIRST_F,
+		     IB_PC_PORT_FLOW_CTL_COUNTERS_LAST_F);
+}
+
+void mad_dump_perfcounters_port_vl_op_packet(char *buf, int bufsz, void *val, int valsz)
+{
+	int cnt;
+
+	cnt = _dump_fields(buf, bufsz, val, IB_PC_EXT_PORT_SELECT_F,
+			   IB_PC_EXT_XMT_BYTES_F);
+	_dump_fields(buf + cnt, bufsz - cnt, val, IB_PC_PORT_VL_OP_PACKETS_FIRST_F,
+		     IB_PC_PORT_VL_OP_PACKETS_LAST_F);
+}
+
+void mad_dump_perfcounters_port_vl_op_data(char *buf, int bufsz, void *val, int valsz)
+{
+	int cnt;
+
+	cnt = _dump_fields(buf, bufsz, val, IB_PC_EXT_PORT_SELECT_F,
+			   IB_PC_EXT_XMT_BYTES_F);
+	_dump_fields(buf + cnt, bufsz - cnt, val, IB_PC_PORT_VL_OP_DATA_FIRST_F,
+		     IB_PC_PORT_VL_OP_DATA_LAST_F);
+}
+
+void mad_dump_perfcounters_port_vl_xmit_flow_ctl_update_errors(char *buf, int bufsz, void *val, int valsz)
+{
+	int cnt;
+
+	cnt = _dump_fields(buf, bufsz, val, IB_PC_EXT_PORT_SELECT_F,
+			   IB_PC_EXT_XMT_BYTES_F);
+	_dump_fields(buf + cnt, bufsz - cnt, val, IB_PC_PORT_VL_XMIT_FLOW_CTL_UPDATE_ERRORS_FIRST_F,
+		     IB_PC_PORT_VL_XMIT_FLOW_CTL_UPDATE_ERRORS_LAST_F);
+}
+
+void mad_dump_perfcounters_port_vl_xmit_wait_counters(char *buf, int bufsz, void *val, int valsz)
+{
+	int cnt;
+
+	cnt = _dump_fields(buf, bufsz, val, IB_PC_EXT_PORT_SELECT_F,
+			   IB_PC_EXT_XMT_BYTES_F);
+	_dump_fields(buf + cnt, bufsz - cnt, val, IB_PC_PORT_VL_XMIT_WAIT_COUNTERS_FIRST_F,
+		     IB_PC_PORT_VL_XMIT_WAIT_COUNTERS_LAST_F);
+}
+
+void mad_dump_perfcounters_sw_port_vl_congestion(char *buf, int bufsz, void *val, int valsz)
+{
+	int cnt;
+
+	cnt = _dump_fields(buf, bufsz, val, IB_PC_EXT_PORT_SELECT_F,
+			   IB_PC_EXT_XMT_BYTES_F);
+	_dump_fields(buf + cnt, bufsz - cnt, val, IB_PC_SW_PORT_VL_CONGESTION_FIRST_F,
+		     IB_PC_SW_PORT_VL_CONGESTION_LAST_F);
+}
+
+void mad_dump_perfcounters_rcv_con_ctrl(char *buf, int bufsz, void *val, int valsz)
+{
+	int cnt;
+
+	cnt = _dump_fields(buf, bufsz, val, IB_PC_EXT_PORT_SELECT_F,
+			   IB_PC_EXT_XMT_BYTES_F);
+	_dump_fields(buf + cnt, bufsz - cnt, val, IB_PC_RCV_CON_CTRL_FIRST_F,
+		     IB_PC_RCV_CON_CTRL_LAST_F);
+}
+
+
+void mad_dump_perfcounters_sl_rcv_fecn(char *buf, int bufsz, void *val, int valsz)
+{
+	int cnt;
+
+	cnt = _dump_fields(buf, bufsz, val, IB_PC_EXT_PORT_SELECT_F,
+			   IB_PC_EXT_XMT_BYTES_F);
+	_dump_fields(buf + cnt, bufsz - cnt, val, IB_PC_SL_RCV_FECN_FIRST_F,
+		     IB_PC_SL_RCV_FECN_LAST_F);
+}
+
+void mad_dump_perfcounters_sl_rcv_becn(char *buf, int bufsz, void *val, int valsz)
+{
+	int cnt;
+
+	cnt = _dump_fields(buf, bufsz, val, IB_PC_EXT_PORT_SELECT_F,
+			   IB_PC_EXT_XMT_BYTES_F);
+	_dump_fields(buf + cnt, bufsz - cnt, val, IB_PC_SL_RCV_BECN_FIRST_F,
+		     IB_PC_SL_RCV_BECN_LAST_F);
+}
+
+void mad_dump_perfcounters_xmit_con_ctrl(char *buf, int bufsz, void *val, int valsz)
+{
+	int cnt;
+
+	cnt = _dump_fields(buf, bufsz, val, IB_PC_EXT_PORT_SELECT_F,
+			   IB_PC_EXT_XMT_BYTES_F);
+	_dump_fields(buf + cnt, bufsz - cnt, val, IB_PC_XMIT_CON_CTRL_FIRST_F,
+		     IB_PC_XMIT_CON_CTRL_LAST_F);
+}
+
+void mad_dump_perfcounters_vl_xmit_time_cong(char *buf, int bufsz, void *val, int valsz)
+{
+	int cnt;
+
+	cnt = _dump_fields(buf, bufsz, val, IB_PC_EXT_PORT_SELECT_F,
+			   IB_PC_EXT_XMT_BYTES_F);
+	_dump_fields(buf + cnt, bufsz - cnt, val, IB_PC_VL_XMIT_TIME_CONG_FIRST_F,
+		     IB_PC_VL_XMIT_TIME_CONG_LAST_F);
+}
+
 void xdump(FILE * file, char *msg, void *p, int size)
 {
 #define HEX(x)  ((x) < 10 ? '0' + (x) : 'a' + ((x) -10))
diff --git a/src/fields.c b/src/fields.c
index 8039882..74a6721 100644
--- a/src/fields.c
+++ b/src/fields.c
@@ -578,6 +578,200 @@ static const ib_field_t ib_mad_f[] = {
 	{992, 32, "FECUncorrectableBlockCtrLane11", mad_dump_uint},
 	{0, 0},			/* IB_PESC_LAST_F */
 
+	/*
+ 	 * PortOpRcvCounters fields
+ 	 */
+	{32, 32, "PortOpRcvPkts", mad_dump_uint},
+	{64, 32, "PortOpRcvData", mad_dump_uint},
+	{0, 0},			/* IB_PC_PORT_OP_RCV_COUNTERS_LAST_F */
+
+	/*
+ 	 * PortFlowCtlCounters fields
+ 	 */
+	{32, 32, "PortXmitFlowPkts", mad_dump_uint},
+	{64, 32, "PortRcvFlowPkts", mad_dump_uint},
+	{0, 0},			/* IB_PC_PORT_FLOW_CTL_COUNTERS_LAST_F */
+
+	/*
+ 	 * PortVLOpPackets fields
+ 	 */
+	{BITSOFFS(32, 16), "PortVLOpPackets0", mad_dump_uint},
+	{BITSOFFS(48, 16), "PortVLOpPackets1", mad_dump_uint},
+	{BITSOFFS(64, 16), "PortVLOpPackets2", mad_dump_uint},
+	{BITSOFFS(80, 16), "PortVLOpPackets3", mad_dump_uint},
+	{BITSOFFS(96, 16), "PortVLOpPackets4", mad_dump_uint},
+	{BITSOFFS(112, 16), "PortVLOpPackets5", mad_dump_uint},
+	{BITSOFFS(128, 16), "PortVLOpPackets6", mad_dump_uint},
+	{BITSOFFS(144, 16), "PortVLOpPackets7", mad_dump_uint},
+	{BITSOFFS(160, 16), "PortVLOpPackets8", mad_dump_uint},
+	{BITSOFFS(176, 16), "PortVLOpPackets9", mad_dump_uint},
+	{BITSOFFS(192, 16), "PortVLOpPackets10", mad_dump_uint},
+	{BITSOFFS(208, 16), "PortVLOpPackets11", mad_dump_uint},
+	{BITSOFFS(224, 16), "PortVLOpPackets12", mad_dump_uint},
+	{BITSOFFS(240, 16), "PortVLOpPackets13", mad_dump_uint},
+	{BITSOFFS(256, 16), "PortVLOpPackets14", mad_dump_uint},
+	{BITSOFFS(272, 16), "PortVLOpPackets15", mad_dump_uint},
+	{0, 0},			/* IB_PC_PORT_VL_OP_PACKETS_LAST_F */
+
+	/*
+ 	 * PortVLOpData fields
+ 	 */
+	{32, 32, "PortVLOpData0", mad_dump_uint},
+	{64, 32, "PortVLOpData1", mad_dump_uint},
+	{96, 32, "PortVLOpData2", mad_dump_uint},
+	{128, 32, "PortVLOpData3", mad_dump_uint},
+	{160, 32, "PortVLOpData4", mad_dump_uint},
+	{192, 32, "PortVLOpData5", mad_dump_uint},
+	{224, 32, "PortVLOpData6", mad_dump_uint},
+	{256, 32, "PortVLOpData7", mad_dump_uint},
+	{288, 32, "PortVLOpData8", mad_dump_uint},
+	{320, 32, "PortVLOpData9", mad_dump_uint},
+	{352, 32, "PortVLOpData10", mad_dump_uint},
+	{384, 32, "PortVLOpData11", mad_dump_uint},
+	{416, 32, "PortVLOpData12", mad_dump_uint},
+	{448, 32, "PortVLOpData13", mad_dump_uint},
+	{480, 32, "PortVLOpData14", mad_dump_uint},
+	{512, 32, "PortVLOpData15", mad_dump_uint},
+	{0, 0},			/* IB_PC_PORT_VL_OP_DATA_LAST_F */
+
+	/*
+ 	 * PortVLXmitFlowCtlUpdateErrors fields
+ 	 */
+	{BITSOFFS(32, 2), "PortVLXmitFlowCtlUpdateErrors0", mad_dump_uint},
+	{BITSOFFS(34, 2), "PortVLXmitFlowCtlUpdateErrors1", mad_dump_uint},
+	{BITSOFFS(36, 2), "PortVLXmitFlowCtlUpdateErrors2", mad_dump_uint},
+	{BITSOFFS(38, 2), "PortVLXmitFlowCtlUpdateErrors3", mad_dump_uint},
+	{BITSOFFS(40, 2), "PortVLXmitFlowCtlUpdateErrors4", mad_dump_uint},
+	{BITSOFFS(42, 2), "PortVLXmitFlowCtlUpdateErrors5", mad_dump_uint},
+	{BITSOFFS(44, 2), "PortVLXmitFlowCtlUpdateErrors6", mad_dump_uint},
+	{BITSOFFS(46, 2), "PortVLXmitFlowCtlUpdateErrors7", mad_dump_uint},
+	{BITSOFFS(48, 2), "PortVLXmitFlowCtlUpdateErrors8", mad_dump_uint},
+	{BITSOFFS(50, 2), "PortVLXmitFlowCtlUpdateErrors9", mad_dump_uint},
+	{BITSOFFS(52, 2), "PortVLXmitFlowCtlUpdateErrors10", mad_dump_uint},
+	{BITSOFFS(54, 2), "PortVLXmitFlowCtlUpdateErrors11", mad_dump_uint},
+	{BITSOFFS(56, 2), "PortVLXmitFlowCtlUpdateErrors12", mad_dump_uint},
+	{BITSOFFS(58, 2), "PortVLXmitFlowCtlUpdateErrors13", mad_dump_uint},
+	{BITSOFFS(60, 2), "PortVLXmitFlowCtlUpdateErrors14", mad_dump_uint},
+	{BITSOFFS(62, 2), "PortVLXmitFlowCtlUpdateErrors15", mad_dump_uint},
+	{0, 0},			/* IB_PC_PORT_VL_XMIT_FLOW_CTL_UPDATE_ERRORS_LAST_F */
+
+	/*
+ 	 * PortVLXmitWaitCounters fields
+ 	 */
+ 	{BITSOFFS(32, 16), "PortVLXmitWait0", mad_dump_uint},
+	{BITSOFFS(48, 16), "PortVLXmitWait1", mad_dump_uint},
+	{BITSOFFS(64, 16), "PortVLXmitWait2", mad_dump_uint},
+	{BITSOFFS(80, 16), "PortVLXmitWait3", mad_dump_uint},
+	{BITSOFFS(96, 16), "PortVLXmitWait4", mad_dump_uint},
+	{BITSOFFS(112, 16), "PortVLXmitWait5", mad_dump_uint},
+	{BITSOFFS(128, 16), "PortVLXmitWait6", mad_dump_uint},
+	{BITSOFFS(144, 16), "PortVLXmitWait7", mad_dump_uint},
+	{BITSOFFS(160, 16), "PortVLXmitWait8", mad_dump_uint},
+	{BITSOFFS(176, 16), "PortVLXmitWait9", mad_dump_uint},
+	{BITSOFFS(192, 16), "PortVLXmitWait10", mad_dump_uint},
+	{BITSOFFS(208, 16), "PortVLXmitWait11", mad_dump_uint},
+	{BITSOFFS(224, 16), "PortVLXmitWait12", mad_dump_uint},
+	{BITSOFFS(240, 16), "PortVLXmitWait13", mad_dump_uint},
+	{BITSOFFS(256, 16), "PortVLXmitWait14", mad_dump_uint},
+	{BITSOFFS(272, 16), "PortVLXmitWait15", mad_dump_uint},
+	{0, 0},			/* IB_PC_PORT_VL_XMIT_WAIT_COUNTERS_LAST_F */
+
+	/*
+ 	 * SwPortVLCongestion fields
+ 	 */
+	{BITSOFFS(32, 16), "SWPortVLCongestion0", mad_dump_uint},
+	{BITSOFFS(48, 16), "SWPortVLCongestion1", mad_dump_uint},
+	{BITSOFFS(64, 16), "SWPortVLCongestion2", mad_dump_uint},
+	{BITSOFFS(80, 16), "SWPortVLCongestion3", mad_dump_uint},
+	{BITSOFFS(96, 16), "SWPortVLCongestion4", mad_dump_uint},
+	{BITSOFFS(112, 16), "SWPortVLCongestion5", mad_dump_uint},
+	{BITSOFFS(128, 16), "SWPortVLCongestion6", mad_dump_uint},
+	{BITSOFFS(144, 16), "SWPortVLCongestion7", mad_dump_uint},
+	{BITSOFFS(160, 16), "SWPortVLCongestion8", mad_dump_uint},
+	{BITSOFFS(176, 16), "SWPortVLCongestion9", mad_dump_uint},
+	{BITSOFFS(192, 16), "SWPortVLCongestion10", mad_dump_uint},
+	{BITSOFFS(208, 16), "SWPortVLCongestion11", mad_dump_uint},
+	{BITSOFFS(224, 16), "SWPortVLCongestion12", mad_dump_uint},
+	{BITSOFFS(240, 16), "SWPortVLCongestion13", mad_dump_uint},
+	{BITSOFFS(256, 16), "SWPortVLCongestion14", mad_dump_uint},
+	{BITSOFFS(272, 16), "SWPortVLCongestion15", mad_dump_uint},
+	{0, 0},			/* IB_PC_SW_PORT_VL_CONGESTION_LAST_F */
+
+	/*
+ 	 * PortRcvConCtrl fields
+ 	 */
+	{32, 32, "PortPktRcvFECN", mad_dump_uint},
+	{64, 32, "PortPktRcvBECN", mad_dump_uint},
+	{0, 0},			/* IB_PC_RCV_CON_CTRL_LAST_F */
+
+	/*
+ 	 * PortSLRcvFECN fields
+ 	 */
+	{32, 32, "PortSLRcvFECN0", mad_dump_uint},
+	{64, 32, "PortSLRcvFECN1", mad_dump_uint},
+	{96, 32, "PortSLRcvFECN2", mad_dump_uint},
+	{128, 32, "PortSLRcvFECN3", mad_dump_uint},
+	{160, 32, "PortSLRcvFECN4", mad_dump_uint},
+	{192, 32, "PortSLRcvFECN5", mad_dump_uint},
+	{224, 32, "PortSLRcvFECN6", mad_dump_uint},
+	{256, 32, "PortSLRcvFECN7", mad_dump_uint},
+	{288, 32, "PortSLRcvFECN8", mad_dump_uint},
+	{320, 32, "PortSLRcvFECN9", mad_dump_uint},
+	{352, 32, "PortSLRcvFECN10", mad_dump_uint},
+	{384, 32, "PortSLRcvFECN11", mad_dump_uint},
+	{416, 32, "PortSLRcvFECN12", mad_dump_uint},
+	{448, 32, "PortSLRcvFECN13", mad_dump_uint},
+	{480, 32, "PortSLRcvFECN14", mad_dump_uint},
+	{512, 32, "PortSLRcvFECN15", mad_dump_uint},
+	{0, 0},			/* IB_PC_SL_RCV_FECN_LAST_F */
+
+	/*
+ 	 * PortSLRcvBECN fields
+ 	 */
+	{32, 32, "PortSLRcvBECN0", mad_dump_uint},
+	{64, 32, "PortSLRcvBECN1", mad_dump_uint},
+	{96, 32, "PortSLRcvBECN2", mad_dump_uint},
+	{128, 32, "PortSLRcvBECN3", mad_dump_uint},
+	{160, 32, "PortSLRcvBECN4", mad_dump_uint},
+	{192, 32, "PortSLRcvBECN5", mad_dump_uint},
+	{224, 32, "PortSLRcvBECN6", mad_dump_uint},
+	{256, 32, "PortSLRcvBECN7", mad_dump_uint},
+	{288, 32, "PortSLRcvBECN8", mad_dump_uint},
+	{320, 32, "PortSLRcvBECN9", mad_dump_uint},
+	{352, 32, "PortSLRcvBECN10", mad_dump_uint},
+	{384, 32, "PortSLRcvBECN11", mad_dump_uint},
+	{416, 32, "PortSLRcvBECN12", mad_dump_uint},
+	{448, 32, "PortSLRcvBECN13", mad_dump_uint},
+	{480, 32, "PortSLRcvBECN14", mad_dump_uint},
+	{512, 32, "PortSLRcvBECN15", mad_dump_uint},
+	{0, 0},			/* IB_PC_SL_RCV_BECN_LAST_F */
+
+	/*
+ 	 * PortXmitConCtrl fields
+ 	 */
+	{32, 32, "PortXmitTimeCong", mad_dump_uint},
+	{0, 0},			/* IB_PC_XMIT_CON_CTRL_LAST_F */
+
+	/*
+ 	 * PortVLXmitTimeCong fields
+ 	 */
+	{32, 32, "PortVLXmitTimeCong0", mad_dump_uint},
+	{64, 32, "PortVLXmitTimeCong1", mad_dump_uint},
+	{96, 32, "PortVLXmitTimeCong2", mad_dump_uint},
+	{128, 32, "PortVLXmitTimeCong3", mad_dump_uint},
+	{160, 32, "PortVLXmitTimeCong4", mad_dump_uint},
+	{192, 32, "PortVLXmitTimeCong5", mad_dump_uint},
+	{224, 32, "PortVLXmitTimeCong6", mad_dump_uint},
+	{256, 32, "PortVLXmitTimeCong7", mad_dump_uint},
+	{288, 32, "PortVLXmitTimeCong8", mad_dump_uint},
+	{320, 32, "PortVLXmitTimeCong9", mad_dump_uint},
+	{352, 32, "PortVLXmitTimeCong10", mad_dump_uint},
+	{384, 32, "PortVLXmitTimeCong11", mad_dump_uint},
+	{416, 32, "PortVLXmitTimeCong12", mad_dump_uint},
+	{448, 32, "PortVLXmitTimeCong13", mad_dump_uint},
+	{480, 32, "PortVLXmitTimeCong14", mad_dump_uint},
+	{0, 0},			/* IB_PC_VL_XMIT_TIME_CONG_LAST_F */
+
 	{0, 0}			/* IB_FIELD_LAST_ */
 
 };
diff --git a/src/libibmad.map b/src/libibmad.map
index 457ec86..f0b42a5 100644
--- a/src/libibmad.map
+++ b/src/libibmad.map
@@ -34,6 +34,18 @@ IBMAD_1.3 {
 		mad_dump_portcapmask;
 		mad_dump_portinfo;
 		mad_dump_portsamples_control;
+		mad_dump_perfcounters_port_op_rcv_counters;
+		mad_dump_perfcounters_port_flow_ctl_counters;
+		mad_dump_perfcounters_port_vl_op_packet;
+		mad_dump_perfcounters_port_vl_op_data;
+		mad_dump_perfcounters_port_vl_xmit_flow_ctl_update_errors;
+		mad_dump_perfcounters_port_vl_xmit_wait_counters;
+		mad_dump_perfcounters_sw_port_vl_congestion;
+		mad_dump_perfcounters_rcv_con_ctrl;
+		mad_dump_perfcounters_sl_rcv_fecn;
+		mad_dump_perfcounters_sl_rcv_becn;
+		mad_dump_perfcounters_xmit_con_ctrl;
+		mad_dump_perfcounters_vl_xmit_time_cong;
 		mad_dump_portstates;
 		mad_dump_portstate;
 		mad_dump_rhex;
-- 
1.7.1


--=-Sp1zsCt1SawyO62cQ5Y+
Content-Disposition: attachment; filename=0002-Fix-offset-in-various-32-bit-field-entries.patch
Content-Type: message/rfc822; name=0002-Fix-offset-in-various-32-bit-field-entries.patch

From: Albert L. Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Date: Wed, 20 Jul 2011 11:52:47 -0700
Subject: [PATCH 2/2] Fix offset in various < 32 bit field entries
Message-Id: <1311206274.6898.182.camel-akkeaxHeDKRliZ7u+bvwcg@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit


Signed-off-by: Albert L. Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 src/fields.c |   52 ++++++++++++++++++++++++++--------------------------
 1 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/src/fields.c b/src/fields.c
index 74a6721..14390c1 100644
--- a/src/fields.c
+++ b/src/fields.c
@@ -452,21 +452,21 @@ static const ib_field_t ib_mad_f[] = {
 	/*
 	 * PortXmitDiscardDetails fields
 	 */
-	{32, 16, "PortInactiveDiscards", mad_dump_uint},
-	{48, 16, "PortNeighborMTUDiscards", mad_dump_uint},
-	{64, 16, "PortSwLifetimeLimitDiscards", mad_dump_uint},
-	{80, 16, "PortSwHOQLifetimeLimitDiscards", mad_dump_uint},
+	{BITSOFFS(32, 16), "PortInactiveDiscards", mad_dump_uint},
+	{BITSOFFS(48, 16), "PortNeighborMTUDiscards", mad_dump_uint},
+	{BITSOFFS(64, 16), "PortSwLifetimeLimitDiscards", mad_dump_uint},
+	{BITSOFFS(80, 16), "PortSwHOQLifetimeLimitDiscards", mad_dump_uint},
 	{0, 0},			/* IB_PC_XMT_DISC_LAST_F */
 
 	/*
 	 * PortRcvErrorDetails fields
 	 */
-	{32, 16, "PortLocalPhysicalErrors", mad_dump_uint},
-	{48, 16, "PortMalformedPktErrors", mad_dump_uint},
-	{64, 16, "PortBufferOverrunErrors", mad_dump_uint},
-	{80, 16, "PortDLIDMappingErrors", mad_dump_uint},
-	{96, 16, "PortVLMappingErrors", mad_dump_uint},
-	{112, 16, "PortLoopingErrors", mad_dump_uint},
+	{BITSOFFS(32, 16), "PortLocalPhysicalErrors", mad_dump_uint},
+	{BITSOFFS(48, 16), "PortMalformedPktErrors", mad_dump_uint},
+	{BITSOFFS(64, 16), "PortBufferOverrunErrors", mad_dump_uint},
+	{BITSOFFS(80, 16), "PortDLIDMappingErrors", mad_dump_uint},
+	{BITSOFFS(96, 16), "PortVLMappingErrors", mad_dump_uint},
+	{BITSOFFS(112, 16), "PortLoopingErrors", mad_dump_uint},
 	{0, 0},                 /* IB_PC_RCV_ERR_LAST_F */
 
 	/*
@@ -485,22 +485,22 @@ static const ib_field_t ib_mad_f[] = {
 	{160, 64, "VendorMask", mad_dump_hex},
 	{224, 32, "SampleStart", mad_dump_uint},
 	{256, 32, "SampleInterval", mad_dump_uint},
-	{288, 16, "Tag", mad_dump_hex},
-	{304, 16, "CounterSelect0", mad_dump_hex},
-	{320, 16, "CounterSelect1", mad_dump_hex},
-	{336, 16, "CounterSelect2", mad_dump_hex},
-	{352, 16, "CounterSelect3", mad_dump_hex},
-	{368, 16, "CounterSelect4", mad_dump_hex},
-	{384, 16, "CounterSelect5", mad_dump_hex},
-	{400, 16, "CounterSelect6", mad_dump_hex},
-	{416, 16, "CounterSelect7", mad_dump_hex},
-	{432, 16, "CounterSelect8", mad_dump_hex},
-	{448, 16, "CounterSelect9", mad_dump_hex},
-	{464, 16, "CounterSelect10", mad_dump_hex},
-	{480, 16, "CounterSelect11", mad_dump_hex},
-	{496, 16, "CounterSelect12", mad_dump_hex},
-	{512, 16, "CounterSelect13", mad_dump_hex},
-	{528, 16, "CounterSelect14", mad_dump_hex},
+	{BITSOFFS(288, 16), "Tag", mad_dump_hex},
+	{BITSOFFS(304, 16), "CounterSelect0", mad_dump_hex},
+	{BITSOFFS(320, 16), "CounterSelect1", mad_dump_hex},
+	{BITSOFFS(336, 16), "CounterSelect2", mad_dump_hex},
+	{BITSOFFS(352, 16), "CounterSelect3", mad_dump_hex},
+	{BITSOFFS(368, 16), "CounterSelect4", mad_dump_hex},
+	{BITSOFFS(384, 16), "CounterSelect5", mad_dump_hex},
+	{BITSOFFS(400, 16), "CounterSelect6", mad_dump_hex},
+	{BITSOFFS(416, 16), "CounterSelect7", mad_dump_hex},
+	{BITSOFFS(432, 16), "CounterSelect8", mad_dump_hex},
+	{BITSOFFS(448, 16), "CounterSelect9", mad_dump_hex},
+	{BITSOFFS(464, 16), "CounterSelect10", mad_dump_hex},
+	{BITSOFFS(480, 16), "CounterSelect11", mad_dump_hex},
+	{BITSOFFS(496, 16), "CounterSelect12", mad_dump_hex},
+	{BITSOFFS(512, 16), "CounterSelect13", mad_dump_hex},
+	{BITSOFFS(528, 16), "CounterSelect14", mad_dump_hex},
 	{576, 64, "SamplesOnlyOptionMask", mad_dump_hex},
 	{0, 0},			/* IB_PSC_LAST_F */
 
-- 
1.7.1


--=-Sp1zsCt1SawyO62cQ5Y+--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

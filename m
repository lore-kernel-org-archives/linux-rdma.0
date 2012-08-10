From: "Huang, Perry" <huang32-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 2/2] ibsim/sim_mad.c: Add read/reset functions for optional
 performance attributes.
Date: Fri, 10 Aug 2012 11:23:52 -0700
Message-ID: <CE8C6FA0-1238-41E2-A51F-572FFFEC1C17@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Chu, Al" <chu11-i2BcT+NCU+M@public.gmane.org>, "Foraker, Jim" <foraker1-i2BcT+NCU+M@public.gmane.org>, "Weiny, Ira K." <weiny2-i2BcT+NCU+M@public.gmane.org>, "alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add functions to read/reset optional performance counters detailed in IB Arch Release 1.2.1 16.1.4.[1-8].

Signed-off-by: Perry Huang <huang32-i2BcT+NCU+M@public.gmane.org>
---
 ibsim/sim_mad.c |  502 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 500 insertions(+), 2 deletions(-)

diff --git a/ibsim/sim_mad.c b/ibsim/sim_mad.c
index 61d4866..d1aaa65 100644
--- a/ibsim/sim_mad.c
+++ b/ibsim/sim_mad.c
@@ -58,8 +58,11 @@ typedef int (Smpfn) (Port * port, unsigned op, uint32_t mod, uint8_t * data);
 typedef int (EncodeTrapfn) (Port * port, char *data);

 static Smpfn do_nodeinfo, do_nodedesc, do_switchinfo, do_portinfo,
-    do_linearforwtbl, do_multicastforwtbl, do_portcounters, do_extcounters,
-    do_pkeytbl, do_sl2vl, do_vlarb, do_guidinfo, do_cpi;
+    do_linearforwtbl, do_multicastforwtbl, do_portcounters, do_extcounters,
+    do_rcv_error_details, do_xmit_discard_details, do_op_rcv_counters,
+    do_flow_ctl_counters, do_vl_op_packets, do_vl_op_data,
+    do_vl_xmit_flow_ctl_update_errors, do_vl_xmit_wait_counters, do_pkeytbl,
+    do_sl2vl, do_vlarb, do_guidinfo, do_cpi;

 static EncodeTrapfn encode_trap128;
 static EncodeTrapfn encode_trap144;
@@ -85,6 +88,14 @@ static Smpfn *attrs[IB_PERFORMANCE_CLASS + 1][0xff] = {
                                [IB_GSI_PORT_COUNTERS] = do_portcounters,
                                [IB_GSI_PORT_COUNTERS_EXT] = do_extcounters,

+                               [IB_GSI_PORT_RCV_ERROR_DETAILS] = do_rcv_error_details,
+                               [IB_GSI_PORT_XMIT_DISCARD_DETAILS] = do_xmit_discard_details,
+                               [IB_GSI_PORT_PORT_OP_RCV_COUNTERS] = do_op_rcv_counters,
+                               [IB_GSI_PORT_PORT_FLOW_CTL_COUNTERS] = do_flow_ctl_counters,
+                               [IB_GSI_PORT_PORT_VL_OP_PACKETS] = do_vl_op_packets,
+                               [IB_GSI_PORT_PORT_VL_OP_DATA] = do_vl_op_data,
+                               [IB_GSI_PORT_PORT_VL_XMIT_FLOW_CTL_UPDATE_ERRORS] = do_vl_xmit_flow_ctl_update_errors,
+                               [IB_GSI_PORT_PORT_VL_XMIT_WAIT_COUNTERS] = do_vl_xmit_wait_counters,
                                [IB_GSI_ATTR_LAST] 0,
                                },
 };
@@ -103,6 +114,10 @@ extern Port **lids;
 extern int netnodes, netports, netswitches;
 extern int maxlinearcap;

+typedef void (*pc_reset_function)(Portcounters * pc, unsigned mask);
+typedef void (*pc_get_function)(Portcounters * pc, uint8_t * data);
+typedef void (*pc_sum_function)(Portcounters * totals, Portcounters * pc);
+
 static uint64_t update_trid(uint8_t *mad, unsigned response, Client *cl)
 {
        uint64_t trid = mad_get_field64(mad, 0, IB_MAD_TRID_F);
@@ -856,6 +871,489 @@ do_extcounters(Port * port, unsigned op, uint32_t unused, uint8_t * data)
        return 0;
 }

+static int do_portcounters_common(Port * port, unsigned op, uint32_t unused, uint8_t * data,
+       pc_reset_function pc_reset_ptr, pc_get_function pc_get_ptr, pc_sum_function pc_sum_ptr)
+{
+       Node *node = port->node;
+       unsigned portnum;
+       Portcounters totals;
+       unsigned mask;
+       Port *p;
+       int i;
+
+       portnum = mad_get_field(data, 0, IB_PC_PORT_SELECT_F);
+       if (node->type != SWITCH_NODE && portnum != port->portnum)
+               return ERR_BAD_PARAM;
+
+       if (node->type == SWITCH_NODE && portnum > node->numports
+           && portnum != 0xff)
+               return ERR_BAD_PARAM;
+
+       DEBUG("in node %" PRIx64 " port %" PRIx64 " portnum %u",
+             node->nodeguid, port->portguid, portnum);
+
+       mask = mad_get_field(data, 0, IB_PC_COUNTER_SELECT_F);
+
+       if (portnum != 0xff) {
+               if (!(p = node_get_port(node, portnum)))
+                       return ERR_BAD_PARAM;
+               if (op == IB_MAD_METHOD_SET)
+                       pc_reset_ptr(&p->portcounters, mask);
+               pc_get_ptr(&p->portcounters, data);
+               return 0;
+       }
+
+       memset(&totals, 0, sizeof totals);
+
+       for (i = 0; i <= node->numports; i++) {
+               if (!(p = node_get_port(node, i)))
+                       return ERR_BAD_PARAM;
+               if (op == IB_MAD_METHOD_SET)
+                       pc_reset_ptr(&p->portcounters, mask);
+               pc_sum_ptr(&totals, &p->portcounters);
+       }
+
+       pc_get_ptr(&totals, data);
+       return 0;
+}
+
+static void pc_rcv_error_details_get(Portcounters * pc, uint8_t * data)
+{
+       mad_set_field(data, 0, IB_PC_RCV_LOCAL_PHY_ERR_F,
+               pc->rcv_error_details.PortLocalPhysicalErrors);
+       mad_set_field(data, 0, IB_PC_RCV_MALFORMED_PKT_ERR_F,
+               pc->rcv_error_details.PortMalformedPacketErrors);
+       mad_set_field(data, 0, IB_PC_RCV_BUF_OVR_ERR_F,
+               pc->rcv_error_details.PortBufferOverrunErrors);
+       mad_set_field(data, 0, IB_PC_RCV_DLID_MAP_ERR_F,
+               pc->rcv_error_details.PortDLIDMappingErrors);
+       mad_set_field(data, 0, IB_PC_RCV_VL_MAP_ERR_F,
+               pc->rcv_error_details.PortVLMappingErrors);
+       mad_set_field(data, 0, IB_PC_RCV_LOOPING_ERR_F,
+               pc->rcv_error_details.PortLoopingErrors);
+}
+
+static void pc_rcv_error_details_sum(Portcounters * totals, Portcounters * pc)
+{
+       totals->rcv_error_details.PortLocalPhysicalErrors =
+               addval(totals->rcv_error_details.PortLocalPhysicalErrors,
+               pc->rcv_error_details.PortLocalPhysicalErrors,
+               GS_PERF_LOCAL_PHYSICAL_ERRORS_LIMIT);
+       totals->rcv_error_details.PortMalformedPacketErrors =
+               addval(totals->rcv_error_details.PortMalformedPacketErrors,
+               pc->rcv_error_details.PortMalformedPacketErrors,
+               GS_PERF_MALFORMED_PACKET_ERRORS_LIMIT);
+       totals->rcv_error_details.PortBufferOverrunErrors =
+               addval(totals->rcv_error_details.PortBufferOverrunErrors,
+               pc->rcv_error_details.PortBufferOverrunErrors,
+               GS_PERF_BUFFER_OVERRUN_ERRORS_LIMIT);
+       totals->rcv_error_details.PortDLIDMappingErrors =
+               addval(totals->rcv_error_details.PortDLIDMappingErrors,
+               pc->rcv_error_details.PortDLIDMappingErrors,
+               GS_PERF_DLID_MAPPING_ERRORS_LIMIT);
+       totals->rcv_error_details.PortVLMappingErrors =
+               addval(totals->rcv_error_details.PortVLMappingErrors,
+               pc->rcv_error_details.PortVLMappingErrors,
+               GS_PERF_VL_MAPPING_ERRORS_LIMIT);
+       totals->rcv_error_details.PortLoopingErrors =
+               addval(totals->rcv_error_details.PortLoopingErrors,
+               pc->rcv_error_details.PortLoopingErrors,
+               GS_PERF_LOOPING_ERRORS_LIMIT);
+}
+
+static void pc_rcv_error_details_reset(Portcounters * pc, unsigned mask)
+{
+       if(mask & GS_PERF_LOCAL_PHYSICAL_ERRORS_MASK)
+               pc->rcv_error_details.PortLocalPhysicalErrors = 0;
+       if(mask & GS_PERF_MALFORMED_PACKET_ERRORS_MASK)
+               pc->rcv_error_details.PortMalformedPacketErrors = 0;
+       if(mask & GS_PERF_BUFFER_OVERRUN_ERRORS_MASK)
+               pc->rcv_error_details.PortBufferOverrunErrors = 0;
+       if(mask & GS_PERF_DLID_MAPPING_ERRORS_MASK)
+               pc->rcv_error_details.PortDLIDMappingErrors = 0;
+       if(mask & GS_PERF_VL_MAPPING_ERRORS_MASK)
+               pc->rcv_error_details.PortVLMappingErrors = 0;
+       if(mask & GS_PERF_LOOPING_ERRORS_MASK)
+               pc->rcv_error_details.PortLoopingErrors = 0;
+}
+
+static int do_rcv_error_details(Port * port, unsigned op, uint32_t unused, uint8_t * data)
+{
+       return do_portcounters_common(port, op, unused, data, pc_rcv_error_details_reset,
+               pc_rcv_error_details_get, pc_rcv_error_details_sum);
+}
+
+static void pc_xmit_discard_details_get(Portcounters * pc, uint8_t * data)
+{
+       mad_set_field(data, 0, IB_PC_XMT_INACT_DISC_F,
+               pc->xmit_discard_details.PortInactiveDiscards);
+       mad_set_field(data, 0, IB_PC_XMT_NEIGH_MTU_DISC_F,
+               pc->xmit_discard_details.PortNeighborMTUDiscards);
+       mad_set_field(data, 0, IB_PC_XMT_SW_LIFE_DISC_F,
+               pc->xmit_discard_details.PortSwLifetimeLimitDiscards);
+       mad_set_field(data, 0, IB_PC_XMT_SW_HOL_DISC_F,
+               pc->xmit_discard_details.PortSwHOQLifetimeLimitDiscards);
+}
+
+static void pc_xmit_discard_details_sum(Portcounters * totals, Portcounters * pc)
+{
+       totals->xmit_discard_details.PortInactiveDiscards =
+               addval(totals->xmit_discard_details.PortInactiveDiscards,
+               pc->xmit_discard_details.PortInactiveDiscards,
+               GS_PERF_INACTIVE_DISCARDS_LIMIT);
+       totals->xmit_discard_details.PortNeighborMTUDiscards =
+               addval(totals->xmit_discard_details.PortNeighborMTUDiscards,
+               pc->xmit_discard_details.PortNeighborMTUDiscards,
+               GS_PERF_NEIGHBOR_MTU_DISCARDS_LIMIT);
+       totals->xmit_discard_details.PortSwLifetimeLimitDiscards =
+               addval(totals->xmit_discard_details.PortSwLifetimeLimitDiscards,
+               pc->xmit_discard_details.PortSwLifetimeLimitDiscards,
+               GS_PERF_SW_LIFETIME_LIMIT_DISCARDS_LIMIT);
+       totals->xmit_discard_details.PortSwHOQLifetimeLimitDiscards =
+               addval(totals->xmit_discard_details.PortSwHOQLifetimeLimitDiscards,
+               pc->xmit_discard_details.PortSwHOQLifetimeLimitDiscards,
+               GS_PERF_SW_HOQ_LIFETIME_LIMIT_DISCARDS_LIMIT);
+}
+
+static void pc_xmit_discard_details_reset(Portcounters * pc, unsigned mask)
+{
+       if(mask & GS_PERF_INACTIVE_DISCARDS_MASK)
+               pc->xmit_discard_details.PortInactiveDiscards = 0;
+       if(mask & GS_PERF_NEIGHBOR_MTU_DISCARDS_MASK)
+               pc->xmit_discard_details.PortNeighborMTUDiscards = 0;
+       if(mask & GS_PERF_SW_LIFETIME_LIMIT_DISCARDS_MASK)
+               pc->xmit_discard_details.PortSwLifetimeLimitDiscards = 0;
+       if(mask & GS_PERF_SW_HOQ_LIFETIME_LIMIT_DISCARDS_MASK)
+               pc->xmit_discard_details.PortSwHOQLifetimeLimitDiscards = 0;
+}
+
+static int do_xmit_discard_details(Port * port, unsigned op, uint32_t unused, uint8_t * data)
+{
+       return do_portcounters_common(port, op, unused, data, pc_xmit_discard_details_reset,
+               pc_xmit_discard_details_get, pc_xmit_discard_details_sum);
+}
+
+static void pc_op_rcv_counters_get(Portcounters * pc, uint8_t * data)
+{
+       mad_set_field(data, 0, IB_PC_PORT_OP_RCV_PKTS_F,
+               pc->op_rcv_counters.PortOpRcvPkts);
+       mad_set_field(data, 0, IB_PC_PORT_OP_RCV_DATA_F,
+               pc->op_rcv_counters.PortOpRcvData);
+}
+
+static void pc_op_rcv_counters_sum(Portcounters * totals, Portcounters * pc)
+{
+       totals->op_rcv_counters.PortOpRcvPkts =
+               addval(totals->op_rcv_counters.PortOpRcvPkts,
+               pc->op_rcv_counters.PortOpRcvPkts, GS_PERF_OP_RCV_PKTS_LIMIT);
+       totals->op_rcv_counters.PortOpRcvData =
+               addval(totals->op_rcv_counters.PortOpRcvData,
+               pc->op_rcv_counters.PortOpRcvData, GS_PERF_OP_RCV_DATA_LIMIT);
+}
+
+static void pc_op_rcv_counters_reset(Portcounters * pc, unsigned mask)
+{
+       if(mask & GS_PERF_OP_RCV_PKTS_MASK)
+               pc->op_rcv_counters.PortOpRcvPkts = 0;
+       if(mask & GS_PERF_OP_RCV_DATA_MASK)
+               pc->op_rcv_counters.PortOpRcvData = 0;
+}
+
+static int do_op_rcv_counters(Port * port, unsigned op, uint32_t unused, uint8_t * data)
+{
+       return do_portcounters_common(port, op, unused, data, pc_op_rcv_counters_reset,
+               pc_op_rcv_counters_get, pc_op_rcv_counters_sum);
+}
+
+static void pc_flow_ctl_counters_get(Portcounters * pc, uint8_t * data)
+{
+       mad_set_field(data, 0, IB_PC_PORT_XMIT_FLOW_PKTS_F,
+               pc->flow_ctl_counters.PortXmitFlowPkts);
+       mad_set_field(data, 0, IB_PC_PORT_RCV_FLOW_PKTS_F,
+               pc->flow_ctl_counters.PortRcvFlowPkts);
+}
+
+static void pc_flow_ctl_counters_sum(Portcounters * totals, Portcounters * pc)
+{
+       totals->flow_ctl_counters.PortXmitFlowPkts =
+               addval(totals->flow_ctl_counters.PortXmitFlowPkts,
+               pc->flow_ctl_counters.PortXmitFlowPkts,
+               GS_PERF_XMIT_FLOW_PKTS_LIMIT);
+       totals->flow_ctl_counters.PortRcvFlowPkts =
+               addval(totals->flow_ctl_counters.PortRcvFlowPkts,
+               pc->flow_ctl_counters.PortRcvFlowPkts,
+               GS_PERF_RCV_FLOW_PKTS_LIMIT);
+}
+
+static void pc_flow_ctl_counters_reset(Portcounters * pc, unsigned mask)
+{
+       if(mask & GS_PERF_XMIT_FLOW_PKTS_MASK)
+               pc->flow_ctl_counters.PortXmitFlowPkts = 0;
+       if(mask & GS_PERF_RCV_FLOW_PKTS_MASK)
+               pc->flow_ctl_counters.PortRcvFlowPkts = 0;
+}
+
+static int do_flow_ctl_counters(Port * port, unsigned op, uint32_t unused, uint8_t * data)
+{
+       return do_portcounters_common(port, op, unused, data, pc_flow_ctl_counters_reset,
+               pc_flow_ctl_counters_get, pc_flow_ctl_counters_sum);
+}
+
+static void pc_vl_op_packets_get(Portcounters * pc, uint8_t * data)
+{
+       mad_set_field(data, 0, IB_PC_PORT_VL_OP_PACKETS0_F,
+               pc->vl_op_packets.PortVLOpPackets[0]);
+       mad_set_field(data, 0, IB_PC_PORT_VL_OP_PACKETS1_F,
+               pc->vl_op_packets.PortVLOpPackets[1]);
+       mad_set_field(data, 0, IB_PC_PORT_VL_OP_PACKETS2_F,
+               pc->vl_op_packets.PortVLOpPackets[2]);
+       mad_set_field(data, 0, IB_PC_PORT_VL_OP_PACKETS3_F,
+               pc->vl_op_packets.PortVLOpPackets[3]);
+       mad_set_field(data, 0, IB_PC_PORT_VL_OP_PACKETS4_F,
+               pc->vl_op_packets.PortVLOpPackets[4]);
+       mad_set_field(data, 0, IB_PC_PORT_VL_OP_PACKETS5_F,
+               pc->vl_op_packets.PortVLOpPackets[5]);
+       mad_set_field(data, 0, IB_PC_PORT_VL_OP_PACKETS6_F,
+               pc->vl_op_packets.PortVLOpPackets[6]);
+       mad_set_field(data, 0, IB_PC_PORT_VL_OP_PACKETS7_F,
+               pc->vl_op_packets.PortVLOpPackets[7]);
+       mad_set_field(data, 0, IB_PC_PORT_VL_OP_PACKETS8_F,
+               pc->vl_op_packets.PortVLOpPackets[8]);
+       mad_set_field(data, 0, IB_PC_PORT_VL_OP_PACKETS9_F,
+               pc->vl_op_packets.PortVLOpPackets[9]);
+       mad_set_field(data, 0, IB_PC_PORT_VL_OP_PACKETS10_F,
+               pc->vl_op_packets.PortVLOpPackets[10]);
+       mad_set_field(data, 0, IB_PC_PORT_VL_OP_PACKETS11_F,
+               pc->vl_op_packets.PortVLOpPackets[11]);
+       mad_set_field(data, 0, IB_PC_PORT_VL_OP_PACKETS12_F,
+               pc->vl_op_packets.PortVLOpPackets[12]);
+       mad_set_field(data, 0, IB_PC_PORT_VL_OP_PACKETS13_F,
+               pc->vl_op_packets.PortVLOpPackets[13]);
+       mad_set_field(data, 0, IB_PC_PORT_VL_OP_PACKETS14_F,
+               pc->vl_op_packets.PortVLOpPackets[14]);
+       mad_set_field(data, 0, IB_PC_PORT_VL_OP_PACKETS15_F,
+               pc->vl_op_packets.PortVLOpPackets[15]);
+}
+
+static void pc_vl_op_packets_sum(Portcounters * totals, Portcounters * pc)
+{
+       int i;
+       for(i = 0; i < 16; i++)
+       {
+               totals->vl_op_packets.PortVLOpPackets[i] =
+                       addval(totals->vl_op_packets.PortVLOpPackets[i],
+                       pc->vl_op_packets.PortVLOpPackets[i],
+                       GS_PERF_VL_OP_PACKETS_LIMIT);
+       }
+}
+
+static void pc_vl_op_packets_reset(Portcounters * pc, unsigned mask)
+{
+       int i;
+       for(i = 0; i < 16; i++)
+       {
+               if(mask & (1UL << i))
+                       pc->vl_op_packets.PortVLOpPackets[i] = 0;
+       }
+}
+
+static int do_vl_op_packets(Port * port, unsigned op, uint32_t unused, uint8_t * data)
+{
+       return do_portcounters_common(port, op, unused, data, pc_vl_op_packets_reset,
+               pc_vl_op_packets_get, pc_vl_op_packets_sum);
+}
+
+static void pc_vl_op_data_get(Portcounters * pc, uint8_t * data)
+{
+       mad_set_field(data, 0, IB_PC_PORT_VL_OP_DATA0_F,
+               pc->vl_op_data.PortVLOpData[0]);
+       mad_set_field(data, 0, IB_PC_PORT_VL_OP_DATA1_F,
+               pc->vl_op_data.PortVLOpData[1]);
+       mad_set_field(data, 0, IB_PC_PORT_VL_OP_DATA2_F,
+               pc->vl_op_data.PortVLOpData[2]);
+       mad_set_field(data, 0, IB_PC_PORT_VL_OP_DATA3_F,
+               pc->vl_op_data.PortVLOpData[3]);
+       mad_set_field(data, 0, IB_PC_PORT_VL_OP_DATA4_F,
+               pc->vl_op_data.PortVLOpData[4]);
+       mad_set_field(data, 0, IB_PC_PORT_VL_OP_DATA5_F,
+               pc->vl_op_data.PortVLOpData[5]);
+       mad_set_field(data, 0, IB_PC_PORT_VL_OP_DATA6_F,
+               pc->vl_op_data.PortVLOpData[6]);
+       mad_set_field(data, 0, IB_PC_PORT_VL_OP_DATA7_F,
+               pc->vl_op_data.PortVLOpData[7]);
+       mad_set_field(data, 0, IB_PC_PORT_VL_OP_DATA8_F,
+               pc->vl_op_data.PortVLOpData[8]);
+       mad_set_field(data, 0, IB_PC_PORT_VL_OP_DATA9_F,
+               pc->vl_op_data.PortVLOpData[9]);
+       mad_set_field(data, 0, IB_PC_PORT_VL_OP_DATA10_F,
+               pc->vl_op_data.PortVLOpData[10]);
+       mad_set_field(data, 0, IB_PC_PORT_VL_OP_DATA11_F,
+               pc->vl_op_data.PortVLOpData[11]);
+       mad_set_field(data, 0, IB_PC_PORT_VL_OP_DATA12_F,
+               pc->vl_op_data.PortVLOpData[12]);
+       mad_set_field(data, 0, IB_PC_PORT_VL_OP_DATA13_F,
+               pc->vl_op_data.PortVLOpData[13]);
+       mad_set_field(data, 0, IB_PC_PORT_VL_OP_DATA14_F,
+               pc->vl_op_data.PortVLOpData[14]);
+       mad_set_field(data, 0, IB_PC_PORT_VL_OP_DATA15_F,
+               pc->vl_op_data.PortVLOpData[15]);
+}
+
+static void pc_vl_op_data_sum(Portcounters * totals, Portcounters * pc)
+{
+       int i;
+       for(i = 0; i < 16; i++)
+       {
+               totals->vl_op_data.PortVLOpData[i] =
+                       addval(totals->vl_op_data.PortVLOpData[i],
+                       pc->vl_op_data.PortVLOpData[i], GS_PERF_VL_OP_DATA_LIMIT);
+       }
+}
+
+static void pc_vl_op_data_reset(Portcounters * pc, unsigned mask)
+{
+       int i;
+       for(i = 0; i < 16; i++)
+       {
+               if(mask & (1UL << i))
+                       pc->vl_op_data.PortVLOpData[i] = 0;
+       }
+}
+
+static int do_vl_op_data(Port * port, unsigned op, uint32_t unused, uint8_t * data)
+{
+       return do_portcounters_common(port, op, unused, data, pc_vl_op_data_reset,
+               pc_vl_op_data_get, pc_vl_op_data_sum);
+}
+
+static void pc_vl_xmit_flow_ctl_update_errors_get(Portcounters * pc, uint8_t * data)
+{
+       mad_set_field(data, 0, IB_PC_PORT_VL_XMIT_FLOW_CTL_UPDATE_ERRORS0_F,
+               pc->vl_xmit_flow_ctl_update_errors.PortVLXmitFlowCtlUpdateErrors[0]);
+       mad_set_field(data, 0, IB_PC_PORT_VL_XMIT_FLOW_CTL_UPDATE_ERRORS1_F,
+               pc->vl_xmit_flow_ctl_update_errors.PortVLXmitFlowCtlUpdateErrors[1]);
+       mad_set_field(data, 0, IB_PC_PORT_VL_XMIT_FLOW_CTL_UPDATE_ERRORS2_F,
+               pc->vl_xmit_flow_ctl_update_errors.PortVLXmitFlowCtlUpdateErrors[2]);
+       mad_set_field(data, 0, IB_PC_PORT_VL_XMIT_FLOW_CTL_UPDATE_ERRORS3_F,
+               pc->vl_xmit_flow_ctl_update_errors.PortVLXmitFlowCtlUpdateErrors[3]);
+       mad_set_field(data, 0, IB_PC_PORT_VL_XMIT_FLOW_CTL_UPDATE_ERRORS4_F,
+               pc->vl_xmit_flow_ctl_update_errors.PortVLXmitFlowCtlUpdateErrors[4]);
+       mad_set_field(data, 0, IB_PC_PORT_VL_XMIT_FLOW_CTL_UPDATE_ERRORS5_F,
+               pc->vl_xmit_flow_ctl_update_errors.PortVLXmitFlowCtlUpdateErrors[5]);
+       mad_set_field(data, 0, IB_PC_PORT_VL_XMIT_FLOW_CTL_UPDATE_ERRORS6_F,
+               pc->vl_xmit_flow_ctl_update_errors.PortVLXmitFlowCtlUpdateErrors[6]);
+       mad_set_field(data, 0, IB_PC_PORT_VL_XMIT_FLOW_CTL_UPDATE_ERRORS7_F,
+               pc->vl_xmit_flow_ctl_update_errors.PortVLXmitFlowCtlUpdateErrors[7]);
+       mad_set_field(data, 0, IB_PC_PORT_VL_XMIT_FLOW_CTL_UPDATE_ERRORS8_F,
+               pc->vl_xmit_flow_ctl_update_errors.PortVLXmitFlowCtlUpdateErrors[8]);
+       mad_set_field(data, 0, IB_PC_PORT_VL_XMIT_FLOW_CTL_UPDATE_ERRORS9_F,
+               pc->vl_xmit_flow_ctl_update_errors.PortVLXmitFlowCtlUpdateErrors[9]);
+       mad_set_field(data, 0, IB_PC_PORT_VL_XMIT_FLOW_CTL_UPDATE_ERRORS10_F,
+               pc->vl_xmit_flow_ctl_update_errors.PortVLXmitFlowCtlUpdateErrors[10]);
+       mad_set_field(data, 0, IB_PC_PORT_VL_XMIT_FLOW_CTL_UPDATE_ERRORS11_F,
+               pc->vl_xmit_flow_ctl_update_errors.PortVLXmitFlowCtlUpdateErrors[11]);
+       mad_set_field(data, 0, IB_PC_PORT_VL_XMIT_FLOW_CTL_UPDATE_ERRORS12_F,
+               pc->vl_xmit_flow_ctl_update_errors.PortVLXmitFlowCtlUpdateErrors[12]);
+       mad_set_field(data, 0, IB_PC_PORT_VL_XMIT_FLOW_CTL_UPDATE_ERRORS13_F,
+               pc->vl_xmit_flow_ctl_update_errors.PortVLXmitFlowCtlUpdateErrors[13]);
+       mad_set_field(data, 0, IB_PC_PORT_VL_XMIT_FLOW_CTL_UPDATE_ERRORS14_F,
+               pc->vl_xmit_flow_ctl_update_errors.PortVLXmitFlowCtlUpdateErrors[14]);
+       mad_set_field(data, 0, IB_PC_PORT_VL_XMIT_FLOW_CTL_UPDATE_ERRORS15_F,
+               pc->vl_xmit_flow_ctl_update_errors.PortVLXmitFlowCtlUpdateErrors[15]);
+}
+
+static void pc_vl_xmit_flow_ctl_update_errors_sum(Portcounters * totals, Portcounters * pc)
+{
+        int i;
+        for(i = 0; i < 16; i++)
+        {
+               totals->vl_xmit_flow_ctl_update_errors.PortVLXmitFlowCtlUpdateErrors[i] =
+                       addval(totals->vl_xmit_flow_ctl_update_errors.PortVLXmitFlowCtlUpdateErrors[i],
+                       pc->vl_xmit_flow_ctl_update_errors.PortVLXmitFlowCtlUpdateErrors[i],
+                       GS_PERF_VL_XMIT_FLOW_CTL_UPDATE_ERRORS);
+        }
+}
+
+static void pc_vl_xmit_flow_ctl_update_errors_reset(Portcounters * pc, unsigned mask)
+{
+        int i;
+        for(i = 0; i < 16; i++)
+        {
+                if(mask & (1UL << i))
+                        pc->vl_xmit_flow_ctl_update_errors.PortVLXmitFlowCtlUpdateErrors[i] = 0;
+        }
+}
+
+static int do_vl_xmit_flow_ctl_update_errors(Port * port, unsigned op, uint32_t unused, uint8_t * data)
+{
+       return do_portcounters_common(port, op, unused, data, pc_vl_xmit_flow_ctl_update_errors_reset,
+               pc_vl_xmit_flow_ctl_update_errors_get, pc_vl_xmit_flow_ctl_update_errors_sum);
+}
+
+static void pc_vl_xmit_wait_counters_get(Portcounters * pc, uint8_t * data)
+{
+       mad_set_field(data, 0, IB_PC_PORT_VL_XMIT_WAIT0_F,
+               pc->vl_xmit_wait_counters.PortVLXmitWait[0]);
+       mad_set_field(data, 0, IB_PC_PORT_VL_XMIT_WAIT1_F,
+               pc->vl_xmit_wait_counters.PortVLXmitWait[1]);
+       mad_set_field(data, 0, IB_PC_PORT_VL_XMIT_WAIT2_F,
+               pc->vl_xmit_wait_counters.PortVLXmitWait[2]);
+       mad_set_field(data, 0, IB_PC_PORT_VL_XMIT_WAIT3_F,
+               pc->vl_xmit_wait_counters.PortVLXmitWait[3]);
+       mad_set_field(data, 0, IB_PC_PORT_VL_XMIT_WAIT4_F,
+               pc->vl_xmit_wait_counters.PortVLXmitWait[4]);
+       mad_set_field(data, 0, IB_PC_PORT_VL_XMIT_WAIT5_F,
+               pc->vl_xmit_wait_counters.PortVLXmitWait[5]);
+       mad_set_field(data, 0, IB_PC_PORT_VL_XMIT_WAIT6_F,
+               pc->vl_xmit_wait_counters.PortVLXmitWait[6]);
+       mad_set_field(data, 0, IB_PC_PORT_VL_XMIT_WAIT7_F,
+               pc->vl_xmit_wait_counters.PortVLXmitWait[7]);
+       mad_set_field(data, 0, IB_PC_PORT_VL_XMIT_WAIT8_F,
+               pc->vl_xmit_wait_counters.PortVLXmitWait[8]);
+       mad_set_field(data, 0, IB_PC_PORT_VL_XMIT_WAIT9_F,
+               pc->vl_xmit_wait_counters.PortVLXmitWait[9]);
+       mad_set_field(data, 0, IB_PC_PORT_VL_XMIT_WAIT10_F,
+               pc->vl_xmit_wait_counters.PortVLXmitWait[10]);
+       mad_set_field(data, 0, IB_PC_PORT_VL_XMIT_WAIT11_F,
+               pc->vl_xmit_wait_counters.PortVLXmitWait[11]);
+       mad_set_field(data, 0, IB_PC_PORT_VL_XMIT_WAIT12_F,
+               pc->vl_xmit_wait_counters.PortVLXmitWait[12]);
+       mad_set_field(data, 0, IB_PC_PORT_VL_XMIT_WAIT13_F,
+               pc->vl_xmit_wait_counters.PortVLXmitWait[13]);
+       mad_set_field(data, 0, IB_PC_PORT_VL_XMIT_WAIT14_F,
+               pc->vl_xmit_wait_counters.PortVLXmitWait[14]);
+       mad_set_field(data, 0, IB_PC_PORT_VL_XMIT_WAIT15_F,
+               pc->vl_xmit_wait_counters.PortVLXmitWait[15]);
+}
+
+static void pc_vl_xmit_wait_counters_sum(Portcounters * totals, Portcounters * pc)
+{
+       int i;
+       for(i = 0; i < 16; i++)
+       {
+               totals->vl_xmit_wait_counters.PortVLXmitWait[i] =
+                       addval(totals->vl_xmit_wait_counters.PortVLXmitWait[i],
+                       pc->vl_xmit_wait_counters.PortVLXmitWait[i],
+                       GS_PERF_VL_XMIT_WAIT_COUNTERS_LIMIT);
+       }
+}
+
+static void pc_vl_xmit_wait_counters_reset(Portcounters * pc, unsigned mask)
+{
+       int i;
+       for(i = 0; i < 16; i++)
+       {
+               if(mask & (1UL << i))
+                       pc->vl_xmit_wait_counters.PortVLXmitWait[i] = 0;
+       }
+}
+
+static int do_vl_xmit_wait_counters(Port * port, unsigned op, uint32_t unused, uint8_t * data)
+{
+       return do_portcounters_common(port, op, unused, data, pc_vl_xmit_wait_counters_reset,
+               pc_vl_xmit_wait_counters_get, pc_vl_xmit_wait_counters_sum);
+}
+
 static char *pathstr(int lid, ib_dr_path_t * path)
 {
        static char buf[1024] = "local";
--
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: "Huang, Perry" <huang32-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 1/2] ibsim/sim.h: Add support for optional performance
 attributes.
Date: Fri, 10 Aug 2012 11:22:28 -0700
Message-ID: <0F3DDD57-C1A9-4304-A20F-7027BF8F590B@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Chu, Al" <chu11-i2BcT+NCU+M@public.gmane.org>, "Foraker, Jim" <foraker1-i2BcT+NCU+M@public.gmane.org>, "Weiny, Ira K." <weiny2-i2BcT+NCU+M@public.gmane.org>, "alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add support for optional performance counters detailed in IB Arch Release 1.2.1 16.1.4.[1-8]. Does not include congestion attributes.

Signed-off-by: Perry Huang <huang32-i2BcT+NCU+M@public.gmane.org>
---
 ibsim/sim.h |   89 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 89 insertions(+), 0 deletions(-)

diff --git a/ibsim/sim.h b/ibsim/sim.h
index 5a8a92f..a28e8b0 100644
--- a/ibsim/sim.h
+++ b/ibsim/sim.h
@@ -125,6 +125,35 @@ enum GS_PC_EXT_SELECT_MASK {
 	GS_PC_EXT_MCAST_RECV = 1 << 7,
 };
 
+enum RCV_ERROR_DETAILS_COUNTER_SELECT_MASK {
+	GS_PERF_LOCAL_PHYSICAL_ERRORS_MASK = (1UL << 0), // PortLocalPhysicalErrors
+	GS_PERF_MALFORMED_PACKET_ERRORS_MASK = (1UL << 1), // PortMalformedPacketErrors
+	GS_PERF_BUFFER_OVERRUN_ERRORS_MASK = (1UL << 2), // PortBufferOverrunErrors
+	GS_PERF_DLID_MAPPING_ERRORS_MASK = (1UL << 3), // PortDLIDMappingErrors
+	GS_PERF_VL_MAPPING_ERRORS_MASK = (1UL << 4), // PortVLMappingErrors
+	GS_PERF_LOOPING_ERRORS_MASK = (1UL << 5), // PortLoopingErrors
+};
+
+enum XMIT_DISCARD_DETAILS_SELECT_MASK {
+	GS_PERF_INACTIVE_DISCARDS_MASK = (1UL << 0), // PortInactiveDiscards
+	GS_PERF_NEIGHBOR_MTU_DISCARDS_MASK = (1UL << 1), // PortNeighborMTUDiscards
+	GS_PERF_SW_LIFETIME_LIMIT_DISCARDS_MASK = (1UL << 2), // PortSwLifetimeLimitDiscards
+	GS_PERF_SW_HOQ_LIFETIME_LIMIT_DISCARDS_MASK = (1UL << 3), // PortSwHOQLifetimeLimitDiscards
+};
+
+enum OP_RCV_COUNTERS_SELECT_MASK {
+	GS_PERF_OP_RCV_PKTS_MASK = (1UL << 0), // PortOpRcvPkts
+	GS_PERF_OP_RCV_DATA_MASK = (1UL << 1), // PortOpRcvData
+};
+
+enum FLOW_CTL_COUNTERS_SELECT_MASK {
+	GS_PERF_XMIT_FLOW_PKTS_MASK = (1UL << 0), // PortXmitFlowPkts
+	GS_PERF_RCV_FLOW_PKTS_MASK = (1UL << 1), // PortRcvFlowPkts
+};
+
+/* Counter select bit masks for PortVLOpPackets[0-15], PortVLOpData[0-15], 
+and PortVLXmitWaitCounters[0-15] are ommitted due to redundency. */
+
 enum GS_PERF_COUNTER_SELECT_LIMIT {
 	GS_PERF_ERR_SYM_LIMIT = 0xffff,
 	GS_PERF_LINK_RECOVERS_LIMIT = 0xff,
@@ -143,6 +172,24 @@ enum GS_PERF_COUNTER_SELECT_LIMIT {
 	GS_PERF_XMT_PKTS_LIMIT = 0xffffffff,
 	GS_PERF_RCV_PKTS_LIMIT = 0xffffffff,
 	GS_PERF_XMT_WAIT_LIMIT = 0xffffffff,
+	GS_PERF_LOCAL_PHYSICAL_ERRORS_LIMIT = 0xffff,  // PortLocalPhysicalErrors
+	GS_PERF_MALFORMED_PACKET_ERRORS_LIMIT = 0xffff, // PortMalformedPacketErrors
+	GS_PERF_BUFFER_OVERRUN_ERRORS_LIMIT = 0xffff, // PortBufferOverrunErrors
+	GS_PERF_DLID_MAPPING_ERRORS_LIMIT = 0xffff, // PortDLIDMappingErrors
+	GS_PERF_VL_MAPPING_ERRORS_LIMIT = 0xffff, // PortVLMappingErrors
+	GS_PERF_LOOPING_ERRORS_LIMIT = 0xffff, // PortLoopingErrors
+	GS_PERF_INACTIVE_DISCARDS_LIMIT = 0xffff, // PortInactiveDiscards
+	GS_PERF_NEIGHBOR_MTU_DISCARDS_LIMIT = 0xffff, // PortNeighborMTUDiscards
+	GS_PERF_SW_LIFETIME_LIMIT_DISCARDS_LIMIT = 0xffff, // PortSwLifetimeLimitDiscards
+	GS_PERF_SW_HOQ_LIFETIME_LIMIT_DISCARDS_LIMIT = 0xffff, // PortSwHOQLifetimeLimitDiscards
+	GS_PERF_OP_RCV_PKTS_LIMIT = 0xffffffff, // PortOpRcvPkts
+	GS_PERF_OP_RCV_DATA_LIMIT = 0xffffffff, // PortOpRcvData
+ 	GS_PERF_XMIT_FLOW_PKTS_LIMIT = 0xffffffff, // PortXmitFlowPkts
+	GS_PERF_RCV_FLOW_PKTS_LIMIT = 0xffffffff, // PortRcvFlowPkts
+	GS_PERF_VL_OP_PACKETS_LIMIT = 0xffff, // PortVLOpPackets[0-15]
+	GS_PERF_VL_OP_DATA_LIMIT = 0xffffffff, // PortVLOpData[0-15]
+	GS_PERF_VL_XMIT_FLOW_CTL_UPDATE_ERRORS = 0x3, // PortVLXmitFlowCtlUpdateErrors[0-15] 
+	GS_PERF_VL_XMIT_WAIT_COUNTERS_LIMIT = 0xffff, // PortVLXmitWaitCounters[0-15]
 };
 
 typedef struct Port Port;
@@ -185,6 +232,48 @@ struct Portcounters {
 	uint16_t errs_rcvswitchrelay;
 	uint8_t errs_excessbufovrrun;
 	uint32_t xmt_wait;
+
+	struct PortRcvErrorDetails {
+		uint16_t PortLocalPhysicalErrors;
+		uint16_t PortMalformedPacketErrors;
+		uint16_t PortBufferOverrunErrors;
+		uint16_t PortDLIDMappingErrors;
+		uint16_t PortVLMappingErrors;
+		uint16_t PortLoopingErrors;
+	} rcv_error_details;
+
+	struct PortXmitDiscardDetails {
+		uint16_t PortInactiveDiscards;
+		uint16_t PortNeighborMTUDiscards;
+		uint16_t PortSwLifetimeLimitDiscards;
+		uint16_t PortSwHOQLifetimeLimitDiscards;
+	} xmit_discard_details;
+
+	struct PortOpRcvCounters {
+		uint32_t PortOpRcvPkts;
+		uint32_t PortOpRcvData;
+	} op_rcv_counters;
+
+	struct PortFlowCtlCounters {
+		uint32_t PortXmitFlowPkts;
+		uint32_t PortRcvFlowPkts;
+	} flow_ctl_counters;
+
+	struct PortVLOpPackets {
+		uint16_t PortVLOpPackets[16];
+	} vl_op_packets;
+
+	struct PortVLOpData {
+		uint32_t PortVLOpData[16];
+	} vl_op_data;
+
+	struct PortVLXmitFlowCtlUpdateErrors {
+		uint8_t PortVLXmitFlowCtlUpdateErrors[16];
+	} vl_xmit_flow_ctl_update_errors;
+
+	struct PortVLXmitWaitCounters {
+		uint16_t PortVLXmitWait[16];
+	} vl_xmit_wait_counters;
 };
 
 struct Port {
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

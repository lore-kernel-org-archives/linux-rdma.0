From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH RESEND infiniband-diags 2/3] perfquery.c: Add support for
 additional counters in PortCountersExtended
Date: Tue, 28 Mar 2017 10:56:20 -0400
Message-ID: <c6ac3c36-edb9-01a7-cfcf-9bc3cb09fe9d@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Oded Nissan <odedni-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Oded Nissan <odedni-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Support aggregation when AllPortSelect is not supported
and reset of those counters.

Signed-off-by: Oded Nissan <odedni-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/include/ibdiag_common.h b/include/ibdiag_common.h
index 587dcfe..08bbf6b 100644
--- a/include/ibdiag_common.h
+++ b/include/ibdiag_common.h
@@ -81,6 +81,15 @@ extern char *ibd_nd_format;
 #define IS_PM_RSFEC_COUNTERS_SUP (CL_HTON16(((uint16_t)1)<<14))
 #endif
 
+#ifndef IB_PM_IS_QP1_DROP_SUP
+#define IB_PM_IS_QP1_DROP_SUP (CL_HTON16(((uint16_t)1)<<15))
+#endif
+
+/* PM ClassPortInfo CapabilityMask2 Bits */
+#ifndef IB_PM_IS_ADDL_PORT_CTRS_EXT_SUP
+#define IB_PM_IS_ADDL_PORT_CTRS_EXT_SUP (CL_HTON32(((uint32_t)1)<<1))
+#endif
+
 /* SM PortInfo CapabilityMask2 Bits */
 #ifndef IB_PORT_CAP2_IS_PORT_INFO_EXT_SUPPORTED
 #define IB_PORT_CAP2_IS_PORT_INFO_EXT_SUPPORTED (CL_HTON16(0x0002))
diff --git a/src/perfquery.c b/src/perfquery.c
index 948ce52..bc3dbf4 100644
--- a/src/perfquery.c
+++ b/src/perfquery.c
@@ -85,13 +85,30 @@ struct perf_count_ext {
 	uint64_t portunicastrcvpkts;
 	uint64_t portmulticastxmitpkits;
 	uint64_t portmulticastrcvpkts;
+
+	uint32_t counterSelect2;
+	uint64_t symbolErrorCounter;
+	uint64_t linkErrorRecoveryCounter;
+	uint64_t linkDownedCounter;
+	uint64_t portRcvErrors;
+	uint64_t portRcvRemotePhysicalErrors;
+	uint64_t portRcvSwitchRelayErrors;
+	uint64_t portXmitDiscards;
+	uint64_t portXmitConstraintErrors;
+	uint64_t portRcvConstraintErrors;
+	uint64_t localLinkIntegrityErrors;
+	uint64_t excessiveBufferOverrunErrors;
+	uint64_t VL15Dropped;
+	uint64_t portXmitWait;
+	uint64_t QP1Dropped;
 };
 
 static uint8_t pc[1024];
 
 struct perf_count perf_count =
     { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
-struct perf_count_ext perf_count_ext = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
+struct perf_count_ext perf_count_ext =
+    { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
 
 #define ALL_PORTS 0xFF
 #define MAX_PORTS 255
@@ -228,7 +245,7 @@ static void output_aggregate_perfcounters(ib_portid_t * portid,
 	       portid2str(portid), ALL_PORTS, ntohs(cap_mask), buf);
 }
 
-static void aggregate_perfcounters_ext(uint16_t cap_mask)
+static void aggregate_perfcounters_ext(uint16_t cap_mask, uint32_t cap_mask2)
 {
 	uint32_t val;
 	uint64_t val64;
@@ -256,10 +273,43 @@ static void aggregate_perfcounters_ext(uint16_t cap_mask)
 		mad_decode_field(pc, IB_PC_EXT_RCV_MPKTS_F, &val64);
 		aggregate_64bit(&perf_count_ext.portmulticastrcvpkts, val64);
 	}
+
+	if (htonl(cap_mask2) & IB_PM_IS_ADDL_PORT_CTRS_EXT_SUP) {
+		mad_decode_field(pc, IB_PC_EXT_COUNTER_SELECT2_F, &val);
+		perf_count_ext.counterSelect2 = val;
+		mad_decode_field(pc, IB_PC_EXT_ERR_SYM_F, &val64);
+		aggregate_64bit(&perf_count_ext.symbolErrorCounter, val64);
+		mad_decode_field(pc, IB_PC_EXT_LINK_RECOVERS_F, &val64);
+		aggregate_64bit(&perf_count_ext.linkErrorRecoveryCounter, val64);
+		mad_decode_field(pc, IB_PC_EXT_LINK_DOWNED_F, &val64);
+		aggregate_64bit(&perf_count_ext.linkDownedCounter, val64);
+		mad_decode_field(pc, IB_PC_EXT_ERR_RCV_F, &val64);
+		aggregate_64bit(&perf_count_ext.portRcvErrors, val64);
+		mad_decode_field(pc, IB_PC_EXT_ERR_PHYSRCV_F, &val64);
+		aggregate_64bit(&perf_count_ext.portRcvRemotePhysicalErrors, val64);
+		mad_decode_field(pc, IB_PC_EXT_ERR_SWITCH_REL_F, &val64);
+		aggregate_64bit(&perf_count_ext.portRcvSwitchRelayErrors, val64);
+		mad_decode_field(pc, IB_PC_EXT_XMT_DISCARDS_F, &val64);
+		aggregate_64bit(&perf_count_ext.portXmitDiscards, val64);
+		mad_decode_field(pc, IB_PC_EXT_ERR_XMTCONSTR_F, &val64);
+		aggregate_64bit(&perf_count_ext.portXmitConstraintErrors, val64);
+		mad_decode_field(pc, IB_PC_EXT_ERR_RCVCONSTR_F, &val64);
+		aggregate_64bit(&perf_count_ext.portRcvConstraintErrors, val64);
+		mad_decode_field(pc, IB_PC_EXT_ERR_LOCALINTEG_F, &val64);
+		aggregate_64bit(&perf_count_ext.localLinkIntegrityErrors, val64);
+		mad_decode_field(pc, IB_PC_EXT_ERR_EXCESS_OVR_F, &val64);
+		aggregate_64bit(&perf_count_ext.excessiveBufferOverrunErrors, val64);
+		mad_decode_field(pc, IB_PC_EXT_VL15_DROPPED_F, &val64);
+		aggregate_64bit(&perf_count_ext.VL15Dropped, val64);
+		mad_decode_field(pc, IB_PC_EXT_XMT_WAIT_F, &val64);
+		aggregate_64bit(&perf_count_ext.portXmitWait, val64);
+		mad_decode_field(pc, IB_PC_EXT_QP1_DROP_F, &val64);
+		aggregate_64bit(&perf_count_ext.QP1Dropped, val64);
+	}
 }
 
 static void output_aggregate_perfcounters_ext(ib_portid_t * portid,
-					      uint16_t cap_mask)
+					      uint16_t cap_mask, uint32_t cap_mask2)
 {
 	char buf[1024];
 	uint32_t val = ALL_PORTS;
@@ -289,10 +339,43 @@ static void output_aggregate_perfcounters_ext(ib_portid_t * portid,
 				 &perf_count_ext.portmulticastrcvpkts);
 	}
 
+	if (htonl(cap_mask2) & IB_PM_IS_ADDL_PORT_CTRS_EXT_SUP) {
+		mad_encode_field(pc, IB_PC_EXT_COUNTER_SELECT2_F,
+				 &perf_count_ext.counterSelect2);
+		mad_encode_field(pc, IB_PC_EXT_ERR_SYM_F,
+				 &perf_count_ext.symbolErrorCounter);
+		mad_encode_field(pc, IB_PC_EXT_LINK_RECOVERS_F,
+				 &perf_count_ext.linkErrorRecoveryCounter);
+		mad_encode_field(pc, IB_PC_EXT_LINK_DOWNED_F,
+				 &perf_count_ext.linkDownedCounter);
+		mad_encode_field(pc, IB_PC_EXT_ERR_RCV_F,
+				 &perf_count_ext.portRcvErrors);
+		mad_encode_field(pc, IB_PC_EXT_ERR_PHYSRCV_F,
+				 &perf_count_ext.portRcvRemotePhysicalErrors);
+		mad_encode_field(pc, IB_PC_EXT_ERR_SWITCH_REL_F,
+				 &perf_count_ext.portRcvSwitchRelayErrors);
+		mad_encode_field(pc, IB_PC_EXT_XMT_DISCARDS_F,
+				 &perf_count_ext.portXmitDiscards);
+		mad_encode_field(pc, IB_PC_EXT_ERR_XMTCONSTR_F,
+				 &perf_count_ext.portXmitConstraintErrors);
+		mad_encode_field(pc, IB_PC_EXT_ERR_RCVCONSTR_F,
+				 &perf_count_ext.portRcvConstraintErrors);
+		mad_encode_field(pc, IB_PC_EXT_ERR_LOCALINTEG_F,
+				 &perf_count_ext.localLinkIntegrityErrors);
+		mad_encode_field(pc, IB_PC_EXT_ERR_EXCESS_OVR_F,
+				 &perf_count_ext.excessiveBufferOverrunErrors);
+		mad_encode_field(pc, IB_PC_EXT_VL15_DROPPED_F,
+				 &perf_count_ext.VL15Dropped);
+		mad_encode_field(pc, IB_PC_EXT_XMT_WAIT_F,
+				 &perf_count_ext.portXmitWait);
+		mad_encode_field(pc, IB_PC_EXT_QP1_DROP_F,
+				 &perf_count_ext.QP1Dropped);
+	}
+
 	mad_dump_perfcounters_ext(buf, sizeof buf, pc, sizeof pc);
 
-	printf("# Port extended counters: %s port %d (CapMask: 0x%02X)\n%s",
-	       portid2str(portid), ALL_PORTS, ntohs(cap_mask), buf);
+	printf("# Port extended counters: %s port %d (CapMask: 0x%02X CapMask2: 0x%07X)\n%s",
+	       portid2str(portid), ALL_PORTS, ntohs(cap_mask), cap_mask2, buf);
 }
 
 static void dump_perfcounters(int extended, int timeout, uint16_t cap_mask,
@@ -336,7 +419,7 @@ static void dump_perfcounters(int extended, int timeout, uint16_t cap_mask,
 				   IB_GSI_PORT_COUNTERS_EXT, srcport))
 			IBEXIT("perfextquery");
 		if (aggregate)
-			aggregate_perfcounters_ext(cap_mask);
+			aggregate_perfcounters_ext(cap_mask, cap_mask2);
 		else
 			mad_dump_perfcounters_ext(buf, sizeof buf, pc,
 						  sizeof pc);
@@ -958,7 +1041,7 @@ int main(int argc, char **argv)
 							      cap_mask);
 			else
 				output_aggregate_perfcounters_ext(&portid,
-								  cap_mask);
+								  cap_mask, cap_mask2);
 		}
 	} else if (ports_count > 1) {
 		for (i = 0; i < ports_count; i++)
@@ -971,7 +1054,7 @@ int main(int argc, char **argv)
 							      cap_mask);
 			else
 				output_aggregate_perfcounters_ext(&portid,
-								  cap_mask);
+								  cap_mask, cap_mask2);
 		}
 	} else
		dump_perfcounters(extended, ibd_timeout, cap_mask, cap_mask2,
@@ -984,6 +1067,14 @@ do_reset:
 	if (argc <= 2 && !extended && (cap_mask & IB_PM_PC_XMIT_WAIT_SUP))
 		mask |= (1 << 16);	/* reset portxmitwait */
 
+	if (extended) {
+		mask |= 0xfff0000;
+		if (cap_mask & IB_PM_PC_XMIT_WAIT_SUP)
+			mask |= (1 << 28);
+		if (cap_mask & IB_PM_IS_QP1_DROP_SUP)
+			mask |= (1 << 29);
+	}
+
 	if (all_ports_loop || (loop_ports && (all_ports || port == ALL_PORTS))) {
 		for (i = start_port; i <= num_ports; i++)
 			reset_counters(extended, ibd_timeout, mask, &portid, i);
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

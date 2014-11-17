From: Dan Ben Yosef <danby-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH infiniband-diags] New MAD SM:PortInfoExtended and changing PM:PortExtendedSpeedsCounters
Date: Mon, 17 Nov 2014 16:57:29 +0200
Message-ID: <1416236249-31791-1-git-send-email-danby@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This change needed for EDR support.
This change includes:
1. Adding new MAD option to smpquery: PortInfoExtended (PIE).
2. Changing perfquery to support PortExtendedSpeedsCounters with
RSFEC mode active.

Signed-off-by: Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/ibdiag_common.h |   34 ++++++++++++++++++++++++++++++++++
 src/ibdiag_common.c     |   27 +++++++++++++++++++++++++++
 src/perfquery.c         |   44 ++++++++++++++++++++++++++++++++++++++++----
 src/smpquery.c          |   25 ++++++++++++++++++++++++-
 4 files changed, 125 insertions(+), 5 deletions(-)

diff --git a/include/ibdiag_common.h b/include/ibdiag_common.h
index ef3a46b..790e465 100644
--- a/include/ibdiag_common.h
+++ b/include/ibdiag_common.h
@@ -75,6 +75,38 @@ extern int show_keys;
 #define IB_PM_PC_XMIT_WAIT_SUP (CL_HTON16(((uint16_t)1)<<12))
 #endif
 
+/* PM ClassPortInfo CapabilityMask Bits */
+#ifndef IS_PM_RSFEC_COUNTERS_SUP
+#define IS_PM_RSFEC_COUNTERS_SUP (CL_HTON16(((uint16_t)1)<<14))
+#endif
+
+/* SM PortInfo CapabilityMask2 Bits */
+#ifndef IB_PORT_CAP2_IS_PORT_INFO_EXT_SUPPORTED
+#define IB_PORT_CAP2_IS_PORT_INFO_EXT_SUPPORTED (CL_HTON16(0x0002))
+#endif
+
+/* SM PortInfoExtended Fec Mode Bits */
+#ifndef IB_PORT_EXT_NO_FEC_MODE_ACTIVE
+#define IB_PORT_EXT_NO_FEC_MODE_ACTIVE 0
+#endif
+
+#ifndef IB_PORT_EXT_FIRE_CODE_FEC_MODE_ACTIVE
+#define IB_PORT_EXT_FIRE_CODE_FEC_MODE_ACTIVE (CL_HTON16(0x0001))
+#endif
+
+#ifndef IB_PORT_EXT_RS_FEC_MODE_ACTIVE
+#define IB_PORT_EXT_RS_FEC_MODE_ACTIVE (CL_HTON16(0x0002))
+#endif
+
+#ifndef IB_PORT_EXT_LOW_LATENCY_RS_FEC_MODE_ACTIVE
+#define IB_PORT_EXT_LOW_LATENCY_RS_FEC_MODE_ACTIVE (CL_HTON16(0x0003))
+#endif
+
+/* SM PortInfoExtended CapabilityMask Bits */
+#ifndef IB_PORT_EXT_CAP_IS_FEC_MODE_SUPPORTED
+#define IB_PORT_EXT_CAP_IS_FEC_MODE_SUPPORTED (CL_HTON32(0x00000001))
+#endif
+
 struct ibdiag_opt {
 	const char *name;
 	char letter;
@@ -102,6 +134,8 @@ extern char *conv_cnt_human_readable(uint64_t val64, float *val, int data);
 
 int is_mlnx_ext_port_info_supported(uint32_t devid);
 
+int is_port_info_extended_supported(ib_portid_t * dest, int port,
+				    struct ibmad_port *srcport);
 void get_max_msg(char *width_msg, char *speed_msg, int msg_size,
 		 ibnd_port_t * port);
 
diff --git a/src/ibdiag_common.c b/src/ibdiag_common.c
index 8c749c7..5484a19 100644
--- a/src/ibdiag_common.c
+++ b/src/ibdiag_common.c
@@ -496,6 +496,33 @@ conv_cnt_human_readable(uint64_t val64, float *val, int data)
 	return ("");
 }
 
+int is_port_info_extended_supported(ib_portid_t * dest, int port,
+				    struct ibmad_port *srcport)
+{
+	uint8_t data[IB_SMP_DATA_SIZE] = { 0 };
+	uint32_t cap_mask;
+	uint16_t cap_mask2;
+
+	if (smp_query_via(data, dest, IB_ATTR_PORT_INFO, port, 0, srcport) < 0)
+		IBEXIT("port info query failed");
+
+	mad_decode_field(data, IB_PORT_CAPMASK_F, &cap_mask);
+	if (cap_mask & CL_NTOH32(IB_PORT_CAP_HAS_CAP_MASK2)) {
+		mad_decode_field(data, IB_PORT_CAPMASK2_F, &cap_mask2);
+		if (!(cap_mask2 &
+		      CL_NTOH16(IB_PORT_CAP2_IS_PORT_INFO_EXT_SUPPORTED))) {
+			IBWARN("port info capability mask2 = 0x%x doesn't"
+			       " indicate PortInfoExtended support", cap_mask2);
+			return 0;
+		}
+	} else {
+		IBWARN("port info capability mask2 not supported");
+		return 0;
+	}
+
+	return 1;
+}
+
 int is_mlnx_ext_port_info_supported(uint32_t devid)
 {
 	if (ibd_ibnetdisc_flags & IBND_CONFIG_MLX_EPI) {
diff --git a/src/perfquery.c b/src/perfquery.c
index 112d92c..e1f7721 100644
--- a/src/perfquery.c
+++ b/src/perfquery.c
@@ -465,15 +465,51 @@ static uint8_t *ext_speeds_reset_via(void *rcvbuf, ib_portid_t * dest,
 	return mad_rpc(srcport, &rpc, dest, rcvbuf, rcvbuf);
 }
 
-static void extended_speeds_query(ib_portid_t * portid, int port, uint64_t ext_mask)
+static uint8_t is_fec_mode_active(ib_portid_t * portid, int port,
+				  uint16_t cap_mask)
+{
+	uint8_t data[IB_SMP_DATA_SIZE] = { 0 };
+	uint16_t fec_mode_active = 0;
+	uint32_t pie_capmask = 0;
+	if (cap_mask & IS_PM_RSFEC_COUNTERS_SUP) {
+		if (!is_port_info_extended_supported(portid, port, srcport)) {
+			IBWARN("Port Info Extended not supported");
+			return 0;
+		}
+
+		if (smp_query_via(data, portid, IB_ATTR_PORT_INFO_EXT, port, 0,
+				  srcport) < 0)
+			IBEXIT("smp query portinfo extended failed");
+
+		mad_decode_field(data, IB_PORT_EXT_CAPMASK_F, &pie_capmask);
+		mad_decode_field(data, IB_PORT_EXT_FEC_MODE_ACTIVE_F,
+				 &fec_mode_active);
+		if((pie_capmask &
+		    CL_NTOH32(IB_PORT_EXT_CAP_IS_FEC_MODE_SUPPORTED)) &&
+		   (CL_NTOH16(IB_PORT_EXT_RS_FEC_MODE_ACTIVE) == fec_mode_active))
+			return 1;
+	}
+
+	return 0;
+}
+
+static void extended_speeds_query(ib_portid_t * portid, int port,
+				  uint64_t ext_mask, uint16_t cap_mask)
 {
 	int mask = ext_mask;
 
-	if (!reset_only)
-		common_func(portid, port, mask, 1, 0,
+	if (!reset_only) {
+		if (is_fec_mode_active(portid, port, cap_mask))
+			common_func(portid, port, mask, 1, 0,
+				    "PortExtendedSpeedsCounters with RS-FEC Active",
+				    IB_GSI_PORT_EXT_SPEEDS_COUNTERS,
+				    mad_dump_port_ext_speeds_counters_rsfec_active);
+		else
+			common_func(portid, port, mask, 1, 0,
 			    "PortExtendedSpeedsCounters",
 			    IB_GSI_PORT_EXT_SPEEDS_COUNTERS,
 			    mad_dump_port_ext_speeds_counters);
+	}
 
 	if ((reset_only || reset) &&
 	    !ext_speeds_reset_via(pc, portid, port, ext_mask, ibd_timeout, srcport))
@@ -808,7 +844,7 @@ int main(int argc, char **argv)
 	}
 
 	if (extended_speeds) {
-		extended_speeds_query(&portid, port, ext_mask);
+		extended_speeds_query(&portid, port, ext_mask, cap_mask);
 		goto done;
 	}
 
diff --git a/src/smpquery.c b/src/smpquery.c
index e2d509a..187ef61 100644
--- a/src/smpquery.c
+++ b/src/smpquery.c
@@ -55,12 +55,13 @@
 struct ibmad_port *srcport;
 
 static op_fn_t node_desc, node_info, port_info, switch_info, pkey_table,
-    sl2vl_table, vlarb_table, guid_info, mlnx_ext_port_info;
+    sl2vl_table, vlarb_table, guid_info, mlnx_ext_port_info, port_info_extended;
 
 static const match_rec_t match_tbl[] = {
 	{"NodeInfo", "NI", node_info, 0, ""},
 	{"NodeDesc", "ND", node_desc, 0, ""},
 	{"PortInfo", "PI", port_info, 1, ""},
+	{"PortInfoExtended", "PIE", port_info_extended, 1, ""},
 	{"SwitchInfo", "SI", switch_info, 0, ""},
 	{"PKeyTable", "PKeys", pkey_table, 1, ""},
 	{"SL2VLTable", "SL2VL", sl2vl_table, 1, ""},
@@ -123,6 +124,28 @@ static char *node_info(ib_portid_t * dest, char **argv, int argc)
 	return 0;
 }
 
+static char *port_info_extended(ib_portid_t * dest, char **argv, int argc)
+{
+	char buf[2048];
+	uint8_t data[IB_SMP_DATA_SIZE] = { 0 };
+	int portnum = 0;
+
+	if (argc > 0)
+		portnum = strtol(argv[0], 0, 0);
+
+	if (!is_port_info_extended_supported(dest, portnum, srcport))
+		return "port info extended not supported";
+
+	if (!smp_query_via(data, dest, IB_ATTR_PORT_INFO_EXT, portnum, 0,
+			   srcport))
+		return "port info extended query failed";
+
+	mad_dump_portinfo_ext(buf, sizeof buf, data, sizeof data);
+	printf("# Port info Extended: %s port %d\n%s", portid2str(dest),
+	       portnum, buf);
+	return 0;
+}
+
 static char *port_info(ib_portid_t * dest, char **argv, int argc)
 {
 	char data[IB_SMP_DATA_SIZE] = { 0 };
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

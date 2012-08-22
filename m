From: "Huang, Perry" <huang32-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] ibsim/sim_cmd: Add command to set perf. counters.
Date: Wed, 22 Aug 2012 12:02:00 -0700
Message-ID: <5844B6EB-4D27-4D4A-9277-284220531169@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Chu, Al" <chu11-i2BcT+NCU+M@public.gmane.org>, "alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Weiny, Ira K." <weiny2-i2BcT+NCU+M@public.gmane.org>, "Foraker, Jim" <foraker1-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch requires:
	[PATCH 1/2] ibsim/sim.h: Add support for optional performance attributes.
	[PATCH 2/2] ibsim/sim_mad.c: Add read/reset functions for optional performance attributes.

Use:
PerformanceSet "nodeid"[port] [attribute].[field]=[value]
eg.
sim> PerformanceSet "S-0002c9020040fec8"[4] PortCounters.PortXmitPkts=125512
PortCounters.PortXmitPkts has been set to 125512

Add PerformanceSet command to enable setting performance counters (both required and optional fields).

Signed-off-by: Perry Huang <huang32-i2BcT+NCU+M@public.gmane.org>
---
 ibsim/sim_cmd.c |  274 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 274 insertions(+)

diff --git a/ibsim/sim_cmd.c b/ibsim/sim_cmd.c
index 2da8c28..beab266 100644
--- a/ibsim/sim_cmd.c
+++ b/ibsim/sim_cmd.c
@@ -40,6 +40,8 @@
 #include <unistd.h>
 #include <ctype.h>
 #include <inttypes.h>
+#include <errno.h>
+#include <limits.h>
 
 #include <ibsim.h>
 #include "sim.h"
@@ -820,6 +822,7 @@ static int dump_help(FILE * f)
 		"\t\t\t\tSwitchInfo      : 18\n"
 		"\t\t\t\tPortInfo        : 19\n"
 		);
+	fprintf(f, "\tPerformanceSet \"nodeid\"[port] [attribute].[field]=[value] : set perf. counters values\n");
 	fprintf(f,
 		"\tBaselid \"nodeid\"[port] <lid> [lmc] : change port's lid (lmc)\n");
 	fprintf(f, "\tVerbose [newlevel] - show/set simulator verbosity\n");
@@ -843,6 +846,275 @@ static int do_disconnect_client(FILE * out, int id)
 	return 0;
 }
 
+static uint64_t check_limit(uint64_t *value, uint64_t limit)
+{
+	*value = (limit > *value? *value : limit);
+	return *value;
+}
+
+static int parse_vl_num(char *attr, char *field, int *vl)
+{
+	char *vl_ptr, *end_ptr;
+	errno = 0;
+	if(strlen(field) < strlen(attr) + 1)
+		return -1;
+	vl_ptr = field + strlen(attr);
+	*vl = (int) strtol(vl_ptr, &end_ptr, 10);
+	if(*vl == 0 && (errno != 0 || vl_ptr == end_ptr))
+		return -1;
+	else if(*vl > 15 || *vl < 0)
+		return -1;
+	return 0;
+}
+
+static int do_perf_counter_set(FILE *f, char *line)
+{
+	char *s = line, *orig, *sp, *nodeid, *attr, *field, *field_trim, *val_error;
+	Node *node;
+	int portnum, vl;
+	uint64_t value;
+	char name[NAMELEN];
+	Port *p;
+	Portcounters *pc;
+
+	if (strsep(&s, "\""))
+		orig = strsep(&s, "\"");
+
+	if (!s)
+		goto format_error;
+
+	nodeid = expand_name(orig, name, &sp);
+
+	if (!sp && *s == '[')
+		sp = s + 1;
+
+	if( !(node = find_node(nodeid))) {
+		fprintf(f, "# nodeid \"%s\" (%s) not found\n", orig, nodeid);
+		return -1;
+	}
+
+	if (sp) {
+		portnum = strtoul(sp, 0, 0);
+		if (portnum < 1 || portnum > node->numports) {
+			fprintf(f, "# bad port number %d at nodeid \"%s\"\n",
+				portnum, nodeid);
+			return -1;
+		}
+	}
+
+	if (!(p = node_get_port(node, portnum))) {
+		fprintf(f, "# port %d not found from node %s\n", portnum, nodeid);
+		return -1;
+	}
+
+	strsep(&s, " ");
+	attr = strsep(&s, ".");
+	if(s == NULL)
+		goto format_error;
+	if(attr == NULL) {
+		fprintf(f, "# attribute not found in command\n");
+		return -1;
+	}
+
+	field = strsep(&s, "=");
+	if(s == NULL)
+		goto format_error;
+	if(field == NULL) {
+		fprintf(f, "# field not found in command\n");
+		return -1;
+	}
+	field_trim = field + strlen(field) - 1;
+	while(field_trim > field && isspace(*field_trim))
+		field_trim--;
+	*(field_trim + 1) = 0;
+
+	errno = 0;
+	value = strtoull(s, &val_error, 0);
+	if((value == 0 || value == ULLONG_MAX) && errno != 0) {
+		fprintf(f, "# value is not valid integer\n");
+		return -1;
+	}
+	if(*val_error)
+	{
+		fprintf(f, "# value %s is not valid integer\n", s);
+		return -1;
+	}
+
+	pc = &(p->portcounters);
+
+	if(!strcasecmp(attr, "PortCounters"))
+	{
+		if(!strcasecmp(field, "SymbolErrorCounter"))
+			pc->errs_sym = check_limit(&value, GS_PERF_ERR_SYM_LIMIT);
+		else if(!strcasecmp(field, "LinkErrorRecoveryCounter"))
+			pc->linkrecovers = check_limit(&value, GS_PERF_LINK_RECOVERS_LIMIT);
+		else if(!strcasecmp(field, "LinkDownedCounter"))
+			pc->linkdowned = check_limit(&value, GS_PERF_LINK_DOWNED_LIMIT);
+		else if(!strcasecmp(field, "PortRcvErrors"))
+			pc->errs_rcv = check_limit(&value, GS_PERF_ERR_RCV_LIMIT);
+		else if(!strcasecmp(field, "PortRcvRemotePhysicalErrors"))
+			pc->errs_remphysrcv = check_limit(&value, GS_PERF_ERR_PHYSRCV_LIMIT);
+		else if(!strcasecmp(field, "PortRcvSwitchRelayErrors"))
+			pc->errs_rcvswitchrelay = check_limit(&value, GS_PERF_ERR_SWITCH_REL_LIMIT);
+		else if(!strcasecmp(field, "PortXmitDiscards"))
+			pc->xmitdiscards = check_limit(&value, GS_PERF_XMT_DISCARDS_LIMIT);
+		else if(!strcasecmp(field, "PortXmitConstraintErrors"))
+			pc->errs_xmtconstraint = check_limit(&value, GS_PERF_ERR_XMTCONSTR_LIMIT);
+		else if(!strcasecmp(field, "PortRcvConstraintErrors"))
+			pc->errs_rcvconstraint = check_limit(&value, GS_PERF_ERR_RCVCONSTR_LIMIT);
+		else if(!strcasecmp(field, "LocalLinkIntegrityErrors"))
+			pc->errs_localinteg = check_limit(&value, GS_PERF_ERR_LOCALINTEG_LIMIT);
+		else if(!strcasecmp(field, "ExcessiveBufferOverrunErrors"))
+			pc->errs_excessbufovrrun = check_limit(&value, GS_PERF_ERR_EXCESS_OVR_LIMIT);
+		else if(!strcasecmp(field, "VL15Dropped"))
+			pc->vl15dropped = check_limit(&value, GS_PERF_VL15_DROPPED_LIMIT);
+		else if(!strcasecmp(field, "PortXmitData"))
+			pc->flow_xmt_bytes = check_limit(&value, GS_PERF_XMT_BYTES_LIMIT);
+		else if(!strcasecmp(field, "PortRcvData"))
+			pc->flow_rcv_bytes = check_limit(&value, GS_PERF_RCV_BYTES_LIMIT);
+		else if(!strcasecmp(field, "PortXmitPkts"))
+			pc->flow_xmt_pkts = check_limit(&value, GS_PERF_XMT_PKTS_LIMIT);
+		else if(!strcasecmp(field, "PortRcvPkts"))
+			pc->flow_rcv_pkts = check_limit(&value, GS_PERF_RCV_PKTS_LIMIT);
+		else if(!strcasecmp(field, "PortXmitWait"))
+			pc->xmt_wait = check_limit(&value, GS_PERF_XMT_WAIT_LIMIT);
+		else
+			goto field_not_found;
+	}
+	else if(!strcasecmp(attr, "PortCountersExtended"))
+	{
+		if(!strcasecmp(field, "PortXmitData"))
+			pc->ext_xmit_data = check_limit(&value, UINT64_MAX);
+		else if(!strcasecmp(field, "PortRcvData"))
+			pc->ext_recv_data = check_limit(&value, UINT64_MAX);
+		else if(!strcasecmp(field, "PortXmitPkts"))
+			pc->ext_xmit_pkts = check_limit(&value, UINT64_MAX);
+		else if(!strcasecmp(field, "PortRcvPkts"))
+			pc->ext_recv_pkts = check_limit(&value, UINT64_MAX);
+		else if(!strcasecmp(field, "PortUnicastXmitPkts"))
+			pc->ext_ucast_xmit = check_limit(&value, UINT64_MAX);
+		else if(!strcasecmp(field, "PortUnicastRcvPkts"))
+			pc->ext_ucast_recv = check_limit(&value, UINT64_MAX);
+		else if(!strcasecmp(field, "PortMultiCastXmitPkts"))
+			pc->ext_mcast_xmit = check_limit(&value, UINT64_MAX);
+		else if(!strcasecmp(field, "PortMultiCastRcvPkts"))
+			pc->ext_mcast_recv = check_limit(&value, UINT64_MAX);
+		else
+			goto field_not_found;
+	}
+	else if(!strcasecmp(attr, "PortRcvErrorDetails"))
+	{
+		if(!strcasecmp(field, "PortLocalPhysicalErrors"))
+			pc->rcv_error_details.PortLocalPhysicalErrors =
+				check_limit(&value, GS_PERF_LOCAL_PHYSICAL_ERRORS_LIMIT);
+		else if(!strcasecmp(field, "PortMalformedPacketErrors"))
+			pc->rcv_error_details.PortMalformedPacketErrors =
+				check_limit(&value, GS_PERF_MALFORMED_PACKET_ERRORS_LIMIT);
+		else if(!strcasecmp(field, "PortBufferOverrunErrors"))
+			pc->rcv_error_details.PortBufferOverrunErrors =
+				check_limit(&value, GS_PERF_BUFFER_OVERRUN_ERRORS_LIMIT);
+		else if(!strcasecmp(field, "PortDLIDMappingErrors"))
+			pc->rcv_error_details.PortDLIDMappingErrors =
+				check_limit(&value, GS_PERF_DLID_MAPPING_ERRORS_LIMIT);
+		else if(!strcasecmp(field, "PortVLMappingErrors"))
+			pc->rcv_error_details.PortVLMappingErrors =
+				check_limit(&value, GS_PERF_VL_MAPPING_ERRORS_LIMIT);
+		else if(!strcasecmp(field, "PortLoopingErrors"))
+			pc->rcv_error_details.PortLoopingErrors =
+				check_limit(&value, GS_PERF_LOOPING_ERRORS_LIMIT);
+		else
+			goto field_not_found;
+	}
+	else if(!strcasecmp(attr, "PortXmitDiscardDetails"))
+	{
+		if(!strcasecmp(field, "PortInactiveDiscards"))
+			pc->xmit_discard_details.PortInactiveDiscards =
+				check_limit(&value, GS_PERF_INACTIVE_DISCARDS_LIMIT);
+		else if(!strcasecmp(field, "PortNeighborMTUDiscards"))
+			pc->xmit_discard_details.PortNeighborMTUDiscards =
+				check_limit(&value, GS_PERF_NEIGHBOR_MTU_DISCARDS_LIMIT);
+		else if(!strcasecmp(field, "PortSwLifetimeLimitDiscards"))
+			pc->xmit_discard_details.PortSwLifetimeLimitDiscards =
+				check_limit(&value, GS_PERF_SW_LIFETIME_LIMIT_DISCARDS_LIMIT);
+		else if(!strcasecmp(field, "PortSwHOQLifetimeLimitDiscards"))
+			pc->xmit_discard_details.PortSwHOQLifetimeLimitDiscards =
+				check_limit(&value, GS_PERF_SW_HOQ_LIFETIME_LIMIT_DISCARDS_LIMIT);
+		else
+			goto field_not_found;
+	}
+	else if(!strcasecmp(attr, "PortOpRcvCounters"))
+	{
+		if(!strcasecmp(field, "PortOpRcvPkts"))
+			pc->op_rcv_counters.PortOpRcvPkts = check_limit(&value,
+				GS_PERF_OP_RCV_PKTS_LIMIT);
+		else if(!strcasecmp(field, "PortOpRcvData"))
+			pc->op_rcv_counters.PortOpRcvData = check_limit(&value,
+				GS_PERF_OP_RCV_DATA_LIMIT);
+		else
+			goto field_not_found;
+	}
+	else if(!strcasecmp(attr, "PortFlowCtlCounters"))
+	{
+		if(!strcasecmp(field, "PortXmitFlowPkts"))
+			pc->flow_ctl_counters.PortXmitFlowPkts =
+				check_limit(&value, GS_PERF_XMIT_FLOW_PKTS_LIMIT);
+		else if(!strcasecmp(field, "PortRcvFlowPkts"))
+			pc->flow_ctl_counters.PortRcvFlowPkts =
+				check_limit(&value, GS_PERF_RCV_FLOW_PKTS_LIMIT);
+		else
+			goto field_not_found;
+	}
+	else if(!strcasecmp(attr, "PortVLOpPackets"))
+	{
+		if(strstr(field, "PortVLOpPackets") != field)
+			goto field_not_found;
+		if(parse_vl_num(attr, field, &vl) < 0)
+			goto field_not_found;
+		pc->vl_op_packets.PortVLOpPackets[vl] =
+			check_limit(&value, GS_PERF_VL_OP_PACKETS_LIMIT);
+	}
+	else if(!strcasecmp(attr, "PortVLOpData"))
+	{
+		if(strstr(field, "PortVLOpData") != field)
+			goto field_not_found;
+		if(parse_vl_num(attr, field, &vl) < 0)
+			goto field_not_found;
+		pc->vl_op_data.PortVLOpData[vl] =
+			check_limit(&value, GS_PERF_VL_OP_DATA_LIMIT);
+	}
+	else if(!strcasecmp(attr, "PortVLXmitFlowCtlUpdateErrors"))
+	{
+		if(strstr(field, "PortVLXmitFlowCtlUpdateErrors") != field)
+			goto field_not_found;
+		if(parse_vl_num(attr, field, &vl) < 0)
+			goto field_not_found;
+		pc->vl_xmit_flow_ctl_update_errors.PortVLXmitFlowCtlUpdateErrors[vl] =
+			check_limit(&value, GS_PERF_VL_XMIT_FLOW_CTL_UPDATE_ERRORS);
+	}
+	else if(!strcasecmp(attr, "PortVLXmitWaitCounters"))
+	{
+		if(strstr(field, "PortVLXmitWaitCounters") != field)
+			goto field_not_found;
+		if(parse_vl_num(attr, field, &vl) < 0)
+			goto field_not_found;
+		pc->vl_xmit_wait_counters.PortVLXmitWait[vl] =
+			check_limit(&value, GS_PERF_VL_XMIT_WAIT_COUNTERS_LIMIT);
+	}
+	else
+	{
+		fprintf(f, "# attribute %s cannot be found\n", attr);
+		return -1;
+	}
+	fprintf(f, "%s.%s has been set to %"PRIu64"\n", attr, field, value);
+	return 0;
+field_not_found:
+	fprintf(f, "# field %s cannot be found in attribute %s\n", field, attr);
+	return -1;
+format_error:
+	fprintf(f, "# command does not match: PerformanceSet \"nodeid\"[port] [attribute].[field]=[value]\n");
+	return -1;
+}
+
 int netstarted;
 
 int do_cmd(char *buf, FILE *f)
@@ -907,6 +1179,8 @@ int do_cmd(char *buf, FILE *f)
 	 */
 	else if (!strncasecmp(line, "ReLink", cmd_len))
 		r = do_relink(f, line);
+	else if (!strncasecmp(line, "PerformanceSet", cmd_len))
+		r = do_perf_counter_set(f, line);
 	else if (*line != '\n' && *line != '\0')
 		fprintf(f, "command \'%s\' unknown - skipped\n", line);
 
-- 
1.7.10.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

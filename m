From: Jon Stanley <jonstanley-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] ibsim/sim_cmd: Fix compile errors
Date: Wed, 24 Oct 2012 22:37:57 -0400
Message-ID: <1351132677-11307-1-git-send-email-jonstanley@gmail.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Jon Stanley <jonstanley-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In the previous commit, lines which seemed not destined for
upstream prevented sim_cmd from building. Remove them.

Signed-off-by: Jon Stanley <jonstanley-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 ibsim/sim_cmd.c |   23 -----------------------
 1 files changed, 0 insertions(+), 23 deletions(-)

diff --git a/ibsim/sim_cmd.c b/ibsim/sim_cmd.c
index 7b2cdd0..f44df93 100644
--- a/ibsim/sim_cmd.c
+++ b/ibsim/sim_cmd.c
@@ -939,7 +939,6 @@ static int do_perf_counter_set(FILE *f, char *line)
 		return -1;
 	}
 	if(*val_error) {
-	{//REMOVE
 		fprintf(f, "# value %s is not valid integer\n", s);
 		return -1;
 	}
@@ -947,7 +946,6 @@ static int do_perf_counter_set(FILE *f, char *line)
 	pc = &(p->portcounters);
 
 	if(!strcasecmp(attr, "PortCounters")) {
-	{//REMOVE
 		if(!strcasecmp(field, "SymbolErrorCounter"))
 			pc->errs_sym = check_limit(&value, GS_PERF_ERR_SYM_LIMIT);
 		else if(!strcasecmp(field, "LinkErrorRecoveryCounter"))
@@ -984,9 +982,7 @@ static int do_perf_counter_set(FILE *f, char *line)
 			pc->xmt_wait = check_limit(&value, GS_PERF_XMT_WAIT_LIMIT);
 		else
 			goto field_not_found;
-	}//REMOVE
 	} else if(!strcasecmp(attr, "PortCountersExtended")) {
-	{//REMOVE
 		if(!strcasecmp(field, "PortXmitData"))
 			pc->ext_xmit_data = check_limit(&value, UINT64_MAX);
 		else if(!strcasecmp(field, "PortRcvData"))
@@ -1005,9 +1001,7 @@ static int do_perf_counter_set(FILE *f, char *line)
 			pc->ext_mcast_recv = check_limit(&value, UINT64_MAX);
 		else
 			goto field_not_found;
-	}//REMOVE
 	} else if(!strcasecmp(attr, "PortRcvErrorDetails")) {
-	{//REMOVE
 		if(!strcasecmp(field, "PortLocalPhysicalErrors"))
 			pc->rcv_error_details.PortLocalPhysicalErrors =
 				check_limit(&value, GS_PERF_LOCAL_PHYSICAL_ERRORS_LIMIT);
@@ -1028,9 +1022,7 @@ static int do_perf_counter_set(FILE *f, char *line)
 				check_limit(&value, GS_PERF_LOOPING_ERRORS_LIMIT);
 		else
 			goto field_not_found;
-	}//REMOVE
 	} else if(!strcasecmp(attr, "PortXmitDiscardDetails")) {
-	{//REMOVE
 		if(!strcasecmp(field, "PortInactiveDiscards"))
 			pc->xmit_discard_details.PortInactiveDiscards =
 				check_limit(&value, GS_PERF_INACTIVE_DISCARDS_LIMIT);
@@ -1045,9 +1037,7 @@ static int do_perf_counter_set(FILE *f, char *line)
 				check_limit(&value, GS_PERF_SW_HOQ_LIFETIME_LIMIT_DISCARDS_LIMIT);
 		else
 			goto field_not_found;
-	}//REMOVE
 	} else if(!strcasecmp(attr, "PortOpRcvCounters")) {
-	{//REMOVE
 		if(!strcasecmp(field, "PortOpRcvPkts"))
 			pc->op_rcv_counters.PortOpRcvPkts = check_limit(&value,
 				GS_PERF_OP_RCV_PKTS_LIMIT);
@@ -1056,9 +1046,7 @@ static int do_perf_counter_set(FILE *f, char *line)
 				GS_PERF_OP_RCV_DATA_LIMIT);
 		else
 			goto field_not_found;
-	}//REMOVE
 	} else if(!strcasecmp(attr, "PortFlowCtlCounters")) {
-	{//REMOVE
 		if(!strcasecmp(field, "PortXmitFlowPkts"))
 			pc->flow_ctl_counters.PortXmitFlowPkts =
 				check_limit(&value, GS_PERF_XMIT_FLOW_PKTS_LIMIT);
@@ -1067,46 +1055,35 @@ static int do_perf_counter_set(FILE *f, char *line)
 				check_limit(&value, GS_PERF_RCV_FLOW_PKTS_LIMIT);
 		else
 			goto field_not_found;
-	}//REMOVE
 	} else if(!strcasecmp(attr, "PortVLOpPackets")) {
-	{//REMOVE
 		if(strstr(field, "PortVLOpPackets") != field)
 			goto field_not_found;
 		if(parse_vl_num(attr, field, &vl) < 0)
 			goto field_not_found;
 		pc->vl_op_packets.PortVLOpPackets[vl] =
 			check_limit(&value, GS_PERF_VL_OP_PACKETS_LIMIT);
-	}//REMOVE
 	} else if(!strcasecmp(attr, "PortVLOpData")) {
-	{//REMOVE
 		if(strstr(field, "PortVLOpData") != field)
 			goto field_not_found;
 		if(parse_vl_num(attr, field, &vl) < 0)
 			goto field_not_found;
 		pc->vl_op_data.PortVLOpData[vl] =
 			check_limit(&value, GS_PERF_VL_OP_DATA_LIMIT);
-	}//REMOVE
 	} else if(!strcasecmp(attr, "PortVLXmitFlowCtlUpdateErrors")) {
-	{//REMOVE
 		if(strstr(field, "PortVLXmitFlowCtlUpdateErrors") != field)
 			goto field_not_found;
 		if(parse_vl_num(attr, field, &vl) < 0)
 			goto field_not_found;
 		pc->vl_xmit_flow_ctl_update_errors.PortVLXmitFlowCtlUpdateErrors[vl] =
 			check_limit(&value, GS_PERF_VL_XMIT_FLOW_CTL_UPDATE_ERRORS);
-	}//REMOVE
 	} else if(!strcasecmp(attr, "PortVLXmitWaitCounters")) {
-	{//REMOVE
 		if(strstr(field, "PortVLXmitWaitCounters") != field)
 			goto field_not_found;
 		if(parse_vl_num(attr, field, &vl) < 0)
 			goto field_not_found;
 		pc->vl_xmit_wait_counters.PortVLXmitWait[vl] =
 			check_limit(&value, GS_PERF_VL_XMIT_WAIT_COUNTERS_LIMIT);
-	}//REMOVE
 	} else {
-	{//REMOVE
-		fprintf(f, "# attribute %s cannot be found\n", attr);
 		return -1;
 	}
 	fprintf(f, "%s.%s has been set to %"PRIu64"\n", attr, field, value);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

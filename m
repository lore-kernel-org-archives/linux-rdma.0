From: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] libibmad/dump.c: clean up boundary conditions in dump routines
Date: Fri, 25 May 2012 15:33:01 -0700
Message-ID: <1337985181-25080-1-git-send-email-foraker1@llnl.gov>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: weiny2-i2BcT+NCU+M@public.gmane.org, Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

If mad_dump_field() exhausts the buffer, _dump_fields() would
accidentally write 1 byte beyond its end.  Additionally, several
functions call _dump_fields() repeatedly without checking for
a negative return; these could clobber memory before the buffer.

Signed-off-by: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
---
 src/dump.c |   53 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 52 insertions(+), 1 deletion(-)

diff --git a/src/dump.c b/src/dump.c
index d4512c0..9937a82 100644
--- a/src/dump.c
+++ b/src/dump.c
@@ -731,7 +731,7 @@ static int _dump_fields(char *buf, int bufsz, void *data, int start, int end)
 
 	for (field = start; field < end && bufsz > 0; field++) {
 		mad_decode_field(data, field, val);
-		if (!mad_dump_field(field, s, bufsz, val))
+		if (!mad_dump_field(field, s, bufsz-1, val))
 			return -1;
 		n = strlen(s);
 		s += n;
@@ -768,6 +768,9 @@ void mad_dump_portinfo(char *buf, int bufsz, void *val, int valsz)
 	int cnt;
 
 	cnt = _dump_fields(buf, bufsz, val, IB_PORT_FIRST_F, IB_PORT_LAST_F);
+	if (cnt < 0)
+		return;
+
 	_dump_fields(buf + cnt, bufsz - cnt, val,
 		     IB_PORT_CAPMASK2_F, IB_PORT_LINK_SPEED_EXT_LAST_F);
 }
@@ -798,6 +801,9 @@ void mad_dump_perfcounters_xmt_sl(char *buf, int bufsz, void *val, int valsz)
 
 	cnt = _dump_fields(buf, bufsz, val, IB_PC_EXT_PORT_SELECT_F,
 			   IB_PC_EXT_XMT_BYTES_F);
+	if (cnt < 0)
+		return;
+
 	_dump_fields(buf + cnt, bufsz - cnt, val, IB_PC_XMT_DATA_SL_FIRST_F,
 		     IB_PC_XMT_DATA_SL_LAST_F);
 }
@@ -808,6 +814,9 @@ void mad_dump_perfcounters_rcv_sl(char *buf, int bufsz, void *val, int valsz)
 
 	cnt = _dump_fields(buf, bufsz, val, IB_PC_EXT_PORT_SELECT_F,
 			   IB_PC_EXT_XMT_BYTES_F);
+	if (cnt < 0)
+		return;
+
 	_dump_fields(buf + cnt, bufsz - cnt, val, IB_PC_RCV_DATA_SL_FIRST_F,
 		     IB_PC_RCV_DATA_SL_LAST_F);
 }
@@ -818,6 +827,9 @@ void mad_dump_perfcounters_xmt_disc(char *buf, int bufsz, void *val, int valsz)
 
 	cnt = _dump_fields(buf, bufsz, val, IB_PC_EXT_PORT_SELECT_F,
 			   IB_PC_EXT_XMT_BYTES_F);
+	if (cnt < 0)
+		return;
+
 	_dump_fields(buf + cnt, bufsz - cnt, val, IB_PC_XMT_INACT_DISC_F,
 		     IB_PC_XMT_DISC_LAST_F);
 }
@@ -828,6 +840,9 @@ void mad_dump_perfcounters_rcv_err(char *buf, int bufsz, void *val, int valsz)
 
 	cnt = _dump_fields(buf, bufsz, val, IB_PC_EXT_PORT_SELECT_F,
 			   IB_PC_EXT_XMT_BYTES_F);
+	if (cnt < 0)
+		return;
+
 	_dump_fields(buf + cnt, bufsz - cnt, val, IB_PC_RCV_LOCAL_PHY_ERR_F,
 		     IB_PC_RCV_ERR_LAST_F);
 }
@@ -848,6 +863,9 @@ void mad_dump_perfcounters_port_op_rcv_counters(char *buf, int bufsz, void *val,
 
 	cnt = _dump_fields(buf, bufsz, val, IB_PC_EXT_PORT_SELECT_F,
 			   IB_PC_EXT_XMT_BYTES_F);
+	if (cnt < 0)
+		return;
+
 	_dump_fields(buf + cnt, bufsz - cnt, val, IB_PC_PORT_OP_RCV_COUNTERS_FIRST_F,
 		     IB_PC_PORT_OP_RCV_COUNTERS_LAST_F);
 }
@@ -858,6 +876,9 @@ void mad_dump_perfcounters_port_flow_ctl_counters(char *buf, int bufsz, void *va
 
 	cnt = _dump_fields(buf, bufsz, val, IB_PC_EXT_PORT_SELECT_F,
 			   IB_PC_EXT_XMT_BYTES_F);
+	if (cnt < 0)
+		return;
+
 	_dump_fields(buf + cnt, bufsz - cnt, val, IB_PC_PORT_FLOW_CTL_COUNTERS_FIRST_F,
 		     IB_PC_PORT_FLOW_CTL_COUNTERS_LAST_F);
 }
@@ -868,6 +889,9 @@ void mad_dump_perfcounters_port_vl_op_packet(char *buf, int bufsz, void *val, in
 
 	cnt = _dump_fields(buf, bufsz, val, IB_PC_EXT_PORT_SELECT_F,
 			   IB_PC_EXT_XMT_BYTES_F);
+	if (cnt < 0)
+		return;
+
 	_dump_fields(buf + cnt, bufsz - cnt, val, IB_PC_PORT_VL_OP_PACKETS_FIRST_F,
 		     IB_PC_PORT_VL_OP_PACKETS_LAST_F);
 }
@@ -878,6 +902,9 @@ void mad_dump_perfcounters_port_vl_op_data(char *buf, int bufsz, void *val, int
 
 	cnt = _dump_fields(buf, bufsz, val, IB_PC_EXT_PORT_SELECT_F,
 			   IB_PC_EXT_XMT_BYTES_F);
+	if (cnt < 0)
+		return;
+
 	_dump_fields(buf + cnt, bufsz - cnt, val, IB_PC_PORT_VL_OP_DATA_FIRST_F,
 		     IB_PC_PORT_VL_OP_DATA_LAST_F);
 }
@@ -888,6 +915,9 @@ void mad_dump_perfcounters_port_vl_xmit_flow_ctl_update_errors(char *buf, int bu
 
 	cnt = _dump_fields(buf, bufsz, val, IB_PC_EXT_PORT_SELECT_F,
 			   IB_PC_EXT_XMT_BYTES_F);
+	if (cnt < 0)
+		return;
+
 	_dump_fields(buf + cnt, bufsz - cnt, val, IB_PC_PORT_VL_XMIT_FLOW_CTL_UPDATE_ERRORS_FIRST_F,
 		     IB_PC_PORT_VL_XMIT_FLOW_CTL_UPDATE_ERRORS_LAST_F);
 }
@@ -898,6 +928,9 @@ void mad_dump_perfcounters_port_vl_xmit_wait_counters(char *buf, int bufsz, void
 
 	cnt = _dump_fields(buf, bufsz, val, IB_PC_EXT_PORT_SELECT_F,
 			   IB_PC_EXT_XMT_BYTES_F);
+	if (cnt < 0)
+		return;
+
 	_dump_fields(buf + cnt, bufsz - cnt, val, IB_PC_PORT_VL_XMIT_WAIT_COUNTERS_FIRST_F,
 		     IB_PC_PORT_VL_XMIT_WAIT_COUNTERS_LAST_F);
 }
@@ -908,6 +941,9 @@ void mad_dump_perfcounters_sw_port_vl_congestion(char *buf, int bufsz, void *val
 
 	cnt = _dump_fields(buf, bufsz, val, IB_PC_EXT_PORT_SELECT_F,
 			   IB_PC_EXT_XMT_BYTES_F);
+	if (cnt < 0)
+		return;
+
 	_dump_fields(buf + cnt, bufsz - cnt, val, IB_PC_SW_PORT_VL_CONGESTION_FIRST_F,
 		     IB_PC_SW_PORT_VL_CONGESTION_LAST_F);
 }
@@ -918,6 +954,9 @@ void mad_dump_perfcounters_rcv_con_ctrl(char *buf, int bufsz, void *val, int val
 
 	cnt = _dump_fields(buf, bufsz, val, IB_PC_EXT_PORT_SELECT_F,
 			   IB_PC_EXT_XMT_BYTES_F);
+	if (cnt < 0)
+		return;
+
 	_dump_fields(buf + cnt, bufsz - cnt, val, IB_PC_RCV_CON_CTRL_FIRST_F,
 		     IB_PC_RCV_CON_CTRL_LAST_F);
 }
@@ -929,6 +968,9 @@ void mad_dump_perfcounters_sl_rcv_fecn(char *buf, int bufsz, void *val, int vals
 
 	cnt = _dump_fields(buf, bufsz, val, IB_PC_EXT_PORT_SELECT_F,
 			   IB_PC_EXT_XMT_BYTES_F);
+	if (cnt < 0)
+		return;
+
 	_dump_fields(buf + cnt, bufsz - cnt, val, IB_PC_SL_RCV_FECN_FIRST_F,
 		     IB_PC_SL_RCV_FECN_LAST_F);
 }
@@ -939,6 +981,9 @@ void mad_dump_perfcounters_sl_rcv_becn(char *buf, int bufsz, void *val, int vals
 
 	cnt = _dump_fields(buf, bufsz, val, IB_PC_EXT_PORT_SELECT_F,
 			   IB_PC_EXT_XMT_BYTES_F);
+	if (cnt < 0)
+		return;
+
 	_dump_fields(buf + cnt, bufsz - cnt, val, IB_PC_SL_RCV_BECN_FIRST_F,
 		     IB_PC_SL_RCV_BECN_LAST_F);
 }
@@ -949,6 +994,9 @@ void mad_dump_perfcounters_xmit_con_ctrl(char *buf, int bufsz, void *val, int va
 
 	cnt = _dump_fields(buf, bufsz, val, IB_PC_EXT_PORT_SELECT_F,
 			   IB_PC_EXT_XMT_BYTES_F);
+	if (cnt < 0)
+		return;
+
 	_dump_fields(buf + cnt, bufsz - cnt, val, IB_PC_XMIT_CON_CTRL_FIRST_F,
 		     IB_PC_XMIT_CON_CTRL_LAST_F);
 }
@@ -959,6 +1007,9 @@ void mad_dump_perfcounters_vl_xmit_time_cong(char *buf, int bufsz, void *val, in
 
 	cnt = _dump_fields(buf, bufsz, val, IB_PC_EXT_PORT_SELECT_F,
 			   IB_PC_EXT_XMT_BYTES_F);
+	if (cnt < 0)
+		return;
+
 	_dump_fields(buf + cnt, bufsz - cnt, val, IB_PC_VL_XMIT_TIME_CONG_FIRST_F,
 		     IB_PC_VL_XMIT_TIME_CONG_LAST_F);
 }
-- 
1.7.9.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

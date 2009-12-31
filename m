From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCH] libibmad: Add support for optional PortRcvErrorDetails
	counter
Date: Thu, 31 Dec 2009 11:57:34 -0500
Message-ID: <20091231165734.GA9123@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
diff --git a/libibmad/include/infiniband/mad.h b/libibmad/include/infiniband/mad.h
index b9f42c0..cadce6c 100644
--- a/libibmad/include/infiniband/mad.h
+++ b/libibmad/include/infiniband/mad.h
@@ -168,6 +168,7 @@ enum GSI_ATTR_ID {
 	IB_GSI_PORT_SAMPLES_CONTROL = 0x10,
 	IB_GSI_PORT_SAMPLES_RESULT = 0x11,
 	IB_GSI_PORT_COUNTERS = 0x12,
+	IB_GSI_PORT_RCV_ERROR_DETAILS = 0x15,
 	IB_GSI_PORT_XMIT_DISCARD_DETAILS = 0x16,
 	IB_GSI_PORT_COUNTERS_EXT = 0x1D,
 	IB_GSI_PORT_XMIT_DATA_SL = 0x36,
@@ -659,6 +660,17 @@ enum MAD_FIELDS {
 	IB_PC_XMT_SW_HOL_DISC_F,
 	IB_PC_XMT_DISC_LAST_F,
 
+	/*
+	 * PortRcvErrorDetails fields
+	 */
+	IB_PC_RCV_LOCAL_PHY_ERR_F,
+	IB_PC_RCV_MALFORMED_PKT_ERR_F,
+	IB_PC_RCV_BUF_OVR_ERR_F,
+	IB_PC_RCV_DLID_MAP_ERR_F,
+	IB_PC_RCV_VL_MAP_ERR_F,
+	IB_PC_RCV_LOOPING_ERR_F,
+	IB_PC_RCV_ERR_LAST_F,
+
 	IB_FIELD_LAST_		/* must be last */
 };
 
@@ -981,7 +993,7 @@ MAD_EXPORT ib_mad_dump_fn
     mad_dump_nodedesc, mad_dump_nodeinfo, mad_dump_portinfo,
     mad_dump_switchinfo, mad_dump_perfcounters, mad_dump_perfcounters_ext,
     mad_dump_perfcounters_xmt_sl, mad_dump_perfcounters_rcv_sl,
-    mad_dump_perfcounters_xmt_disc;
+    mad_dump_perfcounters_xmt_disc, mad_dump_perfcounters_rcv_err;
 
 MAD_EXPORT int ibdebug;
 
diff --git a/libibmad/src/dump.c b/libibmad/src/dump.c
index 3039f03..13524e3 100644
--- a/libibmad/src/dump.c
+++ b/libibmad/src/dump.c
@@ -739,6 +739,16 @@ void mad_dump_perfcounters_xmt_disc(char *buf, int bufsz, void *val, int valsz)
 		     IB_PC_XMT_DISC_LAST_F);
 }
 
+void mad_dump_perfcounters_rcv_err(char *buf, int bufsz, void *val, int valsz)
+{
+	int cnt;
+
+	cnt = _dump_fields(buf, bufsz, val, IB_PC_EXT_PORT_SELECT_F,
+			   IB_PC_EXT_XMT_BYTES_F);
+	_dump_fields(buf + cnt, bufsz - cnt, val, IB_PC_RCV_LOCAL_PHY_ERR_F,
+		     IB_PC_RCV_ERR_LAST_F);
+}
+
 void xdump(FILE * file, char *msg, void *p, int size)
 {
 #define HEX(x)  ((x) < 10 ? '0' + (x) : 'a' + ((x) -10))
diff --git a/libibmad/src/fields.c b/libibmad/src/fields.c
index c2f9585..d6f63cd 100644
--- a/libibmad/src/fields.c
+++ b/libibmad/src/fields.c
@@ -458,6 +458,17 @@ static const ib_field_t ib_mad_f[] = {
 	{80, 16, "PortSwHOQLifetimeLimitDiscards", mad_dump_uint},
 	{0, 0},			/* IB_PC_XMT_DISC_LAST_F */
 
+	/*
+	 * PortRcvErrorDetails fields
+	 */
+	{32, 16, "PortLocalPhysicalErrors", mad_dump_uint},
+	{48, 16, "PortMalformedPktErrors", mad_dump_uint},
+	{64, 16, "PortBufferOverrunErrors", mad_dump_uint},
+	{80, 16, "PortDLIDMappingErrors", mad_dump_uint},
+	{96, 16, "PortVLMappingErrors", mad_dump_uint},
+	{112, 16, "PortLoopingErrors", mad_dump_uint},
+	{0, 0},                 /* IB_PC_RCV_ERR_LAST_F */
+
 	{0, 0}			/* IB_FIELD_LAST_ */
 
 };
diff --git a/libibmad/src/libibmad.map b/libibmad/src/libibmad.map
index 2a6a253..a9e5fcd 100644
--- a/libibmad/src/libibmad.map
+++ b/libibmad/src/libibmad.map
@@ -25,6 +25,7 @@ IBMAD_1.3 {
 		mad_dump_perfcounters_xmt_sl;
 		mad_dump_perfcounters_rcv_sl;
 		mad_dump_perfcounters_xmt_disc;
+		mad_dump_perfcounters_rcv_err;
 		mad_dump_physportstate;
 		mad_dump_portcapmask;
 		mad_dump_portinfo;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

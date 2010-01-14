From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCH] libibmad: Add support for PortSamplesControl counter
Date: Thu, 14 Jan 2010 09:11:56 -0500
Message-ID: <20100114141156.GA12180@comcast.net>
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
index cadce6c..02ef551 100644
--- a/libibmad/include/infiniband/mad.h
+++ b/libibmad/include/infiniband/mad.h
@@ -671,6 +671,41 @@ enum MAD_FIELDS {
 	IB_PC_RCV_LOOPING_ERR_F,
 	IB_PC_RCV_ERR_LAST_F,
 
+	/*
+	 * PortSamplesControl fields
+	 */
+	IB_PSC_OPCODE_F,
+	IB_PSC_PORT_SELECT_F,
+	IB_PSC_TICK_F,
+	IB_PSC_COUNTER_WIDTH_F,
+	IB_PSC_COUNTER_MASK0_F,
+	IB_PSC_COUNTER_MASKS1TO9_F,
+	IB_PSC_COUNTER_MASKS10TO14_F,
+	IB_PSC_SAMPLE_MECHS_F,
+	IB_PSC_SAMPLE_STATUS_F,
+	IB_PSC_OPTION_MASK_F,
+	IB_PSC_VENDOR_MASK_F,
+	IB_PSC_SAMPLE_START_F,
+	IB_PSC_SAMPLE_INTVL_F,
+	IB_PSC_TAG_F,
+	IB_PSC_COUNTER_SEL0_F,
+	IB_PSC_COUNTER_SEL1_F,
+	IB_PSC_COUNTER_SEL2_F,
+	IB_PSC_COUNTER_SEL3_F,
+	IB_PSC_COUNTER_SEL4_F,
+	IB_PSC_COUNTER_SEL5_F,
+	IB_PSC_COUNTER_SEL6_F,
+	IB_PSC_COUNTER_SEL7_F,
+	IB_PSC_COUNTER_SEL8_F,
+	IB_PSC_COUNTER_SEL9_F,
+	IB_PSC_COUNTER_SEL10_F,
+	IB_PSC_COUNTER_SEL11_F,
+	IB_PSC_COUNTER_SEL12_F,
+	IB_PSC_COUNTER_SEL13_F,
+	IB_PSC_COUNTER_SEL14_F,
+	IB_PSC_SAMPLES_ONLY_OPT_MASK_F,
+	IB_PSC_LAST_F,
+
 	IB_FIELD_LAST_		/* must be last */
 };
 
@@ -993,7 +1028,8 @@ MAD_EXPORT ib_mad_dump_fn
     mad_dump_nodedesc, mad_dump_nodeinfo, mad_dump_portinfo,
     mad_dump_switchinfo, mad_dump_perfcounters, mad_dump_perfcounters_ext,
     mad_dump_perfcounters_xmt_sl, mad_dump_perfcounters_rcv_sl,
-    mad_dump_perfcounters_xmt_disc, mad_dump_perfcounters_rcv_err;
+    mad_dump_perfcounters_xmt_disc, mad_dump_perfcounters_rcv_err,
+    mad_dump_portsamples_control;
 
 MAD_EXPORT int ibdebug;
 
diff --git a/libibmad/src/dump.c b/libibmad/src/dump.c
index 13524e3..335e190 100644
--- a/libibmad/src/dump.c
+++ b/libibmad/src/dump.c
@@ -749,6 +749,11 @@ void mad_dump_perfcounters_rcv_err(char *buf, int bufsz, void *val, int valsz)
 		     IB_PC_RCV_ERR_LAST_F);
 }
 
+void mad_dump_portsamples_control(char *buf, int bufsz, void *val, int valsz)
+{
+	_dump_fields(buf, bufsz, val, IB_PSC_OPCODE_F, IB_PSC_LAST_F);
+}
+
 void xdump(FILE * file, char *msg, void *p, int size)
 {
 #define HEX(x)  ((x) < 10 ? '0' + (x) : 'a' + ((x) -10))
diff --git a/libibmad/src/fields.c b/libibmad/src/fields.c
index d6f63cd..a5a510a 100644
--- a/libibmad/src/fields.c
+++ b/libibmad/src/fields.c
@@ -469,6 +469,41 @@ static const ib_field_t ib_mad_f[] = {
 	{112, 16, "PortLoopingErrors", mad_dump_uint},
 	{0, 0},                 /* IB_PC_RCV_ERR_LAST_F */
 
+	/*
+	 * PortSamplesControl fields
+	 */
+	{BITSOFFS(0, 8), "OpCode", mad_dump_hex},
+	{BITSOFFS(8, 8), "PortSelect", mad_dump_uint},
+	{BITSOFFS(16, 8), "Tick", mad_dump_hex},
+	{BITSOFFS(29, 3), "CounterWidth", mad_dump_uint},
+	{BITSOFFS(34, 3), "CounterMask0", mad_dump_hex},
+	{BITSOFFS(37, 27), "CounterMasks1to9", mad_dump_hex},
+	{BITSOFFS(65, 15), "CounterMasks10to14", mad_dump_hex},
+	{BITSOFFS(80, 8), "SampleMechanisms", mad_dump_uint},
+	{BITSOFFS(94, 2), "SampleStatus", mad_dump_uint},
+	{96, 64, "OptionMask", mad_dump_hex},
+	{160, 64, "VendorMask", mad_dump_hex},
+	{224, 32, "SampleStart", mad_dump_uint},
+	{256, 32, "SampleInterval", mad_dump_uint},
+	{288, 16, "Tag", mad_dump_hex},
+	{304, 16, "CounterSelect0", mad_dump_hex},
+	{320, 16, "CounterSelect1", mad_dump_hex},
+	{336, 16, "CounterSelect2", mad_dump_hex},
+	{352, 16, "CounterSelect3", mad_dump_hex},
+	{368, 16, "CounterSelect4", mad_dump_hex},
+	{384, 16, "CounterSelect5", mad_dump_hex},
+	{400, 16, "CounterSelect6", mad_dump_hex},
+	{416, 16, "CounterSelect7", mad_dump_hex},
+	{432, 16, "CounterSelect8", mad_dump_hex},
+	{448, 16, "CounterSelect9", mad_dump_hex},
+	{464, 16, "CounterSelect10", mad_dump_hex},
+	{480, 16, "CounterSelect11", mad_dump_hex},
+	{496, 16, "CounterSelect12", mad_dump_hex},
+	{512, 16, "CounterSelect13", mad_dump_hex},
+	{528, 16, "CounterSelect14", mad_dump_hex},
+	{576, 64, "SamplesOnlyOptionMask", mad_dump_hex},
+	{0, 0},			/* IB_PSC_LAST_F */
+
 	{0, 0}			/* IB_FIELD_LAST_ */
 
 };
diff --git a/libibmad/src/libibmad.map b/libibmad/src/libibmad.map
index a9e5fcd..e2d0b05 100644
--- a/libibmad/src/libibmad.map
+++ b/libibmad/src/libibmad.map
@@ -29,6 +29,7 @@ IBMAD_1.3 {
 		mad_dump_physportstate;
 		mad_dump_portcapmask;
 		mad_dump_portinfo;
+		mad_dump_portsamples_control;
 		mad_dump_portstates;
 		mad_dump_portstate;
 		mad_dump_rhex;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

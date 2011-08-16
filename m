From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] infiniband-diags/saquery: Add extended link speed support
 for PortInfoRecord queries
Date: Mon, 15 Aug 2011 20:18:51 -0400
Message-ID: <4E49B76B.8010403@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/man/saquery.8 b/man/saquery.8
index 4a3102d..56fbbee 100644
--- a/man/saquery.8
+++ b/man/saquery.8
@@ -1,4 +1,4 @@
-.TH SAQUERY 8 "March 28, 2010" "OpenIB" "OpenIB Diagnostics"
+.TH SAQUERY 8 "March 14, 2011" "OpenIB" "OpenIB Diagnostics"
 
 .SH NAME
 saquery \- query InfiniBand subnet administration attributes
@@ -106,7 +106,7 @@ options.
 Supported query names (and aliases):
  ClassPortInfo (CPI)
  NodeRecord (NR) [lid]
- PortInfoRecord (PIR) [[lid]/[port]]
+ PortInfoRecord (PIR) [[lid]/[port]/[options]]
  SL2VLTableRecord (SL2VL) [[lid]/[in_port]/[out_port]]
  PKeyTableRecord (PKTR) [[lid]/[port]/[block]]
  VLArbitrationTableRecord (VLAR) [[lid]/[port]/[block]]
diff --git a/src/saquery.c b/src/saquery.c
index f82772f..bdf5e9a 100644
--- a/src/saquery.c
+++ b/src/saquery.c
@@ -1,7 +1,7 @@
 /*
  * Copyright (c) 2006,2007 The Regents of the University of California.
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2010 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 2002-2011 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  * Copyright (c) 2009 HNR Consulting. All rights reserved.
  *
@@ -1074,14 +1074,15 @@ static int query_portinfo_records(const struct query_cmd *q,
 {
 	ib_portinfo_record_t pir;
 	ib_net64_t comp_mask = 0;
-	int lid = 0, port = -1;
+	int lid = 0, port = -1, options = -1;
 
 	if (argc > 0)
-		parse_lid_and_ports(h, argv[0], &lid, &port, NULL);
+		parse_lid_and_ports(h, argv[0], &lid, &port, &options);
 
 	memset(&pir, 0, sizeof(pir));
 	CHECK_AND_SET_VAL(lid, 16, 0, pir.lid, PIR, LID);
 	CHECK_AND_SET_VAL(port, 8, -1, pir.port_num, PIR, PORTNUM);
+	CHECK_AND_SET_VAL(options, 8, -1, pir.options, PIR, OPTIONS);
 
 	return get_and_dump_any_records(h, IB_SA_ATTR_PORTINFORECORD, 0,
 					comp_mask, &pir, 0,
@@ -1284,7 +1285,7 @@ static const struct query_cmd query_cmds[] = {
 	{"NodeRecord", "NR", IB_SA_ATTR_NODERECORD,
 	 "[lid]", query_node_records},
 	{"PortInfoRecord", "PIR", IB_SA_ATTR_PORTINFORECORD,
-	 "[[lid]/[port]]", query_portinfo_records},
+	 "[[lid]/[port]/[options]]", query_portinfo_records},
 	{"SL2VLTableRecord", "SL2VL", IB_SA_ATTR_SL2VLTABLERECORD,
 	 "[[lid]/[in_port]/[out_port]]", query_sl2vl_records},
 	{"PKeyTableRecord", "PKTR", IB_SA_ATTR_PKEYTABLERECORD,
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

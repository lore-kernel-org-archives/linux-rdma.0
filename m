From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCHv2 2/2] infiniband-diags/smpquery: Add Mellanox extended portinfo
 query
Date: Fri, 22 Jul 2011 10:05:51 -0400
Message-ID: <4E2983BF.80906@dev.mellanox.co.il>
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
Changes since v1:
Added man page change

diff --git a/man/smpquery.8 b/man/smpquery.8
index 3b69e8a..2ba2ef2 100644
--- a/man/smpquery.8
+++ b/man/smpquery.8
@@ -1,4 +1,4 @@
-.TH SMPQUERY 8 "March 14, 2007" "OpenIB" "OpenIB Diagnostics"
+.TH SMPQUERY 8 "March 9, 2011" "OpenIB" "OpenIB Diagnostics"
 
 .SH NAME
 smpquery \- query InfiniBand subnet management attributes
@@ -29,6 +29,7 @@ Current supported operations and their parameters:
         sl2vl <addr> [<portnum>]
         vlarb <addr> [<portnum>]
         guids <addr>
+        extportinfo <addr> [<portnum>]  # default port is zero
 
 .TP
 \fB\-\-node\-name\-map\fR <node-name-map>
@@ -113,4 +114,4 @@ smpquery -c nodeinfo 6 0,12  # nodeinfo by combined route
 .SH AUTHOR
 .TP
 Hal Rosenstock
-.RI < halr-smomgflXvOZWk0Htik3J/w@public.gmane.org >
+.RI < hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org >
diff --git a/src/smpquery.c b/src/smpquery.c
index 65bb65c..04cd925 100644
--- a/src/smpquery.c
+++ b/src/smpquery.c
@@ -63,7 +63,7 @@ typedef struct match_rec {
 } match_rec_t;
 
 static op_fn_t node_desc, node_info, port_info, switch_info, pkey_table,
-    sl2vl_table, vlarb_table, guid_info;
+    sl2vl_table, vlarb_table, guid_info, ext_port_info;
 
 static const match_rec_t match_tbl[] = {
 	{"NodeInfo", "NI", node_info},
@@ -74,6 +74,7 @@ static const match_rec_t match_tbl[] = {
 	{"SL2VLTable", "SL2VL", sl2vl_table, 1},
 	{"VLArbitration", "VLArb", vlarb_table, 1},
 	{"GUIDInfo", "GI", guid_info},
+	{"ExtPortInfo", "EPI", ext_port_info, 1},
 	{0}
 };
 
@@ -147,6 +148,24 @@ static char *port_info(ib_portid_t * dest, char **argv, int argc)
 	return 0;
 }
 
+static char *ext_port_info(ib_portid_t * dest, char **argv, int argc)
+{
+	char buf[2300];
+	char data[IB_SMP_DATA_SIZE];
+	int portnum = 0;
+
+	if (argc > 0)
+		portnum = strtol(argv[0], 0, 0);
+
+	if (!smp_query_via(data, dest, IB_ATTR_MLNX_EXT_PORT_INFO, portnum, 0, srcport))
+		return "ext port info query failed";
+
+	mad_dump_mlnx_ext_port_info(buf, sizeof buf, data, sizeof data);
+
+	printf("# Ext Port info: %s port %d\n%s", portid2str(dest), portnum, buf);
+	return 0;
+}
+
 static char *switch_info(ib_portid_t * dest, char **argv, int argc)
 {
 	char buf[2048];
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

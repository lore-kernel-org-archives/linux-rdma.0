From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 2/2] infiniband-diags/smpquery.c: Add Mellanox extended portinfo
 query
Date: Fri, 22 Jul 2011 07:22:13 -0400
Message-ID: <4E295D65.7000107@dev.mellanox.co.il>
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

From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCH] infiniband-diags/saquery.c: Change lids and port numbers
	to decimal
Date: Fri, 6 Nov 2009 15:32:25 -0500
Message-ID: <20091106203225.GA13461@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


rather than hex

Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
diff --git a/infiniband-diags/src/saquery.c b/infiniband-diags/src/saquery.c
index 091125d..da28d17 100644
--- a/infiniband-diags/src/saquery.c
+++ b/infiniband-diags/src/saquery.c
@@ -279,14 +279,14 @@ static void dump_node_record(void *data)
 	       "\t\tbase_version............0x%X\n"
 	       "\t\tclass_version...........0x%X\n"
 	       "\t\tnode_type...............%s\n"
-	       "\t\tnum_ports...............0x%X\n"
+	       "\t\tnum_ports...............%u\n"
 	       "\t\tsys_guid................0x%016" PRIx64 "\n"
 	       "\t\tnode_guid...............0x%016" PRIx64 "\n"
 	       "\t\tport_guid...............0x%016" PRIx64 "\n"
 	       "\t\tpartition_cap...........0x%X\n"
 	       "\t\tdevice_id...............0x%X\n"
 	       "\t\trevision................0x%X\n"
-	       "\t\tport_num................0x%X\n"
+	       "\t\tport_num................%u\n"
 	       "\t\tvendor_id...............0x%X\n"
 	       "\t\tNodeDescription.........%s\n",
 	       cl_ntoh16(nr->lid), cl_ntoh16(nr->resv),
@@ -339,8 +339,8 @@ static void dump_path_record(void *data)
 	       "\t\tservice_id..............0x%016" PRIx64 "\n"
 	       "\t\tdgid....................%s\n"
 	       "\t\tsgid....................%s\n"
-	       "\t\tdlid....................0x%X\n"
-	       "\t\tslid....................0x%X\n"
+	       "\t\tdlid....................%u\n"
+	       "\t\tslid....................%u\n"
 	       "\t\thop_flow_raw............0x%X\n"
 	       "\t\ttclass..................0x%X\n"
 	       "\t\tnum_path_revers.........0x%X\n"
@@ -407,9 +407,9 @@ static void dump_portinfo_record(void *data)
 
 	printf("PortInfoRecord dump:\n"
 	       "\t\tEndPortLid..............%u\n"
-	       "\t\tPortNum.................0x%X\n"
-	       "\t\tbase_lid................0x%X\n"
-	       "\t\tmaster_sm_base_lid......0x%X\n"
+	       "\t\tPortNum.................%u\n"
+	       "\t\tbase_lid................%u\n"
+	       "\t\tmaster_sm_base_lid......%u\n"
 	       "\t\tcapability_mask.........0x%X\n",
 	       cl_ntoh16(p_pir->lid), p_pir->port_num,
 	       cl_ntoh16(p_pi->base_lid), cl_ntoh16(p_pi->master_sm_base_lid),
@@ -427,7 +427,7 @@ static void dump_one_portinfo_record(void *data)
 	printf("PortInfoRecord dump:\n"
 	       "\tRID:\n"
 	       "\t\tEndPortLid..............%u\n"
-	       "\t\tPortNum.................0x%x\n"
+	       "\t\tPortNum.................%u\n"
 	       "\t\tReserved................0x%x\n"
 	       "\tPortInfo dump:\n\t\t%s",
 	       cl_ntoh16(pir->lid), pir->port_num, pir->resv, buf2);
@@ -630,8 +630,8 @@ static void dump_inform_info_record(void *data)
 		       "\t\tSubscriberEnum..........0x%X\n"
 		       "\t\tInformInfo dump:\n"
 		       "\t\tgid.....................%s\n"
-		       "\t\tlid_range_begin.........0x%X\n"
-		       "\t\tlid_range_end...........0x%X\n"
+		       "\t\tlid_range_begin.........%u\n"
+		       "\t\tlid_range_end...........%u\n"
 		       "\t\tis_generic..............0x%X\n"
 		       "\t\tsubscribe...............0x%X\n"
 		       "\t\ttrap_type...............0x%X\n"
@@ -660,8 +660,8 @@ static void dump_inform_info_record(void *data)
 		       "\t\tSubscriberEnum..........0x%X\n"
 		       "\t\tInformInfo dump:\n"
 		       "\t\tgid.....................%s\n"
-		       "\t\tlid_range_begin.........0x%X\n"
-		       "\t\tlid_range_end...........0x%X\n"
+		       "\t\tlid_range_begin.........%u\n"
+		       "\t\tlid_range_end...........%u\n"
 		       "\t\tis_generic..............0x%X\n"
 		       "\t\tsubscribe...............0x%X\n"
 		       "\t\ttrap_type...............0x%X\n"
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

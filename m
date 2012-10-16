From: Dan Ben Yosef <danby-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] infiniband-diags/src/saquery.c: New option to saquery InformInfoRecord (IIR)
Date: Tue, 16 Oct 2012 11:45:25 +0200
Message-ID: <1350380725-31221-1-git-send-email-danby@dev.mellanox.co.il>
References: <danby@dev.mellanox.co.il>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <danby-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add the option to display the InformInfoRecord by SubscriberGid

Signed-off-by: Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/saquery.c |   30 ++++++++++++++++++++++++++----
 1 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/src/saquery.c b/src/saquery.c
index 60c78ed..f13def9 100644
--- a/src/saquery.c
+++ b/src/saquery.c
@@ -841,6 +841,16 @@ static uint16_t get_lid(struct sa_handle * h, const char *name)
 	return rc_lid;
 }
 
+static int parse_iir_subscriber_gid(char *str, ib_inform_info_record_t *ir)
+{
+       int rc = inet_pton(AF_INET6,str,&(ir->subscriber_gid.raw));
+       if(rc < 1){
+          fprintf(stderr, "Failed to find InformInfoRecord SubscriberGID for \"%s\"\n",str);
+          exit(EINVAL);
+       }
+       return rc;
+}
+
 static int parse_lid_and_ports(struct sa_handle * h,
 			       char *str, int *lid, int *port1, int *port2)
 {
@@ -1140,12 +1150,24 @@ static int query_service_records(const struct query_cmd *q, struct sa_handle * h
 					dump_service_record);
 }
 
-static int query_informinfo_records(const struct query_cmd *q,
+static int query_inform_info_records(const struct query_cmd *q,
 				    struct sa_handle * h, struct query_params *p,
 				    int argc, char *argv[])
 {
-	return get_and_dump_all_records(h, IB_SA_ATTR_INFORMINFORECORD,
-					dump_inform_info_record);
+       int rc = 0;
+       ib_inform_info_record_t ir;
+       ib_net64_t comp_mask = 0;
+       memset(&ir, 0, sizeof(ir));
+
+       if (argc > 0) {
+           comp_mask = IB_IIR_COMPMASK_SUBSCRIBERGID;
+           if(rc = parse_iir_subscriber_gid(argv[0], &ir) < 1)
+                 return rc;
+       }
+
+       return get_and_dump_any_records(h, IB_SA_ATTR_INFORMINFORECORD, 0, comp_mask,
+				       &ir, sizeof(ir), dump_inform_info_record);
+
 }
 
 static int query_link_records(const struct query_cmd *q, struct sa_handle * h,
@@ -1305,7 +1327,7 @@ static const struct query_cmd query_cmds[] = {
 	{"VLArbitrationTableRecord", "VLAR", IB_SA_ATTR_VLARBTABLERECORD,
 	 "[[lid]/[port]/[block]]", query_vlarb_records},
 	{"InformInfoRecord", "IIR", IB_SA_ATTR_INFORMINFORECORD,
-	 NULL, query_informinfo_records},
+	 "[subscriber_gid]", query_inform_info_records},
 	{"LinkRecord", "LR", IB_SA_ATTR_LINKRECORD,
 	 "[[from_lid]/[from_port]] [[to_lid]/[to_port]]", query_link_records},
 	{"ServiceRecord", "SR", IB_SA_ATTR_SERVICERECORD,
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

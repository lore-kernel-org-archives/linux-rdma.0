From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osm_helper: Add osm_dump_guid_info
Date: Tue, 05 Apr 2011 14:24:24 -0400
Message-ID: <4D9B5E58.80205@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Add routine to dump SM GUIDInfo attribute

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/include/opensm/osm_helper.h b/include/opensm/osm_helper.h
index 9abbd61..f11fdee 100644
--- a/include/opensm/osm_helper.h
+++ b/include/opensm/osm_helper.h
@@ -241,6 +241,47 @@ void osm_dump_port_info(IN osm_log_t * p_log, IN ib_net64_t node_guid,
 * SEE ALSO
 *********/
 
+/****f* OpenSM: Helper/osm_dump_guid_info
+* NAME
+*	osm_dump_guid_info
+*
+* DESCRIPTION
+*	Dumps the GUIDInfo attribute to the log.
+*
+* SYNOPSIS
+*/
+void osm_dump_guid_info(IN osm_log_t * p_log, IN ib_net64_t node_guid,
+			IN ib_net64_t port_guid, IN uint8_t block_num,
+			IN const ib_guid_info_t * p_gi,
+			IN osm_log_level_t log_level);
+/*
+* PARAMETERS
+*	p_log
+*		[in] Pointer to the osm_log_t object.
+*
+*	node_guid
+*		[in] Node GUID that owns this port.
+*
+*	port_guid
+*		[in] Port GUID for this port.
+*
+*	block_num
+*		[in] Block number.
+*
+*	p_gi
+*		[in] Pointer to the GUIDInfo attribute.
+*
+*	log_level
+*		[in] Log verbosity level with which to dump the data.
+*
+* RETURN VALUES
+*	None.
+*
+* NOTES
+*
+* SEE ALSO
+*********/
+
 void osm_dump_path_record(IN osm_log_t * p_log, IN const ib_path_rec_t * p_pr,
 			  IN osm_log_level_t log_level);
 
diff --git a/opensm/libopensm.map b/opensm/libopensm.map
index 9cfa886..68d5b17 100644
--- a/opensm/libopensm.map
+++ b/opensm/libopensm.map
@@ -21,6 +21,7 @@ OPENSM_1.5 {
 		ib_zero_gid;
 		osm_dump_port_info;
 		osm_dump_portinfo_record;
+		osm_dump_guid_info;
 		osm_dump_guidinfo_record;
 		osm_dump_node_info;
 		osm_dump_node_record;
diff --git a/opensm/osm_helper.c b/opensm/osm_helper.c
index db1cc29..2a77b00 100644
--- a/opensm/osm_helper.c
+++ b/opensm/osm_helper.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2009 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 2002-2010 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  * Copyright (c) 2009 HNR Consulting. All rights reserved.
  * Copyright (c) 2009 Sun Microsystems, Inc. All rights reserved.
@@ -934,6 +934,33 @@ void osm_dump_portinfo_record(IN osm_log_t * p_log,
 	}
 }
 
+void osm_dump_guid_info(IN osm_log_t * p_log, IN ib_net64_t node_guid,
+			IN ib_net64_t port_guid, IN uint8_t block_num,
+			IN const ib_guid_info_t * p_gi,
+			IN osm_log_level_t log_level)
+{
+	if (osm_log_is_active(p_log, log_level)) {
+		osm_log(p_log, log_level,
+			"GUIDInfo dump:\n"
+                        "\t\t\t\tblock number............%u\n"
+                        "\t\t\t\tnode_guid...............0x%016" PRIx64 "\n"
+                        "\t\t\t\tport_guid...............0x%016" PRIx64 "\n"
+			"\t\t\t\tGUID 0..................0x%016" PRIx64 "\n"
+			"\t\t\t\tGUID 1..................0x%016" PRIx64 "\n"
+			"\t\t\t\tGUID 2..................0x%016" PRIx64 "\n"
+			"\t\t\t\tGUID 3..................0x%016" PRIx64 "\n"
+			"\t\t\t\tGUID 4..................0x%016" PRIx64 "\n"
+			"\t\t\t\tGUID 5..................0x%016" PRIx64 "\n"
+			"\t\t\t\tGUID 6..................0x%016" PRIx64 "\n"
+			"\t\t\t\tGUID 7..................0x%016" PRIx64 "\n",
+			block_num, cl_ntoh64(node_guid), cl_ntoh64(port_guid),
+			cl_ntoh64(p_gi->guid[0]), cl_ntoh64(p_gi->guid[1]),
+			cl_ntoh64(p_gi->guid[2]), cl_ntoh64(p_gi->guid[3]),
+			cl_ntoh64(p_gi->guid[4]), cl_ntoh64(p_gi->guid[5]),
+			cl_ntoh64(p_gi->guid[6]), cl_ntoh64(p_gi->guid[7]));
+	}
+}
+
 void osm_dump_guidinfo_record(IN osm_log_t * p_log,
 			      IN const ib_guidinfo_record_t * p_gir,
 			      IN osm_log_level_t log_level)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osm_sa_mcmember_record.c: Improve debug log message
 in validate_modify
Date: Mon, 08 Apr 2013 07:36:30 -0400
Message-ID: <5162ABBE.2070306@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


to include subnet prefix and not just GUID and display GID in IPv6 format

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_sa_mcmember_record.c b/opensm/osm_sa_mcmember_record.c
index 4a9ad71..0857a66 100644
--- a/opensm/osm_sa_mcmember_record.c
+++ b/opensm/osm_sa_mcmember_record.c
@@ -406,11 +406,19 @@ static boolean_t validate_modify(IN osm_sa_t * sa, IN osm_mgrp_t * p_mgrp,
 		    request_gid.unicast.interface_id ||
 		    (*pp_mcm_alias_guid)->port_gid.unicast.prefix !=
 		    request_gid.unicast.prefix) {
+			ib_gid_t base_port_gid;
+			char gid_str[INET6_ADDRSTRLEN];
+			char gid_str2[INET6_ADDRSTRLEN];
+
+			base_port_gid.unicast.prefix = (*pp_mcm_alias_guid)->port_gid.unicast.prefix;
+			base_port_gid.unicast.interface_id = (*pp_mcm_alias_guid)->p_base_mcm_port->port->guid;
 			OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
 				"No ProxyJoin but different ports: stored:"
-				"0x%016" PRIx64 " request:0x%016" PRIx64 "\n",
-				cl_ntoh64((*pp_mcm_alias_guid)->p_base_mcm_port->port->guid),
-				cl_ntoh64(request_gid.unicast.interface_id));
+				"%s request:%s\n",
+				inet_ntop(AF_INET6, base_port_gid.raw, gid_str,
+					  sizeof gid_str),
+				inet_ntop(AF_INET6, request_gid.raw, gid_str2,
+					  sizeof gid_str2));
 			return FALSE;
 		}
 	} else {
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

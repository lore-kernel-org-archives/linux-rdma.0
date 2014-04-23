From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osm_mcast_mgr.c: Fix endian of port GUID in ERR 0A06
 log message
Date: Wed, 23 Apr 2014 11:33:43 -0400
Message-ID: <5357DD57.6070007@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_mcast_mgr.c b/opensm/osm_mcast_mgr.c
index ad67d48..cc7041b 100644
--- a/opensm/osm_mcast_mgr.c
+++ b/opensm/osm_mcast_mgr.c
@@ -472,7 +472,7 @@ static void mcast_mgr_purge_list(osm_sm_t * sm, cl_qlist_t * list)
 			wobj = cl_item_obj(i, wobj, list_item);
 			OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 0A06: "
 				"Unable to route for port 0x%" PRIx64 "\n",
-				osm_port_get_guid(wobj->p_port));
+				cl_ntoh64(osm_port_get_guid(wobj->p_port)));
 		}
 	}
 	osm_mcast_drop_port_list(list);
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

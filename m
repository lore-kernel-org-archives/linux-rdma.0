From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 14/13] opensm/osm_sa_guidinfo_record.c: In set_guidinfo, better
 SM reassigned guid handing
Date: Tue, 22 Nov 2011 15:24:09 -0500
Message-ID: <4ECC04E9.701@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


When an SM assigned guid is rerequested and one has already been assigned
at that index for that port, allow this and return the guid in the proper
index in the SA response rather than indicating ERR 5108 due to duplicate.

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_sa_guidinfo_record.c b/opensm/osm_sa_guidinfo_record.c
index a1bb166..e363e81 100644
--- a/opensm/osm_sa_guidinfo_record.c
+++ b/opensm/osm_sa_guidinfo_record.c
@@ -537,7 +537,28 @@ static void set_guidinfo(IN osm_sa_t *sa, IN osm_madw_t *p_madw,
 				set_alias_guid = p_assigned_guids->assigned_guid[i];
 				if (set_alias_guid) {
 					p_rcvd_rec->guid_info.guid[i % 8] = set_alias_guid;
-					goto add_alias_guid;
+					p_item = cl_qmap_get(&sa->sm->p_subn->alias_port_guid_tbl,
+							     set_alias_guid);
+					if (p_item == cl_qmap_end(&sa->sm->p_subn->alias_port_guid_tbl))
+						goto add_alias_guid;
+					else {
+						p_alias_guid = (osm_alias_guid_t *) p_item;
+						if (p_alias_guid->p_base_port != p_port) {
+							OSM_LOG(sa->p_log,
+								OSM_LOG_ERROR,
+								"ERR 5110: "
+								" Assigned alias port GUID 0x%" PRIx64
+								" index %d base port GUID 0x%" PRIx64
+								" now attempted on port GUID 0x%" PRIx64
+								"\n",
+								cl_ntoh64(p_alias_guid->alias_guid), i,
+								cl_ntoh64(p_alias_guid->p_base_port->guid),
+								cl_ntoh64(p_port->guid));
+							/* clear response guid at index to indicate duplicate */
+							p_rcvd_rec->guid_info.guid[i % 8] = 0;
+						}
+						continue;
+					}
 				}
 			}
 		}
-- 
1.7.6.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Line Holen <line.holen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] osm_sa_guidinfo_record.c False duplicate GUID error messages
Date: Tue, 3 Sep 2013 04:30:16 -0700 (PDT)
Message-ID: <6914cb0e-d864-4b06-abb6-59d392de852a@default>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Cc: Linux-Rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

If the same request is received twice then the second one will cause 
error messages indicating duplicate alias GUIDs. In this case this is 
a false warning. The second request should be treated as a void and 
return success to the requester.

Signed-off-by: Line Holen <Line.Holen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

---

diff --git a/opensm/osm_sa_guidinfo_record.c b/opensm/osm_sa_guidinfo_record.c
index 8323b38..cfaf6f3 100644
--- a/opensm/osm_sa_guidinfo_record.c
+++ b/opensm/osm_sa_guidinfo_record.c
@@ -638,6 +638,14 @@ static void set_guidinfo(IN osm_sa_t *sa, IN osm_madw_t *p_madw,
 		}
 
 add_alias_guid:
+		/* Check whether the port already contain this alias guid
+		   at this index. If so we're done, continue to next */
+		if (set_alias_guid == (*p_port->p_physp->p_guids)[i]) {
+			OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
+			    "The alias GUID is already correctly assigned, continue\n");
+			continue;
+		}
+
 		/* allocate alias guid and add to alias guid table */
 		p_alias_guid = osm_alias_guid_new(set_alias_guid, p_port);
 		if (!p_alias_guid) {
@@ -656,9 +664,12 @@ add_alias_guid:
 			/* alias GUID is a duplicate */
 			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 5108: "
 				"Duplicate alias port GUID 0x%" PRIx64
-				" index %d base port GUID 0x%" PRIx64 "\n",
+				" index %d base port GUID 0x%" PRIx64
+				", alias GUID already assigned to "
+				"base port GUID 0x%" PRIx64 "\n",
 				cl_ntoh64(p_alias_guid->alias_guid), i,
-				cl_ntoh64(p_alias_guid->p_base_port->guid));
+				cl_ntoh64(p_alias_guid->p_base_port->guid),
+				cl_ntoh64(p_alias_guid_check->p_base_port->guid));
 			osm_alias_guid_delete(&p_alias_guid);
 			/* clear response guid at index to indicate duplicate */
 			p_rcvd_rec->guid_info.guid[i % 8] = 0;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

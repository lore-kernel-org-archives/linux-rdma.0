From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 7/13] opensm/osm_sa_guidinfo_record.c: In del_guidinfo, validate
 guid not in use
Date: Fri, 29 Apr 2011 09:27:40 -0400
Message-ID: <4DBABCCC.2080102@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>From 45754088b3c8afc785a87678577494c6169c7a4c Mon Sep 17 00:00:00 2001
From: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date: Thu, 28 Apr 2011 23:55:35 +0300
Subject: [PATCH] opensm/osm_sa_guidinfo_record.c: In del_guidinfo, validate guid not in use

When deleting an alias GUID (by index), validate that the alias GUID
is not in current use (in a multicast group). If it is, issue SA denied
status.

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_sa_guidinfo_record.c |   27 +++++++++++++++++++++++++++
 1 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/opensm/osm_sa_guidinfo_record.c b/opensm/osm_sa_guidinfo_record.c
index c4b7d3d..daf28ac 100644
--- a/opensm/osm_sa_guidinfo_record.c
+++ b/opensm/osm_sa_guidinfo_record.c
@@ -402,6 +402,9 @@ static void del_guidinfo(IN osm_sa_t *sa, IN osm_madw_t *p_madw,
 	ib_guidinfo_record_t *p_rcvd_rec;
 	ib_net64_t del_alias_guid;
 	osm_alias_guid_t *p_alias_guid;
+	cl_list_item_t *p_list_item;
+	osm_mcm_port_t *p_mcm_port;
+	osm_mcm_alias_guid_t *p_mcm_alias_guid;
 	uint8_t del_mask;
 	int dirty = 0;
 
@@ -430,6 +433,30 @@ static void del_guidinfo(IN osm_sa_t *sa, IN osm_madw_t *p_madw,
 
 		del_alias_guid = (*p_port->p_physp->p_guids)[i];
 		if (del_alias_guid) {
+			/* Search all of port's multicast groups for alias */
+			p_list_item = cl_qlist_head(&p_port->mcm_list);
+			while (p_list_item != cl_qlist_end(&p_port->mcm_list)) {
+				p_mcm_port = cl_item_obj(p_list_item,
+							 p_mcm_port, list_item);
+				p_list_item = cl_qlist_next(p_list_item);
+				p_mcm_alias_guid = osm_mgrp_get_mcm_alias_guid(p_mcm_port->mgrp, del_alias_guid);
+				if (p_mcm_alias_guid) {
+					osm_sa_send_error(sa, p_madw,
+							  IB_SA_MAD_STATUS_DENIED);
+					return;
+				}
+			}
+		}
+	}
+
+	for (i = block_num * GUID_TABLE_MAX_ENTRIES;
+	     (block_num + 1) * GUID_TABLE_MAX_ENTRIES < p_port->p_physp->port_info.guid_cap ? i < (block_num + 1) * GUID_TABLE_MAX_ENTRIES : i < p_port->p_physp->port_info.guid_cap;
+	     i++) {
+		if (!(del_mask & 1<<(i % 8)))
+			continue;
+
+		del_alias_guid = (*p_port->p_physp->p_guids)[i];
+		if (del_alias_guid) {
 			/* remove original from alias guid table */
 			p_alias_guid = (osm_alias_guid_t *)
 				cl_qmap_remove(&sa->p_subn->alias_port_guid_tbl,
-- 
1.5.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

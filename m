From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 9/13] opensm/osm_sa_service_record.c: Alias GUID support
Date: Fri, 29 Apr 2011 09:27:49 -0400
Message-ID: <4DBABCD5.4090000@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>From c5bb9125bf1e0cc0a40f2152e67cfb719170cba4 Mon Sep 17 00:00:00 2001
From: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date: Fri, 29 Apr 2011 00:03:29 +0300
Subject: [PATCH] opensm/osm_sa_service_record.c: Alias GUID support

In match_service_pkey_with_ports_pkey, use alias rather than base port
GUID list for service port determination

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_sa_service_record.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/opensm/osm_sa_service_record.c b/opensm/osm_sa_service_record.c
index ae002ad..830ef8f 100644
--- a/opensm/osm_sa_service_record.c
+++ b/opensm/osm_sa_service_record.c
@@ -113,7 +113,7 @@ match_service_pkey_with_ports_pkey(IN osm_sa_t * sa,
 			service_guid =
 			    p_service_rec->service_gid.unicast.interface_id;
 			service_port =
-			    osm_get_port_by_guid(sa->p_subn, service_guid);
+			    osm_get_port_by_alias_guid(sa->p_subn, service_guid);
 			if (!service_port) {
 				OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 2405: "
 					"No port object for port 0x%016" PRIx64
-- 
1.5.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

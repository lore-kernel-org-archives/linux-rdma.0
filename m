From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] osm_ucast_cache.c : Fix dereference null return value
Date: Tue, 11 Jun 2013 14:24:28 -0400
Message-ID: <51B76B5C.3070108@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Dan Ben-Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>From c5ef3da14a22721a09edc5a0d70ca1715b310c6f Mon Sep 17 00:00:00 2001
From: Dan Ben Yosef <danby-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Date: Tue, 4 Dec 2012 16:44:06 +0200
Subject: [PATCH] osm_ucast_cache.c : Fix dereference null return value

Dereferencing a null pointer "p_remote_port".

Signed-off-by: Dan Ben Yosef <danby-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 opensm/osm_ucast_cache.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/opensm/osm_ucast_cache.c b/opensm/osm_ucast_cache.c
index 952622f..78e40f3 100644
--- a/opensm/osm_ucast_cache.c
+++ b/opensm/osm_ucast_cache.c
@@ -559,6 +559,17 @@ static void ucast_cache_validate(osm_ucast_mgr_t * p_mgr)
 					    osm_get_port_by_guid(p_mgr->p_subn,
 								 osm_physp_get_port_guid
 								 (p_remote_physp));
+					if (!p_remote_port) {
+						OSM_LOG(p_mgr->p_log,
+							OSM_LOG_ERROR,
+							"ERR AD04: No port was found for "
+							"port GUID 0x%" PRIx64 "\n",
+							cl_ntoh64(osm_physp_get_port_guid
+								      (p_remote_physp)));
+						osm_ucast_cache_invalidate
+						    (p_mgr);
+						goto Exit;
+					}
 					if (p_remote_port->is_new) {
 						OSM_LOG(p_mgr->p_log,
 							OSM_LOG_DEBUG,
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

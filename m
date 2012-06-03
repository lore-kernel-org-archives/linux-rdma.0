From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm: fix locking in osm_guid_mgr_process
Date: Sun, 3 Jun 2012 12:08:42 +0300
Message-ID: <20120603090842.GA5279@calypso>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

osm_guid_mgr_process() should take lock when processing alias_guid_list.

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_guid_mgr.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/opensm/osm_guid_mgr.c b/opensm/osm_guid_mgr.c
index 73a32ac..42c7794 100644
--- a/opensm/osm_guid_mgr.c
+++ b/opensm/osm_guid_mgr.c
@@ -129,6 +129,7 @@ void osm_guid_mgr_process(IN osm_sm_t * sm) {
 
 	OSM_LOG(sm->p_log, OSM_LOG_DEBUG, "Processing alias guid list\n");
 
+	CL_PLOCK_EXCL_ACQUIRE(sm->p_lock);
 	while (cl_qlist_count(&sm->p_subn->alias_guid_list)) {
 		p_obj = (osm_guidinfo_work_obj_t *) cl_qlist_remove_head(&sm->p_subn->alias_guid_list);
 		guidinfo_set(&sm->p_subn->p_osm->sa, p_obj->p_port,
@@ -136,5 +137,6 @@ void osm_guid_mgr_process(IN osm_sm_t * sm) {
 		osm_guid_work_obj_delete(p_obj);
 	}
 
+	CL_PLOCK_RELEASE(sm->p_lock);
 	OSM_LOG_EXIT(sm->p_log);
 }
-- 
1.7.10.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

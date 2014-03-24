From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osm_sa_mcmember_record.c: Fix removing members from
 existing mc group due to invalid requests
Date: Mon, 24 Mar 2014 09:37:18 -0400
Message-ID: <5330350E.3040203@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date: Thu, 20 Mar 2014 10:26:51 +0200

Bug description:
If there is an existing well known group with only non-full members, and
opensm receives an invalid join request. opensm removes all the
member of the groups.

Signed-off-by: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_sa_mcmember_record.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/opensm/osm_sa_mcmember_record.c b/opensm/osm_sa_mcmember_record.c
index 96bddb7..85e7681 100644
--- a/opensm/osm_sa_mcmember_record.c
+++ b/opensm/osm_sa_mcmember_record.c
@@ -1177,7 +1177,8 @@ static void mcmr_rcv_join_mgrp(IN osm_sa_t * sa, IN osm_madw_t * p_madw)
 	    || !(join_state != 0)) {
 		char gid_str[INET6_ADDRSTRLEN];
 		/* since we might have created the new group we need to cleanup */
-		osm_mgrp_cleanup(sa->p_subn, p_mgrp);
+		if (is_new_group)
+			osm_mgrp_cleanup(sa->p_subn, p_mgrp);
 		CL_PLOCK_RELEASE(sa->p_lock);
 		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1B12: "
 			"validate_more_comp_fields, validate_port_caps, "
@@ -1214,7 +1215,8 @@ static void mcmr_rcv_join_mgrp(IN osm_sa_t * sa, IN osm_madw_t * p_madw)
 					&mcmember_rec, proxy);
 	if (!p_mcmr_port) {
 		/* we fail to add the port so we might need to delete the group */
-		osm_mgrp_cleanup(sa->p_subn, p_mgrp);
+		if (is_new_group)
+			osm_mgrp_cleanup(sa->p_subn, p_mgrp);
 		CL_PLOCK_RELEASE(sa->p_lock);
 		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1B06: "
 			"osm_mgrp_add_port failed\n");
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Jens Domke <domke.j.aa@m.titech.ac.jp>
Subject: [PATCH 10/10] OpenSM: dfsssp - moved paths from one to another VL might be counted multiple times
Date: Wed, 23 Jan 2013 01:42:04 +0900
Message-ID: <1358872924-17101-1-git-send-email-domke.j.aa@m.titech.ac.jp>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Torsten Hoefler <htor-gy3b+zu4XSAfv37vnLkPlQ@public.gmane.org>, Jens Domke <domke.j.aa@m.titech.ac.jp>
List-Id: linux-rdma@vger.kernel.org

the counter for paths, which have been moved to a different VL,
was incorrect; the counter should not include paths moved in a
previous step

Signed-off-by: Jens Domke <domke.j.aa@m.titech.ac.jp>
---
 opensm/osm_ucast_dfsssp.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/opensm/osm_ucast_dfsssp.c b/opensm/osm_ucast_dfsssp.c
index c8a1007..a53e783 100644
--- a/opensm/osm_ucast_dfsssp.c
+++ b/opensm/osm_ucast_dfsssp.c
@@ -1813,8 +1813,14 @@ static int dfsssp_remove_deadlocks(dfsssp_context_t * dfsssp_ctx)
 					    (uint8_t)
 					    vltable_get_vl(srcdest2vl_table,
 							   cl_hton16(slid),
-							   cl_hton16(dlid)))
+							   cl_hton16(dlid))) {
+						/* this path has been moved
+						   before -> don't count
+						 */
+						paths_per_vl[test_vl]++;
+						paths_per_vl[test_vl + 1]--;
 						continue;
+					}
 
 					src_port =
 					    osm_get_port_by_lid(p_mgr->p_subn,
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

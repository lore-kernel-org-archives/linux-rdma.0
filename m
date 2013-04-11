From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osm_lid_mgr.c: fix duplicate LID assignment after
 SM port down
Date: Thu, 11 Apr 2013 10:19:35 -0400
Message-ID: <5166C677.8080900@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

We must discard previous guid2lid db if this is the first master sweep and
reassign_lids option is TRUE.
If we came out of standby and honor_guid2lid_file option is TRUE, we must
restore guid2lid db. Otherwise if honor_guid2lid_file option is FALSE we must
discard previous guid2lid db.

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_lid_mgr.c |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/opensm/osm_lid_mgr.c b/opensm/osm_lid_mgr.c
index f92084a..4289424 100644
--- a/opensm/osm_lid_mgr.c
+++ b/opensm/osm_lid_mgr.c
@@ -302,11 +302,17 @@ static int lid_mgr_init_sweep(IN osm_lid_mgr_t * p_mgr)
 
 	lmc_mask = ~((1 << p_mgr->p_subn->opt.lmc) - 1);
 
-	/* if we came out of standby we need to discard any previous guid2lid
-	   info we might have.
-	   Do this only if the honor_guid2lid_file option is FALSE. If not, then
-	   need to honor this file. */
-	if (p_mgr->p_subn->coming_out_of_standby == TRUE) {
+	/* We must discard previous guid2lid db if this is the first master
+	 * sweep and reassign_lids option is TRUE.
+	 * If we came out of standby and honor_guid2lid_file option is TRUE, we
+	 * must restore guid2lid db. Otherwise if honor_guid2lid_file option is
+	 * FALSE we must discard previous guid2lid db.
+	 */
+	if (p_mgr->p_subn->first_time_master_sweep == TRUE &&
+	    p_mgr->p_subn->opt.reassign_lids == TRUE) {
+		osm_db_clear(p_mgr->p_g2l);
+		memset(p_mgr->used_lids, 0, sizeof(p_mgr->used_lids));
+	} else if (p_mgr->p_subn->coming_out_of_standby == TRUE) {
 		osm_db_clear(p_mgr->p_g2l);
 		memset(p_mgr->used_lids, 0, sizeof(p_mgr->used_lids));
 		if (p_mgr->p_subn->opt.honor_guid2lid_file == FALSE)
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

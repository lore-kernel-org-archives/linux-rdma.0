From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm/osm_lid_mgr: revert 'coming_out_of_standby'
 replacement patch
Date: Sat, 22 May 2010 16:16:47 +0300
Message-ID: <20100522131647.GQ28549@me>
References: <20100426104838.GS23994@me>
 <20100522130941.GP28549@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100522130941.GP28549@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Alex Netes <alexne-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


This reverts the patch where 'coming_out_of_standby' flag was replaced by
'first_time_master_sweep'. It is probably a good idea in general to
merge those, but right now it will change the default lid manager
behavior, since it will ignore guid2lid file in initial sweep.

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 opensm/opensm/osm_lid_mgr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/opensm/opensm/osm_lid_mgr.c b/opensm/opensm/osm_lid_mgr.c
index 7da4eb0..97b1de6 100644
--- a/opensm/opensm/osm_lid_mgr.c
+++ b/opensm/opensm/osm_lid_mgr.c
@@ -304,7 +304,7 @@ static int lid_mgr_init_sweep(IN osm_lid_mgr_t * p_mgr)
 	   info we might have.
 	   Do this only if the honor_guid2lid_file option is FALSE. If not, then
 	   need to honor this file. */
-	if (p_mgr->p_subn->first_time_master_sweep == TRUE) {
+	if (p_mgr->p_subn->coming_out_of_standby == TRUE) {
 		osm_db_clear(p_mgr->p_g2l);
 		memset(p_mgr->used_lids, 0, sizeof(p_mgr->used_lids));
 		if (p_mgr->p_subn->opt.honor_guid2lid_file == FALSE)
-- 
1.7.0.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

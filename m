From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 06/27] opensm/osm_subnet.c: Cosmetic formatting change
Date: Tue, 31 Jul 2012 19:04:34 +0300
Message-ID: <1343750695-28063-6-git-send-email-alexne@mellanox.com>
References: <1343750695-28063-1-git-send-email-alexne@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1343750695-28063-1-git-send-email-alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_subnet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/opensm/osm_subnet.c b/opensm/osm_subnet.c
index 2358140..fb8213f 100644
--- a/opensm/osm_subnet.c
+++ b/opensm/osm_subnet.c
@@ -1197,7 +1197,7 @@ osm_mgrp_t *osm_get_mgrp_by_mgid(IN osm_subn_t * subn, IN ib_gid_t * mgid)
 {
 	osm_mgrp_t *mgrp;
 
-	mgrp= (osm_mgrp_t *)cl_fmap_get(&subn->mgrp_mgid_tbl, mgid);
+	mgrp = (osm_mgrp_t *)cl_fmap_get(&subn->mgrp_mgid_tbl, mgid);
 	if (mgrp != (osm_mgrp_t *)cl_fmap_end(&subn->mgrp_mgid_tbl))
 		return mgrp;
 	return NULL;
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

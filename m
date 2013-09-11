From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] Use after free in osm_prtn_delete
Date: Wed, 11 Sep 2013 09:29:29 -0400
Message-ID: <52307039.8060209@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Signed-off-by: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_prtn.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/opensm/osm_prtn.c b/opensm/osm_prtn.c
index ca7703d..24a1fe3 100644
--- a/opensm/osm_prtn.c
+++ b/opensm/osm_prtn.c
@@ -105,13 +105,13 @@ void osm_prtn_delete(IN osm_subn_t * p_subn, IN OUT osm_prtn_t ** pp_prtn)
 			/* osm_mgrp_cleanup will not delete
 			 * "well_known" groups */
 			p->mgrps[i]->well_known = FALSE;
-			osm_mgrp_cleanup(p_subn, p->mgrps[i]);
 			OSM_LOG(&p_subn->p_osm->log, OSM_LOG_DEBUG,
 				"removing mgroup %s from partition (0x%x)\n",
 				inet_ntop(AF_INET6,
 					  p->mgrps[i]->mcmember_rec.mgid.raw,
 					  gid_str, sizeof gid_str),
 				cl_hton16(p->pkey));
+			osm_mgrp_cleanup(p_subn, p->mgrps[i]);
 		}
 
 		free(p->mgrps);
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

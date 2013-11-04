From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] When exiting, update SADB only in MASTER state
Date: Mon, 04 Nov 2013 07:53:14 -0500
Message-ID: <527798BA.10509@dev.mellanox.co.il>
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
 opensm/osm_opensm.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/opensm/osm_opensm.c b/opensm/osm_opensm.c
index b3c487f..f2e04f6 100644
--- a/opensm/osm_opensm.c
+++ b/opensm/osm_opensm.c
@@ -132,7 +132,8 @@ void osm_opensm_destroy(IN osm_opensm_t * p_osm)
 	cl_disp_shutdown(&p_osm->sminfo_get_disp);
 
 	/* dump SA DB */
-	if (p_osm->subn.opt.sa_db_dump)
+	if ((p_osm->sm.p_subn->sm_state == IB_SMINFO_STATE_MASTER) &&
+	     p_osm->subn.opt.sa_db_dump)
 		osm_sa_db_file_dump(p_osm);
 
 	/* do the destruction in reverse order as init */
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

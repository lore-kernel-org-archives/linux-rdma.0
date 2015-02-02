From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osm_opensm.c: Call cl_disp_shutdown for SA SET dispatcher
Date: Mon, 02 Feb 2015 08:25:48 -0500
Message-ID: <54CF7ADC.5030706@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Bug description:
OpenSM does not call cl_disp_shutdown for SA SET dispatcher

Signed-off-by: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_opensm.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/opensm/osm_opensm.c b/opensm/osm_opensm.c
index afa2544..62a1f3a 100644
--- a/opensm/osm_opensm.c
+++ b/opensm/osm_opensm.c
@@ -316,6 +316,8 @@ void osm_opensm_destroy(IN osm_opensm_t * p_osm)
 
 	/* shut down the dispatcher - so no new messages cross */
 	cl_disp_shutdown(&p_osm->disp);
+	if (p_osm->sa_set_disp_initialized)
+		cl_disp_shutdown(&p_osm->sa_set_disp);
 
 	/* dump SA DB */
 	if ((p_osm->sm.p_subn->sm_state == IB_SMINFO_STATE_MASTER) &&
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osm_trap_rcv.c: fix race condition during sweep
Date: Mon, 30 Dec 2013 07:24:57 -0500
Message-ID: <52C16619.2000703@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

If SM receives trap 128 from a physp it didn't discover yet, it will
crash.

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_trap_rcv.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/opensm/osm_trap_rcv.c b/opensm/osm_trap_rcv.c
index 72df5db..d5f646f 100644
--- a/opensm/osm_trap_rcv.c
+++ b/opensm/osm_trap_rcv.c
@@ -568,7 +568,8 @@ check_sweep:
 	if (osm_log_is_active_v2(sm->p_log, OSM_LOG_INFO, FILE_ID)) {
 		if (ib_notice_is_generic(p_ntci) &&
 		    cl_ntoh16(p_ntci->g_or_v.generic.trap_num) == SM_LINK_STATE_CHANGED_TRAP) {
-			p_path = osm_physp_get_dr_path_ptr(p_physp);
+			p_path = (p_physp) ?
+			    osm_physp_get_dr_path_ptr(p_physp) : NULL;
 			if (p_path) {
 				n = sprintf(buf, "SM class trap %u: ",
 					    cl_ntoh16(p_ntci->g_or_v.generic.trap_num));
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

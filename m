From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] Timeout on VLARB and SL2VL SET operation MADs should cause
 heavy-sweep
Date: Wed, 11 Apr 2012 10:29:34 -0400
Message-ID: <4F85954E.1020006@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Chu, Al" <chu11-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


This change re-adds send error handling for VLArbitration and
SL2VLMappingTable SM attributes which was last removed by commit
2a424a7e4fab93aad4781c3abad39be3015fee56

No additional option is believed to be needed as send errors are
timeouts and cancellations from the OpenSM vendor layer and not
bad MAD status (like 0x1c (status code 7).

Signed-off-by: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_sm_mad_ctrl.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/opensm/osm_sm_mad_ctrl.c b/opensm/osm_sm_mad_ctrl.c
index e19fa8d..93077dd 100644
--- a/opensm/osm_sm_mad_ctrl.c
+++ b/opensm/osm_sm_mad_ctrl.c
@@ -735,7 +735,9 @@ static void sm_mad_ctrl_send_err_cb(IN void *context, IN osm_madw_t * p_madw)
 	     p_smp->attr_id == IB_MAD_ATTR_MCAST_FWD_TBL ||
 	     p_smp->attr_id == IB_MAD_ATTR_SWITCH_INFO ||
 	     p_smp->attr_id == IB_MAD_ATTR_LIN_FWD_TBL ||
-	     p_smp->attr_id == IB_MAD_ATTR_P_KEY_TABLE)) {
+	     p_smp->attr_id == IB_MAD_ATTR_P_KEY_TABLE ||
+	     p_smp->attr_id == IB_MAD_ATTR_VL_ARBITRATION ||
+	     p_smp->attr_id == IB_MAD_ATTR_SLVL_TABLE)) {
 		OSM_LOG_V2(p_ctrl->p_log, OSM_LOG_ERROR, "ERR 3119: "
 			   "Set method failed for attribute 0x%X (%s)\n",
 			   cl_ntoh16(p_smp->attr_id),
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

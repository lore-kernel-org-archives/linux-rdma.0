From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm/osm_sminfo_rcv.c: send trap144 to a newly found MASTER SM when in MASTER state
Date: Thu,  6 Mar 2014 15:01:01 +0200
Message-ID: <1394110861-6128-1-git-send-email-alexne@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Before this patch, when SM in Master state finds other Master SM, it
sends trap144 to previously found Master SM/SM with higher priority when
it was in Discovering/Standby state.
This can lead to wrong behaviour in a multi-SM topolgy:

Setup: SM1 with priority 1, SM2 with priority 2, SM3 with priority 3.
Flow:
1. setting SM3 to ignore SMInfo MADs -> SM2 become master
2. setting SM2 to ignore SMInfo MADs -> SM1 become master
3. setting SM2 to accept SMInfo MADs
4. SM2 sends SMInfo to SM1 -> finds that SM1 is master
5. SM2 sends trap144 to SM3 instead of sending it to SM1

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_sminfo_rcv.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/opensm/osm_sminfo_rcv.c b/opensm/osm_sminfo_rcv.c
index 9f62f9f..100a82d 100644
--- a/opensm/osm_sminfo_rcv.c
+++ b/opensm/osm_sminfo_rcv.c
@@ -395,8 +395,13 @@ static void smi_rcv_process_get_sm(IN osm_sm_t * sm,
 			if (sm->polling_sm_guid) {
 				if (smi_rcv_remote_sm_is_higher(sm, p_smi))
 					sm->p_subn->force_heavy_sweep = TRUE;
-				else
+				else {
+					/* Update master_sm_guid to the GUID of the newly
+					 * found MASTER SM and send trap 144 to it.
+					 */
+					sm->master_sm_guid = sm->polling_sm_guid;
 					osm_send_trap144(sm, TRAP_144_MASK_SM_PRIORITY_CHANGE);
+				}
 				osm_sm_state_mgr_signal_master_is_alive(sm);
 			} else {
 				/* This is a response we got while sweeping the subnet.
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

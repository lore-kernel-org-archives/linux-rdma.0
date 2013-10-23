From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] Resend trap 144 when detecting remote MASTER SM with
 lower priority
Date: Wed, 23 Oct 2013 10:38:17 -0400
Message-ID: <5267DF59.7000809@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Remote MASTER SM might not get trap 144 and therefore never perform a HANDOVER.
The patch solves this by resending trap 144 when receiving GetResp(SMInfo) to
a remote MASTER SM after polling timeout expires.

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_sminfo_rcv.c |   17 +++++++++++++----
 1 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/opensm/osm_sminfo_rcv.c b/opensm/osm_sminfo_rcv.c
index 2fee359..16d2a4c 100644
--- a/opensm/osm_sminfo_rcv.c
+++ b/opensm/osm_sminfo_rcv.c
@@ -383,11 +383,20 @@ static void smi_rcv_process_get_sm(IN osm_sm_t * sm,
 		switch (ib_sminfo_get_state(p_smi)) {
 		case IB_SMINFO_STATE_MASTER:
 			/* If this is a response due to our polling, this means that we are
-			   waiting for a handover from this SM, and it is still alive -
-			   signal that. */
-			if (sm->p_polling_sm)
+			 * waiting for a handover from this SM, and it is still alive -
+			 * signal that. If we detected the remote SM with higher priority
+			 * we should init a heavy sweep in order to go STANDBY. If we
+			 * detected a remote SM with lower priority, we should resend trap144
+			 * as it might not get it and we don't want to wait for a HANDOVER
+			 * forever.
+			 */
+			if (sm->p_polling_sm) {
+				if (smi_rcv_remote_sm_is_higher(sm, p_smi))
+					sm->p_subn->force_heavy_sweep = TRUE;
+				else
+					osm_send_trap144(sm, TRAP_144_MASK_SM_PRIORITY_CHANGE);
 				osm_sm_state_mgr_signal_master_is_alive(sm);
-			else {
+			} else {
 				/* This is a response we got while sweeping the subnet.
 				 *
 				 * If this is during a heavy sweep, we will handle a case of
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

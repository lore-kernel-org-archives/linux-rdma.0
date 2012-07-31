From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 07/27] Fix deadlock between sminfo_set_req() and osm_sm_state_mgr()
Date: Tue, 31 Jul 2012 19:04:35 +0300
Message-ID: <1343750695-28063-7-git-send-email-alexne@mellanox.com>
References: <1343750695-28063-1-git-send-email-alexne@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1343750695-28063-1-git-send-email-alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

A deadlock will occur when SM with higher priority gets HANDOVER
message during the state manager when it start polling the current MASTER SM.

Both sminfo_set_req() and osm_sm_state_mgr() use two locks -
sm->p_lock and sm->state_lock but in reverse order. This scenario
can lead to a deadlock.

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_sminfo_rcv.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/opensm/osm_sminfo_rcv.c b/opensm/osm_sminfo_rcv.c
index eb7c17f..a0092a5 100644
--- a/opensm/osm_sminfo_rcv.c
+++ b/opensm/osm_sminfo_rcv.c
@@ -181,7 +181,7 @@ static void smi_rcv_process_set_request(IN osm_sm_t * sm,
 		goto Exit;
 	}
 
-	CL_PLOCK_EXCL_ACQUIRE(sm->p_lock);
+	CL_PLOCK_ACQUIRE(sm->p_lock);
 
 	p_smi->guid = sm->p_subn->sm_port_guid;
 	p_smi->act_count = cl_hton32(sm->p_subn->p_osm->stats.qp0_mads_sent);
@@ -247,6 +247,8 @@ static void smi_rcv_process_set_request(IN osm_sm_t * sm,
 		goto Exit;
 	}
 
+	CL_PLOCK_RELEASE(sm->p_lock);
+
 	/* check legality of the needed transition in the SM state machine */
 	status = osm_sm_state_mgr_check_legality(sm, sm_signal);
 	if (status != IB_SUCCESS) {
@@ -260,7 +262,6 @@ static void smi_rcv_process_set_request(IN osm_sm_t * sm,
 			OSM_LOG(sm->p_log, OSM_LOG_ERROR, "ERR 2F08: "
 				"Error sending response (%s)\n",
 				ib_get_err_str(status));
-		CL_PLOCK_RELEASE(sm->p_lock);
 		goto Exit;
 	}
 
@@ -280,10 +281,11 @@ static void smi_rcv_process_set_request(IN osm_sm_t * sm,
 			"Received a STANDBY signal. Updating "
 			"sm_state_mgr master_guid: 0x%016" PRIx64 "\n",
 			cl_ntoh64(sm_smi->guid));
+		CL_PLOCK_EXCL_ACQUIRE(sm->p_lock);
 		sm->master_sm_guid = sm_smi->guid;
+		CL_PLOCK_RELEASE(sm->p_lock);
 	}
 
-	CL_PLOCK_RELEASE(sm->p_lock);
 	status = osm_sm_state_mgr_process(sm, sm_signal);
 
 	if (status != IB_SUCCESS)
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

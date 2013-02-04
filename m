From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm/osm_sm_mad_ctrl.c: Upon receiving trap repress we should decrease qp0_mads_outstanding_on_wire
Date: Mon,  4 Feb 2013 15:20:10 +0200
Message-ID: <1359984011-30753-9-git-send-email-alexne@mellanox.com>
References: <1359984011-30753-1-git-send-email-alexne@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1359984011-30753-1-git-send-email-alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Current code causes SM to stuck after a few times SM priority is changed.

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_sm_mad_ctrl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/opensm/osm_sm_mad_ctrl.c b/opensm/osm_sm_mad_ctrl.c
index c384eca..11195e8 100644
--- a/opensm/osm_sm_mad_ctrl.c
+++ b/opensm/osm_sm_mad_ctrl.c
@@ -534,6 +534,7 @@ static void sm_mad_ctrl_process_trap_repress(IN osm_sm_mad_ctrl_t * p_ctrl,
 	 */
 	switch (p_smp->attr_id) {
 	case IB_MAD_ATTR_NOTICE:
+		sm_mad_ctrl_update_wire_stats(p_ctrl);
 		sm_mad_ctrl_retire_trans_mad(p_ctrl, p_madw);
 		break;
 	default:
-- 
1.7.11.7

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

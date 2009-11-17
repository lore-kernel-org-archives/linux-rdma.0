From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCH] opensm/osm_sm_mad_ctrl.c: Fix qp0_mads_accounting
Date: Tue, 17 Nov 2009 14:08:38 -0500
Message-ID: <20091117190838.GA23887@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


In sm_mad_ctrl_process_trap_repress, when attribute ID is notice, don't
just return the mad but rather retire it which fixes the qp0_mads_accounting.
Trap/TrapRepresses are treated as transactions.

Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
diff --git a/opensm/opensm/osm_sm_mad_ctrl.c b/opensm/opensm/osm_sm_mad_ctrl.c
index a4f488d..74beb1c 100644
--- a/opensm/opensm/osm_sm_mad_ctrl.c
+++ b/opensm/opensm/osm_sm_mad_ctrl.c
@@ -552,6 +552,7 @@ static void sm_mad_ctrl_process_trap_repress(IN osm_sm_mad_ctrl_t * p_ctrl,
 	 */
 	switch (p_smp->attr_id) {
 	case IB_MAD_ATTR_NOTICE:
+		sm_mad_ctrl_retire_trans_mad(p_ctrl, p_madw);
 		break;
 	default:
 		cl_atomic_inc(&p_ctrl->p_stats->qp0_mads_rcvd_unknown);
@@ -559,11 +560,10 @@ static void sm_mad_ctrl_process_trap_repress(IN osm_sm_mad_ctrl_t * p_ctrl,
 			"Unsupported attribute 0x%X\n",
 			cl_ntoh16(p_smp->attr_id));
 		osm_dump_dr_smp(p_ctrl->p_log, p_smp, OSM_LOG_ERROR);
+		osm_mad_pool_put(p_ctrl->p_mad_pool, p_madw);
 		break;
 	}
 
-	osm_mad_pool_put(p_ctrl->p_mad_pool, p_madw);
-
 	OSM_LOG_EXIT(p_ctrl->p_log);
 }
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

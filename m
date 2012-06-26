From: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 5/8] opensm: Signal subnet init errors on SubnGet timeouts
Date: Mon, 25 Jun 2012 17:55:01 -0700
Message-ID: <1340672104-18039-5-git-send-email-foraker1@llnl.gov>
References: <1340672058.5218.97.camel@auk75.llnl.gov>
 <1340672104-18039-1-git-send-email-foraker1@llnl.gov>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1340672104-18039-1-git-send-email-foraker1-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: weiny2-i2BcT+NCU+M@public.gmane.org, Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

A subnet should not be listed as cleanly initialized if CAs
fail to respond to SubnGet requests.

Signed-off-by: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
---
 opensm/osm_sm_mad_ctrl.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/opensm/osm_sm_mad_ctrl.c b/opensm/osm_sm_mad_ctrl.c
index f0bcff2..464b6b0 100644
--- a/opensm/osm_sm_mad_ctrl.c
+++ b/opensm/osm_sm_mad_ctrl.c
@@ -741,6 +741,15 @@ static void sm_mad_ctrl_send_err_cb(IN void *context, IN osm_madw_t * p_madw)
 			cl_ntoh16(p_smp->attr_id),
 			ib_get_sm_attr_str(p_smp->attr_id));
 		p_ctrl->p_subn->subnet_initialization_error = TRUE;
+	} else if (p_madw->status == IB_TIMEOUT &&
+		   p_smp->method == IB_MAD_METHOD_GET) {
+		/* Timeouts on SubnGet may be an indication of an mkey
+	 	   error at protection levels 2/3 */
+		OSM_LOG(p_ctrl->p_log, OSM_LOG_ERROR, "ERR 3120 "
+			"Timeout while getting attribute 0x%X (%s)\n",
+			cl_ntoh16(p_smp->attr_id),
+			ib_get_sm_attr_str(p_smp->attr_id));
+		p_ctrl->p_subn->subnet_initialization_error = TRUE;
 	}
 
 	osm_dump_dr_smp(p_ctrl->p_log, p_smp, OSM_LOG_VERBOSE);
-- 
1.7.9.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 5/9 v2] opensm: Log errors on SubnGet timeouts
Date: Wed,  1 Aug 2012 07:52:31 -0700
Message-ID: <1343832755-26753-5-git-send-email-foraker1@llnl.gov>
References: <1343832537.26423.8.camel@auk75.llnl.gov>
 <1343832755-26753-1-git-send-email-foraker1@llnl.gov>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1343832755-26753-1-git-send-email-foraker1-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: weiny2-i2BcT+NCU+M@public.gmane.org, alexne-LTKPlh9/A5tDPfheJLI6IQ@public.gmane.org, Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

At protection levels >=2, CAs will not respond to SubnGets
that do not have a valid mkey.  We log errors for the timed out
requests.

Signed-off-by: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
---
 opensm/osm_sm_mad_ctrl.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/opensm/osm_sm_mad_ctrl.c b/opensm/osm_sm_mad_ctrl.c
index e4c8d94..c384eca 100644
--- a/opensm/osm_sm_mad_ctrl.c
+++ b/opensm/osm_sm_mad_ctrl.c
@@ -743,6 +743,13 @@ static void sm_mad_ctrl_send_err_cb(IN void *context, IN osm_madw_t * p_madw)
 			cl_ntoh16(p_smp->attr_id),
 			ib_get_sm_attr_str(p_smp->attr_id));
 		p_ctrl->p_subn->subnet_initialization_error = TRUE;
+	} else if (p_madw->status == IB_TIMEOUT &&
+		   p_smp->method == IB_MAD_METHOD_GET) {
+		OSM_LOG(p_ctrl->p_log, OSM_LOG_ERROR, "ERR 3120 "
+			"Timeout while getting attribute 0x%X (%s); "
+			"Possible mis-set mkey?\n",
+			cl_ntoh16(p_smp->attr_id),
+			ib_get_sm_attr_str(p_smp->attr_id));
 	}
 
 	osm_dump_dr_smp_v2(p_ctrl->p_log, p_smp, FILE_ID, OSM_LOG_VERBOSE);
-- 
1.7.9.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

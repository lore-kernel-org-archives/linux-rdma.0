From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCH] opensm/osm_sm_mad_ctrl.c: Add missing call to return mad
	to mad pool
Date: Thu, 3 Dec 2009 11:12:04 -0500
Message-ID: <20091203161203.GA2947@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


when the attribute is unknown in sm_mad_ctrl_process_get_resp

Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
diff --git a/opensm/opensm/osm_sm_mad_ctrl.c b/opensm/opensm/osm_sm_mad_ctrl.c
index 0ccc327..a58b3f4 100644
--- a/opensm/opensm/osm_sm_mad_ctrl.c
+++ b/opensm/opensm/osm_sm_mad_ctrl.c
@@ -257,6 +257,7 @@ static void sm_mad_ctrl_process_get_resp(IN osm_sm_mad_ctrl_t * p_ctrl,
 			"Unsupported attribute 0x%X\n",
 			cl_ntoh16(p_smp->attr_id));
 		osm_dump_dr_smp(p_ctrl->p_log, p_smp, OSM_LOG_ERROR);
+		osm_mad_pool_put(p_ctrl->p_mad_pool, p_madw);
 		goto Exit;
 	}
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

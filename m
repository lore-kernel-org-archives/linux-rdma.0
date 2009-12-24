From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCH] opensm/osm_sm_mad_ctrl.c: In sm_mad_ctrl_send_err_cb,
	revert setting of init failure on QoS initialization failures
Date: Thu, 24 Dec 2009 06:20:36 -0500
Message-ID: <20091224112036.GA32559@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, elid-smomgflXvOZWk0Htik3J/w@public.gmane.org, celine.bourde-6ktuUTfB/bM@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


opensm/osm_sm_mad_ctrl.c: In sm_mad_ctrl_send_err_cb, revert setting of init failure on QoS attribute initialization failures

Revert the QoS related part of commit 254c2ef34fa0f475a93a63d805582bdd2efdeace 

There are unexplained cases of status 0x1c that have been observed
for SL to VL mapping table setting as documented in "Re: qos on service-id"
http://article.gmane.org/gmane.linux.drivers.rdma/1464

A subsequent patch will reintroduce this checking based on an additional
option which will default to not do this.

Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
diff --git a/opensm/opensm/osm_sm_mad_ctrl.c b/opensm/opensm/osm_sm_mad_ctrl.c
index 3ae1eb6..086f71c 100644
--- a/opensm/opensm/osm_sm_mad_ctrl.c
+++ b/opensm/opensm/osm_sm_mad_ctrl.c
@@ -729,9 +729,7 @@ static void sm_mad_ctrl_send_err_cb(IN void *context, IN osm_madw_t * p_madw)
 	     p_smp->attr_id == IB_MAD_ATTR_MCAST_FWD_TBL ||
 	     p_smp->attr_id == IB_MAD_ATTR_SWITCH_INFO ||
 	     p_smp->attr_id == IB_MAD_ATTR_LIN_FWD_TBL ||
-	     p_smp->attr_id == IB_MAD_ATTR_P_KEY_TABLE ||
-	     p_smp->attr_id == IB_MAD_ATTR_SLVL_TABLE ||
-	     p_smp->attr_id == IB_MAD_ATTR_VL_ARBITRATION)) {
+	     p_smp->attr_id == IB_MAD_ATTR_P_KEY_TABLE)) {
 		OSM_LOG(p_ctrl->p_log, OSM_LOG_ERROR, "ERR 3119: "
 			"Set method failed for attribute 0x%X (%s)\n",
 			cl_ntoh16(p_smp->attr_id),
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 2/3] osm_congestion_control.c: Consistently set
	cc_unavailable_flag
Date: Mon, 22 Dec 2014 15:32:14 -0800
Message-ID: <1419291134.21271.15.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

For consistency to other code, set flag using TRUE and FALSE macros.

Signed-off-by: Albert L. Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 opensm/osm_congestion_control.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/opensm/osm_congestion_control.c b/opensm/osm_congestion_control.c
index 0612ba1..54574b7 100644
--- a/opensm/osm_congestion_control.c
+++ b/opensm/osm_congestion_control.c
@@ -482,12 +482,12 @@ static void cc_rcv_mad(void *context, void *data)
 		if (p_cc_mad->header.status & IB_MAD_STATUS_UNSUP_CLASS_VER
 		    || p_cc_mad->header.status & IB_MAD_STATUS_UNSUP_METHOD
 		    || p_cc_mad->header.status & IB_MAD_STATUS_UNSUP_METHOD_ATTR)
-			p_port->cc_unavailable_flag = 1;
+			p_port->cc_unavailable_flag = TRUE;
 		cl_plock_release(&p_osm->lock);
 		goto Exit;
 	}
 	else
-		p_port->cc_unavailable_flag = 0;
+		p_port->cc_unavailable_flag = FALSE;
 
 	if (p_cc_mad->header.attr_id == IB_MAD_ATTR_SW_CONG_SETTING) {
 		ib_sw_cong_setting_t *p_sw_cong_setting;
@@ -706,7 +706,7 @@ static void cc_mad_send_err_callback(void *bind_context,
 		p_port->cc_timeout_count++;
 		if (p_port->cc_timeout_count > OSM_CC_TIMEOUT_COUNT_THRESHOLD
 		    && !p_port->cc_unavailable_flag)
-			p_port->cc_unavailable_flag++;
+			p_port->cc_unavailable_flag = TRUE;
 	} else
 		p_cc->subn->subnet_initialization_error = TRUE;
 
-- 
1.7.1



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

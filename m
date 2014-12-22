From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 3/3] osm_congestion_control.c: Reset cc_timeout_count when
	count threshold passed
Date: Mon, 22 Dec 2014 15:32:21 -0800
Message-ID: <1419291141.21271.17.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Albert L. Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 opensm/osm_congestion_control.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/opensm/osm_congestion_control.c b/opensm/osm_congestion_control.c
index 54574b7..bfcd8a5 100644
--- a/opensm/osm_congestion_control.c
+++ b/opensm/osm_congestion_control.c
@@ -705,8 +705,10 @@ static void cc_mad_send_err_callback(void *bind_context,
 	if (p_madw->status == IB_TIMEOUT) {
 		p_port->cc_timeout_count++;
 		if (p_port->cc_timeout_count > OSM_CC_TIMEOUT_COUNT_THRESHOLD
-		    && !p_port->cc_unavailable_flag)
+		    && !p_port->cc_unavailable_flag) {
 			p_port->cc_unavailable_flag = TRUE;
+			p_port->cc_timeout_count = 0;
+		}
 	} else
 		p_cc->subn->subnet_initialization_error = TRUE;
 
-- 
1.7.1



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

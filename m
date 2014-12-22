From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 1/3] osm_congestion_control.c: Add additional header status
	check
Date: Mon, 22 Dec 2014 15:32:12 -0800
Message-ID: <1419291132.21271.14.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

In cc_rcv_mad, also check for IB_MAD_STATUS_UNSUP_CLASS_VER as indication
congestion control is not available.

Signed-off-by: Albert L. Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 opensm/osm_congestion_control.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/opensm/osm_congestion_control.c b/opensm/osm_congestion_control.c
index ead1888..0612ba1 100644
--- a/opensm/osm_congestion_control.c
+++ b/opensm/osm_congestion_control.c
@@ -479,7 +479,8 @@ static void cc_rcv_mad(void *context, void *data)
 	p_port->cc_timeout_count = 0;
 
 	if (p_cc_mad->header.status) {
-		if (p_cc_mad->header.status & IB_MAD_STATUS_UNSUP_METHOD
+		if (p_cc_mad->header.status & IB_MAD_STATUS_UNSUP_CLASS_VER
+		    || p_cc_mad->header.status & IB_MAD_STATUS_UNSUP_METHOD
 		    || p_cc_mad->header.status & IB_MAD_STATUS_UNSUP_METHOD_ATTR)
 			p_port->cc_unavailable_flag = 1;
 		cl_plock_release(&p_osm->lock);
-- 
1.7.1



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

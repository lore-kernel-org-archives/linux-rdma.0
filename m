From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osm_port_info_rcv.c: Reset client reregister bit only
 on a response to SET
Date: Wed, 01 Jan 2014 08:44:28 -0500
Message-ID: <52C41BBC.2040607@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

It's better to clean the bit only when getting response to a SET request
that was issued previously.

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_port_info_rcv.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/opensm/osm_port_info_rcv.c b/opensm/osm_port_info_rcv.c
index 30cd096..a8ac75b 100644
--- a/opensm/osm_port_info_rcv.c
+++ b/opensm/osm_port_info_rcv.c
@@ -566,7 +566,7 @@ void osm_pi_rcv_process(IN void *context, IN void *data)
 
 	/* On receipt of client reregister, clear the reregister bit so
 	   reregistering won't be sent again and again */
-	if (ib_port_info_get_client_rereg(p_pi)) {
+	if (p_context->set_method && ib_port_info_get_client_rereg(p_pi)) {
 		OSM_LOG(sm->p_log, OSM_LOG_DEBUG,
 			"Client reregister received on response\n");
 		ib_port_info_set_client_rereg(p_pi, 0);
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

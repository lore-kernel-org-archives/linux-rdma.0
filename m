From: Yevgeny Kliteynik <kliteyn-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCH] opensm/osm_trap_rcv.c: fix possible core dump
Date: Tue, 7 Sep 2010 17:53:03 +0300
Message-ID: <4C8651CF.2080807@mellanox.co.il>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Handle the case when source physical port
for trap 145 wasn't found.

Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 opensm/opensm/osm_trap_rcv.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/opensm/opensm/osm_trap_rcv.c b/opensm/opensm/osm_trap_rcv.c
index 500632c..9f39644 100644
--- a/opensm/opensm/osm_trap_rcv.c
+++ b/opensm/opensm/osm_trap_rcv.c
@@ -510,10 +510,16 @@ static void trap_rcv_process_request(IN osm_sm_t * sm,
 				"ERR 3812: No physical port found for "
 				"trap 144: \"node description update\"\n");
 		goto check_sweep;
-	} else if (cl_ntoh16(p_ntci->g_or_v.generic.trap_num) == 145)
-		/* this assumes that trap 145 content is not broken? */
-		p_physp->p_node->node_info.sys_guid =
-			p_ntci->data_details.ntc_145.new_sys_guid;
+	} else if (cl_ntoh16(p_ntci->g_or_v.generic.trap_num) == 145) {
+		if (p_physp)
+			/* this assumes that trap 145 content is not broken? */
+			p_physp->p_node->node_info.sys_guid =
+				p_ntci->data_details.ntc_145.new_sys_guid;
+		else
+			OSM_LOG(sm->p_log, OSM_LOG_ERROR,
+				"ERR 3813: No physical port found for "
+				"trap 145: \"SystemImageGUID update\"\n");
+	}

 check_sweep:
 	/* do a sweep if we received a trap */
-- 
1.6.2.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

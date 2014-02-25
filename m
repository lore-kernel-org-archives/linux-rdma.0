From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osm_sw_info_rcv.c: Fix sending PortInfo during lightsweep
Date: Tue, 25 Feb 2014 13:14:09 -0500
Message-ID: <530CDD71.20705@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

OpenSM shouldn't send PortInfo MADs when receiving SWInfo during
lightsweep or as a response to SET.

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_sw_info_rcv.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/opensm/osm_sw_info_rcv.c b/opensm/osm_sw_info_rcv.c
index 910e8f0..bcd13a9 100644
--- a/opensm/osm_sw_info_rcv.c
+++ b/opensm/osm_sw_info_rcv.c
@@ -439,6 +439,9 @@ void osm_si_rcv_process(IN void *context, IN void *data)
 		/* we might get back a request for signaling change was detected */
 		sm->p_subn->force_heavy_sweep = TRUE;
 
+	if (p_context->light_sweep || p_context->set_method)
+		goto Exit;
+
 	si_rcv_get_sp0_info(sm, p_node);
 
 Exit:
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

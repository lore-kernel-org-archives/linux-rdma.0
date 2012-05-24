From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osm_sminfo_rcv.c: Handle SMP status
Date: Thu, 24 May 2012 08:45:57 -0400
Message-ID: <4FBE2D85.6030601@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Terminate receive processing when SMP status is not 0

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_sminfo_rcv.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/opensm/osm_sminfo_rcv.c b/opensm/osm_sminfo_rcv.c
index 6f0b099..ff4d209 100644
--- a/opensm/osm_sminfo_rcv.c
+++ b/opensm/osm_sminfo_rcv.c
@@ -561,6 +561,12 @@ void osm_sminfo_rcv_process(IN void *context, IN void *data)
 	CL_ASSERT(p_madw);
 
 	p_smp = osm_madw_get_smp_ptr(p_madw);
+	if (ib_smp_get_status(p_smp)) {
+		OSM_LOG(sm->p_log, OSM_LOG_DEBUG,
+			"MAD status 0x%x received\n",
+			cl_ntoh16(ib_smp_get_status(p_smp)));
+		goto Exit;
+	}
 
 	/* Determine if this is a request for our own SMInfo or if
 	   this is a response to our request for another SM's SMInfo. */
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

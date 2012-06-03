From: Daniel Klein <danielk-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osmtest: fix timeout and max_retries
Date: Sun, 03 Jun 2012 11:56:46 +0300
Message-ID: <4FCB26CE.6040209@dev.mellanox.co.il>
References: <4FCB2387.3050904@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4FCB2387.3050904-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Fix: osmtest doesnt bind to port with given timeout / max_retries
parameters.

Signed-off-by: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libvendor/osm_vendor_ibumad_sa.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/libvendor/osm_vendor_ibumad_sa.c b/libvendor/osm_vendor_ibumad_sa.c
index 1470624..ce5ee5e 100644
--- a/libvendor/osm_vendor_ibumad_sa.c
+++ b/libvendor/osm_vendor_ibumad_sa.c
@@ -240,8 +240,8 @@ osmv_bind_sa(IN osm_vendor_t * const p_vend,
 	bind_info.is_report_processor = FALSE;
 	bind_info.send_q_size = OSM_SM_DEFAULT_QP1_RCV_SIZE;
 	bind_info.recv_q_size = OSM_SM_DEFAULT_QP1_SEND_SIZE;
-	bind_info.timeout = OSM_DEFAULT_TRANS_TIMEOUT_MILLISEC;
-	bind_info.retries = OSM_DEFAULT_RETRY_COUNT;
+	bind_info.timeout = p_vend->timeout;
+	bind_info.retries = p_vend->max_retries;
 
 	/* allocate the new sa bind info */
 	p_sa_bind_info =
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

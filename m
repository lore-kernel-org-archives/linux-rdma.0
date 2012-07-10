From: Daniel Klein <danielk-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCHv1] opensm/osmtest: fix osmtest ignores timeout parameter
Date: Tue, 10 Jul 2012 17:23:35 +0300
Message-ID: <4FFC3AE7.8040006@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Fix: osmtest ignores timeout parameter, and binds with default value

v1 changes:
updating only timeout field of bind_info

Signed-off-by: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libvendor/osm_vendor_ibumad_sa.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/libvendor/osm_vendor_ibumad_sa.c b/libvendor/osm_vendor_ibumad_sa.c
index 1470624..1d482c0 100644
--- a/libvendor/osm_vendor_ibumad_sa.c
+++ b/libvendor/osm_vendor_ibumad_sa.c
@@ -240,7 +240,7 @@ osmv_bind_sa(IN osm_vendor_t * const p_vend,
 	bind_info.is_report_processor = FALSE;
 	bind_info.send_q_size = OSM_SM_DEFAULT_QP1_RCV_SIZE;
 	bind_info.recv_q_size = OSM_SM_DEFAULT_QP1_SEND_SIZE;
-	bind_info.timeout = OSM_DEFAULT_TRANS_TIMEOUT_MILLISEC;
+	bind_info.timeout = p_vend->timeout;
 	bind_info.retries = OSM_DEFAULT_RETRY_COUNT;
 
 	/* allocate the new sa bind info */
-- 
1.7.1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

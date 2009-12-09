From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/libvendor//osm_vendor_ibumad_sa.c: uninitialized fields
Date: Wed, 09 Dec 2009 10:48:20 +0200
Message-ID: <4B1F6454.8060001@dev.mellanox.co.il>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Taking care of couple of uninitialized fields.
Discovered with 'osmtest -f a' - bad things
start to happen when a packet is dropped, and
osmtest should really get a timeout.

Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 opensm/libvendor/osm_vendor_ibumad_sa.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/opensm/libvendor/osm_vendor_ibumad_sa.c b/opensm/libvendor/osm_vendor_ibumad_sa.c
index e05a5ef..78f2bce 100644
--- a/opensm/libvendor/osm_vendor_ibumad_sa.c
+++ b/opensm/libvendor/osm_vendor_ibumad_sa.c
@@ -241,6 +241,8 @@ osmv_bind_sa(IN osm_vendor_t * const p_vend,
 	bind_info.is_report_processor = FALSE;
 	bind_info.send_q_size = OSM_SM_DEFAULT_QP1_RCV_SIZE;
 	bind_info.recv_q_size = OSM_SM_DEFAULT_QP1_SEND_SIZE;
+	bind_info.timeout = OSM_DEFAULT_TRANS_TIMEOUT_MILLISEC;
+	bind_info.retries = OSM_DEFAULT_RETRY_COUNT;

 	/* allocate the new sa bind info */
 	p_sa_bind_info =
-- 
1.5.1.4


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

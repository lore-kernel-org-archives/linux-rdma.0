From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm: Fixed debug message in osm_vendor_send()
Date: Mon, 7 Mar 2011 11:57:39 +0200
Message-ID: <20110307095739.GG5577@calypso.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

p_madw might be freed in umad_send(). So printing TID instead of the p_madw
pointer is more accurate.

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libvendor/osm_vendor_ibumad.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/libvendor/osm_vendor_ibumad.c b/libvendor/osm_vendor_ibumad.c
index 2373803..be2dda2 100644
--- a/libvendor/osm_vendor_ibumad.c
+++ b/libvendor/osm_vendor_ibumad.c
@@ -1004,6 +1004,7 @@ osm_vendor_send(IN osm_bind_handle_t h_bind,
 	int ret = -1;
 	int is_rmpp = 0;
 	uint32_t sent_mad_size;
+	uint64_t tid;
 #ifndef VENDOR_RMPP_SUPPORT
 	uint32_t paylen = 0;
 #endif
@@ -1068,13 +1069,14 @@ Resp:
 	sent_mad_size = is_rmpp ? p_madw->mad_size - IB_SA_MAD_HDR_SIZE :
 	    p_madw->mad_size;
 #endif
+	tid = cl_ntoh64(p_mad->trans_id);
 	if ((ret = umad_send(p_bind->port_id, p_bind->agent_id, p_vw->umad,
 			     sent_mad_size,
 			     resp_expected ? p_bind->timeout : 0,
 			     p_bind->max_retries)) < 0) {
 		OSM_LOG(p_vend->p_log, OSM_LOG_ERROR, "ERR 5430: "
 			"Send p_madw = %p of size %d TID 0x%" PRIx64 " failed %d (%m)\n",
-			p_madw, sent_mad_size, cl_ntoh64(p_mad->trans_id), ret);
+			p_madw, sent_mad_size, tid, ret);
 		if (resp_expected) {
 			get_madw(p_vend, &p_mad->trans_id);	/* remove from aging table */
 			p_madw->status = IB_ERROR;
@@ -1089,8 +1091,8 @@ Resp:
 	if (!resp_expected)
 		osm_mad_pool_put(p_bind->p_mad_pool, p_madw);
 
-	OSM_LOG(p_vend->p_log, OSM_LOG_DEBUG, "Completed sending %s p_madw = %p\n",
-		resp_expected ? "request" : "response or unsolicited", p_madw);
+	OSM_LOG(p_vend->p_log, OSM_LOG_DEBUG, "Completed sending %s TID 0x%" PRIx64 "\n",
+		resp_expected ? "request" : "response or unsolicited", tid);
 Exit:
 	OSM_LOG_EXIT(p_vend->p_log);
 	return (ret);
-- 
1.7.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 2/4] opensm/osm_sa_guidinfo_record.c: end error resoponse to
 invalid LID in GUIDInfo request
Date: Thu, 22 Mar 2012 10:36:58 +0200
Message-ID: <20120322083658.GC2613@calypso>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Sending IB_SA_MAD_STATUS_NO_RECORDS for SA GUIDInfo requests with
invalid LID in record identifier.

Signed-off-by: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_sa_guidinfo_record.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/opensm/osm_sa_guidinfo_record.c b/opensm/osm_sa_guidinfo_record.c
index b23bc28..b100da1 100644
--- a/opensm/osm_sa_guidinfo_record.c
+++ b/opensm/osm_sa_guidinfo_record.c
@@ -748,9 +748,10 @@ void osm_gir_rcv_process(IN void *ctx, IN void *data)
 		p_rcvd_rec = (ib_guidinfo_record_t *) ib_sa_mad_get_payload_ptr(p_rcvd_mad);
 		p_port = osm_get_port_by_lid(sa->p_subn, p_rcvd_rec->lid);
 		if (!p_port) {
-			OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
+			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 5117: "
 				"Port with LID %u not found\n",
 				cl_ntoh16(p_rcvd_rec->lid));
+			osm_sa_send_error(sa, p_madw, IB_SA_MAD_STATUS_NO_RECORDS);
 			goto Exit;
 		}
 		if (!osm_physp_share_pkey(sa->p_log, p_req_physp,
-- 
1.7.7.6

-- Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

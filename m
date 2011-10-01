From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 4/7] opensm/osm_sa_multipath_record.c: Add rate validation
 if supplied
Date: Sat, 01 Oct 2011 09:16:01 -0400
Message-ID: <4E871291.1050202@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Stan Smith <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_sa_multipath_record.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/opensm/osm_sa_multipath_record.c b/opensm/osm_sa_multipath_record.c
index 33cf130..82f5ea1 100644
--- a/opensm/osm_sa_multipath_record.c
+++ b/opensm/osm_sa_multipath_record.c
@@ -1494,6 +1494,7 @@ void osm_mpr_rcv_process(IN void *context, IN void *data)
 	cl_qlist_t pr_list;
 	ib_net16_t sa_status;
 	int nsrc, ndest;
+	uint8_t rate;
 
 	OSM_LOG_ENTER(sa->p_log);
 
@@ -1533,6 +1534,17 @@ void osm_mpr_rcv_process(IN void *context, IN void *data)
 	if (osm_log_is_active(sa->p_log, OSM_LOG_DEBUG))
 		osm_dump_multipath_record(sa->p_log, p_mpr, OSM_LOG_DEBUG);
 
+	/* Validatg rate if supplied */
+	if ((p_sa_mad->comp_mask & IB_MPR_COMPMASK_RATESELEC) &&
+	    (p_sa_mad->comp_mask & IB_MPR_COMPMASK_RATE)) {
+		rate = ib_multipath_rec_rate(p_mpr);
+		if (!ib_rate_is_valid(rate)) {
+			osm_sa_send_error(sa, p_madw,
+					  IB_SA_MAD_STATUS_REQ_INVALID);
+			goto Exit;
+		}
+	}
+
 	cl_qlist_init(&pr_list);
 
 	/*
-- 
1.7.6.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

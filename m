From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 2/7] opensm/osm_sa_path_record.c: Add rate validation if supplied
Date: Sat, 01 Oct 2011 09:15:40 -0400
Message-ID: <4E87127C.4040409@dev.mellanox.co.il>
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
 opensm/osm_sa_path_record.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/opensm/osm_sa_path_record.c b/opensm/osm_sa_path_record.c
index 1f36326..09dcaff 100644
--- a/opensm/osm_sa_path_record.c
+++ b/opensm/osm_sa_path_record.c
@@ -1604,6 +1604,7 @@ void osm_pr_rcv_process(IN void *context, IN void *data)
 	const ib_gid_t *p_dgid = NULL;
 	const osm_port_t *p_src_port, *p_dest_port;
 	osm_port_t *requester_port;
+	uint8_t rate;
 
 	OSM_LOG_ENTER(sa->p_log);
 
@@ -1634,6 +1635,17 @@ void osm_pr_rcv_process(IN void *context, IN void *data)
 	if (osm_log_is_active(sa->p_log, OSM_LOG_DEBUG))
 		osm_dump_path_record(sa->p_log, p_pr, OSM_LOG_DEBUG);
 
+	/* Validate rate if supplied */
+	if ((p_sa_mad->comp_mask & IB_PR_COMPMASK_RATESELEC) &&
+	    (p_sa_mad->comp_mask & IB_PR_COMPMASK_RATE)) {
+		rate = ib_path_rec_rate(p_pr);
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

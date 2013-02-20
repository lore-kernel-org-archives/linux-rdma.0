From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osm_sa_multipath_record.c: Fix commentary typo
Date: Wed, 20 Feb 2013 14:02:28 -0500
Message-ID: <51251DC4.3000707@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_sa_multipath_record.c b/opensm/osm_sa_multipath_record.c
index e89c93a..75921e1 100644
--- a/opensm/osm_sa_multipath_record.c
+++ b/opensm/osm_sa_multipath_record.c
@@ -1566,7 +1594,7 @@ void osm_mpr_rcv_process(IN void *context, IN void *data)
 		osm_dump_multipath_record_v2(sa->p_log, p_mpr, FILE_ID, OSM_LOG_DEBUG);
 	}
 
-	/* Validatg rate if supplied */
+	/* Validate rate if supplied */
 	if ((p_sa_mad->comp_mask & IB_MPR_COMPMASK_RATESELEC) &&
 	    (p_sa_mad->comp_mask & IB_MPR_COMPMASK_RATE)) {
 		rate = ib_multipath_rec_rate(p_mpr);
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

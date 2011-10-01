From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 3/7] opensm/osm_sa_mcmember_record.c: Add rate validation
 if supplied
Date: Sat, 01 Oct 2011 09:15:51 -0400
Message-ID: <4E871287.3020109@dev.mellanox.co.il>
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
 opensm/osm_sa_mcmember_record.c |   30 ++++++++++++++++++++++++++++++
 1 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/opensm/osm_sa_mcmember_record.c b/opensm/osm_sa_mcmember_record.c
index 81d752a..451f774 100644
--- a/opensm/osm_sa_mcmember_record.c
+++ b/opensm/osm_sa_mcmember_record.c
@@ -1438,6 +1438,20 @@ Exit:
 	OSM_LOG_EXIT(sa->p_log);
 }
 
+static uint8_t rate_is_valid(IN const ib_sa_mad_t *p_sa_mad,
+			     IN const ib_member_rec_t *p_recvd_mcmember_rec)
+{
+	uint8_t rate;
+
+	/* Validate rate if supplied */
+	if ((p_sa_mad->comp_mask & IB_MCR_COMPMASK_RATE_SEL) &&
+	    (p_sa_mad->comp_mask & IB_MCR_COMPMASK_RATE)) {
+		rate = (uint8_t) (p_recvd_mcmember_rec->rate & 0x3F);
+		return ib_rate_is_valid(rate);
+	}
+	return 1;
+}
+
 void osm_mcmr_rcv_process(IN void *context, IN void *data)
 {
 	osm_sa_t *sa = context;
@@ -1478,6 +1492,11 @@ void osm_mcmr_rcv_process(IN void *context, IN void *data)
 					  IB_SA_MAD_STATUS_INSUF_COMPS);
 			goto Exit;
 		}
+		if (!rate_is_valid(p_sa_mad, p_recvd_mcmember_rec)) {
+			osm_sa_send_error(sa, p_madw,
+					  IB_SA_MAD_STATUS_REQ_INVALID);
+			goto Exit;
+		}
 
 		/*
 		 * Join or Create Multicast Group
@@ -1495,6 +1514,11 @@ void osm_mcmr_rcv_process(IN void *context, IN void *data)
 					  IB_SA_MAD_STATUS_INSUF_COMPS);
 			goto Exit;
 		}
+		if (!rate_is_valid(p_sa_mad, p_recvd_mcmember_rec)) {
+			osm_sa_send_error(sa, p_madw,
+					  IB_SA_MAD_STATUS_REQ_INVALID);
+			goto Exit;
+		}
 
 		/*
 		 * Leave Multicast Group
@@ -1503,6 +1527,12 @@ void osm_mcmr_rcv_process(IN void *context, IN void *data)
 		break;
 	case IB_MAD_METHOD_GET:
 	case IB_MAD_METHOD_GETTABLE:
+		if (!rate_is_valid(p_sa_mad, p_recvd_mcmember_rec)) {
+			osm_sa_send_error(sa, p_madw,
+					  IB_SA_MAD_STATUS_REQ_INVALID);
+			goto Exit;
+		}
+
 		/*
 		 * Querying a Multicast Group
 		 */
-- 
1.7.6.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

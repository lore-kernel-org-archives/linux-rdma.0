From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 4/4] opensm/osm_sa_multipath_record.c: Add mtu validation
 if supplied
Date: Tue, 04 Oct 2011 09:53:28 -0400
Message-ID: <4E8B0FD8.5050301@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_sa_multipath_record.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/opensm/osm_sa_multipath_record.c b/opensm/osm_sa_multipath_record.c
index 82f5ea1..e8ec95e 100644
--- a/opensm/osm_sa_multipath_record.c
+++ b/opensm/osm_sa_multipath_record.c
@@ -1494,7 +1494,7 @@ void osm_mpr_rcv_process(IN void *context, IN void *data)
 	cl_qlist_t pr_list;
 	ib_net16_t sa_status;
 	int nsrc, ndest;
-	uint8_t rate;
+	uint8_t rate, mtu;
 
 	OSM_LOG_ENTER(sa->p_log);
 
@@ -1544,6 +1544,16 @@ void osm_mpr_rcv_process(IN void *context, IN void *data)
 			goto Exit;
 		}
 	}
+	/* Validate MTU if supplied */
+	if ((p_sa_mad->comp_mask & IB_MPR_COMPMASK_MTUSELEC) &&
+	    (p_sa_mad->comp_mask & IB_MPR_COMPMASK_MTU)) {
+		mtu = ib_multipath_rec_mtu(p_mpr);
+		if (!ib_mtu_is_valid(mtu)) {
+			osm_sa_send_error(sa, p_madw,
+					  IB_SA_MAD_STATUS_REQ_INVALID);
+			goto Exit;
+		}
+	}
 
 	cl_qlist_init(&pr_list);
 
-- 
1.7.6.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

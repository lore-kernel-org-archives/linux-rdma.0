From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 11/13] opensm/osm_sa_guidinfo_record.c: Better status for
 SA response
Date: Fri, 29 Apr 2011 09:27:59 -0400
Message-ID: <4DBABCDF.30508@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>From 8ac0f4d7e91c3112030f696cd4d35f666263dedf Mon Sep 17 00:00:00 2001
From: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date: Fri, 29 Apr 2011 13:44:49 +0300
Subject: [PATCH] opensm/osm_sa_guidinfo_record.c: Better status for SA response

In osm_gir_rcv_process, when set or delete with insufficient components,
indicate that rather than invalid status

Signed-off-by: Hal Rosenstock <Hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_sa_guidinfo_record.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/opensm/osm_sa_guidinfo_record.c b/opensm/osm_sa_guidinfo_record.c
index daf28ac..2211469 100644
--- a/opensm/osm_sa_guidinfo_record.c
+++ b/opensm/osm_sa_guidinfo_record.c
@@ -742,7 +742,7 @@ void osm_gir_rcv_process(IN void *ctx, IN void *data)
 				cl_ntoh64(p_rcvd_mad->comp_mask),
 				CL_NTOH64(MOD_GIR_COMP_MASK));
 			osm_sa_send_error(sa, p_madw,
-					  IB_SA_MAD_STATUS_REQ_INVALID);
+					  IB_SA_MAD_STATUS_INSUF_COMPS);
 			goto Exit;
 		}
 		p_rcvd_rec = (ib_guidinfo_record_t *) ib_sa_mad_get_payload_ptr(p_rcvd_mad);
-- 
1.5.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

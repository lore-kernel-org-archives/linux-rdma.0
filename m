From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 2/2] opensm/osm_sa_service_record.c: Fix minor memory leak
Date: Tue, 19 Apr 2011 10:27:52 -0400
Message-ID: <4DAD9BE8.4040503@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


in sr_rcv_process_delete_method

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_sa_service_record.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/opensm/osm_sa_service_record.c b/opensm/osm_sa_service_record.c
index 72bcbdc..ae002ad 100644
--- a/opensm/osm_sa_service_record.c
+++ b/opensm/osm_sa_service_record.c
@@ -644,6 +644,7 @@ static void sr_rcv_process_delete_method(osm_sa_t * sa, IN osm_madw_t * p_madw)
 		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 2413: "
 			"Unable to acquire Service record\n");
 		osm_sa_send_error(sa, p_madw, IB_SA_MAD_STATUS_NO_RESOURCES);
+		osm_svcr_delete(p_svcr);
 		goto Exit;
 	}
 
-- 
1.5.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

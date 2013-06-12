From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] osm_sa_sminfo_record.c: fix sminfo sa query returns all sminfo
 records when filtering by LID in osm_smir_rcv_process
Date: Wed, 12 Jun 2013 06:33:03 -0400
Message-ID: <51B84E5F.3090802@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Dan Ben-Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>From fefee6db5955554ab6cc66da9aef1084f14d7006 Mon Sep 17 00:00:00 2001
From: Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date: Wed, 5 Jun 2013 14:52:01 +0300
Subject: [PATCH] osm_sa_sminfo_record.c: fix sminfo sa query returns all sminfo records when filtering by LID in osm_smir_rcv_process

Signed-off-by: Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_sa_sminfo_record.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/opensm/osm_sa_sminfo_record.c b/opensm/osm_sa_sminfo_record.c
index f6bd9be..f73b433 100644
--- a/opensm/osm_sa_sminfo_record.c
+++ b/opensm/osm_sa_sminfo_record.c
@@ -310,7 +310,7 @@ void osm_smir_rcv_process(IN void *ctx, IN void *data)
 				OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 280A: "
 					"No remote SM for GUID 0x%016" PRIx64
 					"\n", cl_ntoh64(port_guid));
-		} else {
+		} else if (!p_port) {
 			/* Go over all other known (remote) SMs */
 			cl_qmap_apply_func(&sa->p_subn->sm_guid_tbl,
 					   sa_smir_by_comp_mask_cb, &context);
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

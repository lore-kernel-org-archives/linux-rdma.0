From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 1/2] opensm/osm_req.c: Fix transaction id casting
Date: Thu, 28 Jun 2012 13:11:12 -0400
Message-ID: <4FEC9030.6070007@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


cl_atomic() returns signed int32, so without the casting
sm_trans_id > 0x7fffffff were messed up.

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_req.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/opensm/osm_req.c b/opensm/osm_req.c
index 7e9e664..ee2a64e 100644
--- a/opensm/osm_req.c
+++ b/opensm/osm_req.c
@@ -91,7 +91,8 @@ ib_api_status_t osm_req_get(IN osm_sm_t * sm, IN const osm_dr_path_t * p_path,
 		goto Exit;
 	}
 
-	tid = cl_hton64((uint64_t) cl_atomic_inc(&sm->sm_trans_id));
+	tid = cl_hton64((uint64_t) cl_atomic_inc(&sm->sm_trans_id) &
+						 (uint64_t)(0xFFFFFFFF));
 
 	OSM_LOG(sm->p_log, OSM_LOG_DEBUG,
 		"Getting %s (0x%X), modifier 0x%X, TID 0x%" PRIx64 "\n",
@@ -161,7 +162,8 @@ ib_api_status_t osm_req_set(IN osm_sm_t * sm, IN const osm_dr_path_t * p_path,
 		goto Exit;
 	}
 
-	tid = cl_hton64((uint64_t) cl_atomic_inc(&sm->sm_trans_id));
+	tid = cl_hton64((uint64_t) cl_atomic_inc(&sm->sm_trans_id) &
+						 (uint64_t)(0xFFFFFFFF));
 
 	OSM_LOG(sm->p_log, OSM_LOG_DEBUG,
 		"Setting %s (0x%X), modifier 0x%X, TID 0x%" PRIx64 "\n",
@@ -248,7 +250,8 @@ int osm_send_trap144(osm_sm_t * sm, ib_net16_t local)
 	smp->mgmt_class = IB_MCLASS_SUBN_LID;
 	smp->class_ver = 1;
 	smp->method = IB_MAD_METHOD_TRAP;
-	smp->trans_id = cl_hton64((uint64_t) cl_atomic_inc(&sm->sm_trans_id));
+	smp->trans_id = cl_hton64((uint64_t) cl_atomic_inc(&sm->sm_trans_id) &
+							   (uint64_t)(0xFFFFFFFF));
 	smp->attr_id = IB_MAD_ATTR_NOTICE;
 
 	ntc = (ib_mad_notice_attr_t *) smp->data;
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

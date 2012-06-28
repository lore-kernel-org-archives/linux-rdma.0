From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 2/2] opensm: Skip TID 0 on 32 bit wraparound for SM, SA, and
 PerfMgt queries
Date: Thu, 28 Jun 2012 13:11:21 -0400
Message-ID: <4FEC9039.8020506@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_inform.c  |    9 +++++++--
 opensm/osm_perfmgr.c |    7 ++++++-
 opensm/osm_req.c     |   10 ++++++++++
 3 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/opensm/osm_inform.c b/opensm/osm_inform.c
index 6a2cb7e..77115d5 100644
--- a/opensm/osm_inform.c
+++ b/opensm/osm_inform.c
@@ -295,6 +295,7 @@ static ib_api_status_t send_report(IN osm_infr_t * p_infr_rec,	/* the informinfo
 	static atomic32_t trap_fwd_trans_id = 0x02DAB000;
 	ib_api_status_t status = IB_SUCCESS;
 	osm_log_t *p_log = p_infr_rec->sa->p_log;
+	ib_net64_t tid;
 
 	OSM_LOG_ENTER(p_log);
 
@@ -321,10 +322,14 @@ static ib_api_status_t send_report(IN osm_infr_t * p_infr_rec,	/* the informinfo
 	p_report_madw->resp_expected = TRUE;
 
 	/* advance trap trans id (cant simply ++ on some systems inside ntoh) */
+	tid = cl_hton64((uint64_t) cl_atomic_inc(&trap_fwd_trans_id) &
+						 (uint64_t) (0xFFFFFFFF));
+	if (trap_fwd_trans_id == 0)
+		tid = cl_hton64((uint64_t) cl_atomic_inc(&trap_fwd_trans_id) &
+							 (uint64_t) (0xFFFFFFFF));
 	p_mad = osm_madw_get_mad_ptr(p_report_madw);
 	ib_mad_init_new(p_mad, IB_MCLASS_SUBN_ADM, 2, IB_MAD_METHOD_REPORT,
-			cl_hton64((uint64_t) cl_atomic_inc(&trap_fwd_trans_id)),
-			IB_MAD_ATTR_NOTICE, 0);
+			tid, IB_MAD_ATTR_NOTICE, 0);
 
 	p_sa_mad = osm_madw_get_sa_mad_ptr(p_report_madw);
 
diff --git a/opensm/osm_perfmgr.c b/opensm/osm_perfmgr.c
index 41ef08b..1b46679 100644
--- a/opensm/osm_perfmgr.c
+++ b/opensm/osm_perfmgr.c
@@ -380,7 +380,12 @@ static ib_api_status_t perfmgr_send_pc_mad(osm_perfmgr_t * perfmgr,
 	pm_mad->header.status = 0;
 	pm_mad->header.class_spec = 0;
 	pm_mad->header.trans_id =
-	    cl_hton64((uint64_t) cl_atomic_inc(&perfmgr->trans_id));
+	    cl_hton64((uint64_t) cl_atomic_inc(&perfmgr->trans_id) &
+					       (uint64_t) (0xFFFFFFFF));
+	if (perfmgr->trans_id == 0)
+		pm_mad->header.trans_id =
+		    cl_hton64((uint64_t) cl_atomic_inc(&perfmgr->trans_id) &
+						       (uint64_t) (0xFFFFFFFF));
 	pm_mad->header.attr_id = IB_MAD_ATTR_PORT_CNTRS;
 	pm_mad->header.resv = 0;
 	pm_mad->header.attr_mod = 0;
diff --git a/opensm/osm_req.c b/opensm/osm_req.c
index ee2a64e..c0d36e4 100644
--- a/opensm/osm_req.c
+++ b/opensm/osm_req.c
@@ -93,6 +93,9 @@ ib_api_status_t osm_req_get(IN osm_sm_t * sm, IN const osm_dr_path_t * p_path,
 
 	tid = cl_hton64((uint64_t) cl_atomic_inc(&sm->sm_trans_id) &
 						 (uint64_t)(0xFFFFFFFF));
+	if (tid == 0)
+		tid = cl_hton64((uint64_t) cl_atomic_inc(&sm->sm_trans_id) &
+							 (uint64_t)(0xFFFFFFFF));
 
 	OSM_LOG(sm->p_log, OSM_LOG_DEBUG,
 		"Getting %s (0x%X), modifier 0x%X, TID 0x%" PRIx64 "\n",
@@ -164,6 +167,9 @@ ib_api_status_t osm_req_set(IN osm_sm_t * sm, IN const osm_dr_path_t * p_path,
 
 	tid = cl_hton64((uint64_t) cl_atomic_inc(&sm->sm_trans_id) &
 						 (uint64_t)(0xFFFFFFFF));
+	if (tid == 0)
+		tid = cl_hton64((uint64_t) cl_atomic_inc(&sm->sm_trans_id) &
+							 (uint64_t)(0xFFFFFFFF));
 
 	OSM_LOG(sm->p_log, OSM_LOG_DEBUG,
 		"Setting %s (0x%X), modifier 0x%X, TID 0x%" PRIx64 "\n",
@@ -252,6 +258,10 @@ int osm_send_trap144(osm_sm_t * sm, ib_net16_t local)
 	smp->method = IB_MAD_METHOD_TRAP;
 	smp->trans_id = cl_hton64((uint64_t) cl_atomic_inc(&sm->sm_trans_id) &
 							   (uint64_t)(0xFFFFFFFF));
+	if (smp->trans_id == 0)
+		smp->trans_id = cl_hton64((uint64_t) cl_atomic_inc(&sm->sm_trans_id) &
+								   (uint64_t)(0xFFFFFFFF));
+
 	smp->attr_id = IB_MAD_ATTR_NOTICE;
 
 	ntc = (ib_mad_notice_attr_t *) smp->data;
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

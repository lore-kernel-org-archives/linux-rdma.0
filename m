From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osm_[sm sa]_mad_ctrl.c: Improve unsupported attribute
 error messages
Date: Wed, 28 May 2014 09:06:45 -0400
Message-ID: <5385DF65.10207@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_sa_mad_ctrl.c |    5 +++--
 opensm/osm_sm_mad_ctrl.c |   20 ++++++++++++--------
 2 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/opensm/osm_sa_mad_ctrl.c b/opensm/osm_sa_mad_ctrl.c
index 72ebe6a..b838787 100644
--- a/opensm/osm_sa_mad_ctrl.c
+++ b/opensm/osm_sa_mad_ctrl.c
@@ -242,8 +242,9 @@ static void sa_mad_ctrl_process(IN osm_sa_mad_ctrl_t * p_ctrl,
 
 	default:
 		OSM_LOG(p_ctrl->p_log, OSM_LOG_ERROR, "ERR 1A01: "
-			"Unsupported attribute 0x%X\n",
-			cl_ntoh16(p_sa_mad->attr_id));
+			"Unsupported attribute 0x%X (%s)\n",
+			cl_ntoh16(p_sa_mad->attr_id),
+			ib_get_sa_attr_str(p_sa_mad->attr_id));
 		osm_dump_sa_mad_v2(p_ctrl->p_log, p_sa_mad, FILE_ID, OSM_LOG_ERROR);
 	}
 
diff --git a/opensm/osm_sm_mad_ctrl.c b/opensm/osm_sm_mad_ctrl.c
index d166587..85ad088 100644
--- a/opensm/osm_sm_mad_ctrl.c
+++ b/opensm/osm_sm_mad_ctrl.c
@@ -262,8 +262,9 @@ static void sm_mad_ctrl_process_get_resp(IN osm_sm_mad_ctrl_t * p_ctrl,
 	default:
 		cl_atomic_inc(&p_ctrl->p_stats->qp0_mads_rcvd_unknown);
 		OSM_LOG(p_ctrl->p_log, OSM_LOG_ERROR, "ERR 3103: "
-			"Unsupported attribute 0x%X\n",
-			cl_ntoh16(p_smp->attr_id));
+			"Unsupported attribute 0x%X (%s)\n",
+			cl_ntoh16(p_smp->attr_id),
+			ib_get_sm_attr_str(p_smp->attr_id));
 		osm_dump_dr_smp_v2(p_ctrl->p_log, p_smp, FILE_ID, OSM_LOG_ERROR);
 		osm_mad_pool_put(p_ctrl->p_mad_pool, p_madw);
 		goto Exit;
@@ -392,8 +393,9 @@ static void sm_mad_ctrl_process_set(IN osm_sm_mad_ctrl_t * p_ctrl,
 	default:
 		cl_atomic_inc(&p_ctrl->p_stats->qp0_mads_rcvd_unknown);
 		OSM_LOG(p_ctrl->p_log, OSM_LOG_ERROR, "ERR 3107: "
-			"Unsupported attribute 0x%X\n",
-			cl_ntoh16(p_smp->attr_id));
+			"Unsupported attribute 0x%X (%s)\n",
+			cl_ntoh16(p_smp->attr_id),
+			ib_get_sm_attr_str(p_smp->attr_id));
 		osm_dump_dr_smp_v2(p_ctrl->p_log, p_smp, FILE_ID, OSM_LOG_ERROR);
 		osm_mad_pool_put(p_ctrl->p_mad_pool, p_madw);
 		goto Exit;
@@ -471,8 +473,9 @@ static void sm_mad_ctrl_process_trap(IN osm_sm_mad_ctrl_t * p_ctrl,
 	default:
 		cl_atomic_inc(&p_ctrl->p_stats->qp0_mads_rcvd_unknown);
 		OSM_LOG(p_ctrl->p_log, OSM_LOG_ERROR, "ERR 3109: "
-			"Unsupported attribute 0x%X\n",
-			cl_ntoh16(p_smp->attr_id));
+			"Unsupported attribute 0x%X (%s)\n",
+			cl_ntoh16(p_smp->attr_id),
+			ib_get_sm_attr_str(p_smp->attr_id));
 		osm_dump_dr_smp_v2(p_ctrl->p_log, p_smp, FILE_ID, OSM_LOG_ERROR);
 		osm_mad_pool_put(p_ctrl->p_mad_pool, p_madw);
 		goto Exit;
@@ -540,8 +543,9 @@ static void sm_mad_ctrl_process_trap_repress(IN osm_sm_mad_ctrl_t * p_ctrl,
 	default:
 		cl_atomic_inc(&p_ctrl->p_stats->qp0_mads_rcvd_unknown);
 		OSM_LOG(p_ctrl->p_log, OSM_LOG_ERROR, "ERR 3105: "
-			"Unsupported attribute 0x%X\n",
-			cl_ntoh16(p_smp->attr_id));
+			"Unsupported attribute 0x%X (%s)\n",
+			cl_ntoh16(p_smp->attr_id),
+			ib_get_sm_attr_str(p_smp->attr_id));
 		osm_dump_dr_smp_v2(p_ctrl->p_log, p_smp, FILE_ID, OSM_LOG_ERROR);
 		osm_mad_pool_put(p_ctrl->p_mad_pool, p_madw);
 		break;
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

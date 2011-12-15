From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH V2] opensm: on MAD error call back print DR PATH or LID of
 request MAD
Date: Wed, 14 Dec 2011 19:18:43 -0800
Message-ID: <20111214191843.35cecd64.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


In addition print transaction ID of all DR PATH dumps to make sure we know
which MAD's they refer to.

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 libvendor/osm_vendor_ibumad.c |    2 --
 opensm/osm_helper.c           |    5 +++--
 opensm/osm_sm_mad_ctrl.c      |   16 ++++++++++++++--
 3 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/libvendor/osm_vendor_ibumad.c b/libvendor/osm_vendor_ibumad.c
index e2ebd8e..b2872c8 100644
--- a/libvendor/osm_vendor_ibumad.c
+++ b/libvendor/osm_vendor_ibumad.c
@@ -348,8 +348,6 @@ static void *umad_receiver(void *p_ptr)
 					", Hop Ptr: 0x%X\n",
 					mad->method, cl_ntoh16(mad->attr_id),
 					cl_ntoh64(mad->trans_id), smp->hop_ptr);
-				osm_dump_smp_dr_path(p_vend->p_log, smp,
-						     OSM_LOG_ERROR);
 			}
 
 			if (!(p_req_madw = get_madw(p_vend, &mad->trans_id))) {
diff --git a/opensm/osm_helper.c b/opensm/osm_helper.c
index f9f3d9d..b968679 100644
--- a/opensm/osm_helper.c
+++ b/opensm/osm_helper.c
@@ -2059,8 +2059,9 @@ void osm_dump_smp_dr_path(IN osm_log_t * p_log, IN const ib_smp_t * p_smp,
 		char buf[BUF_SIZE];
 		unsigned n;
 
-		n = sprintf(buf, "Received SMP on a %u hop path: "
-			    "Initial path = ", p_smp->hop_count);
+		n = sprintf(buf, "   DR SMP (TID 0x%" PRIx64 ") on a %u hop path: "
+			    "Initial path = ",
+			    cl_ntoh64(p_smp->trans_id), p_smp->hop_count);
 		n += sprint_uint8_arr(buf + n, sizeof(buf) - n,
 				      p_smp->initial_path,
 				      p_smp->hop_count + 1);
diff --git a/opensm/osm_sm_mad_ctrl.c b/opensm/osm_sm_mad_ctrl.c
index ee92c66..a3b444a 100644
--- a/opensm/osm_sm_mad_ctrl.c
+++ b/opensm/osm_sm_mad_ctrl.c
@@ -704,6 +704,7 @@ Exit:
  */
 static void sm_mad_ctrl_send_err_cb(IN void *context, IN osm_madw_t * p_madw)
 {
+	char lidstr[8];
 	osm_sm_mad_ctrl_t *p_ctrl = context;
 	ib_api_status_t status;
 	ib_smp_t *p_smp;
@@ -713,13 +714,24 @@ static void sm_mad_ctrl_send_err_cb(IN void *context, IN osm_madw_t * p_madw)
 	CL_ASSERT(p_madw);
 
 	p_smp = osm_madw_get_smp_ptr(p_madw);
+
+	if (p_smp->mgmt_class == IB_MCLASS_SUBN_DIR)
+		lidstr[0] = '\0';
+	else
+		snprintf(lidstr, 8, " DLID %u",
+			cl_ntoh16(p_madw->mad_addr.dest_lid));
+
 	OSM_LOG(p_ctrl->p_log, OSM_LOG_ERROR, "ERR 3113: "
 		"MAD completed in error (%s): "
-		"%s(%s), attr_mod 0x%x, TID 0x%" PRIx64 "\n",
+		"%s(%s), attr_mod 0x%x, TID 0x%" PRIx64 " %s\n",
 		ib_get_err_str(p_madw->status),
 		ib_get_sm_method_str(p_smp->method),
 		ib_get_sm_attr_str(p_smp->attr_id), cl_ntoh32(p_smp->attr_mod),
-		cl_ntoh64(p_smp->trans_id));
+		cl_ntoh64(p_smp->trans_id),
+		lidstr);
+
+	if (p_smp->mgmt_class == IB_MCLASS_SUBN_DIR)
+		osm_dump_smp_dr_path(p_ctrl->p_log, p_smp, OSM_LOG_ERROR);
 
 	/*
 	   If this was a SubnSet MAD, then this error might indicate a problem
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

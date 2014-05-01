From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] SM should resweep the fabric if vl15_send_mad fails
Date: Thu, 01 May 2014 10:42:00 -0400
Message-ID: <53625D38.6020602@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

If osm_vendor_send fails to send a resp_expected MAD in vl15_send_mad,
opensm needs to resweep the fabric to recover from this
error.

Signed-off-by: Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/opensm/osm_vl15intf.h |   11 ++++++++++-
 opensm/osm_opensm.c           |    2 +-
 opensm/osm_vl15intf.c         |   18 +++++++++++++++++-
 3 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/include/opensm/osm_vl15intf.h b/include/opensm/osm_vl15intf.h
index e621c68..b024b23 100644
--- a/include/opensm/osm_vl15intf.h
+++ b/include/opensm/osm_vl15intf.h
@@ -53,6 +53,7 @@
 #include <opensm/osm_madw.h>
 #include <opensm/osm_mad_pool.h>
 #include <vendor/osm_vendor_api.h>
+#include <opensm/osm_subnet.h>
 
 #ifdef __cplusplus
 #  define BEGIN_C_DECLS extern "C" {
@@ -127,6 +128,7 @@ typedef struct osm_vl15 {
 	osm_vendor_t *p_vend;
 	osm_log_t *p_log;
 	osm_stats_t *p_stats;
+	osm_subn_t *p_subn;
 } osm_vl15_t;
 /*
 * FIELDS
@@ -171,6 +173,9 @@ typedef struct osm_vl15 {
 *	p_stats
 *		Pointer to the OpenSM statistics block.
 *
+*	p_subn
+*		Pointer to the OpenSM subnet object.
+*
 * SEE ALSO
 *	VL15 object
 *********/
@@ -251,6 +256,7 @@ void osm_vl15_destroy(IN osm_vl15_t * p_vl15, IN struct osm_mad_pool *p_pool);
 */
 ib_api_status_t osm_vl15_init(IN osm_vl15_t * p_vl15, IN osm_vendor_t * p_vend,
 			      IN osm_log_t * p_log, IN osm_stats_t * p_stats,
+			      IN osm_subn_t * p_subn,
 			      IN int32_t max_wire_smps,
 			      IN int32_t max_wire_smps2,
 			      IN uint32_t max_smps_timeout);
@@ -266,7 +272,10 @@ ib_api_status_t osm_vl15_init(IN osm_vl15_t * p_vl15, IN osm_vendor_t * p_vend,
 *		[in] Pointer to the log object.
 *
 *	p_stats
-*		[in] Pointer to the OpenSM stastics block.
+*		[in] Pointer to the OpenSM statistics block.
+*
+*	p_subn
+*		[in] Pointer to the OpenSM subnet object.
 *
 *	max_wire_smps
 *		[in] Maximum number of SMPs allowed on the wire at one time.
diff --git a/opensm/osm_opensm.c b/opensm/osm_opensm.c
index f702c80..69d2ba6 100644
--- a/opensm/osm_opensm.c
+++ b/opensm/osm_opensm.c
@@ -465,7 +465,7 @@ ib_api_status_t osm_opensm_init_finish(IN osm_opensm_t * p_osm,
 		goto Exit;
 
 	status = osm_vl15_init(&p_osm->vl15, p_osm->p_vendor,
-			       &p_osm->log, &p_osm->stats,
+			       &p_osm->log, &p_osm->stats, &p_osm->subn,
 			       p_opt->max_wire_smps, p_opt->max_wire_smps2,
 			       p_opt->max_smps_timeout);
 	if (status != IB_SUCCESS)
diff --git a/opensm/osm_vl15intf.c b/opensm/osm_vl15intf.c
index f85252c..d00ecda 100644
--- a/opensm/osm_vl15intf.c
+++ b/opensm/osm_vl15intf.c
@@ -60,6 +60,7 @@ static void vl15_send_mad(osm_vl15_t * p_vl, osm_madw_t * p_madw)
 {
 	ib_api_status_t status;
 	boolean_t resp_expected = p_madw->resp_expected;
+	ib_smp_t * p_smp;
 
 	/*
 	   Non-response-expected mads are not throttled on the wire
@@ -106,8 +107,21 @@ static void vl15_send_mad(osm_vl15_t * p_vl, osm_madw_t * p_madw)
 	   qp0_mads_outstanding will be decremented by send error callback
 	   (called by osm_vendor_send() */
 	cl_atomic_dec(&p_vl->p_stats->qp0_mads_sent);
-	if (!resp_expected)
+	if (!resp_expected) {
 		cl_atomic_dec(&p_vl->p_stats->qp0_unicasts_sent);
+		return;
+	}
+
+	/* need to cause heavy-sweep if resp_expected MAD sending failed */
+	p_smp = osm_madw_get_smp_ptr(p_madw);
+	OSM_LOG(p_vl->p_log, OSM_LOG_ERROR, "ERR 3E04: "
+		"%s method failed for attribute 0x%X (%s)\n",
+		p_smp->method == IB_MAD_METHOD_SET ? "SET" : "GET",
+		cl_ntoh16(p_smp->attr_id),
+		ib_get_sm_attr_str(p_smp->attr_id));
+
+	p_vl->p_subn->subnet_initialization_error = TRUE;
+
 }
 
 static void vl15_poller(IN void *p_ptr)
@@ -246,6 +260,7 @@ void osm_vl15_destroy(IN osm_vl15_t * p_vl, IN struct osm_mad_pool *p_pool)
 
 ib_api_status_t osm_vl15_init(IN osm_vl15_t * p_vl, IN osm_vendor_t * p_vend,
 			      IN osm_log_t * p_log, IN osm_stats_t * p_stats,
+			      IN osm_subn_t * p_subn,
 			      IN int32_t max_wire_smps,
 			      IN int32_t max_wire_smps2,
 			      IN uint32_t max_smps_timeout)
@@ -257,6 +272,7 @@ ib_api_status_t osm_vl15_init(IN osm_vl15_t * p_vl, IN osm_vendor_t * p_vend,
 	p_vl->p_vend = p_vend;
 	p_vl->p_log = p_log;
 	p_vl->p_stats = p_stats;
+	p_vl->p_subn = p_subn;
 	p_vl->max_wire_smps = max_wire_smps;
 	p_vl->max_wire_smps2 = max_wire_smps2;
 	p_vl->max_smps_timeout = max_wire_smps < max_wire_smps2 ?
-- 
1.7.8.2


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

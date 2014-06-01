From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osm_vl15intf.c: Fix potential NULL dereference in
 vl15_send_mad
Date: Sun, 01 Jun 2014 08:41:42 -0400
Message-ID: <538B1F86.60503@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Tomer Cohen <tomerco-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Tomer Cohen <tomerco-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

In vl15_send_mad, there is a use in the function osm_vendor_send that could
free the p_madw and after the use of that function we use another function
the need p_madw.

Fix: save the parameters needed beforehand.

Signed-off-by: Tomer Cohen <tomerco-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_vl15intf.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/opensm/osm_vl15intf.c b/opensm/osm_vl15intf.c
index d00ecda..06a5001 100644
--- a/opensm/osm_vl15intf.c
+++ b/opensm/osm_vl15intf.c
@@ -61,6 +61,12 @@ static void vl15_send_mad(osm_vl15_t * p_vl, osm_madw_t * p_madw)
 	ib_api_status_t status;
 	boolean_t resp_expected = p_madw->resp_expected;
 	ib_smp_t * p_smp;
+	ib_net16_t attr_id;
+	uint8_t method;
+
+	p_smp = osm_madw_get_smp_ptr(p_madw);
+	method = p_smp->method;
+	attr_id = p_smp->attr_id;
 
 	/*
 	   Non-response-expected mads are not throttled on the wire
@@ -113,12 +119,10 @@ static void vl15_send_mad(osm_vl15_t * p_vl, osm_madw_t * p_madw)
 	}
 
 	/* need to cause heavy-sweep if resp_expected MAD sending failed */
-	p_smp = osm_madw_get_smp_ptr(p_madw);
 	OSM_LOG(p_vl->p_log, OSM_LOG_ERROR, "ERR 3E04: "
 		"%s method failed for attribute 0x%X (%s)\n",
-		p_smp->method == IB_MAD_METHOD_SET ? "SET" : "GET",
-		cl_ntoh16(p_smp->attr_id),
-		ib_get_sm_attr_str(p_smp->attr_id));
+		method == IB_MAD_METHOD_SET ? "SET" : "GET",
+		cl_ntoh16(attr_id), ib_get_sm_attr_str(attr_id));
 
 	p_vl->p_subn->subnet_initialization_error = TRUE;
 
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

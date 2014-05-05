From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osmtest.c: Fixed missing assignment of return value
 from function osmtest_get_port_rec_by_num
Date: Mon, 05 May 2014 09:31:54 -0400
Message-ID: <536792CA.4040707@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Tomer Cohen <tomerco-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Tomer Cohen <tomerco-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date: Sun, 4 May 2014 11:38:01 +0300

found by Coverity

Signed-off-by: Tomer Cohen <tomerco-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 osmtest/osmtest.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/osmtest/osmtest.c b/osmtest/osmtest.c
index 857df86..d7aef60 100644
--- a/osmtest/osmtest.c
+++ b/osmtest/osmtest.c
@@ -5097,9 +5097,9 @@ osmtest_validate_single_port_rec_lid(IN osmtest_t * const p_osmt,
 	memset(&context, 0, sizeof(context));
 
 	context.p_osmt = p_osmt;
-	osmtest_get_port_rec_by_num(p_osmt,
-				    p_port->rec.lid,
-				    p_port->rec.port_num, &context);
+	status = osmtest_get_port_rec_by_num(p_osmt,
+					     p_port->rec.lid,
+					     p_port->rec.port_num, &context);
 	if (status != IB_SUCCESS) {
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 0108: "
 			"ib_query failed (%s)\n", ib_get_err_str(status));
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

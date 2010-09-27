From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCH] osmtest/osmt_service.c: In osmt_run_service_records_flow,
	add missing status
Date: Mon, 27 Sep 2010 09:40:40 -0400
Message-ID: <20100927134040.GA1321@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


When deleting ServiceRecord for service_name[6] fails, error status should
be set.

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osmtest/osmt_service.c b/opensm/osmtest/osmt_service.c
index a203b0c..891fbe3 100644
--- a/opensm/osmtest/osmt_service.c
+++ b/opensm/osmtest/osmt_service.c
@@ -1578,6 +1578,7 @@ ib_api_status_t osmt_run_service_records_flow(IN osmtest_t * const p_osmt)
 		OSM_LOG(&p_osmt->log, OSM_LOG_ERROR, "ERR 4A32: "
 			"Failed to delete service name: %s\n",
 			(char *)service_name[6]);
+		status = IB_ERROR;
 		goto Exit;
 	}
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

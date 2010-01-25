From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCH] infiniband-diags/ibqueryerrors.c: Fix typo in counter name
Date: Mon, 25 Jan 2010 08:32:45 -0500
Message-ID: <20100125133245.GC2053@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
diff --git a/infiniband-diags/src/ibqueryerrors.c b/infiniband-diags/src/ibqueryerrors.c
index 04842d5..0b320ec 100644
--- a/infiniband-diags/src/ibqueryerrors.c
+++ b/infiniband-diags/src/ibqueryerrors.c
@@ -270,7 +270,7 @@ static void print_results(ib_portid_t * portid, char *node_name,
 		} else if (i == IB_PC_ERR_RCV_F && details && val) {
 			n += query_and_dump(str + n, sizeof(buf) - n, portid,
 					    node, node_name, portnum,
-					    "PortRcvErrorsDetails",
+					    "PortRcvErrorDetails",
 					    IB_GSI_PORT_RCV_ERROR_DETAILS,
 					    IB_PC_XMT_INACT_DISC_F,
 					    IB_PC_XMT_DISC_LAST_F);
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

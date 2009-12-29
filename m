From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCH] infiniband-diags/ibqueryerrors.c: Fix output format of
	counters
Date: Tue, 29 Dec 2009 09:30:49 -0500
Message-ID: <20091229143049.GA20458@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Should be unsigned decimal rather than plain decimal

Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
diff --git a/infiniband-diags/src/ibqueryerrors.c b/infiniband-diags/src/ibqueryerrors.c
index 370c74d..47bd2af 100644
--- a/infiniband-diags/src/ibqueryerrors.c
+++ b/infiniband-diags/src/ibqueryerrors.c
@@ -226,7 +226,7 @@ static int print_xmitdisc_details(char *buf, size_t size, ib_portid_t * portid,
 	     i++) {
 		mad_decode_field(pc, i, (void *)&val);
 		if (val)
-			n += snprintf(buf + n, size - n, " [%s == %d]",
+			n += snprintf(buf + n, size - n, " [%s == %u]",
 				      mad_field_name(i), val);
 	}
 	return n;
@@ -251,7 +251,7 @@ static void print_results(ib_portid_t * portid, char *node_name,
 
 		mad_decode_field(pc, i, (void *)&val);
 		if (val)
-			n += snprintf(str + n, 1024 - n, " [%s == %d]",
+			n += snprintf(str + n, 1024 - n, " [%s == %u]",
 				      mad_field_name(i), val);
 
 		/* If there are PortXmitDiscards, get details (if supported) */
@@ -264,7 +264,7 @@ static void print_results(ib_portid_t * portid, char *node_name,
 	if (!suppress(IB_PC_XMT_WAIT_F)) {
 		mad_decode_field(pc, IB_PC_XMT_WAIT_F, (void *)&val);
 		if (val)
-			n += snprintf(str + n, 1024 - n, " [%s == %d]",
+			n += snprintf(str + n, 1024 - n, " [%s == %u]",
 				      mad_field_name(IB_PC_XMT_WAIT_F), val);
 	}
 
@@ -276,7 +276,7 @@ static void print_results(ib_portid_t * portid, char *node_name,
 				mad_decode_field(pc, i, (void *)&val64);
 				if (val64)
 					n += snprintf(str + n, 1024 - n,
-						      " [%s == %" PRId64 "]",
+						      " [%s == %" PRIu64 "]",
 						      mad_field_name(i), val64);
 			}
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

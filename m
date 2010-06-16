From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCH][TRIVIAL] infiniband-diags/perfquery.8: Add some missing
	counters to description
Date: Wed, 16 Jun 2010 07:05:42 -0400
Message-ID: <20100616110542.GA11132@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Also, updated email address

Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
diff --git a/infiniband-diags/man/perfquery.8 b/infiniband-diags/man/perfquery.8
index 7e9636e..e01dc2f 100644
--- a/infiniband-diags/man/perfquery.8
+++ b/infiniband-diags/man/perfquery.8
@@ -1,4 +1,4 @@
-.TH PERFQUERY 8 "Dec 31, 2009" "OpenIB" "OpenIB Diagnostics"
+.TH PERFQUERY 8 "Jun 16, 2010" "OpenIB" "OpenIB Diagnostics"
 
 .SH NAME
 perfquery \- query InfiniBand port counters
@@ -14,7 +14,8 @@ perfquery \- query InfiniBand port counters
 .SH DESCRIPTION
 .PP
 perfquery uses PerfMgt GMPs to obtain the PortCounters (basic performance
-and error counters), PortExtendedCounters, PortXmitDataSL, or PortRcvDataSL
+and error counters), PortExtendedCounters, PortXmitDataSL, PortRcvDataSL,
+PortRcvErrorDetails, PortXmitDiscardDetails, or PortSamplesControl
 from the PMA at the node/port specified. Optionally shows aggregated
 counters for all ports of node.
 Also, optionally, reset after read, or only reset counters.
@@ -144,4 +145,4 @@ perfquery -R 32 2 0xf000 # reset only non-error counters of port 2
 .SH AUTHOR
 .TP
 Hal Rosenstock
-.RI < halr-smomgflXvOZWk0Htik3J/w@public.gmane.org >
+.RI < hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org >
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

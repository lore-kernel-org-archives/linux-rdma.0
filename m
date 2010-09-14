From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCH] infiniband-diags/ibtracert: Eliminate direct route (-D)
	option
Date: Tue, 14 Sep 2010 11:10:16 -0400
Message-ID: <20100914151016.GA19615@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Direct route does not make sense as an ibtracert option so eliminate it. 

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/infiniband-diags/man/ibtracert.8 b/infiniband-diags/man/ibtracert.8
index 0628554..674db7e 100644
--- a/infiniband-diags/man/ibtracert.8
+++ b/infiniband-diags/man/ibtracert.8
@@ -1,14 +1,14 @@
-.TH IBTRACERT 8 "April 14, 2007" "OpenIB" "OpenIB Diagnostics"
+.TH IBTRACERT 8 "September 14, 2010" "OpenIB" "OpenIB Diagnostics"
 
 .SH NAME
 ibtracert\- trace InfiniBand path
 
 .SH SYNOPSIS
 .B ibtracert
-[\-d(ebug)] [-v(erbose)] [\-D(irect)] [\-G(uids)] [-n(o_info)] [-m mlid]
+[\-d(ebug)] [-v(erbose)] [\-G(uids)] [-n(o_info)] [-m mlid]
 [-s smlid] [\-C ca_name] [\-P ca_port] [\-t(imeout) timeout_ms]
 [\-V(ersion)] [\-\-node\-name\-\-map <node-name-map>] [\-h(elp)]
-[<dest dr_path|lid|guid> [<startlid> [<endlid>]]]
+[<lid|guid> [<startlid> [<endlid>]]]
 
 .SH DESCRIPTION
 .PP
@@ -54,12 +54,6 @@ using the util_name -h syntax.
 
 # Addressing flags
 .PP
-\-D      use directed path address arguments. The path
-        is a comma separated list of out ports.
-        Examples:
-        "0"             # self port
-        "0,1,2,1,4"     # out via port 1, then 2, ...
-.PP
 \-G      use GUID address argument. In most cases, it is the Port GUID.
         Example:
         "0x08f1040023"
@@ -108,7 +102,7 @@ ibtracert -m 0xc000 4 16    # show multicast path of mlid 0xc000 between lids 4
 .SH AUTHOR
 .TP
 Hal Rosenstock
-.RI < halr-smomgflXvOZWk0Htik3J/w@public.gmane.org >
+.RI < hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
 .TP
 Ira Weiny
 .RI < weiny2-i2BcT+NCU+M@public.gmane.org >
diff --git a/infiniband-diags/src/ibtracert.c b/infiniband-diags/src/ibtracert.c
index 80694f2..9b563ab 100644
--- a/infiniband-diags/src/ibtracert.c
+++ b/infiniband-diags/src/ibtracert.c
@@ -1,6 +1,7 @@
 /*
  * Copyright (c) 2004-2009 Voltaire Inc.  All rights reserved.
  * Copyright (c) 2009 HNR Consulting.  All rights reserved.
+ * Copyright (c) 2010 Mellanox Technologies LTD.  All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -749,7 +750,7 @@ int main(int argc, char **argv)
 		NULL,
 	};
 
-	ibdiag_process_opts(argc, argv, NULL, NULL, opts, process_opt,
+	ibdiag_process_opts(argc, argv, NULL, "D", opts, process_opt,
 			    usage_args, usage_examples);
 
 	f = stdout;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCH] infiniband-diags/ibportstate.8: Add new supported ops
Date: Wed, 13 Jan 2010 15:23:18 -0500
Message-ID: <20100113202318.GA21477@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Added by Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
in commit 3af8e05e01a92bb504c8e806c0c81dc5ef246f7f

Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
diff --git a/infiniband-diags/man/ibportstate.8 b/infiniband-diags/man/ibportstate.8
index fea860e..c4c1b2a 100644
--- a/infiniband-diags/man/ibportstate.8
+++ b/infiniband-diags/man/ibportstate.8
@@ -1,4 +1,4 @@
-.TH IBPORTSTATE 8 "September 8, 2009" "OpenIB" "OpenIB Diagnostics"
+.TH IBPORTSTATE 8 "Jan 13, 2010" "OpenIB" "OpenIB Diagnostics"
 
 .SH NAME
 ibportstate \- handle port (physical) state and link speed of an InfiniBand port
@@ -23,7 +23,8 @@ also allows the link speed/width enabled on any IB port to be adjusted.
 .TP
 op
 Port operations allowed
- supported ops: enable, disable, reset, speed, width, query
+ supported ops: enable, disable, reset, speed, width, query,
+                down, arm, active, vls, mtu, lid, smlid, lmc
  Default is query
 .PP
  ops enable, disable, and reset are only allowed on switch ports
@@ -113,6 +114,8 @@ ibportstate 3 1 reset				# by lid
 ibportstate 3 1 speed 1				# by lid
 .PP
 ibportstate 3 1 width 1				# by lid
+.PP
+ibportstate -D 0 1 lid 0x1234 arm		# by direct route
 
 .SH AUTHOR
 .TP
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

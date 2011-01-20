From: Lloyd Brown <lloyd_brown-pC3/9zQCMHo@public.gmane.org>
Subject: [PATCH 2/2] Update ibcheckerrors manpage for -T option
Date: Thu, 20 Jan 2011 15:42:42 -0700
Message-ID: <1295563362-24695-3-git-send-email-lloyd_brown@byu.edu>
References: <1295563362-24695-1-git-send-email-lloyd_brown@byu.edu>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1295563362-24695-1-git-send-email-lloyd_brown-8Bzd4dk9+oo@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Lloyd Brown <lloyd_brown-pC3/9zQCMHo@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch documents the "-T" option in the ibcheckerrors
 manpage, which allows the user to specify a thresholds file,
 which is passed along to the ibcheckerrs tool.

Signed-off-by: Lloyd Brown <lloyd_brown-8Bzd4dk9+oo@public.gmane.org>
---
 infiniband-diags/man/ibcheckerrors.8 |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/infiniband-diags/man/ibcheckerrors.8 b/infiniband-diags/man/ibcheckerrors.8
index 7c2467f..6f82ab3 100644
--- a/infiniband-diags/man/ibcheckerrors.8
+++ b/infiniband-diags/man/ibcheckerrors.8
@@ -5,7 +5,7 @@ ibcheckerrors \- validate IB subnet and report errors
 
 .SH SYNOPSIS
 .B ibcheckerrors
-[\-h] [\-b] [\-v] [\-N | \-nocolor] [<topology-file> | \-C ca_name
+[\-h] [\-b] [\-v] [\-N | \-nocolor] [-T <threshold_file>] [<topology-file> | \-C ca_name
 \-P ca_port \-t(imeout) timeout_ms]
 
 .SH DESCRIPTION
@@ -23,6 +23,8 @@ errors (from port counters).
 .PP
 \-N | \-nocolor	use mono rather than color mode
 .PP
+\-T <threshold_file> use the specified threshold file, overriding defaults.  You can generate a file containing default thresholds with \fIibcheckerrs -s\fP.
+.PP
 \-C <ca_name>   use the specified ca_name.
 .PP
 \-P <ca_port>   use the specified ca_port.
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

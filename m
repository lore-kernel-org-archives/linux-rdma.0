From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH libibverbs v2] Add basic man page entry for ibv_xsrq_pingpong
Date: Tue, 24 May 2016 16:35:05 -0400
Message-ID: <1464122105-52462-1-git-send-email-jarod@redhat.com>
References: <1464120403-39680-1-git-send-email-jarod@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1464120403-39680-1-git-send-email-jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

We have internal tools that complain about any binaries that are missing
corresponding man pages, and all the other examples have 'em.

Shamelessly ripped off from ibv_srq_pingpong's man page.

CC: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Signed-off-by: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
v2: Add reference to Makefile.am so it gets installed

 Makefile.am             |  2 +-
 man/ibv_xsrq_pingpong.1 | 71 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 72 insertions(+), 1 deletion(-)
 create mode 100644 man/ibv_xsrq_pingpong.1

diff --git a/Makefile.am b/Makefile.am
index cae80bb..6d46678 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -65,7 +65,7 @@ man_MANS = man/ibv_asyncwatch.1 man/ibv_devices.1 man/ibv_devinfo.1	\
     man/ibv_create_qp_ex.3 man/ibv_create_srq_ex.3 man/ibv_open_xrcd.3  \
     man/ibv_get_srq_num.3 man/ibv_open_qp.3 man/ibv_query_device_ex.3	\
     man/ibv_alloc_mw.3 man/ibv_bind_mw.3 man/ibv_inc_rkey.3		\
-    man/ibv_rereg_mr.3
+    man/ibv_rereg_mr.3 man/ibv_xsrq_pingpong.1
 
 DEBIAN = debian/changelog debian/compat debian/control debian/copyright \
     debian/ibverbs-utils.install debian/libibverbs1.install \
diff --git a/man/ibv_xsrq_pingpong.1 b/man/ibv_xsrq_pingpong.1
new file mode 100644
index 0000000..db4a988
--- /dev/null
+++ b/man/ibv_xsrq_pingpong.1
@@ -0,0 +1,71 @@
+.TH IBV_XSRQ_PINGPONG 1 "May 24, 2016" "libibverbs" "USER COMMANDS"
+
+.SH NAME
+ibv_xsrq_pingpong \- simple InfiniBand shared receive queue test
+
+.SH SYNOPSIS
+.B ibv_xsrq_pingpong
+[\-p port] [\-d device] [\-i ib port] [\-s size] [\-m mtu] [\-c clients]
+[\-n num_tests] [\-l sl] [\-e] \fBHOSTNAME\fR
+
+.B ibv_xsrq_pingpong
+[\-p port] [\-d device] [\-i ib port] [\-s size] [\-m mtu] [\-c clients]
+[\-n num_tests] [\-l sl] [\-e]
+
+.SH DESCRIPTION
+.PP
+Run a simple ping-pong test over InfiniBand via the extended reliable
+connected (XRC) transport service, using a shared receive queue (SRQ).
+
+.SH OPTIONS
+
+.PP
+.TP
+\fB\-p\fR, \fB\-\-port\fR=\fIPORT\fR
+use TCP port \fIPORT\fR for initial synchronization (default 18515)
+.TP
+\fB\-d\fR, \fB\-\-ib\-dev\fR=\fIDEVICE\fR
+use IB device \fIDEVICE\fR (default first device found)
+.TP
+\fB\-i\fR, \fB\-\-ib\-port\fR=\fIPORT\fR
+use IB port \fIPORT\fR (default port 1)
+.TP
+\fB\-s\fR, \fB\-\-size\fR=\fISIZE\fR
+ping-pong messages of size \fISIZE\fR (default 4096)
+.TP
+\fB\-m\fR, \fB\-\-mtu\fR=\fIMTU\fR
+use path mtu of size \fIMTU\fR (default 2048)
+.TP
+\fB\-c\fR, \fB\-\-clients\fR=\fICLIENTS\fR
+number of clients \fICLIENTS\fR (on server only, default 1)
+.TP
+\fB\-n\fR, \fB\-\-num\-tests\fR=\fINUM_TESTS\fR
+perform \fINUM_TESTS\fR tests per client (default 5)
+.TP
+\fB\-l\fR, \fB\-\-sl\fR=\fISL\fR
+use \fISL\fR as the service level value (default 0)
+.TP
+\fB\-e\fR, \fB\-\-events\fR
+sleep while waiting for work completion events (default is to poll for
+completions)
+
+.SH SEE ALSO
+.BR ibv_rc_pingpong (1),
+.BR ibv_uc_pingpong (1),
+.BR ibv_ud_pingpong (1)
+.BR ibv_srq_pingpong (1)
+
+.SH AUTHORS
+.TP
+Roland Dreier
+.RI < roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org >
+.TP
+Jarod Wilson
+.RI < jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org >
+
+.SH BUGS
+The network synchronization between client and server instances is
+weak, and does not prevent incompatible options from being used on the
+two instances.  The method used for retrieving work completions is not
+strictly correct, and race conditions may cause failures on some
+systems.
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

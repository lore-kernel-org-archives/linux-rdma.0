From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 09/15 ibacm] Update ib_acme.1 and ibacm.1 man pages
Date: Fri, 21 Jun 2013 07:02:10 -0400
Message-ID: <51C432B2.6090607@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 man/ib_acme.1 |   21 +++++++++++++++------
 man/ibacm.1   |   20 +++++++++++++++++---
 2 files changed, 32 insertions(+), 9 deletions(-)

diff --git a/man/ib_acme.1 b/man/ib_acme.1
index d5ac269..6485858 100644
--- a/man/ib_acme.1
+++ b/man/ib_acme.1
@@ -1,13 +1,13 @@
-.TH "ib_acme" 7 "2010-12-06" "ib_acme" "ib_acme" ib_acme
+.TH "ib_acme" 7 "2013-06-15" "ib_acme" "ib_acme" ib_acme
 .SH NAME
 ib_acme \- test and configuration utility for the IB ACM
 .SH SYNOPSIS
 .sp
 .nf
-\fIib_acme\fR [-f addr_format] [-s src_addr] -d dest_addr [-v]
+\fIib_acme\fR [-f addr_format] [-s src_addr] -d dest_addr [-v] [-c] [-P] [-S svc_addr]
 .fi
 .nf
-\fIib_acme\fR [-G] [-O]
+\fIib_acme\fR [-A [addr_file]] [-O [opt_file]] [-D dest_dir] [-V]
 .fi
 .SH "DESCRIPTION"
 ib_acme provides assistance configuring and testing the ibacm service.
@@ -42,17 +42,26 @@ resolved path information is usable given the current cluster configuration.
 Instructs the ACM service to only returned information that currently resides
 in its local cache.
 .TP
-\-A
+\-P
+Queries performance data from the destination service
+.TP
+\-S svc_addr
+address of ACM service, default: local service
+.TP
+\-A [addr_file]
 With this option, the ib_acme utility automatically generates the address
 configuration file ibacm_addr.cfg.  The generated file is
 constructed using the system host name and any IP addresses that are
 assigned to IPoIB device instances.
 .TP
-\-O
+\-O [opt_file]
 With this option, the ib_acme utility automatically generates the option
 configuration file ibacm_opts.cfg.  The generated file is currently generated
 using static information.
 .TP
+\-D dest_dir
+Specify the destination directory for the output files.
+.TP
 \-V
 Enables verbose output.  When combined with -A or -O options, ib_acme will
 display additional details, such as generated address information saved
@@ -78,4 +87,4 @@ numerical ranges inside the brackets using the following example as a
 guide: node[1-3,5,7-8].  This will result in testing node1, node2, node3,
 node5, node7, and node8.   
 .SH "SEE ALSO"
-ibacm(7) ibacm(1)
+ibacm(7), ibacm(1)
diff --git a/man/ibacm.1 b/man/ibacm.1
index 075b98e..35b79c6 100644
--- a/man/ibacm.1
+++ b/man/ibacm.1
@@ -1,10 +1,10 @@
-.TH "ibacm" 1 "2012-03-01" "ibacm" "ibacm" ibacm
+.TH "ibacm" 1 "2013-06-15" "ibacm" "ibacm" ibacm
 .SH NAME
 ibacm \- address and route resolution services for InfiniBand.
 .SH SYNOPSIS
 .sp
 .nf
-\fIibacm\fR
+\fIibacm\fR [-D] [-P] [-A addr_file] [-O option_file]
 .fi
 .SH "DESCRIPTION"
 The IB ACM implements and provides a framework for name,
@@ -33,6 +33,19 @@ different fabric topologies.
 The IB ACM package is comprised of two components: the ibacm service
 and a test/configuration utility - ib_acme.  Both are userspace components
 and are available for Linux and Windows.  Additional details are given below.
+.SH "OPTIONS"
+.TP
+\-D
+run in daemon mode (default)
+.TP
+\-P
+run as standard process
+.TP
+\-A addr_file
+address configuration file
+.TP
+\-O option_file
+option configuration file
 .SH "QUICK START GUIDE"
 1. Prerequisites: libibverbs and libibumad must be installed.
 The IB stack should be running with IPoIB configured.
@@ -46,6 +59,7 @@ These steps assume that the user has administrative privileges.
 the ibacm service is running.
 .P
 5. Install librdmacm, using the build option --with-ib_acm if needed.
+This build option is not needed with librdmacm 1.0.17 or newer.
 The librdmacm will automatically use the ibacm service.
 On failures, the librdmacm will fall back to normal resolution.
 .P
@@ -132,4 +146,4 @@ limited to 4.
 .P
 - The number of multicast groups that an endpoint can support is limited to 2.
 .SH "SEE ALSO"
-ibacm(7) ib_acme(1), rdma_cm(7)
+ibacm(7), ib_acme(1), rdma_cm(7)
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

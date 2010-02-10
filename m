From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCH] ibutils: Update email address and URL
Date: Wed, 10 Feb 2010 08:23:30 -0500
Message-ID: <20100210132330.GA11198@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
diff --git a/configure.in b/configure.in
index 40d0a29..39105c4 100644
--- a/configure.in
+++ b/configure.in
@@ -1,6 +1,6 @@
 dnl Process this file with autoconf to produce a configure script.
 
-AC_INIT([ibutils], [1.5.1], [openib-general-0P3JtQMG0aQdnm+yROfE0A@public.gmane.org])
+AC_INIT([ibutils], [1.5.1], [linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org])
 dnl use local config dir for extras
 AC_CONFIG_AUX_DIR(config)
 
diff --git a/ibutils.spec.in b/ibutils.spec.in
index 25c356b..8766d31 100644
--- a/ibutils.spec.in
+++ b/ibutils.spec.in
@@ -32,7 +32,7 @@ Name: ibutils
 Version: @VERSION@
 Release: 1%{?dist}
 License: GPL/BSD
-Url: http://openib.org/downloads/%{name}-%{version}.tar.gz
+Url: http://openfabrics.org/downloads/%{name}-%{version}.tar.gz
 Group: System Environment/Libraries
 Source: %{name}-%{version}.tar.gz
 BuildRoot: %{?build_root:%{build_root}}%{!?build_root:%{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)}
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

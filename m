From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 5/8] iwpmd: Move iwpmd.1 man page to iwpmd.8
Date: Wed, 26 Jul 2017 13:59:09 -0600
Message-ID: <1501099152-6344-6-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1501099152-6344-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1501099152-6344-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Section 8 is appropriate for root only daemons.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 debian/iwpmd.install             | 4 ++--
 iwpmd/CMakeLists.txt             | 2 +-
 iwpmd/{iwpmd.1.in => iwpmd.8.in} | 2 +-
 iwpmd/iwpmd.conf.5.in            | 2 +-
 redhat/rdma-core.spec            | 2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)
 rename iwpmd/{iwpmd.1.in => iwpmd.8.in} (98%)

diff --git a/debian/iwpmd.install b/debian/iwpmd.install
index bff17f15abf7d9..30ff49ccaefa41 100644
--- a/debian/iwpmd.install
+++ b/debian/iwpmd.install
@@ -1,6 +1,6 @@
 etc/init.d/iwpmd
 etc/iwpmd.conf
 lib/systemd/system/iwpmd.service
-usr/bin/iwpmd
-usr/share/man/man1/iwpmd.1
+usr/sbin/iwpmd
+usr/share/man/man8/iwpmd.8
 usr/share/man/man5/iwpmd.conf.5
diff --git a/iwpmd/CMakeLists.txt b/iwpmd/CMakeLists.txt
index ee9e5a3dfeb24e..56dabdcf409638 100644
--- a/iwpmd/CMakeLists.txt
+++ b/iwpmd/CMakeLists.txt
@@ -9,7 +9,7 @@ target_link_libraries(iwpmd LINK_PRIVATE
   )
 
 rdma_man_pages(
-  iwpmd.1.in
+  iwpmd.8.in
   iwpmd.conf.5.in
   )
 
diff --git a/iwpmd/iwpmd.1.in b/iwpmd/iwpmd.8.in
similarity index 98%
rename from iwpmd/iwpmd.1.in
rename to iwpmd/iwpmd.8.in
index 88eece7f6522a6..c42f2dd3de2b8a 100644
--- a/iwpmd/iwpmd.1.in
+++ b/iwpmd/iwpmd.8.in
@@ -1,4 +1,4 @@
-.TH "iwpmd" 1 "2016-09-16" "iwpmd" "iwpmd" iwpmd
+.TH "iwpmd" 8 "2016-09-16" "iwpmd" "iwpmd" iwpmd
 .SH NAME
 iwpmd \- port mapping services for iWARP.
 .SH SYNOPSIS
diff --git a/iwpmd/iwpmd.conf.5.in b/iwpmd/iwpmd.conf.5.in
index 1baae82b76da73..019525f7ae0053 100644
--- a/iwpmd/iwpmd.conf.5.in
+++ b/iwpmd/iwpmd.conf.5.in
@@ -1,4 +1,4 @@
-.TH "iwpmd.conf" 5 "2016-09-16" "iwpmd.conf" "iwpmd.conf" iwpmd.conf
+.TH "iwpmd.conf" 1 "2016-09-16" "iwpmd.conf" "iwpmd.conf" iwpmd.conf
 .SH NAME
 iwpmd.conf \- iWARP port mapper config file.
 .SH SYNOPSIS
diff --git a/redhat/rdma-core.spec b/redhat/rdma-core.spec
index 80a78265d02bfb..4f1ab71e5c4e27 100644
--- a/redhat/rdma-core.spec
+++ b/redhat/rdma-core.spec
@@ -394,7 +394,7 @@ rm -rf %{buildroot}/%{_sbindir}/srp_daemon.sh
 %{_bindir}/iwpmd
 %{_unitdir}/iwpmd.service
 %config(noreplace) %{_sysconfdir}/iwpmd.conf
-%{_mandir}/man1/iwpmd.*
+%{_mandir}/man8/iwpmd.*
 %{_mandir}/man5/iwpmd.*
 
 %files -n libibcm
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

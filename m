From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-core] Bump version to be v15
Date: Tue, 30 May 2017 08:56:48 +0300
Message-ID: <20170530055648.1754-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 CMakeLists.txt        | 2 +-
 debian/changelog      | 2 +-
 rdma-core.spec        | 2 +-
 redhat/rdma-core.spec | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/CMakeLists.txt b/CMakeLists.txt
index 29c61644..76b31ed2 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -44,7 +44,7 @@ endif()
 set(PACKAGE_NAME "RDMA")

 # See Documentation/versioning.md
-set(PACKAGE_VERSION "14")
+set(PACKAGE_VERSION "15")

 #-------------------------
 # Basic standard paths
diff --git a/debian/changelog b/debian/changelog
index 37c1df2d..86b402f4 100644
--- a/debian/changelog
+++ b/debian/changelog
@@ -1,4 +1,4 @@
-rdma-core (14-1) unstable; urgency=low
+rdma-core (15-1) unstable; urgency=low

   * New version.
   * Adding debian/copyright.
diff --git a/rdma-core.spec b/rdma-core.spec
index 2cb67c50..b923a5d7 100644
--- a/rdma-core.spec
+++ b/rdma-core.spec
@@ -1,5 +1,5 @@
 Name: rdma-core
-Version: 14
+Version: 15
 Release: 1%{?dist}
 Summary: RDMA core userspace libraries and daemons

diff --git a/redhat/rdma-core.spec b/redhat/rdma-core.spec
index 8e6cf3ae..1f5cd146 100644
--- a/redhat/rdma-core.spec
+++ b/redhat/rdma-core.spec
@@ -1,5 +1,5 @@
 Name: rdma-core
-Version: 14
+Version: 15
 Release: 1%{?dist}
 Summary: RDMA core userspace libraries and daemons

--
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

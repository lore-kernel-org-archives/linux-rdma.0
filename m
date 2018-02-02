From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] IB: Update references to libibverbs
Date: Fri, 2 Feb 2018 14:35:29 -0700
Message-ID: <20180202213529.GA28581@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

These days the userspace comes from rdma-core, revise references
in the kernel to point to the current repository.

Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 Documentation/infiniband/user_verbs.txt | 2 +-
 MAINTAINERS                             | 2 +-
 drivers/infiniband/Kconfig              | 5 +++--
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/Documentation/infiniband/user_verbs.txt b/Documentation/infiniband/user_verbs.txt
index e5092d696da2c2..df049b9f5b6ec8 100644
--- a/Documentation/infiniband/user_verbs.txt
+++ b/Documentation/infiniband/user_verbs.txt
@@ -5,7 +5,7 @@ USERSPACE VERBS ACCESS
   described in chapter 11 of the InfiniBand Architecture Specification.
 
   To use the verbs, the libibverbs library, available from
-  http://www.openfabrics.org/, is required.  libibverbs contains a
+  https://github.com/linux-rdma/rdma-core, is required. libibverbs contains a
   device-independent API for using the ib_uverbs interface.
   libibverbs also requires appropriate device-dependent kernel and
   userspace driver for your InfiniBand hardware.  For example, to use
diff --git a/MAINTAINERS b/MAINTAINERS
index 1facaa8cd6c961..1bace5b5cee332 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6885,7 +6885,7 @@ INFINIBAND SUBSYSTEM
 M:	Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 M:	Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
 L:	linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
-W:	http://www.openfabrics.org/
+W:	https://github.com/linux-rdma/rdma-core
 Q:	http://patchwork.kernel.org/project/linux-rdma/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git
 S:	Supported
diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
index cbf186522016f9..fe63af421e798d 100644
--- a/drivers/infiniband/Kconfig
+++ b/drivers/infiniband/Kconfig
@@ -19,7 +19,8 @@ config INFINIBAND_USER_MAD
 	  Userspace InfiniBand Management Datagram (MAD) support.  This
 	  is the kernel side of the userspace MAD support, which allows
 	  userspace processes to send and receive MADs. You will also
-	  need libibumad from <http://www.openfabrics.org/downloads/management/>.
+	  need libibumad from rdma-core
+	  <https://github.com/linux-rdma/rdma-core>.
 
 config INFINIBAND_USER_ACCESS
 	tristate "InfiniBand userspace access (verbs and CM)"
@@ -31,7 +32,7 @@ config INFINIBAND_USER_ACCESS
 	  to set up connections and directly access InfiniBand
 	  hardware for fast-path operations.  You will also need
 	  libibverbs, libibcm and a hardware driver library from
-	  <http://www.openfabrics.org/git/>.
+	  rdma-core <https://github.com/linux-rdma/rdma-core>.
 
 config INFINIBAND_EXP_USER_ACCESS
 	bool "Allow experimental support for Infiniband ABI"
-- 
2.16.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

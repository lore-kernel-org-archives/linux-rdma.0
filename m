From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 2/6] Fix spelling of CMAKE_INSTALL_UDEV_RULESDIR
Date: Wed, 23 Nov 2016 16:35:00 -0700
Message-ID: <1479944104-19949-3-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1479944104-19949-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1479944104-19949-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Fixes: 1b9b57df9924 ("Add a dependency on libudev")
Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 rdma-core.spec        | 2 +-
 redhat/rdma-core.spec | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/rdma-core.spec b/rdma-core.spec
index 5e36c37745c5fb..41ec47e9f86425 100644
--- a/rdma-core.spec
+++ b/rdma-core.spec
@@ -94,7 +94,7 @@ This is a simple example without the split sub packages to get things started.
 	 -DCMAKE_INSTALL_INITDDIR:PATH=%{_initrddir} \
 	 -DCMAKE_INSTALL_RUNDIR:PATH=%{_rundir} \
 	 -DCMAKE_INSTALL_DOCDIR:PATH=%{_docdir}/%{name}-%{version} \
-	 -DCMAKE_INSTALL_UDEV_RULESDR:PATH=%{_udevrulesdir}
+	 -DCMAKE_INSTALL_UDEV_RULESDIR:PATH=%{_udevrulesdir}
 %make_jobs
 
 %install
diff --git a/redhat/rdma-core.spec b/redhat/rdma-core.spec
index 0d1275ad1bfb49..39267be2033abc 100644
--- a/redhat/rdma-core.spec
+++ b/redhat/rdma-core.spec
@@ -218,7 +218,7 @@ discover and use SCSI devices via the SCSI RDMA Protocol over InfiniBand.
 	 -DCMAKE_INSTALL_INITDDIR:PATH=%{_initrddir} \
 	 -DCMAKE_INSTALL_RUNDIR:PATH=%{_rundir} \
 	 -DCMAKE_INSTALL_DOCDIR:PATH=%{_docdir}/%{name}-%{version} \
-	 -DCMAKE_INSTALL_UDEV_RULESDR:PATH=%{_udevrulesdir}
+	 -DCMAKE_INSTALL_UDEV_RULESDIR:PATH=%{_udevrulesdir}
 %make_jobs
 
 %install
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

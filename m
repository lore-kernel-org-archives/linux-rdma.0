From: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 7/8] libpvrdma: Add to consolidated rdma-core
Date: Thu, 3 Nov 2016 16:44:36 -0700
Message-ID: <1478216677-6150-8-git-send-email-aditr@vmware.com>
References: <1478216677-6150-1-git-send-email-aditr@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1478216677-6150-1-git-send-email-aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
Cc: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Update the build scripts and infrastructure for the pvrdma user library.

Signed-off-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
---
 CMakeLists.txt                  | 1 +
 MAINTAINERS                     | 6 ++++++
 README.md                       | 1 +
 providers/pvrdma/CMakeLists.txt | 6 ++++++
 4 files changed, 14 insertions(+)
 create mode 100644 providers/pvrdma/CMakeLists.txt

diff --git a/CMakeLists.txt b/CMakeLists.txt
index b3b3ff1..2010265 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -335,6 +335,7 @@ add_subdirectory(providers/mlx5)
 add_subdirectory(providers/mthca)
 add_subdirectory(providers/nes)
 add_subdirectory(providers/ocrdma)
+add_subdirectory(providers/pvrdma)
 add_subdirectory(providers/qedr)
 add_subdirectory(providers/rxe)
 add_subdirectory(providers/rxe/man)
diff --git a/MAINTAINERS b/MAINTAINERS
index d83de10..69ab1f9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -139,6 +139,12 @@ M:	Devesh Sharma <Devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
 S:	Supported
 F:	providers/ocrdma/
 
+PVRDMA USERSPACE PROVIDER (for pvrdma.ko)
+M:	Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
+L:	pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
+S:	Supported
+F:	providers/pvrdma/
+
 QEDR USERSPACE PROVIDER (for qedr.ko)
 M:	Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
 M:	Ariel Elior <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
diff --git a/README.md b/README.md
index 3a13042..fed8803 100644
--- a/README.md
+++ b/README.md
@@ -25,6 +25,7 @@ is included:
  - ib_mthca.ko
  - iw_nes.ko
  - ocrdma.ko
+ - pvrdma.ko
  - qedr.ko
  - rdma_rxe.ko
 
diff --git a/providers/pvrdma/CMakeLists.txt b/providers/pvrdma/CMakeLists.txt
new file mode 100644
index 0000000..8ba9a45
--- /dev/null
+++ b/providers/pvrdma/CMakeLists.txt
@@ -0,0 +1,6 @@
+rdma_provider(pvrdma
+  cq.c
+  pvrdma_main.c
+  qp.c
+  verbs.c
+)
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

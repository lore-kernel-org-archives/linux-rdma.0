From: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH rdma-core 6/6] libqedr: addition to consolidated repo
Date: Thu, 20 Oct 2016 12:49:12 +0300
Message-ID: <1476956952-17388-7-git-send-email-Ram.Amrani@cavium.com>
References: <1476956952-17388-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1476956952-17388-1-git-send-email-Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Ram Amrani <Ram.Amrani-74tsMCuadCbQT0dZR+AlfA@public.gmane.org>, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ram Amrani <Ram.Amrani-74tsMCuadCbQT0dZR+AlfA@public.gmane.org>

Configure the consolidated repo to build libqedr (qelr).

Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
---
 CMakeLists.txt                | 1 +
 MAINTAINERS                   | 7 +++++++
 README.md                     | 1 +
 providers/qedr/CMakeLists.txt | 5 +++++
 4 files changed, 14 insertions(+)
 create mode 100644 providers/qedr/CMakeLists.txt

diff --git a/CMakeLists.txt b/CMakeLists.txt
index 375859d..fef7f03 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -335,6 +335,7 @@ add_subdirectory(providers/mlx5)
 add_subdirectory(providers/mthca)
 add_subdirectory(providers/nes)
 add_subdirectory(providers/ocrdma)
+add_subdirectory(providers/qedr)
 add_subdirectory(providers/rxe)
 add_subdirectory(providers/rxe/man)
 
diff --git a/MAINTAINERS b/MAINTAINERS
index fb15276..65fad74 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -139,6 +139,13 @@ M:	Devesh Sharma <Devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
 S:	Supported
 F:	providers/ocrdma/
 
+QEDR USERSPACE PROVIDER (for qedr.ko)
+M:	Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
+M:	Ariel Elior <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
+S:	Supported
+F:	providers/qedr/
+P:	Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
+
 RXE SOFT ROCEE USERSPACE PROVIDER (for rdma_rxe.ko)
 M:	Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
 S:	Supported
diff --git a/README.md b/README.md
index 66aee3f..3a13042 100644
--- a/README.md
+++ b/README.md
@@ -25,6 +25,7 @@ is included:
  - ib_mthca.ko
  - iw_nes.ko
  - ocrdma.ko
+ - qedr.ko
  - rdma_rxe.ko
 
 Additional service daemons are provided for:
diff --git a/providers/qedr/CMakeLists.txt b/providers/qedr/CMakeLists.txt
new file mode 100644
index 0000000..8d4f3ce
--- /dev/null
+++ b/providers/qedr/CMakeLists.txt
@@ -0,0 +1,5 @@
+rdma_provider(qedr
+  qelr_main.c
+  qelr_verbs.c
+  qelr_chain.c
+  )
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

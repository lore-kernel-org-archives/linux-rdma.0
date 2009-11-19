From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 01/53] IB/qib: Add Kconfig
Date: Thu, 19 Nov 2009 15:37:01 -0800
Message-ID: <20091119233701.30356.78628.stgit@chromite.mv.qlogic.com>
References: <20091119233655.30356.57433.stgit@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091119233655.30356.57433.stgit-/vjeY7uYZjrPXfVEPVhPGq6RkeBMCJyt@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This creates the Kconfig file.

Signed-off-by: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---

 drivers/infiniband/hw/qib/Kconfig |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)
 create mode 100644 drivers/infiniband/hw/qib/Kconfig

diff --git a/drivers/infiniband/hw/qib/Kconfig b/drivers/infiniband/hw/qib/Kconfig
new file mode 100644
index 0000000..69790d6
--- /dev/null
+++ b/drivers/infiniband/hw/qib/Kconfig
@@ -0,0 +1,9 @@
+config INFINIBAND_QIB
+	tristate "QLogic IB Driver"
+	depends on 64BIT && INFINIBAND
+	---help---
+	This is a driver for QLogic PCIe QLE IB host channel adapters,
+	including InfiniBand verbs support.  This driver allows these
+	devices to be used with both kernel upper level protocols such
+	as IP-over-InfiniBand as well as with userspace applications
+	(in conjunction with InfiniBand userspace access).

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

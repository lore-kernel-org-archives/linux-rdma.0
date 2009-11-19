From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 02/53] IB/qib: Add Makefile
Date: Thu, 19 Nov 2009 15:37:06 -0800
Message-ID: <20091119233706.30356.20051.stgit@chromite.mv.qlogic.com>
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

This creates the Makefile file.

Signed-off-by: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---

 drivers/infiniband/hw/qib/Makefile |   46 ++++++++++++++++++++++++++++++++++++
 1 files changed, 46 insertions(+), 0 deletions(-)
 create mode 100644 drivers/infiniband/hw/qib/Makefile

diff --git a/drivers/infiniband/hw/qib/Makefile b/drivers/infiniband/hw/qib/Makefile
new file mode 100644
index 0000000..5dc5134
--- /dev/null
+++ b/drivers/infiniband/hw/qib/Makefile
@@ -0,0 +1,46 @@
+ccflags-y += -DQIB_KERN_TYPE=0 -DQIB_IDSTR='"QLogic kernel.org driver"'
+
+obj-$(CONFIG_INFINIBAND_QIB) += ib_qib.o
+
+ib_qib-y := \
+	qib_cq.o \
+	qib_diag.o \
+	qib_dma.o \
+	qib_driver.o \
+	qib_eeprom.o \
+	qib_file_ops.o \
+	qib_fs.o \
+	qib_init.o \
+	qib_intr.o \
+	qib_keys.o \
+	qib_mad.o \
+	qib_mmap.o \
+	qib_mr.o \
+	qib_pcie.o \
+	qib_pio_copy.o \
+	qib_qp.o \
+	qib_qsfp.o \
+	qib_rc.o \
+	qib_ruc.o \
+	qib_sdma.o \
+	qib_srq.o \
+	qib_sysfs.o \
+	qib_trace.o \
+	qib_twsi.o \
+	qib_tx.o \
+	qib_uc.o \
+	qib_ud.o \
+	qib_user_pages.o \
+	qib_user_sdma.o \
+	qib_verbs_mcast.o \
+	qib_iba7220.o \
+	qib_sd7220.o \
+	qib_sd7220_img.o \
+	qib_iba7322.o \
+	qib_verbs.o
+
+# 6120 has no fallback if no MSI interrupts, others can do INTx
+ib_qib-$(CONFIG_PCI_MSI) += qib_iba6120.o
+
+ib_qib-$(CONFIG_X86_64) += qib_wc_x86_64.o
+ib_qib-$(CONFIG_PPC64) += qib_wc_ppc64.o

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

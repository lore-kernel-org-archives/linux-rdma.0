From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/2] IB/qib: build issues with qib DCA and some config files
Date: Fri, 21 Jun 2013 11:23:03 -0400
Message-ID: <20130621152303.1776.36117.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, kbuild-all-JC7UmRfGjtg@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The Kconfig needed some extra tests to avoid:

drivers/built-in.o: In function `qib_irq_notifier_notify':
 (.text+0x561510): undefined reference to `dca3_get_tag'

and:

In file included from drivers/infiniband/hw/qib/qib_diag.c:53:0:
 drivers/infiniband/hw/qib/qib.h:436:29: error: field 'notify' has
incomplete type
     struct irq_affinity_notify notify;
                               ^
Reported-by: Fengguang Wu <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/Kconfig       |    2 +-
 drivers/infiniband/hw/qib/qib.h         |    6 +-----
 drivers/infiniband/hw/qib/qib_iba7322.c |    8 ++++++++
 3 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/qib/Kconfig b/drivers/infiniband/hw/qib/Kconfig
index 9d49cfa..d03ca4c 100644
--- a/drivers/infiniband/hw/qib/Kconfig
+++ b/drivers/infiniband/hw/qib/Kconfig
@@ -8,7 +8,7 @@ config INFINIBAND_QIB
 
 config INFINIBAND_QIB_DCA
 	bool "QIB DCA support"
-	depends on DCA && INFINIBAND_QIB
+	depends on INFINIBAND_QIB && DCA && SMP && GENERIC_HARDIRQS && !(INFINIBAND_QIB=y && DCA=m)
 	default y
 	---help---
 	Setting this enables DCA support on some Intel chip sets
diff --git a/drivers/infiniband/hw/qib/qib.h b/drivers/infiniband/hw/qib/qib.h
index ce10faf..5453e2b 100644
--- a/drivers/infiniband/hw/qib/qib.h
+++ b/drivers/infiniband/hw/qib/qib.h
@@ -441,11 +441,7 @@ struct qib_verbs_txreq {
 #define MAX_NAME_SIZE 64
 
 #ifdef CONFIG_INFINIBAND_QIB_DCA
-struct qib_irq_notify {
-	int rcv;
-	void *arg;
-	struct irq_affinity_notify notify;
-};
+struct qib_irq_notify;
 #endif
 
 struct qib_msix_entry {
diff --git a/drivers/infiniband/hw/qib/qib_iba7322.c b/drivers/infiniband/hw/qib/qib_iba7322.c
index 08fd74a..5f266d0 100644
--- a/drivers/infiniband/hw/qib/qib_iba7322.c
+++ b/drivers/infiniband/hw/qib/qib_iba7322.c
@@ -522,6 +522,14 @@ static const u8 qib_7322_physportstate[0x20] = {
 	[0x17] = IB_PHYSPORTSTATE_CFG_TRAIN
 };
 
+#ifdef CONFIG_INFINIBAND_QIB_DCA
+struct qib_irq_notify {
+	int rcv;
+	void *arg;
+	struct irq_affinity_notify notify;
+};
+#endif
+
 struct qib_chip_specific {
 	u64 __iomem *cregbase;
 	u64 *cntrs;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

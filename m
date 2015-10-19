From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 08/23] staging/rdma/hfi1: Method to toggle "fast ECN" detection
Date: Mon, 19 Oct 2015 12:43:32 -0400
Message-ID: <1445273027-29634-9-git-send-email-ira.weiny@intel.com>
References: <1445273027-29634-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1445273027-29634-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Vennila Megavannan <vennila.megavannan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Vennila Megavannan <vennila.megavannan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Add a module paramter to toggle prescan/Fast ECN Detection.

In addition change the PRESCAN_RXQ Kconfig default to "yes".

Reviewed-by: Arthur Kepner<arthur.kepner-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn<mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Vennila Megavannan<vennila.megavannan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/Kconfig  | 14 +++++++-------
 drivers/staging/rdma/hfi1/driver.c | 24 +++++++++++++++++-------
 2 files changed, 24 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/Kconfig b/drivers/staging/rdma/hfi1/Kconfig
index fd25078ee923..0336dea60786 100644
--- a/drivers/staging/rdma/hfi1/Kconfig
+++ b/drivers/staging/rdma/hfi1/Kconfig
@@ -26,12 +26,12 @@ config SDMA_VERBOSITY
 	This is a configuration flag to enable verbose
 	SDMA debug
 config PRESCAN_RXQ
-	bool "Enable prescanning of the RX queue for ECNs"
+	bool "Enable optional prescanning of the RX queue for ECNs"
 	depends on INFINIBAND_HFI1
-	default n
+	default y
 	---help---
-	This option toggles the prescanning of the receive queue for
-	Explicit Congestion Notifications. If an ECN is detected, it
-	is processed as quickly as possible, the ECN is toggled off.
-	After the prescanning step, the receive queue is processed as
-	usual.
+	This option enables code for the prescanning of the receive queue for
+	Explicit Congestion Notifications.  Pre-scanning can be controled via a
+	module option at run time.  If an ECN is detected, it is processed as
+	quickly as possible, the ECN is toggled off.  After the prescanning
+	step, the receive queue is processed as usual.
diff --git a/drivers/staging/rdma/hfi1/driver.c b/drivers/staging/rdma/hfi1/driver.c
index 4ccc2c87b196..9f2cf9589b63 100644
--- a/drivers/staging/rdma/hfi1/driver.c
+++ b/drivers/staging/rdma/hfi1/driver.c
@@ -83,6 +83,14 @@ unsigned int hfi1_cu = 1;
 module_param_named(cu, hfi1_cu, uint, S_IRUGO);
 MODULE_PARM_DESC(cu, "Credit return units");
 
+#ifdef CONFIG_PRESCAN_RXQ
+static unsigned int prescan_rx_queue;
+module_param_named(prescan_rxq, prescan_rx_queue, uint,
+			S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(prescan_rxq,
+		"Used to toggle rx prescan. Set to 1 to enable prescan");
+#endif /* CONFIG_PRESCAN_RXQ */
+
 unsigned long hfi1_cap_mask = HFI1_CAP_MASK_DEFAULT;
 static int hfi1_caps_set(const char *, const struct kernel_param *);
 static int hfi1_caps_get(char *, const struct kernel_param *);
@@ -435,10 +443,8 @@ static inline void init_packet(struct hfi1_ctxtdata *rcd,
 }
 
 #ifndef CONFIG_PRESCAN_RXQ
-static void prescan_rxq(struct hfi1_packet *packet) {}
+#define prescan_rxq(packet)
 #else /* !CONFIG_PRESCAN_RXQ */
-static int prescan_receive_queue;
-
 static void process_ecn(struct hfi1_qp *qp, struct hfi1_ib_header *hdr,
 			struct hfi1_other_headers *ohdr,
 			u64 rhf, u32 bth1, struct ib_grh *grh)
@@ -541,15 +547,19 @@ static inline void update_ps_mdata(struct ps_mdata *mdata)
  * containing Excplicit Congestion Notifications (FECNs, or BECNs).
  * When an ECN is found, process the Congestion Notification, and toggle
  * it off.
+ * This is declared as a macro to allow quick checking of the module param and
+ * avoid the overhead of a function call if not enabled.
  */
-static void prescan_rxq(struct hfi1_packet *packet)
+#define prescan_rxq(packet) \
+	do { \
+		if (prescan_rx_queue) \
+			__prescan_rxq(packet); \
+	} while (0)
+static void __prescan_rxq(struct hfi1_packet *packet)
 {
 	struct hfi1_ctxtdata *rcd = packet->rcd;
 	struct ps_mdata mdata;
 
-	if (!prescan_receive_queue)
-		return;
-
 	init_ps_mdata(&mdata, packet);
 
 	while (1) {
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

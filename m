From: ira.weiny@intel.com
Subject: [PATCH v2 3/3] staging/rdma/hfi1: Method to toggle "fast ECN"
 detection
Date: Thu,  5 Nov 2015 21:41:31 -0500
Message-ID: <1446777691-17460-1-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org
Cc: linux-rdma@vger.kernel.org, dennis.dalessandro@intel.com, dledford@redhat.com, Vennila Megavannan <vennila.megavannan@intel.com>
List-Id: linux-rdma@vger.kernel.org

From: Vennila Megavannan <vennila.megavannan@intel.com>

Add a module parameter to toggle prescan/Fast ECN Detection.

The config is maintained to be able to fully remove the code to obtain the
maximum receive performance _if_ the customer knows that they will never need
the prescanning.  This will result in the maximum performance on the RX path.

The default of enabling the code with the config option but having the module
parameter set to disabled, introduces a _slight_ performance impact but allows
the user to determine if this congestion control fix should be active or not at
run time.

Testing showed that this was the best compromise for most systems in terms of
performance and flexibility.  This is because prescanning is not required most
of the time.  Should a customer find that their topology and/or workload
requires prescanning they can then enable this option at run time.  Enabling
prescanning at run time will result in a significant reduction of performance
at the node level but may result in better overall fabric/cluster performance.

Reviewed-by: Arthur Kepner<arthur.kepner@intel.com>
Reviewed-by: Mike Marciniszyn<mike.marciniszyn@intel.com>
Signed-off-by: Vennila Megavannan<vennila.megavannan@intel.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>

---
Changes from V1:
	Redo commit message as well as Kconfig help to make it clear what the
	compile and module options do.
---
 drivers/staging/rdma/hfi1/Kconfig  | 24 +++++++++++++++++-------
 drivers/staging/rdma/hfi1/driver.c | 24 +++++++++++++++++-------
 2 files changed, 34 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/Kconfig b/drivers/staging/rdma/hfi1/Kconfig
index fd25078ee923..b534cd0e348a 100644
--- a/drivers/staging/rdma/hfi1/Kconfig
+++ b/drivers/staging/rdma/hfi1/Kconfig
@@ -26,12 +26,22 @@ config SDMA_VERBOSITY
 	This is a configuration flag to enable verbose
 	SDMA debug
 config PRESCAN_RXQ
-	bool "Enable prescanning of the RX queue for ECNs"
+	bool "Enable code for prescanning of the RX queue for ECNs"
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
+	Explicit Congestion Notifications.  Pre-scanning can be controlled via a
+	module option at run time.  If an ECN is detected, it is processed as
+	quickly as possible, the ECN is toggled off.  After the prescanning
+	step, the receive queue is processed as usual.
+
+	If you know that you will never Explicit Congestion Notification,
+	setting this option to "no" will result in maximum performance.
+
+	The default of "yes" results in a _slight_ performance impact but
+	allows the user to enable faster ECN detection at run time.  This
+	allows for the most flexible tuning of an entire system at run time.
+
+	If in doubt say "yes"
+
diff --git a/drivers/staging/rdma/hfi1/driver.c b/drivers/staging/rdma/hfi1/driver.c
index 9a4ec09af020..4c1dd7130d7a 100644
--- a/drivers/staging/rdma/hfi1/driver.c
+++ b/drivers/staging/rdma/hfi1/driver.c
@@ -83,6 +83,14 @@ unsigned int hfi1_cu = 1;
 module_param_named(cu, hfi1_cu, uint, S_IRUGO);
 MODULE_PARM_DESC(cu, "Credit return units");
 
+#ifdef CONFIG_PRESCAN_RXQ
+static unsigned int prescan_rx_queue;
+module_param_named(prescan_rxq, prescan_rx_queue, uint,
+		   S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(prescan_rxq,
+		 "Used to toggle rx prescan. Set to 1 to enable prescan");
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

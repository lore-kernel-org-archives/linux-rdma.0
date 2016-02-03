From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 17/54] staging/rdma/hfi1: Method to toggle "fast ECN"
 detection
Date: Wed, 03 Feb 2016 14:32:57 -0800
Message-ID: <20160203223254.5923.60805.stgit@scvm10.sc.intel.com>
References: <20160203222512.5923.30980.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160203222512.5923.30980.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Arthur Kepner <arthur.kepner-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vennila Megavannan <vennila.megavannan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Vennila Megavannan <vennila.megavannan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Add a per port sysfs paramter to toggle cc_prescan/Fast ECN Detection and
remove the Kconfig option which was previously used to control this.

While am updating the sysfs documentation, fix the name of CCMgtA.

Reviewed-by: Arthur Kepner <arthur.kepner-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Vennila Megavannan <vennila.megavannan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

---
Changes from V1:
	Redo commit message as well as Kconfig help to make it clear what the
	compile and module options do.

Changes from V2:
	Remove Kconfig option completely

Changes from V3:
	convert module parameter to sysfs parameter
	The use of a sysfs parameter was discussed:
		https://www.mail-archive.com/linux-rdma%40vger.kernel.org/msg29694.html
---
 Documentation/infiniband/sysfs.txt |    3 +-
 drivers/staging/rdma/hfi1/Kconfig  |   10 -----
 drivers/staging/rdma/hfi1/driver.c |   24 ++++++-------
 drivers/staging/rdma/hfi1/hfi.h    |    2 +
 drivers/staging/rdma/hfi1/sysfs.c  |   66 ++++++++++++++++++++++++++++++++++--
 5 files changed, 77 insertions(+), 28 deletions(-)

diff --git a/Documentation/infiniband/sysfs.txt b/Documentation/infiniband/sysfs.txt
index 9028b02..3ecf0c3 100644
--- a/Documentation/infiniband/sysfs.txt
+++ b/Documentation/infiniband/sysfs.txt
@@ -78,9 +78,10 @@ HFI1
    chip_reset - diagnostic (root only)
    boardversion - board version
    ports/1/
-          CMgtA/
+          CCMgtA/
                cc_settings_bin - CCA tables used by PSM2
                cc_table_bin
+               cc_prescan - enable prescaning for faster BECN response
           sc2v/ - 32 files (0 - 31) used to translate sl->vl
           sl2sc/ - 32 files (0 - 31) used to translate sl->sc
           vl2mtu/ - 16 (0 - 15) files used to determine MTU for vl
diff --git a/drivers/staging/rdma/hfi1/Kconfig b/drivers/staging/rdma/hfi1/Kconfig
index 846c240..3e668d8 100644
--- a/drivers/staging/rdma/hfi1/Kconfig
+++ b/drivers/staging/rdma/hfi1/Kconfig
@@ -26,13 +26,3 @@ config SDMA_VERBOSITY
 	---help---
 	This is a configuration flag to enable verbose
 	SDMA debug
-config PRESCAN_RXQ
-	bool "Enable prescanning of the RX queue for ECNs"
-	depends on INFINIBAND_HFI1
-	default n
-	---help---
-	This option toggles the prescanning of the receive queue for
-	Explicit Congestion Notifications. If an ECN is detected, it
-	is processed as quickly as possible, the ECN is toggled off.
-	After the prescanning step, the receive queue is processed as
-	usual.
diff --git a/drivers/staging/rdma/hfi1/driver.c b/drivers/staging/rdma/hfi1/driver.c
index d848cc0..59ce85f 100644
--- a/drivers/staging/rdma/hfi1/driver.c
+++ b/drivers/staging/rdma/hfi1/driver.c
@@ -453,11 +453,6 @@ static inline void init_packet(struct hfi1_ctxtdata *rcd,
 	packet->rcv_flags = 0;
 }
 
-#ifndef CONFIG_PRESCAN_RXQ
-static void prescan_rxq(struct hfi1_packet *packet) {}
-#else /* !CONFIG_PRESCAN_RXQ */
-static int prescan_receive_queue;
-
 static void process_ecn(struct rvt_qp *qp, struct hfi1_ib_header *hdr,
 			struct hfi1_other_headers *ohdr,
 			u64 rhf, u32 bth1, struct ib_grh *grh)
@@ -581,15 +576,19 @@ static inline void update_ps_mdata(struct ps_mdata *mdata,
  * containing Excplicit Congestion Notifications (FECNs, or BECNs).
  * When an ECN is found, process the Congestion Notification, and toggle
  * it off.
+ * This is declared as a macro to allow quick checking of the port to avoid
+ * the overhead of a function call if not enabled.
  */
-static void prescan_rxq(struct hfi1_packet *packet)
+#define prescan_rxq(rcd, packet) \
+	do { \
+		if (rcd->ppd->cc_prescan) \
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
@@ -653,7 +652,6 @@ next:
 		update_ps_mdata(&mdata, rcd);
 	}
 }
-#endif /* CONFIG_PRESCAN_RXQ */
 
 static inline int skip_rcv_packet(struct hfi1_packet *packet, int thread)
 {
@@ -819,7 +817,7 @@ int handle_receive_interrupt_nodma_rtail(struct hfi1_ctxtdata *rcd, int thread)
 		goto bail;
 	}
 
-	prescan_rxq(&packet);
+	prescan_rxq(rcd, &packet);
 
 	while (last == RCV_PKT_OK) {
 		last = process_rcv_packet(&packet, thread);
@@ -850,7 +848,7 @@ int handle_receive_interrupt_dma_rtail(struct hfi1_ctxtdata *rcd, int thread)
 	}
 	smp_rmb();  /* prevent speculative reads of dma'ed hdrq */
 
-	prescan_rxq(&packet);
+	prescan_rxq(rcd, &packet);
 
 	while (last == RCV_PKT_OK) {
 		last = process_rcv_packet(&packet, thread);
@@ -961,7 +959,7 @@ int handle_receive_interrupt(struct hfi1_ctxtdata *rcd, int thread)
 		}
 	}
 
-	prescan_rxq(&packet);
+	prescan_rxq(rcd, &packet);
 
 	while (last == RCV_PKT_OK) {
 
diff --git a/drivers/staging/rdma/hfi1/hfi.h b/drivers/staging/rdma/hfi1/hfi.h
index 76c369a..d19d6b7 100644
--- a/drivers/staging/rdma/hfi1/hfi.h
+++ b/drivers/staging/rdma/hfi1/hfi.h
@@ -734,6 +734,8 @@ struct hfi1_pportdata {
 	/* Error events that will cause a port bounce. */
 	u32 port_error_action;
 	struct work_struct linkstate_active_work;
+	/* Does this port need to prescan for FECNs */
+	bool cc_prescan;
 };
 
 typedef int (*rhf_rcv_function_ptr)(struct hfi1_packet *packet);
diff --git a/drivers/staging/rdma/hfi1/sysfs.c b/drivers/staging/rdma/hfi1/sysfs.c
index d05b9f3..f1d47e7 100644
--- a/drivers/staging/rdma/hfi1/sysfs.c
+++ b/drivers/staging/rdma/hfi1/sysfs.c
@@ -99,10 +99,6 @@ static void port_release(struct kobject *kobj)
 	/* nothing to do since memory is freed by hfi1_free_devdata() */
 }
 
-static struct kobj_type port_cc_ktype = {
-	.release = port_release,
-};
-
 static struct bin_attribute cc_table_bin_attr = {
 	.attr = {.name = "cc_table_bin", .mode = 0444},
 	.read = read_cc_table_bin,
@@ -151,6 +147,68 @@ static struct bin_attribute cc_setting_bin_attr = {
 	.size = PAGE_SIZE,
 };
 
+struct hfi1_port_attr {
+	struct attribute attr;
+	ssize_t	(*show)(struct hfi1_pportdata *, char *);
+	ssize_t	(*store)(struct hfi1_pportdata *, const char *, size_t);
+};
+
+static ssize_t cc_prescan_show(struct hfi1_pportdata *ppd, char *buf)
+{
+	return sprintf(buf, "%s\n", ppd->cc_prescan ? "on" : "off");
+}
+
+static ssize_t cc_prescan_store(struct hfi1_pportdata *ppd, const char *buf,
+				size_t count)
+{
+	if (!memcmp(buf, "on", 2))
+		ppd->cc_prescan = true;
+	else if (!memcmp(buf, "off", 3))
+		ppd->cc_prescan = false;
+
+	return count;
+}
+
+static struct hfi1_port_attr cc_prescan_attr =
+		__ATTR(cc_prescan, 0600, cc_prescan_show, cc_prescan_store);
+
+static ssize_t cc_attr_show(struct kobject *kobj, struct attribute *attr,
+			    char *buf)
+{
+	struct hfi1_port_attr *port_attr =
+		container_of(attr, struct hfi1_port_attr, attr);
+	struct hfi1_pportdata *ppd =
+		container_of(kobj, struct hfi1_pportdata, pport_cc_kobj);
+
+	return port_attr->show(ppd, buf);
+}
+
+static ssize_t cc_attr_store(struct kobject *kobj, struct attribute *attr,
+			     const char *buf, size_t count)
+{
+	struct hfi1_port_attr *port_attr =
+		container_of(attr, struct hfi1_port_attr, attr);
+	struct hfi1_pportdata *ppd =
+		container_of(kobj, struct hfi1_pportdata, pport_cc_kobj);
+
+	return port_attr->store(ppd, buf, count);
+}
+
+static const struct sysfs_ops port_cc_sysfs_ops = {
+	.show = cc_attr_show,
+	.store = cc_attr_store
+};
+
+static struct attribute *port_cc_default_attributes[] = {
+	&cc_prescan_attr.attr
+};
+
+static struct kobj_type port_cc_ktype = {
+	.release = port_release,
+	.sysfs_ops = &port_cc_sysfs_ops,
+	.default_attrs = port_cc_default_attributes
+};
+
 /* Start sc2vl */
 #define HFI1_SC2VL_ATTR(N)				    \
 	static struct hfi1_sc2vl_attr hfi1_sc2vl_attr_##N = { \

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

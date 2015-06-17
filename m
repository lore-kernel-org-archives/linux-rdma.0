From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3 49/49] IB/core: Add opa driver to kbuild
Date: Wed, 17 Jun 2015 08:33:00 -0400
Message-ID: <20150617123259.8744.80023.stgit@phlsvslse11.ph.intel.com>
References: <20150617122755.8744.44665.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150617122755.8744.44665.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/Kconfig         |    1 
 drivers/infiniband/hw/Makefile     |    1 
 drivers/infiniband/hw/hfi1/sysfs.c |  131 ------------------------------------
 3 files changed, 3 insertions(+), 130 deletions(-)

diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
index b899531..dd24c3d 100644
--- a/drivers/infiniband/Kconfig
+++ b/drivers/infiniband/Kconfig
@@ -57,6 +57,7 @@ config INFINIBAND_ADDR_TRANS
 source "drivers/infiniband/hw/mthca/Kconfig"
 source "drivers/infiniband/hw/ipath/Kconfig"
 source "drivers/infiniband/hw/qib/Kconfig"
+source "drivers/infiniband/hw/hfi1/Kconfig"
 source "drivers/infiniband/hw/ehca/Kconfig"
 source "drivers/infiniband/hw/amso1100/Kconfig"
 source "drivers/infiniband/hw/cxgb3/Kconfig"
diff --git a/drivers/infiniband/hw/Makefile b/drivers/infiniband/hw/Makefile
index e900b03..f3f4d9d 100644
--- a/drivers/infiniband/hw/Makefile
+++ b/drivers/infiniband/hw/Makefile
@@ -1,6 +1,7 @@
 obj-$(CONFIG_INFINIBAND_MTHCA)		+= mthca/
 obj-$(CONFIG_INFINIBAND_IPATH)		+= ipath/
 obj-$(CONFIG_INFINIBAND_QIB)		+= qib/
+obj-$(CONFIG_INFINIBAND_HFI1)		+= hfi1/
 obj-$(CONFIG_INFINIBAND_EHCA)		+= ehca/
 obj-$(CONFIG_INFINIBAND_AMSO1100)	+= amso1100/
 obj-$(CONFIG_INFINIBAND_CXGB3)		+= cxgb3/
diff --git a/drivers/infiniband/hw/hfi1/sysfs.c b/drivers/infiniband/hw/hfi1/sysfs.c
index fdedb20..6fad3a6 100644
--- a/drivers/infiniband/hw/hfi1/sysfs.c
+++ b/drivers/infiniband/hw/hfi1/sysfs.c
@@ -619,123 +619,6 @@ static struct kobj_type hfi1_vl2mtu_ktype = {
 	.default_attrs = vl2mtu_default_attributes
 };
 
-/* Start diag_counters */
-#define HFI1_DIAGC_NORMAL 0x0
-#define HFI1_DIAGC_PCPU   0x1
-
-#define HFI1_DIAGC_ATTR(N) \
-	static struct hfi1_diagc_attr diagc_attr_##N = { \
-		.attr = { .name = __stringify(N), .mode = 0664 }, \
-		.counter = offsetof(struct hfi1_ibport, n_##N), \
-		.type = HFI1_DIAGC_NORMAL, \
-		.vl = CNTR_INVALID_VL \
-	}
-
-#define HFI1_DIAGC_ATTR_PCPU(N, V, L) \
-	static struct hfi1_diagc_attr diagc_attr_##N = { \
-		.attr = { .name = __stringify(N), .mode = 0664 }, \
-		.counter = V, \
-		.type = HFI1_DIAGC_PCPU, \
-		.vl = L \
-	}
-
-struct hfi1_diagc_attr {
-	struct attribute attr;
-	size_t counter;
-	int type;
-	int vl;
-};
-
-HFI1_DIAGC_ATTR(rc_resends);
-HFI1_DIAGC_ATTR_PCPU(rc_acks, C_SW_CPU_RC_ACKS, CNTR_INVALID_VL);
-HFI1_DIAGC_ATTR_PCPU(rc_qacks, C_SW_CPU_RC_QACKS, CNTR_INVALID_VL);
-HFI1_DIAGC_ATTR_PCPU(rc_delayed_comp, C_SW_CPU_RC_DELAYED_COMP,
-	CNTR_INVALID_VL);
-HFI1_DIAGC_ATTR(seq_naks);
-HFI1_DIAGC_ATTR(rdma_seq);
-HFI1_DIAGC_ATTR(rnr_naks);
-HFI1_DIAGC_ATTR(other_naks);
-HFI1_DIAGC_ATTR(rc_timeouts);
-HFI1_DIAGC_ATTR(loop_pkts);
-HFI1_DIAGC_ATTR(pkt_drops);
-HFI1_DIAGC_ATTR(dmawait);
-HFI1_DIAGC_ATTR(unaligned);
-HFI1_DIAGC_ATTR(rc_dupreq);
-HFI1_DIAGC_ATTR(rc_seqnak);
-
-static struct attribute *diagc_default_attributes[] = {
-	&diagc_attr_rc_resends.attr,
-	&diagc_attr_rc_acks.attr,
-	&diagc_attr_rc_qacks.attr,
-	&diagc_attr_rc_delayed_comp.attr,
-	&diagc_attr_seq_naks.attr,
-	&diagc_attr_rdma_seq.attr,
-	&diagc_attr_rnr_naks.attr,
-	&diagc_attr_other_naks.attr,
-	&diagc_attr_rc_timeouts.attr,
-	&diagc_attr_loop_pkts.attr,
-	&diagc_attr_pkt_drops.attr,
-	&diagc_attr_dmawait.attr,
-	&diagc_attr_unaligned.attr,
-	&diagc_attr_rc_dupreq.attr,
-	&diagc_attr_rc_seqnak.attr,
-	NULL
-};
-
-static ssize_t diagc_attr_show(struct kobject *kobj, struct attribute *attr,
-			       char *buf)
-{
-	struct hfi1_diagc_attr *dattr =
-		container_of(attr, struct hfi1_diagc_attr, attr);
-	struct hfi1_pportdata *ppd =
-		container_of(kobj, struct hfi1_pportdata, diagc_kobj);
-	struct hfi1_ibport *hfip = &ppd->ibport_data;
-
-	switch (dattr->type) {
-	case (HFI1_DIAGC_PCPU):
-		return(sprintf(buf, "%lld\n",
-			read_port_cntr(ppd,
-				       dattr->counter,
-				       dattr->vl)));
-	case (HFI1_DIAGC_NORMAL):
-		/* Fall through */
-	default:
-		return sprintf(buf, "%u\n",
-			*(u32 *)((char *)hfip + dattr->counter));
-	}
-}
-
-static ssize_t diagc_attr_store(struct kobject *kobj, struct attribute *attr,
-				const char *buf, size_t size)
-{
-	struct hfi1_diagc_attr *dattr =
-		container_of(attr, struct hfi1_diagc_attr, attr);
-	struct hfi1_pportdata *ppd =
-		container_of(kobj, struct hfi1_pportdata, diagc_kobj);
-	struct hfi1_ibport *hfip = &ppd->ibport_data;
-	u32 val;
-	int ret;
-
-	ret = kstrtou32(buf, 0, &val);
-	if (ret)
-		return ret;
-	*(u32 *)((char *)hfip + dattr->counter) = val;
-	return size;
-}
-
-static const struct sysfs_ops hfi1_diagc_ops = {
-	.show = diagc_attr_show,
-	.store = diagc_attr_store,
-};
-
-static struct kobj_type diagc_ktype = {
-	.release = port_release,
-	.sysfs_ops = &hfi1_diagc_ops,
-	.default_attrs = diagc_default_attributes
-};
-
-/* End diag_counters */
-
 /* end of per-port file structures and support code */
 
 /*
@@ -978,23 +861,13 @@ int hfi1_create_port_files(struct ib_device *ibdev, u8 port_num,
 	}
 	kobject_uevent(&ppd->vl2mtu_kobj, KOBJ_ADD);
 
-	ret = kobject_init_and_add(&ppd->diagc_kobj, &diagc_ktype, kobj,
-				   "diag_counters");
-	if (ret) {
-		dd_dev_err(dd,
-			"Skipping diag_counters sysfs info, (err %d) port %u\n",
-			ret, port_num);
-		goto bail_mtu;
-	}
-	kobject_uevent(&ppd->diagc_kobj, KOBJ_ADD);
-
 	ret = kobject_init_and_add(&ppd->pport_cc_kobj, &port_cc_ktype,
 				   kobj, "CCMgtA");
 	if (ret) {
 		dd_dev_err(dd,
 		 "Skipping Congestion Control sysfs info, (err %d) port %u\n",
 		 ret, port_num);
-		goto bail_diagc;
+		goto bail_mtu;
 	}
 
 	kobject_uevent(&ppd->pport_cc_kobj, KOBJ_ADD);
@@ -1027,8 +900,6 @@ bail_cc_entry_bin:
 	sysfs_remove_bin_file(&ppd->pport_cc_kobj, &cc_setting_bin_attr);
 bail_cc:
 	kobject_put(&ppd->pport_cc_kobj);
-bail_diagc:
-	kobject_put(&ppd->diagc_kobj);
 bail_mtu:
 	kobject_put(&ppd->vl2mtu_kobj);
 bail_sl:

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

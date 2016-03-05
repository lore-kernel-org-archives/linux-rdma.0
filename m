From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 06/17] IB/hfi1: Add ASIC resource reservation functions
Date: Sat, 05 Mar 2016 08:49:50 -0800
Message-ID: <20160305164950.32025.30957.stgit@scvm10.sc.intel.com>
References: <20160305164725.32025.99686.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160305164725.32025.99686.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The ASIC block is a shared hardware resource between two devices
on the chip.  Add functions to acquire and release these resources
in a way that is safe for both multiple users on the same OS
and multiple users on different OSes, while holding the hardware
mutex as little as possible.

Reservations are noted in a scratch register in the shared region.
There are two types of reservations: per-HFI dynamic and permanent.

Reviewed-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c     |    2 
 drivers/infiniband/hw/hfi1/chip.h     |   30 +++++
 drivers/infiniband/hw/hfi1/firmware.c |  187 +++++++++++++++++++++++++++++++++
 3 files changed, 219 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index 686cadf..98ebee4 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -13368,6 +13368,7 @@ static void init_chip(struct hfi1_devdata *dd)
 	 */
 	write_csr(dd, ASIC_QSFP1_OUT, 0x1f);
 	write_csr(dd, ASIC_QSFP2_OUT, 0x1f);
+	init_chip_resources(dd);
 }
 
 static void init_early_variables(struct hfi1_devdata *dd)
@@ -13794,6 +13795,7 @@ void hfi1_start_cleanup(struct hfi1_devdata *dd)
 	free_cntrs(dd);
 	free_rcverr(dd);
 	clean_up_interrupts(dd);
+	finish_chip_resources(dd);
 }
 
 #define HFI_BASE_GUID(dev) \
diff --git a/drivers/infiniband/hw/hfi1/chip.h b/drivers/infiniband/hw/hfi1/chip.h
index e9a41ed..dc684bc 100644
--- a/drivers/infiniband/hw/hfi1/chip.h
+++ b/drivers/infiniband/hw/hfi1/chip.h
@@ -639,6 +639,36 @@ int load_firmware(struct hfi1_devdata *dd);
 void dispose_firmware(void);
 int acquire_hw_mutex(struct hfi1_devdata *dd);
 void release_hw_mutex(struct hfi1_devdata *dd);
+
+/*
+ * Bitmask of dynamic access for ASIC block chip resources.  Each HFI has its
+ * own range of bits for the resource so it can clear its own bits on
+ * starting and exiting.  If either HFI has the resource bit set, the
+ * resource is in use.  The separate bit ranges are:
+ *	HFI0 bits  7:0
+ *	HFI1 bits 15:8
+ */
+#define CR_SBUS  0x01	/* SBUS, THERM, and PCIE registers */
+#define CR_EPROM 0x02	/* EEP, GPIO registers */
+#define CR_I2C1  0x04	/* QSFP1_OE register */
+#define CR_I2C2  0x08	/* QSFP2_OE register */
+#define CR_DYN_SHIFT 8	/* dynamic flag shift */
+#define CR_DYN_MASK  ((1ull << CR_DYN_SHIFT) - 1)
+
+/*
+ * Bitmask of static ASIC states these are outside of the dynamic ASIC
+ * block chip resources above.  These are to be set once and never cleared.
+ * Must be holding the SBus dynamic flag when setting.
+ */
+#define CR_THERM_INIT	0x010000
+
+int acquire_chip_resource(struct hfi1_devdata *dd, u32 resource, u32 mswait);
+void release_chip_resource(struct hfi1_devdata *dd, u32 resource);
+bool check_chip_resource(struct hfi1_devdata *dd, u32 resource,
+			 const char *func);
+void init_chip_resources(struct hfi1_devdata *dd);
+void finish_chip_resources(struct hfi1_devdata *dd);
+
 void fabric_serdes_reset(struct hfi1_devdata *dd);
 int read_8051_data(struct hfi1_devdata *dd, u32 addr, u32 len, u64 *result);
 
diff --git a/drivers/infiniband/hw/hfi1/firmware.c b/drivers/infiniband/hw/hfi1/firmware.c
index ca4e489..140dd86 100644
--- a/drivers/infiniband/hw/hfi1/firmware.c
+++ b/drivers/infiniband/hw/hfi1/firmware.c
@@ -1385,6 +1385,193 @@ void release_hw_mutex(struct hfi1_devdata *dd)
 	write_csr(dd, ASIC_CFG_MUTEX, 0);
 }
 
+/* return the given resource bit(s) as a mask for the given HFI */
+static inline u64 resource_mask(u32 hfi1_id, u32 resource)
+{
+	return ((u64)resource) << (hfi1_id ? CR_DYN_SHIFT : 0);
+}
+
+static void fail_mutex_acquire_message(struct hfi1_devdata *dd,
+				       const char *func)
+{
+	dd_dev_err(dd,
+		   "%s: hardware mutex stuck - suggest rebooting the machine\n",
+		   func);
+}
+
+/*
+ * Acquire access to a chip resource.
+ *
+ * Return 0 on success, -EBUSY if resource busy, -EIO if mutex acquire failed.
+ */
+static int __acquire_chip_resource(struct hfi1_devdata *dd, u32 resource)
+{
+	u64 scratch0, all_bits, my_bit;
+	int ret;
+
+	if (resource & CR_DYN_MASK) {
+		/* a dynamic resource is in use if either HFI has set the bit */
+		all_bits = resource_mask(0, resource) |
+						resource_mask(1, resource);
+		my_bit = resource_mask(dd->hfi1_id, resource);
+	} else {
+		/* non-dynamic resources are not split between HFIs */
+		all_bits = resource;
+		my_bit = resource;
+	}
+
+	/* lock against other callers within the driver wanting a resource */
+	mutex_lock(&dd->asic_data->asic_resource_mutex);
+
+	ret = acquire_hw_mutex(dd);
+	if (ret) {
+		fail_mutex_acquire_message(dd, __func__);
+		ret = -EIO;
+		goto done;
+	}
+
+	scratch0 = read_csr(dd, ASIC_CFG_SCRATCH);
+	if (scratch0 & all_bits) {
+		ret = -EBUSY;
+	} else {
+		write_csr(dd, ASIC_CFG_SCRATCH, scratch0 | my_bit);
+		/* force write to be visible to other HFI on another OS */
+		(void)read_csr(dd, ASIC_CFG_SCRATCH);
+	}
+
+	release_hw_mutex(dd);
+
+done:
+	mutex_unlock(&dd->asic_data->asic_resource_mutex);
+	return ret;
+}
+
+/*
+ * Acquire access to a chip resource, wait up to mswait milliseconds for
+ * the resource to become available.
+ *
+ * Return 0 on success, -EBUSY if busy (even after wait), -EIO if mutex
+ * acquire failed.
+ */
+int acquire_chip_resource(struct hfi1_devdata *dd, u32 resource, u32 mswait)
+{
+	unsigned long timeout;
+	int ret;
+
+	timeout = jiffies + msecs_to_jiffies(mswait);
+	while (1) {
+		ret = __acquire_chip_resource(dd, resource);
+		if (ret != -EBUSY)
+			return ret;
+		/* resource is busy, check our timeout */
+		if (time_after_eq(jiffies, timeout))
+			return -EBUSY;
+		usleep_range(80, 120);	/* arbitrary delay */
+	}
+}
+
+/*
+ * Release access to a chip resource
+ */
+void release_chip_resource(struct hfi1_devdata *dd, u32 resource)
+{
+	u64 scratch0, bit;
+
+	/* only dynamic resources should ever be cleared */
+	if (!(resource & CR_DYN_MASK)) {
+		dd_dev_err(dd, "%s: invalid resource 0x%x\n", __func__,
+			   resource);
+		return;
+	}
+	bit = resource_mask(dd->hfi1_id, resource);
+
+	/* lock against other callers within the driver wanting a resource */
+	mutex_lock(&dd->asic_data->asic_resource_mutex);
+
+	if (acquire_hw_mutex(dd)) {
+		fail_mutex_acquire_message(dd, __func__);
+		goto done;
+	}
+
+	scratch0 = read_csr(dd, ASIC_CFG_SCRATCH);
+	if ((scratch0 & bit) != 0) {
+		scratch0 &= ~bit;
+		write_csr(dd, ASIC_CFG_SCRATCH, scratch0);
+		/* force write to be visible to other HFI on another OS */
+		(void)read_csr(dd, ASIC_CFG_SCRATCH);
+	} else {
+		dd_dev_warn(dd, "%s: id %d, resource 0x%x: bit not set\n",
+			    __func__, dd->hfi1_id, resource);
+	}
+
+	release_hw_mutex(dd);
+
+done:
+	mutex_unlock(&dd->asic_data->asic_resource_mutex);
+}
+
+/*
+ * Return true if resource is set, false otherwise.  Print a warning
+ * if not set and a function is supplied.
+ */
+bool check_chip_resource(struct hfi1_devdata *dd, u32 resource,
+			 const char *func)
+{
+	u64 scratch0, bit;
+
+	if (resource & CR_DYN_MASK)
+		bit = resource_mask(dd->hfi1_id, resource);
+	else
+		bit = resource;
+
+	scratch0 = read_csr(dd, ASIC_CFG_SCRATCH);
+	if ((scratch0 & bit) == 0) {
+		if (func)
+			dd_dev_warn(dd,
+				    "%s: id %d, resource 0x%x, not acquired!\n",
+				    func, dd->hfi1_id, resource);
+		return false;
+	}
+	return true;
+}
+
+static void clear_chip_resources(struct hfi1_devdata *dd, const char *func)
+{
+	u64 scratch0;
+
+	/* lock against other callers within the driver wanting a resource */
+	mutex_lock(&dd->asic_data->asic_resource_mutex);
+
+	if (acquire_hw_mutex(dd)) {
+		fail_mutex_acquire_message(dd, func);
+		goto done;
+	}
+
+	/* clear all dynamic access bits for this HFI */
+	scratch0 = read_csr(dd, ASIC_CFG_SCRATCH);
+	scratch0 &= ~resource_mask(dd->hfi1_id, CR_DYN_MASK);
+	write_csr(dd, ASIC_CFG_SCRATCH, scratch0);
+	/* force write to be visible to other HFI on another OS */
+	(void)read_csr(dd, ASIC_CFG_SCRATCH);
+
+	release_hw_mutex(dd);
+
+done:
+	mutex_unlock(&dd->asic_data->asic_resource_mutex);
+}
+
+void init_chip_resources(struct hfi1_devdata *dd)
+{
+	/* clear any holds left by us */
+	clear_chip_resources(dd, __func__);
+}
+
+void finish_chip_resources(struct hfi1_devdata *dd)
+{
+	/* clear any holds left by us */
+	clear_chip_resources(dd, __func__);
+}
+
 void set_sbus_fast_mode(struct hfi1_devdata *dd)
 {
 	write_csr(dd, ASIC_CFG_SBUS_EXECUTE,

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

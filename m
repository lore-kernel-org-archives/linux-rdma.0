From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 09/17] IB/hfi1: Change QSFP functions to use resource
 reservation
Date: Sat, 05 Mar 2016 08:50:06 -0800
Message-ID: <20160305165006.32025.36173.stgit@scvm10.sc.intel.com>
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

Remove the mutex guarding each operation in favor the ASIC
resource acquire/release.  Push the resource acquire/release,
above each operation call to allow exclusive access across
multiple operations.

Reviewed-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c     |   20 +++++-
 drivers/infiniband/hw/hfi1/chip.h     |    3 +
 drivers/infiniband/hw/hfi1/debugfs.c  |   22 +++++--
 drivers/infiniband/hw/hfi1/hfi.h      |   14 ++++
 drivers/infiniband/hw/hfi1/init.c     |    1 
 drivers/infiniband/hw/hfi1/platform.c |   26 ++++++--
 drivers/infiniband/hw/hfi1/qsfp.c     |  108 ++++++++++++++++++++++-----------
 drivers/infiniband/hw/hfi1/qsfp.h     |    4 +
 8 files changed, 142 insertions(+), 56 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index 269c977..d3a9b9f 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -6267,8 +6267,8 @@ void handle_8051_request(struct work_struct *work)
 					cdr_ctrl_byte &= ~(1 << i);
 			}
 		}
-		qsfp_write(ppd, ppd->dd->hfi1_id, QSFP_CDR_CTRL_BYTE_OFFS,
-			   &cdr_ctrl_byte, 1);
+		one_qsfp_write(ppd, dd->hfi1_id, QSFP_CDR_CTRL_BYTE_OFFS,
+			       &cdr_ctrl_byte, 1);
 		hreq_response(dd, HREQ_SUCCESS, data);
 		refresh_qsfp_cache(ppd, &ppd->qsfp_info);
 		break;
@@ -9290,8 +9290,8 @@ void qsfp_event(struct work_struct *work)
 	if (qd->check_interrupt_flags) {
 		u8 qsfp_interrupt_status[16] = {0,};
 
-		if (qsfp_read(ppd, dd->hfi1_id, 6,
-			      &qsfp_interrupt_status[0], 16) != 16) {
+		if (one_qsfp_read(ppd, dd->hfi1_id, 6,
+				  &qsfp_interrupt_status[0], 16) != 16) {
 			dd_dev_info(dd,
 				    "%s: Failed to read status of QSFP module\n",
 				    __func__);
@@ -9845,7 +9845,17 @@ static int goto_offline(struct hfi1_pportdata *ppd, u8 rem_reason)
 	if (ppd->port_type == PORT_TYPE_QSFP &&
 	    ppd->qsfp_info.limiting_active &&
 	    qsfp_mod_present(ppd)) {
-		set_qsfp_tx(ppd, 0);
+		int ret;
+
+		ret = acquire_chip_resource(dd, qsfp_resource(dd), QSFP_WAIT);
+		if (ret == 0) {
+			set_qsfp_tx(ppd, 0);
+			release_chip_resource(dd, qsfp_resource(dd));
+		} else {
+			/* not fatal, but should warn */
+			dd_dev_err(dd,
+				   "Unable to acquire lock to turn off QSFP TX\n");
+		}
 	}
 
 	/*
diff --git a/drivers/infiniband/hw/hfi1/chip.h b/drivers/infiniband/hw/hfi1/chip.h
index 311e6e8..9313963 100644
--- a/drivers/infiniband/hw/hfi1/chip.h
+++ b/drivers/infiniband/hw/hfi1/chip.h
@@ -672,6 +672,9 @@ void finish_chip_resources(struct hfi1_devdata *dd);
 /* ms wait time for access to an SBus resoure */
 #define SBUS_TIMEOUT 4000 /* long enough for a FW download and SBR */
 
+/* ms wait time for a qsfp (i2c) chain to become available */
+#define QSFP_WAIT 20000 /* long enough for FW update to the F4 uc */
+
 void fabric_serdes_reset(struct hfi1_devdata *dd);
 int read_8051_data(struct hfi1_devdata *dd, u32 addr, u32 len, u64 *result);
 
diff --git a/drivers/infiniband/hw/hfi1/debugfs.c b/drivers/infiniband/hw/hfi1/debugfs.c
index 99845bc..665666c 100644
--- a/drivers/infiniband/hw/hfi1/debugfs.c
+++ b/drivers/infiniband/hw/hfi1/debugfs.c
@@ -465,16 +465,22 @@ static ssize_t __i2c_debugfs_write(struct file *file, const char __user *buf,
 		goto _free;
 	}
 
+	ret = acquire_chip_resource(ppd->dd, i2c_target(target), 0);
+	if (ret)
+		goto _free;
+
 	total_written = i2c_write(ppd, target, i2c_addr, offset, buff, count);
 	if (total_written < 0) {
 		ret = total_written;
-		goto _free;
+		goto _release;
 	}
 
 	*ppos += total_written;
 
 	ret = total_written;
 
+ _release:
+	release_chip_resource(ppd->dd, i2c_target(target));
  _free:
 	kfree(buff);
  _return:
@@ -526,10 +532,14 @@ static ssize_t __i2c_debugfs_read(struct file *file, char __user *buf,
 		goto _return;
 	}
 
+	ret = acquire_chip_resource(ppd->dd, i2c_target(target), 0);
+	if (ret)
+		goto _free;
+
 	total_read = i2c_read(ppd, target, i2c_addr, offset, buff, count);
 	if (total_read < 0) {
 		ret = total_read;
-		goto _free;
+		goto _release;
 	}
 
 	*ppos += total_read;
@@ -537,11 +547,13 @@ static ssize_t __i2c_debugfs_read(struct file *file, char __user *buf,
 	ret = copy_to_user(buf, buff, total_read);
 	if (ret > 0) {
 		ret = -EFAULT;
-		goto _free;
+		goto _release;
 	}
 
 	ret = total_read;
 
+ _release:
+	release_chip_resource(ppd->dd, i2c_target(target));
  _free:
 	kfree(buff);
  _return:
@@ -592,7 +604,7 @@ static ssize_t __qsfp_debugfs_write(struct file *file, const char __user *buf,
 		goto _free;
 	}
 
-	total_written = qsfp_write(ppd, target, *ppos, buff, count);
+	total_written = one_qsfp_write(ppd, target, *ppos, buff, count);
 	if (total_written < 0) {
 		ret = total_written;
 		goto _free;
@@ -646,7 +658,7 @@ static ssize_t __qsfp_debugfs_read(struct file *file, char __user *buf,
 		goto _return;
 	}
 
-	total_read = qsfp_read(ppd, target, *ppos, buff, count);
+	total_read = one_qsfp_read(ppd, target, *ppos, buff, count);
 	if (total_read < 0) {
 		ret = total_read;
 		goto _free;
diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index e71a1c2..108015c 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -1048,8 +1048,6 @@ struct hfi1_devdata {
 
 	struct platform_config platform_config;
 	struct platform_config_cache pcfg_cache;
-	/* control high-level access to qsfp */
-	struct mutex qsfp_i2c_mutex;
 
 	struct diag_client *diag_client;
 	spinlock_t hfi1_diag_trans_lock; /* protect diag observer ops */
@@ -1938,6 +1936,18 @@ static inline void setextled(struct hfi1_devdata *dd, u32 on)
 		write_csr(dd, DCC_CFG_LED_CNTRL, 0x10);
 }
 
+/* return the i2c resource given the target */
+static inline u32 i2c_target(u32 target)
+{
+	return target ? CR_I2C2 : CR_I2C1;
+}
+
+/* return the i2c chain chip resource that this HFI uses for QSFP */
+static inline u32 qsfp_resource(struct hfi1_devdata *dd)
+{
+	return i2c_target(dd->hfi1_id);
+}
+
 int hfi1_tempsense_rd(struct hfi1_devdata *dd, struct hfi1_temp *temp);
 
 #endif                          /* _HFI1_KERNEL_H */
diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index 260a8e1..f21933c 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -1065,7 +1065,6 @@ struct hfi1_devdata *hfi1_alloc_devdata(struct pci_dev *pdev, size_t extra)
 	spin_lock_init(&dd->sc_init_lock);
 	spin_lock_init(&dd->dc8051_lock);
 	spin_lock_init(&dd->dc8051_memlock);
-	mutex_init(&dd->qsfp_i2c_mutex);
 	seqlock_init(&dd->sc2vl_lock);
 	spin_lock_init(&dd->sde_map_lock);
 	spin_lock_init(&dd->pio_map_lock);
diff --git a/drivers/infiniband/hw/hfi1/platform.c b/drivers/infiniband/hw/hfi1/platform.c
index 4777414..0a1d074 100644
--- a/drivers/infiniband/hw/hfi1/platform.c
+++ b/drivers/infiniband/hw/hfi1/platform.c
@@ -601,23 +601,30 @@ static void apply_tunings(
 static int tune_active_qsfp(struct hfi1_pportdata *ppd, u32 *ptr_tx_preset,
 			    u32 *ptr_rx_preset, u32 *ptr_total_atten)
 {
-	int ret = 0;
+	int ret;
 	u16 lss = ppd->link_speed_supported, lse = ppd->link_speed_enabled;
 	u8 *cache = ppd->qsfp_info.cache;
 
+	ret = acquire_chip_resource(ppd->dd, qsfp_resource(ppd->dd), QSFP_WAIT);
+	if (ret) {
+		dd_dev_err(ppd->dd, "%s: hfi%d: cannot lock i2c chain\n",
+			   __func__, (int)ppd->dd->hfi1_id);
+		return ret;
+	}
+
 	ppd->qsfp_info.limiting_active = 1;
 
 	ret = set_qsfp_tx(ppd, 0);
 	if (ret)
-		return ret;
+		goto bail_unlock;
 
 	ret = qual_power(ppd);
 	if (ret)
-		return ret;
+		goto bail_unlock;
 
 	ret = qual_bitrate(ppd);
 	if (ret)
-		return ret;
+		goto bail_unlock;
 
 	if (ppd->qsfp_info.reset_needed) {
 		reset_qsfp(ppd);
@@ -629,7 +636,7 @@ static int tune_active_qsfp(struct hfi1_pportdata *ppd, u32 *ptr_tx_preset,
 
 	ret = set_qsfp_high_power(ppd);
 	if (ret)
-		return ret;
+		goto bail_unlock;
 
 	if (cache[QSFP_EQ_INFO_OFFS] & 0x4) {
 		ret = get_platform_config_field(
@@ -639,7 +646,7 @@ static int tune_active_qsfp(struct hfi1_pportdata *ppd, u32 *ptr_tx_preset,
 			ptr_tx_preset, 4);
 		if (ret) {
 			*ptr_tx_preset = OPA_INVALID_INDEX;
-			return ret;
+			goto bail_unlock;
 		}
 	} else {
 		ret = get_platform_config_field(
@@ -649,7 +656,7 @@ static int tune_active_qsfp(struct hfi1_pportdata *ppd, u32 *ptr_tx_preset,
 			ptr_tx_preset, 4);
 		if (ret) {
 			*ptr_tx_preset = OPA_INVALID_INDEX;
-			return ret;
+			goto bail_unlock;
 		}
 	}
 
@@ -658,7 +665,7 @@ static int tune_active_qsfp(struct hfi1_pportdata *ppd, u32 *ptr_tx_preset,
 		PORT_TABLE_RX_PRESET_IDX, ptr_rx_preset, 4);
 	if (ret) {
 		*ptr_rx_preset = OPA_INVALID_INDEX;
-		return ret;
+		goto bail_unlock;
 	}
 
 	if ((lss & OPA_LINK_SPEED_25G) && (lse & OPA_LINK_SPEED_25G))
@@ -677,6 +684,9 @@ static int tune_active_qsfp(struct hfi1_pportdata *ppd, u32 *ptr_tx_preset,
 	apply_rx_amplitude_settings(ppd, *ptr_rx_preset, *ptr_tx_preset);
 
 	ret = set_qsfp_tx(ppd, 1);
+
+bail_unlock:
+	release_chip_resource(ppd->dd, qsfp_resource(ppd->dd));
 	return ret;
 }
 
diff --git a/drivers/infiniband/hw/hfi1/qsfp.c b/drivers/infiniband/hw/hfi1/qsfp.c
index 7e76b93..9ed1963 100644
--- a/drivers/infiniband/hw/hfi1/qsfp.c
+++ b/drivers/infiniband/hw/hfi1/qsfp.c
@@ -59,7 +59,7 @@
 #define I2C_MAX_RETRY 4
 
 /*
- * Unlocked i2c write.  Must hold dd->qsfp_i2c_mutex.
+ * Raw i2c write.  No set-up or lock checking.
  */
 static int __i2c_write(struct hfi1_pportdata *ppd, u32 target, int i2c_addr,
 		       int offset, void *bp, int len)
@@ -88,15 +88,16 @@ static int __i2c_write(struct hfi1_pportdata *ppd, u32 target, int i2c_addr,
 	return cnt;
 }
 
+/*
+ * Caller must hold the i2c chain resource.
+ */
 int i2c_write(struct hfi1_pportdata *ppd, u32 target, int i2c_addr, int offset,
 	      void *bp, int len)
 {
-	struct hfi1_devdata *dd = ppd->dd;
 	int ret;
 
-	ret = mutex_lock_interruptible(&dd->qsfp_i2c_mutex);
-	if (ret)
-		return ret;
+	if (!check_chip_resource(ppd->dd, qsfp_resource(ppd->dd), __func__))
+		return -EACCES;
 
 	/* make sure the TWSI bus is in a sane state */
 	ret = hfi1_twsi_reset(ppd->dd, target);
@@ -104,18 +105,14 @@ int i2c_write(struct hfi1_pportdata *ppd, u32 target, int i2c_addr, int offset,
 		hfi1_dev_porterr(ppd->dd, ppd->port,
 				 "I2C chain %d write interface reset failed\n",
 				 target);
-		goto done;
+		return ret;
 	}
 
-	ret = __i2c_write(ppd, target, i2c_addr, offset, bp, len);
-
-done:
-	mutex_unlock(&dd->qsfp_i2c_mutex);
-	return ret;
+	return __i2c_write(ppd, target, i2c_addr, offset, bp, len);
 }
 
 /*
- * Unlocked i2c read.  Must hold dd->qsfp_i2c_mutex.
+ * Raw i2c read.  No set-up or lock checking.
  */
 static int __i2c_read(struct hfi1_pportdata *ppd, u32 target, int i2c_addr,
 		      int offset, void *bp, int len)
@@ -157,15 +154,16 @@ exit:
 	return ret;
 }
 
+/*
+ * Caller must hold the i2c chain resource.
+ */
 int i2c_read(struct hfi1_pportdata *ppd, u32 target, int i2c_addr, int offset,
 	     void *bp, int len)
 {
-	struct hfi1_devdata *dd = ppd->dd;
 	int ret;
 
-	ret = mutex_lock_interruptible(&dd->qsfp_i2c_mutex);
-	if (ret)
-		return ret;
+	if (!check_chip_resource(ppd->dd, qsfp_resource(ppd->dd), __func__))
+		return -EACCES;
 
 	/* make sure the TWSI bus is in a sane state */
 	ret = hfi1_twsi_reset(ppd->dd, target);
@@ -173,19 +171,17 @@ int i2c_read(struct hfi1_pportdata *ppd, u32 target, int i2c_addr, int offset,
 		hfi1_dev_porterr(ppd->dd, ppd->port,
 				 "I2C chain %d read interface reset failed\n",
 				 target);
-		goto done;
+		return ret;
 	}
 
-	ret = __i2c_read(ppd, target, i2c_addr, offset, bp, len);
-
-done:
-	mutex_unlock(&dd->qsfp_i2c_mutex);
-	return ret;
+	return __i2c_read(ppd, target, i2c_addr, offset, bp, len);
 }
 
 /*
  * Write page n, offset m of QSFP memory as defined by SFF 8636
  * by writing @addr = ((256 * n) + m)
+ *
+ * Caller must hold the i2c chain resource.
  */
 int qsfp_write(struct hfi1_pportdata *ppd, u32 target, int addr, void *bp,
 	       int len)
@@ -196,9 +192,8 @@ int qsfp_write(struct hfi1_pportdata *ppd, u32 target, int addr, void *bp,
 	int ret;
 	u8 page;
 
-	ret = mutex_lock_interruptible(&ppd->dd->qsfp_i2c_mutex);
-	if (ret)
-		return ret;
+	if (!check_chip_resource(ppd->dd, qsfp_resource(ppd->dd), __func__))
+		return -EACCES;
 
 	/* make sure the TWSI bus is in a sane state */
 	ret = hfi1_twsi_reset(ppd->dd, target);
@@ -206,7 +201,6 @@ int qsfp_write(struct hfi1_pportdata *ppd, u32 target, int addr, void *bp,
 		hfi1_dev_porterr(ppd->dd, ppd->port,
 				 "QSFP chain %d write interface reset failed\n",
 				 target);
-		mutex_unlock(&ppd->dd->qsfp_i2c_mutex);
 		return ret;
 	}
 
@@ -242,16 +236,36 @@ int qsfp_write(struct hfi1_pportdata *ppd, u32 target, int addr, void *bp,
 		addr += ret;
 	}
 
-	mutex_unlock(&ppd->dd->qsfp_i2c_mutex);
-
 	if (ret < 0)
 		return ret;
 	return count;
 }
 
 /*
+ * Perform a stand-alone single QSFP write.  Acquire the resource, do the
+ * read, then release the resource.
+ */
+int one_qsfp_write(struct hfi1_pportdata *ppd, u32 target, int addr, void *bp,
+		   int len)
+{
+	struct hfi1_devdata *dd = ppd->dd;
+	u32 resource = qsfp_resource(dd);
+	int ret;
+
+	ret = acquire_chip_resource(dd, resource, QSFP_WAIT);
+	if (ret)
+		return ret;
+	ret = qsfp_write(ppd, target, addr, bp, len);
+	release_chip_resource(dd, resource);
+
+	return ret;
+}
+
+/*
  * Access page n, offset m of QSFP memory as defined by SFF 8636
  * by reading @addr = ((256 * n) + m)
+ *
+ * Caller must hold the i2c chain resource.
  */
 int qsfp_read(struct hfi1_pportdata *ppd, u32 target, int addr, void *bp,
 	      int len)
@@ -262,9 +276,8 @@ int qsfp_read(struct hfi1_pportdata *ppd, u32 target, int addr, void *bp,
 	int ret;
 	u8 page;
 
-	ret = mutex_lock_interruptible(&ppd->dd->qsfp_i2c_mutex);
-	if (ret)
-		return ret;
+	if (!check_chip_resource(ppd->dd, qsfp_resource(ppd->dd), __func__))
+		return -EACCES;
 
 	/* make sure the TWSI bus is in a sane state */
 	ret = hfi1_twsi_reset(ppd->dd, target);
@@ -272,7 +285,6 @@ int qsfp_read(struct hfi1_pportdata *ppd, u32 target, int addr, void *bp,
 		hfi1_dev_porterr(ppd->dd, ppd->port,
 				 "QSFP chain %d read interface reset failed\n",
 				 target);
-		mutex_unlock(&ppd->dd->qsfp_i2c_mutex);
 		return ret;
 	}
 
@@ -309,14 +321,32 @@ int qsfp_read(struct hfi1_pportdata *ppd, u32 target, int addr, void *bp,
 		addr += ret;
 	}
 
-	mutex_unlock(&ppd->dd->qsfp_i2c_mutex);
-
 	if (ret < 0)
 		return ret;
 	return count;
 }
 
 /*
+ * Perform a stand-alone single QSFP read.  Acquire the resource, do the
+ * read, then release the resource.
+ */
+int one_qsfp_read(struct hfi1_pportdata *ppd, u32 target, int addr, void *bp,
+		  int len)
+{
+	struct hfi1_devdata *dd = ppd->dd;
+	u32 resource = qsfp_resource(dd);
+	int ret;
+
+	ret = acquire_chip_resource(dd, resource, QSFP_WAIT);
+	if (ret)
+		return ret;
+	ret = qsfp_read(ppd, target, addr, bp, len);
+	release_chip_resource(dd, resource);
+
+	return ret;
+}
+
+/*
  * This function caches the QSFP memory range in 128 byte chunks.
  * As an example, the next byte after address 255 is byte 128 from
  * upper page 01H (if existing) rather than byte 0 from lower page 00H.
@@ -341,9 +371,13 @@ int refresh_qsfp_cache(struct hfi1_pportdata *ppd, struct qsfp_data *cp)
 
 	if (!qsfp_mod_present(ppd)) {
 		ret = -ENODEV;
-		goto bail;
+		goto bail_no_release;
 	}
 
+	ret = acquire_chip_resource(ppd->dd, qsfp_resource(ppd->dd), QSFP_WAIT);
+	if (ret)
+		goto bail_no_release;
+
 	ret = qsfp_read(ppd, target, 0, cache, QSFP_PAGESIZE);
 	if (ret != QSFP_PAGESIZE) {
 		dd_dev_info(ppd->dd,
@@ -406,6 +440,8 @@ int refresh_qsfp_cache(struct hfi1_pportdata *ppd, struct qsfp_data *cp)
 		}
 	}
 
+	release_chip_resource(ppd->dd, qsfp_resource(ppd->dd));
+
 	spin_lock_irqsave(&ppd->qsfp_info.qsfp_lock, flags);
 	ppd->qsfp_info.cache_valid = 1;
 	ppd->qsfp_info.cache_refresh_required = 0;
@@ -414,6 +450,8 @@ int refresh_qsfp_cache(struct hfi1_pportdata *ppd, struct qsfp_data *cp)
 	return 0;
 
 bail:
+	release_chip_resource(ppd->dd, qsfp_resource(ppd->dd));
+bail_no_release:
 	memset(cache, 0, (QSFP_MAX_NUM_PAGES * 128));
 	return ret;
 }
diff --git a/drivers/infiniband/hw/hfi1/qsfp.h b/drivers/infiniband/hw/hfi1/qsfp.h
index 2ad5980..831fe4c 100644
--- a/drivers/infiniband/hw/hfi1/qsfp.h
+++ b/drivers/infiniband/hw/hfi1/qsfp.h
@@ -235,3 +235,7 @@ int qsfp_write(struct hfi1_pportdata *ppd, u32 target, int addr, void *bp,
 	       int len);
 int qsfp_read(struct hfi1_pportdata *ppd, u32 target, int addr, void *bp,
 	      int len);
+int one_qsfp_write(struct hfi1_pportdata *ppd, u32 target, int addr, void *bp,
+		   int len);
+int one_qsfp_read(struct hfi1_pportdata *ppd, u32 target, int addr, void *bp,
+		  int len);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

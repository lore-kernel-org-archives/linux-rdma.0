From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB/qib: Fix checkpatch warnings
Date: Fri, 16 Jan 2015 10:52:18 -0500
Message-ID: <20150116155217.14859.18556.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib.h           |    7 +++++--
 drivers/infiniband/hw/qib/qib_common.h    |    4 ++--
 drivers/infiniband/hw/qib/qib_debugfs.c   |    1 -
 drivers/infiniband/hw/qib/qib_eeprom.c    |    6 +++---
 drivers/infiniband/hw/qib/qib_file_ops.c  |   16 +++++++---------
 drivers/infiniband/hw/qib/qib_iba7322.c   |    7 +++----
 drivers/infiniband/hw/qib/qib_init.c      |    7 +++----
 drivers/infiniband/hw/qib/qib_intr.c      |    1 -
 drivers/infiniband/hw/qib/qib_pcie.c      |    8 +++++---
 drivers/infiniband/hw/qib/qib_qsfp.c      |    9 ++++-----
 drivers/infiniband/hw/qib/qib_ruc.c       |    4 ++--
 drivers/infiniband/hw/qib/qib_sd7220.c    |    4 ++--
 drivers/infiniband/hw/qib/qib_user_sdma.c |    6 ++----
 drivers/infiniband/hw/qib/qib_verbs.c     |    4 +++-
 drivers/infiniband/hw/qib/qib_wc_x86_64.c |    2 +-
 15 files changed, 42 insertions(+), 44 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib.h b/drivers/infiniband/hw/qib/qib.h
index b218254..820a230 100644
--- a/drivers/infiniband/hw/qib/qib.h
+++ b/drivers/infiniband/hw/qib/qib.h
@@ -1460,11 +1460,14 @@ const char *qib_get_unit_name(int unit);
  * Flush write combining store buffers (if present) and perform a write
  * barrier.
  */
+static inline void qib_flush_wc(void)
+{
 #if defined(CONFIG_X86_64)
-#define qib_flush_wc() asm volatile("sfence" : : : "memory")
+	asm volatile("sfence" : : : "memory");
 #else
-#define qib_flush_wc() wmb() /* no reorder around wc flush */
+	wmb() /* no reorder around wc flush */
 #endif
+}
 
 /* global module parameter variables */
 extern unsigned qib_ibmtu;
diff --git a/drivers/infiniband/hw/qib/qib_common.h b/drivers/infiniband/hw/qib/qib_common.h
index 5670ace..4fb78ab 100644
--- a/drivers/infiniband/hw/qib/qib_common.h
+++ b/drivers/infiniband/hw/qib/qib_common.h
@@ -257,7 +257,7 @@ struct qib_base_info {
 
 	/* shared memory page for send buffer disarm status */
 	__u64 spi_sendbuf_status;
-} __attribute__ ((aligned(8)));
+} __aligned(8);
 
 /*
  * This version number is given to the driver by the user code during
@@ -361,7 +361,7 @@ struct qib_user_info {
 	 */
 	__u64 spu_base_info;
 
-} __attribute__ ((aligned(8)));
+} __aligned(8);
 
 /* User commands. */
 
diff --git a/drivers/infiniband/hw/qib/qib_debugfs.c b/drivers/infiniband/hw/qib/qib_debugfs.c
index 6abd3ed..5e75b43 100644
--- a/drivers/infiniband/hw/qib/qib_debugfs.c
+++ b/drivers/infiniband/hw/qib/qib_debugfs.c
@@ -255,7 +255,6 @@ void qib_dbg_ibdev_init(struct qib_ibdev *ibd)
 	DEBUGFS_FILE_CREATE(opcode_stats);
 	DEBUGFS_FILE_CREATE(ctx_stats);
 	DEBUGFS_FILE_CREATE(qp_stats);
-	return;
 }
 
 void qib_dbg_ibdev_exit(struct qib_ibdev *ibd)
diff --git a/drivers/infiniband/hw/qib/qib_eeprom.c b/drivers/infiniband/hw/qib/qib_eeprom.c
index d35805e..311ee6c 100644
--- a/drivers/infiniband/hw/qib/qib_eeprom.c
+++ b/drivers/infiniband/hw/qib/qib_eeprom.c
@@ -260,9 +260,9 @@ void qib_get_eeprom_info(struct qib_devdata *dd)
 		if (len > sizeof(ifp->if_serial))
 			len = sizeof(ifp->if_serial);
 		memcpy(snp, ifp->if_serial, len);
-	} else
-		memcpy(dd->serial, ifp->if_serial,
-		       sizeof(ifp->if_serial));
+	} else {
+		memcpy(dd->serial, ifp->if_serial, sizeof(ifp->if_serial));
+	}
 	if (!strstr(ifp->if_comment, "Tested successfully"))
 		qib_dev_err(dd,
 			"Board SN %s did not pass functional test: %s\n",
diff --git a/drivers/infiniband/hw/qib/qib_file_ops.c b/drivers/infiniband/hw/qib/qib_file_ops.c
index 9860001..41937c6 100644
--- a/drivers/infiniband/hw/qib/qib_file_ops.c
+++ b/drivers/infiniband/hw/qib/qib_file_ops.c
@@ -351,9 +351,10 @@ static int qib_tid_update(struct qib_ctxtdata *rcd, struct file *fp,
 		 * unless perhaps the user has mpin'ed the pages
 		 * themselves.
 		 */
-		qib_devinfo(dd->pcidev,
-			 "Failed to lock addr %p, %u pages: "
-			 "errno %d\n", (void *) vaddr, cnt, -ret);
+		qib_devinfo(
+			dd->pcidev,
+			"Failed to lock addr %p, %u pages: errno %d\n",
+			(void *) vaddr, cnt, -ret);
 		goto done;
 	}
 	for (i = 0; i < cnt; i++, vaddr += PAGE_SIZE) {
@@ -951,8 +952,8 @@ static int mmap_kvaddr(struct vm_area_struct *vma, u64 pgaddr,
 		/* rcvegrbufs are read-only on the slave */
 		if (vma->vm_flags & VM_WRITE) {
 			qib_devinfo(dd->pcidev,
-				 "Can't map eager buffers as "
-				 "writable (flags=%lx)\n", vma->vm_flags);
+				 "Can't map eager buffers as writable (flags=%lx)\n",
+				 vma->vm_flags);
 			ret = -EPERM;
 			goto bail;
 		}
@@ -1248,10 +1249,7 @@ static int init_subctxts(struct qib_devdata *dd,
 	if (!qib_compatible_subctxts(uinfo->spu_userversion >> 16,
 		uinfo->spu_userversion & 0xffff)) {
 		qib_devinfo(dd->pcidev,
-			 "Mismatched user version (%d.%d) and driver "
-			 "version (%d.%d) while context sharing. Ensure "
-			 "that driver and library are from the same "
-			 "release.\n",
+			 "Mismatched user version (%d.%d) and driver version (%d.%d) while context sharing. Ensure that driver and library are from the same release.\n",
 			 (int) (uinfo->spu_userversion >> 16),
 			 (int) (uinfo->spu_userversion & 0xffff),
 			 QIB_USER_SWMAJOR, QIB_USER_SWMINOR);
diff --git a/drivers/infiniband/hw/qib/qib_iba7322.c b/drivers/infiniband/hw/qib/qib_iba7322.c
index f17e703..550d4b0 100644
--- a/drivers/infiniband/hw/qib/qib_iba7322.c
+++ b/drivers/infiniband/hw/qib/qib_iba7322.c
@@ -117,7 +117,7 @@ MODULE_PARM_DESC(chase, "Enable state chase handling");
 
 static ushort qib_long_atten = 10; /* 10 dB ~= 5m length */
 module_param_named(long_attenuation, qib_long_atten, ushort, S_IRUGO);
-MODULE_PARM_DESC(long_attenuation, \
+MODULE_PARM_DESC(long_attenuation,
 		 "attenuation cutoff (dB) for long copper cable setup");
 
 static ushort qib_singleport;
@@ -153,7 +153,7 @@ static struct kparam_string kp_txselect = {
 static int  setup_txselect(const char *, struct kernel_param *);
 module_param_call(txselect, setup_txselect, param_get_string,
 		  &kp_txselect, S_IWUSR | S_IRUGO);
-MODULE_PARM_DESC(txselect, \
+MODULE_PARM_DESC(txselect,
 		 "Tx serdes indices (for no QSFP or invalid QSFP data)");
 
 #define BOARD_QME7342 5
@@ -6577,8 +6577,7 @@ static int qib_init_7322_variables(struct qib_devdata *dd)
 				ppd->vls_supported = IB_VL_VL0_7;
 			else {
 				qib_devinfo(dd->pcidev,
-					    "Invalid num_vls %u for MTU %d "
-					    ", using 4 VLs\n",
+					    "Invalid num_vls %u for MTU %d , using 4 VLs\n",
 					    qib_num_cfg_vls, mtu);
 				ppd->vls_supported = IB_VL_VL0_3;
 				qib_num_cfg_vls = 4;
diff --git a/drivers/infiniband/hw/qib/qib_init.c b/drivers/infiniband/hw/qib/qib_init.c
index ae979a1..2ee3695 100644
--- a/drivers/infiniband/hw/qib/qib_init.c
+++ b/drivers/infiniband/hw/qib/qib_init.c
@@ -140,7 +140,7 @@ int qib_create_ctxts(struct qib_devdata *dd)
 	 * Allocate full ctxtcnt array, rather than just cfgctxts, because
 	 * cleanup iterates across all possible ctxts.
 	 */
-	dd->rcd = kzalloc(sizeof(*dd->rcd) * dd->ctxtcnt, GFP_KERNEL);
+	dd->rcd = kcalloc(dd->ctxtcnt, sizeof(*dd->rcd), GFP_KERNEL);
 	if (!dd->rcd) {
 		qib_dev_err(dd,
 			"Unable to allocate ctxtdata array, failing\n");
@@ -1028,8 +1028,7 @@ static void qib_verify_pioperf(struct qib_devdata *dd)
 	addr = vmalloc(cnt);
 	if (!addr) {
 		qib_devinfo(dd->pcidev,
-			 "Couldn't get memory for checking PIO perf,"
-			 " skipping\n");
+			 "Couldn't get memory for checking PIO perf, skipping\n");
 		goto done;
 	}
 
@@ -1182,7 +1181,7 @@ bail:
 	if (!list_empty(&dd->list))
 		list_del_init(&dd->list);
 	ib_dealloc_device(&dd->verbs_dev.ibdev);
-	return ERR_PTR(ret);;
+	return ERR_PTR(ret);
 }
 
 /*
diff --git a/drivers/infiniband/hw/qib/qib_intr.c b/drivers/infiniband/hw/qib/qib_intr.c
index f4918f2..086616d 100644
--- a/drivers/infiniband/hw/qib/qib_intr.c
+++ b/drivers/infiniband/hw/qib/qib_intr.c
@@ -168,7 +168,6 @@ skip_ibchange:
 	ppd->lastibcstat = ibcs;
 	if (ev)
 		signal_ib_event(ppd, ev);
-	return;
 }
 
 void qib_clear_symerror_on_linkup(unsigned long opaque)
diff --git a/drivers/infiniband/hw/qib/qib_pcie.c b/drivers/infiniband/hw/qib/qib_pcie.c
index 130ec33..4758a38 100644
--- a/drivers/infiniband/hw/qib/qib_pcie.c
+++ b/drivers/infiniband/hw/qib/qib_pcie.c
@@ -210,7 +210,7 @@ static void qib_msix_setup(struct qib_devdata *dd, int pos, u32 *msixcnt,
 	/* We can't pass qib_msix_entry array to qib_msix_setup
 	 * so use a dummy msix_entry array and copy the allocated
 	 * irq back to the qib_msix_entry array. */
-	msix_entry = kmalloc(nvec * sizeof(*msix_entry), GFP_KERNEL);
+	msix_entry = kcalloc(nvec, sizeof(*msix_entry), GFP_KERNEL);
 	if (!msix_entry)
 		goto do_intx;
 
@@ -234,8 +234,10 @@ free_msix_entry:
 	kfree(msix_entry);
 
 do_intx:
-	qib_dev_err(dd, "pci_enable_msix_range %d vectors failed: %d, "
-			"falling back to INTx\n", nvec, ret);
+	qib_dev_err(
+		dd,
+		"pci_enable_msix_range %d vectors failed: %d, falling back to INTx\n",
+		nvec, ret);
 	*msixcnt = 0;
 	qib_enable_intx(dd->pcidev);
 }
diff --git a/drivers/infiniband/hw/qib/qib_qsfp.c b/drivers/infiniband/hw/qib/qib_qsfp.c
index 7d36d96..5e27f76 100644
--- a/drivers/infiniband/hw/qib/qib_qsfp.c
+++ b/drivers/infiniband/hw/qib/qib_qsfp.c
@@ -81,7 +81,7 @@ static int qsfp_read(struct qib_pportdata *ppd, int addr, void *bp, int len)
 	 * Module could take up to 2 Msec to respond to MOD_SEL, and there
 	 * is no way to tell if it is ready, so we must wait.
 	 */
-	msleep(2);
+	msleep(20);
 
 	/* Make sure TWSI bus is in sane state. */
 	ret = qib_twsi_reset(dd);
@@ -140,7 +140,7 @@ deselect:
 	else if (pass)
 		qib_dev_porterr(dd, ppd->port, "QSFP retries: %d\n", pass);
 
-	msleep(2);
+	msleep(20);
 
 bail:
 	mutex_unlock(&dd->eep_lock);
@@ -190,7 +190,7 @@ static int qib_qsfp_write(struct qib_pportdata *ppd, int addr, void *bp,
 	 * Module could take up to 2 Msec to respond to MOD_SEL,
 	 * and there is no way to tell if it is ready, so we must wait.
 	 */
-	msleep(2);
+	msleep(20);
 
 	/* Make sure TWSI bus is in sane state. */
 	ret = qib_twsi_reset(dd);
@@ -236,7 +236,7 @@ deselect:
 	 * going away, and there is no way to tell if it is ready.
 	 * so we must wait.
 	 */
-	msleep(2);
+	msleep(20);
 
 bail:
 	mutex_unlock(&dd->eep_lock);
@@ -483,7 +483,6 @@ void qib_qsfp_init(struct qib_qsfp_data *qd,
 	udelay(20); /* Generous RST dwell */
 
 	dd->f_gpio_mod(dd, mask, mask, mask);
-	return;
 }
 
 void qib_qsfp_deinit(struct qib_qsfp_data *qd)
diff --git a/drivers/infiniband/hw/qib/qib_ruc.c b/drivers/infiniband/hw/qib/qib_ruc.c
index 45353a4..f42bd0f 100644
--- a/drivers/infiniband/hw/qib/qib_ruc.c
+++ b/drivers/infiniband/hw/qib/qib_ruc.c
@@ -247,8 +247,8 @@ static __be64 get_sguid(struct qib_ibport *ibp, unsigned index)
 		struct qib_pportdata *ppd = ppd_from_ibp(ibp);
 
 		return ppd->guid;
-	} else
-		return ibp->guids[index - 1];
+	}
+	return ibp->guids[index - 1];
 }
 
 static int gid_ok(union ib_gid *gid, __be64 gid_prefix, __be64 id)
diff --git a/drivers/infiniband/hw/qib/qib_sd7220.c b/drivers/infiniband/hw/qib/qib_sd7220.c
index 2a3ff40..c72775f 100644
--- a/drivers/infiniband/hw/qib/qib_sd7220.c
+++ b/drivers/infiniband/hw/qib/qib_sd7220.c
@@ -926,7 +926,7 @@ qib_sd7220_ib_vfy(struct qib_devdata *dd, const struct firmware *fw)
  * IRQ not set up at this point in init, so we poll.
  */
 #define IB_SERDES_TRIM_DONE (1ULL << 11)
-#define TRIM_TMO (30)
+#define TRIM_TMO (15)
 
 static int qib_sd_trimdone_poll(struct qib_devdata *dd)
 {
@@ -944,7 +944,7 @@ static int qib_sd_trimdone_poll(struct qib_devdata *dd)
 			ret = 1;
 			break;
 		}
-		msleep(10);
+		msleep(20);
 	}
 	if (trim_tmo >= TRIM_TMO) {
 		qib_dev_err(dd, "No TRIMDONE in %d tries\n", trim_tmo);
diff --git a/drivers/infiniband/hw/qib/qib_user_sdma.c b/drivers/infiniband/hw/qib/qib_user_sdma.c
index 8ad1414..3e0677c 100644
--- a/drivers/infiniband/hw/qib/qib_user_sdma.c
+++ b/drivers/infiniband/hw/qib/qib_user_sdma.c
@@ -50,7 +50,7 @@
 /* expected size of headers (for dma_pool) */
 #define QIB_USER_SDMA_EXP_HEADER_LENGTH 64
 /* attempt to drain the queue for 5secs */
-#define QIB_USER_SDMA_DRAIN_TIMEOUT 500
+#define QIB_USER_SDMA_DRAIN_TIMEOUT 250
 
 /*
  * track how many times a process open this driver.
@@ -1144,7 +1144,7 @@ void qib_user_sdma_queue_drain(struct qib_pportdata *ppd,
 		qib_user_sdma_hwqueue_clean(ppd);
 		qib_user_sdma_queue_clean(ppd, pq);
 		mutex_unlock(&pq->lock);
-		msleep(10);
+		msleep(20);
 	}
 
 	if (pq->num_pending || pq->num_sending) {
@@ -1318,8 +1318,6 @@ retry:
 
 	if (nfree && !list_empty(pktlist))
 		goto retry;
-
-	return;
 }
 
 /* pq->lock must be held, get packets on the wire... */
diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index f279f9c..4a35998 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -2055,7 +2055,9 @@ int qib_register_ib_device(struct qib_devdata *dd)
 
 	dev->qp_table_size = ib_qib_qp_table_size;
 	get_random_bytes(&dev->qp_rnd, sizeof(dev->qp_rnd));
-	dev->qp_table = kmalloc(dev->qp_table_size * sizeof(*dev->qp_table),
+	dev->qp_table = kmalloc_array(
+				dev->qp_table_size,
+				sizeof(*dev->qp_table),
 				GFP_KERNEL);
 	if (!dev->qp_table) {
 		ret = -ENOMEM;
diff --git a/drivers/infiniband/hw/qib/qib_wc_x86_64.c b/drivers/infiniband/hw/qib/qib_wc_x86_64.c
index 4a3d730..4fcf245 100644
--- a/drivers/infiniband/hw/qib/qib_wc_x86_64.c
+++ b/drivers/infiniband/hw/qib/qib_wc_x86_64.c
@@ -92,7 +92,7 @@ int qib_enable_wc(struct qib_devdata *dd)
 	}
 
 	for (bits = 0; !(piolen & (1ULL << bits)); bits++)
-		/* do nothing */ ;
+		/* do nothing */
 
 	if (piolen != (1ULL << bits)) {
 		piolen >>= bits;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

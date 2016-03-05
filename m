From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 16/17] IB/hfi1: Add adaptive cacheless verbs copy
Date: Sat, 05 Mar 2016 08:50:43 -0800
Message-ID: <20160305165043.32025.69459.stgit@scvm10.sc.intel.com>
References: <20160305164725.32025.99686.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160305164725.32025.99686.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The kernel memcpy is faster than a cacheless copy.  However,
if too much of the L3 cache is overwritten by one-time copies
then overall bandwidth suffers.  Implement an adaptive scheme
where full page copies are tracked and if the number of unique
entries are larger than a threshold, verbs will use a cacheless
copy.  Tracked entries are gradually cleaned, allowing memcpy to
resume once the larger copies have stopped.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/init.c  |    6 +
 drivers/infiniband/hw/hfi1/verbs.c |  185 ++++++++++++++++++++++++++++++++++++
 drivers/infiniband/hw/hfi1/verbs.h |   22 ++++
 3 files changed, 211 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index f21933c..deabb08 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -1242,6 +1242,9 @@ static int __init hfi1_mod_init(void)
 	idr_init(&hfi1_unit_table);
 
 	hfi1_dbg_init();
+	ret = hfi1_wss_init();
+	if (ret < 0)
+		goto bail_wss;
 	ret = pci_register_driver(&hfi1_pci_driver);
 	if (ret < 0) {
 		pr_err("Unable to register driver: error %d\n", -ret);
@@ -1250,6 +1253,8 @@ static int __init hfi1_mod_init(void)
 	goto bail; /* all OK */
 
 bail_dev:
+	hfi1_wss_exit();
+bail_wss:
 	hfi1_dbg_exit();
 	idr_destroy(&hfi1_unit_table);
 	dev_cleanup();
@@ -1265,6 +1270,7 @@ module_init(hfi1_mod_init);
 static void __exit hfi1_mod_cleanup(void)
 {
 	pci_unregister_driver(&hfi1_pci_driver);
+	hfi1_wss_exit();
 	hfi1_dbg_exit();
 	hfi1_cpulist_count = 0;
 	kfree(hfi1_cpulist);
diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index 220bdb0..8209757 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -125,6 +125,13 @@ unsigned short piothreshold;
 module_param(piothreshold, ushort, S_IRUGO);
 MODULE_PARM_DESC(piothreshold, "size used to determine sdma vs. pio");
 
+#define COPY_CACHELESS 1
+#define COPY_ADAPTIVE  2
+static unsigned int sge_copy_mode;
+module_param(sge_copy_mode, uint, S_IRUGO);
+MODULE_PARM_DESC(sge_copy_mode,
+		 "Verbs copy mode: 0 use memcpy, 1 use cacheless copy, 2 adapt based on WSS");
+
 static void verbs_sdma_complete(
 	struct sdma_txreq *cookie,
 	int status);
@@ -137,6 +144,159 @@ static int pio_wait(struct rvt_qp *qp,
 /* Length of buffer to create verbs txreq cache name */
 #define TXREQ_NAME_LEN 24
 
+static uint wss_threshold;
+module_param(wss_threshold, uint, S_IRUGO);
+MODULE_PARM_DESC(wss_threshold, "Percentage (1-100) of LLC to use as a threshold for a cacheless copy");
+static uint wss_clean_period = 256;
+module_param(wss_clean_period, uint, S_IRUGO);
+MODULE_PARM_DESC(wss_clean_period, "Count of verbs copies before an entry in the page copy table is cleaned");
+
+/* memory working set size */
+struct hfi1_wss {
+	unsigned long *entries;
+	atomic_t total_count;
+	atomic_t clean_counter;
+	atomic_t clean_entry;
+
+	int threshold;
+	int num_entries;
+	long pages_mask;
+};
+
+static struct hfi1_wss wss;
+
+int hfi1_wss_init(void)
+{
+	long llc_size;
+	long llc_bits;
+	long table_size;
+	long table_bits;
+
+	/* check for a valid percent range - default to 80 if none or invalid */
+	if (wss_threshold < 1 || wss_threshold > 100)
+		wss_threshold = 80;
+	/* reject a wildly large period */
+	if (wss_clean_period > 1000000)
+		wss_clean_period = 256;
+	/* reject a zero period */
+	if (wss_clean_period == 0)
+		wss_clean_period = 1;
+
+	/*
+	 * Calculate the table size - the next power of 2 larger than the
+	 * LLC size.  LLC size is in KiB.
+	 */
+	llc_size = wss_llc_size() * 1024;
+	table_size = roundup_pow_of_two(llc_size);
+
+	/* one bit per page in rounded up table */
+	llc_bits = llc_size / PAGE_SIZE;
+	table_bits = table_size / PAGE_SIZE;
+	wss.pages_mask = table_bits - 1;
+	wss.num_entries = table_bits / BITS_PER_LONG;
+
+	wss.threshold = (llc_bits * wss_threshold) / 100;
+	if (wss.threshold == 0)
+		wss.threshold = 1;
+
+	atomic_set(&wss.clean_counter, wss_clean_period);
+
+	wss.entries = kcalloc(wss.num_entries, sizeof(*wss.entries),
+			      GFP_KERNEL);
+	if (!wss.entries) {
+		hfi1_wss_exit();
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+void hfi1_wss_exit(void)
+{
+	/* coded to handle partially initialized and repeat callers */
+	kfree(wss.entries);
+	wss.entries = NULL;
+}
+
+/*
+ * Advance the clean counter.  When the clean period has expired,
+ * clean an entry.
+ *
+ * This is implemented in atomics to avoid locking.  Because multiple
+ * variables are involved, it can be racy which can lead to slightly
+ * inaccurate information.  Since this is only a heuristic, this is
+ * OK.  Any innaccuracies will clean themselves out as the counter
+ * advances.  That said, it is unlikely the entry clean operation will
+ * race - the next possible racer will not start until the next clean
+ * period.
+ *
+ * The clean counter is implemented as a decrement to zero.  When zero
+ * is reached an entry is cleaned.
+ */
+static void wss_advance_clean_counter(void)
+{
+	int entry;
+	int weight;
+	unsigned long bits;
+
+	/* become the cleaner if we decrement the counter to zero */
+	if (atomic_dec_and_test(&wss.clean_counter)) {
+		/*
+		 * Set, not add, the clean period.  This avoids an issue
+		 * where the counter could decrement below the clean period.
+		 * Doing a set can result in lost decrements, slowing the
+		 * clean advance.  Since this a heuristic, this possible
+		 * slowdown is OK.
+		 *
+		 * An alternative is to loop, advancing the counter by a
+		 * clean period until the result is > 0. However, this could
+		 * lead to several threads keeping another in the clean loop.
+		 * This could be mitigated by limiting the number of times
+		 * we stay in the loop.
+		 */
+		atomic_set(&wss.clean_counter, wss_clean_period);
+
+		/*
+		 * Uniquely grab the entry to clean and move to next.
+		 * The current entry is always the lower bits of
+		 * wss.clean_entry.  The table size, wss.num_entries,
+		 * is always a power-of-2.
+		 */
+		entry = (atomic_inc_return(&wss.clean_entry) - 1)
+			& (wss.num_entries - 1);
+
+		/* clear the entry and count the bits */
+		bits = xchg(&wss.entries[entry], 0);
+		weight = hweight64((u64)bits);
+		/* only adjust the contended total count if needed */
+		if (weight)
+			atomic_sub(weight, &wss.total_count);
+	}
+}
+
+/*
+ * Insert the given address into the working set array.
+ */
+static void wss_insert(void *address)
+{
+	u32 page = ((unsigned long)address >> PAGE_SHIFT) & wss.pages_mask;
+	u32 entry = page / BITS_PER_LONG; /* assumes this ends up a shift */
+	u32 nr = page & (BITS_PER_LONG - 1);
+
+	if (!test_and_set_bit(nr, &wss.entries[entry]))
+		atomic_inc(&wss.total_count);
+
+	wss_advance_clean_counter();
+}
+
+/*
+ * Is the working set larger than the threshold?
+ */
+static inline int wss_exceeds_threshold(void)
+{
+	return atomic_read(&wss.total_count) >= wss.threshold;
+}
+
 /*
  * Translate ib_wr_opcode into ib_wc_opcode.
  */
@@ -258,7 +418,26 @@ void hfi1_copy_sge(
 	struct rvt_sge *sge = &ss->sge;
 	int in_last = 0;
 	int i;
+	int cacheless_copy = 0;
 
+	if (sge_copy_mode == COPY_CACHELESS) {
+		cacheless_copy = length >= PAGE_SIZE;
+	} else if (sge_copy_mode == COPY_ADAPTIVE) {
+		if (length >= PAGE_SIZE) {
+			/*
+			 * NOTE: this *assumes*:
+			 * o The first vaddr is the dest.
+			 * o If multiple pages, then vaddr is sequential.
+			 */
+			wss_insert(sge->vaddr);
+			if (length >= (2 * PAGE_SIZE))
+				wss_insert(sge->vaddr + PAGE_SIZE);
+
+			cacheless_copy = wss_exceeds_threshold();
+		} else {
+			wss_advance_clean_counter();
+		}
+	}
 	if (copy_last) {
 		if (length > 8) {
 			length -= 8;
@@ -277,10 +456,12 @@ again:
 		if (len > sge->sge_length)
 			len = sge->sge_length;
 		WARN_ON_ONCE(len == 0);
-		if (in_last) {
-			/* enforce byte transer ordering */
+		if (unlikely(in_last)) {
+			/* enforce byte transfer ordering */
 			for (i = 0; i < len; i++)
 				((u8 *)sge->vaddr)[i] = ((u8 *)data)[i];
+		} else if (cacheless_copy) {
+			cacheless_memcpy(sge->vaddr, data, len);
 		} else {
 			memcpy(sge->vaddr, data, len);
 		}
diff --git a/drivers/infiniband/hw/hfi1/verbs.h b/drivers/infiniband/hw/hfi1/verbs.h
index a85e6bc..6c4670f 100644
--- a/drivers/infiniband/hw/hfi1/verbs.h
+++ b/drivers/infiniband/hw/hfi1/verbs.h
@@ -475,6 +475,28 @@ int hfi1_verbs_send_dma(struct rvt_qp *qp, struct hfi1_pkt_state *ps,
 int hfi1_verbs_send_pio(struct rvt_qp *qp, struct hfi1_pkt_state *ps,
 			u64 pbc);
 
+int hfi1_wss_init(void);
+void hfi1_wss_exit(void);
+
+/* platform specific: return the lowest level cache (llc) size, in KiB */
+static inline int wss_llc_size(void)
+{
+	/* assume that the boot CPU value is universal for all CPUs */
+	return boot_cpu_data.x86_cache_size;
+}
+
+/* platform specific: cacheless copy */
+static inline void cacheless_memcpy(void *dst, void *src, size_t n)
+{
+	/*
+	 * Use the only available X64 cacheless copy.  Add a __user cast
+	 * to quiet sparse.  The src agument is already in the kernel so
+	 * there are no security issues.  The extra fault recovery machinery
+	 * is not invoked.
+	 */
+	__copy_user_nocache(dst, (void __user *)src, n, 0);
+}
+
 extern const enum ib_wc_opcode ib_hfi1_wc_opcode[];
 
 extern const u8 hdr_len_by_opcode[];

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

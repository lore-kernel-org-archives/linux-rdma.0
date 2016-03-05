From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 14/17] IB/hfi1: Add ASIC flag view/clear
Date: Sat, 05 Mar 2016 08:50:33 -0800
Message-ID: <20160305165032.32025.69994.stgit@scvm10.sc.intel.com>
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

Different OSes using parts of the same hardware may leave
cross-device flags set.  Export a debugfs file to view and
clear these flags if needed.

Reviewed-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/debugfs.c |  125 ++++++++++++++++++++++++++++++++++
 1 files changed, 125 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/debugfs.c b/drivers/infiniband/hw/hfi1/debugfs.c
index 6a1bc28..dbab9d9 100644
--- a/drivers/infiniband/hw/hfi1/debugfs.c
+++ b/drivers/infiniband/hw/hfi1/debugfs.c
@@ -404,6 +404,130 @@ static ssize_t portcntrs_debugfs_read(struct file *file, char __user *buf,
 	return rval;
 }
 
+static void check_dyn_flag(u64 scratch0, char *p, int size, int *used,
+			   int this_hfi, int hfi, u32 flag, const char *what)
+{
+	u32 mask;
+
+	mask = flag << (hfi ? CR_DYN_SHIFT : 0);
+	if (scratch0 & mask) {
+		*used += scnprintf(p + *used, size - *used,
+				   "  0x%08x - HFI%d %s in use, %s device\n",
+				   mask, hfi, what,
+				   this_hfi == hfi ? "this" : "other");
+	}
+}
+
+static ssize_t asic_flags_read(struct file *file, char __user *buf,
+			       size_t count, loff_t *ppos)
+{
+	struct hfi1_pportdata *ppd;
+	struct hfi1_devdata *dd;
+	u64 scratch0;
+	char *tmp;
+	int ret = 0;
+	int size;
+	int used;
+	int i;
+
+	rcu_read_lock();
+	ppd = private2ppd(file);
+	dd = ppd->dd;
+	size = PAGE_SIZE;
+	used = 0;
+	tmp = kmalloc(size, GFP_KERNEL);
+	if (!tmp) {
+		rcu_read_unlock();
+		return -ENOMEM;
+	}
+
+	scratch0 = read_csr(dd, ASIC_CFG_SCRATCH);
+	used += scnprintf(tmp + used, size - used,
+			  "Resource flags: 0x%016llx\n", scratch0);
+
+	/* check permanent flag */
+	if (scratch0 & CR_THERM_INIT) {
+		used += scnprintf(tmp + used, size - used,
+				  "  0x%08x - thermal monitoring initialized\n",
+				  (u32)CR_THERM_INIT);
+	}
+
+	/* check each dynamic flag on each HFI */
+	for (i = 0; i < 2; i++) {
+		check_dyn_flag(scratch0, tmp, size, &used, dd->hfi1_id, i,
+			       CR_SBUS, "SBus");
+		check_dyn_flag(scratch0, tmp, size, &used, dd->hfi1_id, i,
+			       CR_EPROM, "EPROM");
+		check_dyn_flag(scratch0, tmp, size, &used, dd->hfi1_id, i,
+			       CR_I2C1, "i2c chain 1");
+		check_dyn_flag(scratch0, tmp, size, &used, dd->hfi1_id, i,
+			       CR_I2C2, "i2c chain 2");
+	}
+	used += scnprintf(tmp + used, size - used, "Write bits to clear\n");
+
+	ret = simple_read_from_buffer(buf, count, ppos, tmp, used);
+	rcu_read_unlock();
+	kfree(tmp);
+	return ret;
+}
+
+static ssize_t asic_flags_write(struct file *file, const char __user *buf,
+				size_t count, loff_t *ppos)
+{
+	struct hfi1_pportdata *ppd;
+	struct hfi1_devdata *dd;
+	char *buff;
+	int ret;
+	unsigned long long value;
+	u64 scratch0;
+	u64 clear;
+
+	rcu_read_lock();
+	ppd = private2ppd(file);
+	dd = ppd->dd;
+
+	buff = kmalloc(count + 1, GFP_KERNEL);
+	if (!buff) {
+		ret = -ENOMEM;
+		goto do_return;
+	}
+
+	ret = copy_from_user(buff, buf, count);
+	if (ret > 0) {
+		ret = -EFAULT;
+		goto do_free;
+	}
+
+	/* zero terminate and read the expected integer */
+	buff[count] = 0;
+	ret = kstrtoull(buff, 0, &value);
+	if (ret)
+		goto do_free;
+	clear = value;
+
+	/* obtain exclusive access */
+	mutex_lock(&dd->asic_data->asic_resource_mutex);
+	acquire_hw_mutex(dd);
+
+	scratch0 = read_csr(dd, ASIC_CFG_SCRATCH);
+	scratch0 &= ~clear;
+	write_csr(dd, ASIC_CFG_SCRATCH, scratch0);
+	/* force write to be visible to other HFI on another OS */
+	(void)read_csr(dd, ASIC_CFG_SCRATCH);
+
+	release_hw_mutex(dd);
+	mutex_unlock(&dd->asic_data->asic_resource_mutex);
+
+	/* return the number of bytes written */
+	ret = count;
+
+ do_free:
+	kfree(buff);
+ do_return:
+	rcu_read_unlock();
+	return ret;
+}
+
 /*
  * read the per-port QSFP data for ppd
  */
@@ -821,6 +945,7 @@ static const struct counter_info port_cntr_ops[] = {
 		     qsfp1_debugfs_open, qsfp1_debugfs_release),
 	DEBUGFS_XOPS("qsfp2", qsfp2_debugfs_read, qsfp2_debugfs_write,
 		     qsfp2_debugfs_open, qsfp2_debugfs_release),
+	DEBUGFS_OPS("asic_flags", asic_flags_read, asic_flags_write),
 };
 
 void hfi1_dbg_ibdev_init(struct hfi1_ibdev *ibd)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

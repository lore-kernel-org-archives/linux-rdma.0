From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 04/23] IB/hfi1: Export 8051 memory and LCB registers via
 debugfs
Date: Wed, 07 Dec 2016 19:32:34 -0800
Message-ID: <20161208033233.21135.16395.stgit@scvm10.sc.intel.com>
References: <20161208032312.21135.66056.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161208032312.21135.66056.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Both the 8051 memory and LCB register access require multiple
steps and coordination with the driver.  This cannot be safely
done with resource0 alone.

The 8051 memory is exported read-only.  LCB is exported read/write.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/debugfs.c |  110 ++++++++++++++++++++++++++++++++++
 1 files changed, 110 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/debugfs.c b/drivers/infiniband/hw/hfi1/debugfs.c
index 632ba21..8725f4c 100644
--- a/drivers/infiniband/hw/hfi1/debugfs.c
+++ b/drivers/infiniband/hw/hfi1/debugfs.c
@@ -541,6 +541,114 @@ static ssize_t asic_flags_write(struct file *file, const char __user *buf,
 	return ret;
 }
 
+/* read the dc8051 memory */
+static ssize_t dc8051_memory_read(struct file *file, char __user *buf,
+				  size_t count, loff_t *ppos)
+{
+	struct hfi1_pportdata *ppd = private2ppd(file);
+	ssize_t rval;
+	void *tmp;
+	loff_t start, end;
+
+	/* the checks below expect the position to be positive */
+	if (*ppos < 0)
+		return -EINVAL;
+
+	tmp = kzalloc(DC8051_DATA_MEM_SIZE, GFP_KERNEL);
+	if (!tmp)
+		return -ENOMEM;
+
+	/*
+	 * Fill in the requested portion of the temporary buffer from the
+	 * 8051 memory.  The 8051 memory read is done in terms of 8 bytes.
+	 * Adjust start and end to fit.  Skip reading anything if out of
+	 * range.
+	 */
+	start = *ppos & ~0x7;	/* round down */
+	if (start < DC8051_DATA_MEM_SIZE) {
+		end = (*ppos + count + 7) & ~0x7; /* round up */
+		if (end > DC8051_DATA_MEM_SIZE)
+			end = DC8051_DATA_MEM_SIZE;
+		rval = read_8051_data(ppd->dd, start, end - start,
+				      (u64 *)(tmp + start));
+		if (rval)
+			goto done;
+	}
+
+	rval = simple_read_from_buffer(buf, count, ppos, tmp,
+				       DC8051_DATA_MEM_SIZE);
+done:
+	kfree(tmp);
+	return rval;
+}
+
+static ssize_t debugfs_lcb_read(struct file *file, char __user *buf,
+				size_t count, loff_t *ppos)
+{
+	struct hfi1_pportdata *ppd = private2ppd(file);
+	struct hfi1_devdata *dd = ppd->dd;
+	unsigned long total, csr_off;
+	u64 data;
+
+	if (*ppos < 0)
+		return -EINVAL;
+	/* only read 8 byte quantities */
+	if ((count % 8) != 0)
+		return -EINVAL;
+	/* offset must be 8-byte aligned */
+	if ((*ppos % 8) != 0)
+		return -EINVAL;
+	/* do nothing if out of range or zero count */
+	if (*ppos >= (LCB_END - LCB_START) || !count)
+		return 0;
+	/* reduce count if needed */
+	if (*ppos + count > LCB_END - LCB_START)
+		count = (LCB_END - LCB_START) - *ppos;
+
+	csr_off = LCB_START + *ppos;
+	for (total = 0; total < count; total += 8, csr_off += 8) {
+		if (read_lcb_csr(dd, csr_off, (u64 *)&data))
+			break; /* failed */
+		if (put_user(data, (unsigned long __user *)(buf + total)))
+			break;
+	}
+	*ppos += total;
+	return total;
+}
+
+static ssize_t debugfs_lcb_write(struct file *file, const char __user *buf,
+				 size_t count, loff_t *ppos)
+{
+	struct hfi1_pportdata *ppd = private2ppd(file);
+	struct hfi1_devdata *dd = ppd->dd;
+	unsigned long total, csr_off, data;
+
+	if (*ppos < 0)
+		return -EINVAL;
+	/* only write 8 byte quantities */
+	if ((count % 8) != 0)
+		return -EINVAL;
+	/* offset must be 8-byte aligned */
+	if ((*ppos % 8) != 0)
+		return -EINVAL;
+	/* do nothing if out of range or zero count */
+	if (*ppos >= (LCB_END - LCB_START) || !count)
+		return 0;
+	/* reduce count if needed */
+	if (*ppos + count > LCB_END - LCB_START)
+		count = (LCB_END - LCB_START) - *ppos;
+
+	csr_off = LCB_START + *ppos;
+	for (total = 0; total < count; total += 8, csr_off += 8) {
+		if (get_user(data, (unsigned long __user *)(buf + total)))
+			break;
+		if (write_lcb_csr(dd, csr_off, data))
+			break; /* failed */
+	}
+	*ppos += total;
+	return total;
+}
+
 /*
  * read the per-port QSFP data for ppd
  */
@@ -931,6 +1039,8 @@ static int qsfp2_debugfs_release(struct inode *in, struct file *fp)
 	DEBUGFS_XOPS("qsfp2", qsfp2_debugfs_read, qsfp2_debugfs_write,
 		     qsfp2_debugfs_open, qsfp2_debugfs_release),
 	DEBUGFS_OPS("asic_flags", asic_flags_read, asic_flags_write),
+	DEBUGFS_OPS("dc8051_memory", dc8051_memory_read, NULL),
+	DEBUGFS_OPS("lcb", debugfs_lcb_read, debugfs_lcb_write),
 };
 
 static void *_sdma_cpu_list_seq_start(struct seq_file *s, loff_t *pos)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

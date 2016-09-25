From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 4/5] IB/hfi1: Add new debugfs sdma_cpu_list file
Date: Sun, 25 Sep 2016 07:44:44 -0700
Message-ID: <20160925144442.12088.95386.stgit@scvm10.sc.intel.com>
References: <20160925144248.12088.71489.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160925144248.12088.71489.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Add a debugfs sdma_cpu_list file that can be used to examine the CPU to
sdma engine assignments for the whole device.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/debugfs.c |   38 ++++++++++++++++++++++++++++++
 drivers/infiniband/hw/hfi1/sdma.c    |   43 ++++++++++++++++++++++++++++++++++
 drivers/infiniband/hw/hfi1/sdma.h    |    2 ++
 3 files changed, 83 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/debugfs.c b/drivers/infiniband/hw/hfi1/debugfs.c
index 5e9be16..632ba21 100644
--- a/drivers/infiniband/hw/hfi1/debugfs.c
+++ b/drivers/infiniband/hw/hfi1/debugfs.c
@@ -933,6 +933,43 @@ static const struct counter_info port_cntr_ops[] = {
 	DEBUGFS_OPS("asic_flags", asic_flags_read, asic_flags_write),
 };
 
+static void *_sdma_cpu_list_seq_start(struct seq_file *s, loff_t *pos)
+{
+	if (*pos >= num_online_cpus())
+		return NULL;
+
+	return pos;
+}
+
+static void *_sdma_cpu_list_seq_next(struct seq_file *s, void *v, loff_t *pos)
+{
+	++*pos;
+	if (*pos >= num_online_cpus())
+		return NULL;
+
+	return pos;
+}
+
+static void _sdma_cpu_list_seq_stop(struct seq_file *s, void *v)
+{
+	/* nothing allocated */
+}
+
+static int _sdma_cpu_list_seq_show(struct seq_file *s, void *v)
+{
+	struct hfi1_ibdev *ibd = (struct hfi1_ibdev *)s->private;
+	struct hfi1_devdata *dd = dd_from_dev(ibd);
+	loff_t *spos = v;
+	loff_t i = *spos;
+
+	sdma_seqfile_dump_cpu_list(s, dd, (unsigned long)i);
+	return 0;
+}
+
+DEBUGFS_SEQ_FILE_OPS(sdma_cpu_list);
+DEBUGFS_SEQ_FILE_OPEN(sdma_cpu_list)
+DEBUGFS_FILE_OPS(sdma_cpu_list);
+
 void hfi1_dbg_ibdev_init(struct hfi1_ibdev *ibd)
 {
 	char name[sizeof("port0counters") + 1];
@@ -961,6 +998,7 @@ void hfi1_dbg_ibdev_init(struct hfi1_ibdev *ibd)
 	DEBUGFS_SEQ_FILE_CREATE(ctx_stats, ibd->hfi1_ibdev_dbg, ibd);
 	DEBUGFS_SEQ_FILE_CREATE(qp_stats, ibd->hfi1_ibdev_dbg, ibd);
 	DEBUGFS_SEQ_FILE_CREATE(sdes, ibd->hfi1_ibdev_dbg, ibd);
+	DEBUGFS_SEQ_FILE_CREATE(sdma_cpu_list, ibd->hfi1_ibdev_dbg, ibd);
 	/* dev counter files */
 	for (i = 0; i < ARRAY_SIZE(cntr_ops); i++)
 		DEBUGFS_FILE_CREATE(cntr_ops[i].name,
diff --git a/drivers/infiniband/hw/hfi1/sdma.c b/drivers/infiniband/hw/hfi1/sdma.c
index 8cfa960..fd39bca 100644
--- a/drivers/infiniband/hw/hfi1/sdma.c
+++ b/drivers/infiniband/hw/hfi1/sdma.c
@@ -1093,6 +1093,49 @@ static void sdma_rht_free(void *ptr, void *arg)
 	kfree(rht_node);
 }
 
+/**
+ * sdma_seqfile_dump_cpu_list() - debugfs dump the cpu to sdma mappings
+ * @s: seq file
+ * @dd: hfi1_devdata
+ * @cpuid: cpu id
+ *
+ * This routine dumps the process to sde mappings per cpu
+ */
+void sdma_seqfile_dump_cpu_list(struct seq_file *s,
+				struct hfi1_devdata *dd,
+				unsigned long cpuid)
+{
+	struct sdma_rht_node *rht_node;
+	int i, j;
+
+	rht_node = rhashtable_lookup_fast(&dd->sdma_rht, &cpuid,
+					  sdma_rht_params);
+	if (!rht_node)
+		return;
+
+	seq_printf(s, "cpu%3lu: ", cpuid);
+	for (i = 0; i < HFI1_MAX_VLS_SUPPORTED; i++) {
+		if (!rht_node->map[i] || !rht_node->map[i]->ctr)
+			continue;
+
+		seq_printf(s, " vl%d: [", i);
+
+		for (j = 0; j < rht_node->map[i]->ctr; j++) {
+			if (!rht_node->map[i]->sde[j])
+				continue;
+
+			if (j > 0)
+				seq_puts(s, ",");
+
+			seq_printf(s, " sdma%2d",
+				   rht_node->map[i]->sde[j]->this_idx);
+		}
+		seq_puts(s, " ]");
+	}
+
+	seq_puts(s, "\n");
+}
+
 /*
  * Free the indicated map struct
  */
diff --git a/drivers/infiniband/hw/hfi1/sdma.h b/drivers/infiniband/hw/hfi1/sdma.h
index 93025f6..56257ea 100644
--- a/drivers/infiniband/hw/hfi1/sdma.h
+++ b/drivers/infiniband/hw/hfi1/sdma.h
@@ -1068,6 +1068,8 @@ ssize_t sdma_set_cpu_to_sde_map(struct sdma_engine *sde, const char *buf,
 				size_t count);
 int sdma_engine_get_vl(struct sdma_engine *sde);
 void sdma_seqfile_dump_sde(struct seq_file *s, struct sdma_engine *);
+void sdma_seqfile_dump_cpu_list(struct seq_file *s, struct hfi1_devdata *dd,
+				unsigned long cpuid);
 
 #ifdef CONFIG_SDMA_VERBOSITY
 void sdma_dumpstate(struct sdma_engine *);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

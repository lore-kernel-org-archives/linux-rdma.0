From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/4] IB/qib: add per context stats interface
Date: Sat, 15 Jun 2013 17:07:09 -0400
Message-ID: <20130615210709.6069.46210.stgit@phlsvslse11.ph.intel.com>
References: <20130615210633.6069.14865.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130615210633.6069.14865.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch adds a debugfs stats interface
for per kernel contexts packet counts.

The code uses the opcode stats count and eliminates the
counter in the context.

Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_debugfs.c |   63 +++++++++++++++++++++++++++++++
 1 file changed, 63 insertions(+)

diff --git a/drivers/infiniband/hw/qib/qib_debugfs.c b/drivers/infiniband/hw/qib/qib_debugfs.c
index 47d0116..a4e6ee1 100644
--- a/drivers/infiniband/hw/qib/qib_debugfs.c
+++ b/drivers/infiniband/hw/qib/qib_debugfs.c
@@ -126,6 +126,68 @@ static int _opcode_stats_seq_show(struct seq_file *s, void *v)
 
 DEBUGFS_FILE(opcode_stats)
 
+static void *_ctx_stats_seq_start(struct seq_file *s, loff_t *pos)
+{
+	struct qib_ibdev *ibd = (struct qib_ibdev *)s->private;
+	struct qib_devdata *dd = dd_from_dev(ibd);
+
+	if (!*pos)
+		return SEQ_START_TOKEN;
+	if (*pos >= dd->first_user_ctxt)
+		return NULL;
+	return pos;
+}
+
+static void *_ctx_stats_seq_next(struct seq_file *s, void *v, loff_t *pos)
+{
+	struct qib_ibdev *ibd = (struct qib_ibdev *)s->private;
+	struct qib_devdata *dd = dd_from_dev(ibd);
+
+	if (v == SEQ_START_TOKEN)
+		return pos;
+
+	++*pos;
+	if (*pos >= dd->first_user_ctxt)
+		return NULL;
+	return pos;
+}
+
+static void _ctx_stats_seq_stop(struct seq_file *s, void *v)
+{
+	/* nothing allocated */
+}
+
+static int _ctx_stats_seq_show(struct seq_file *s, void *v)
+{
+	loff_t *spos;
+	loff_t i, j;
+	u64 n_packets = 0;
+	struct qib_ibdev *ibd = (struct qib_ibdev *)s->private;
+	struct qib_devdata *dd = dd_from_dev(ibd);
+
+	if (v == SEQ_START_TOKEN) {
+		seq_puts(s, "Ctx:npkts\n");
+		return 0;
+	}
+
+	spos = v;
+	i = *spos;
+
+	if (!dd->rcd[i])
+		return SEQ_SKIP;
+
+	for (j = 0; j < ARRAY_SIZE(dd->rcd[i]->opstats->stats); j++)
+		n_packets += dd->rcd[i]->opstats->stats[j].n_packets;
+
+	if (!n_packets)
+		return SEQ_SKIP;
+
+	seq_printf(s, "  %llu:%llu\n", i, n_packets);
+	return 0;
+}
+
+DEBUGFS_FILE(ctx_stats)
+
 void qib_dbg_ibdev_init(struct qib_ibdev *ibd)
 {
 	char name[10];
@@ -137,6 +199,7 @@ void qib_dbg_ibdev_init(struct qib_ibdev *ibd)
 		return;
 	}
 	DEBUGFS_FILE_CREATE(opcode_stats);
+	DEBUGFS_FILE_CREATE(ctx_stats);
 	return;
 }
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

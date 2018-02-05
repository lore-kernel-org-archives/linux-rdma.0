From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: [PATCH rfc 2/5] irq-am: add some debugfs exposure on tuning state
Date: Tue,  6 Feb 2018 00:03:13 +0200
Message-ID: <20180205220316.30236-3-sagi@grimberg.me>
References: <20180205220316.30236-1-sagi@grimberg.me>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180205220316.30236-1-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Idan Burstein <idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Useful for local debugging

Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
---
 include/linux/irq-am.h |   2 +
 lib/irq-am.c           | 109 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 111 insertions(+)

diff --git a/include/linux/irq-am.h b/include/linux/irq-am.h
index 5ddd5ca268aa..18df315633a4 100644
--- a/include/linux/irq-am.h
+++ b/include/linux/irq-am.h
@@ -101,6 +101,8 @@ struct irq_am {
 
 	struct work_struct		work;
 	irq_am_fn			*program;
+	struct dentry			*debugfs_dir;
+	int				id;
 };
 
 void irq_am_add_event(struct irq_am *am);
diff --git a/lib/irq-am.c b/lib/irq-am.c
index ed7befd7a560..6cd2f131f5e8 100644
--- a/lib/irq-am.c
+++ b/lib/irq-am.c
@@ -12,6 +12,61 @@
  * more details.
  */
 #include <linux/irq-am.h>
+#include <linux/debugfs.h>
+
+static DEFINE_IDA(am_ida);
+
+#ifdef CONFIG_DEBUG_FS
+struct dentry *irq_am_debugfs_root;
+
+struct irq_am_debugfs_attr {
+	const char *name;
+	umode_t mode;
+	int (*show)(void *, struct seq_file *);
+	ssize_t (*write)(void *, const char __user *, size_t, loff_t *);
+};
+
+static int irq_am_tune_state_show(void *data, struct seq_file *m)
+{
+	struct irq_am *am = data;
+
+	seq_printf(m, "%d\n", am->tune_state);
+	return 0;
+}
+
+static int irq_am_curr_level_show(void *data, struct seq_file *m)
+{
+	struct irq_am *am = data;
+
+	seq_printf(m, "%d\n", am->curr_level);
+	return 0;
+}
+
+static int irq_am_debugfs_show(struct seq_file *m, void *v)
+{
+	const struct irq_am_debugfs_attr *attr = m->private;
+	void *data = d_inode(m->file->f_path.dentry->d_parent)->i_private;
+
+	return attr->show(data, m);
+}
+
+static int irq_am_debugfs_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, irq_am_debugfs_show, inode->i_private);
+}
+
+static const struct file_operations irq_am_debugfs_fops = {
+	.open		= irq_am_debugfs_open,
+	.read		= seq_read,
+	.release	= seq_release,
+};
+
+static const struct irq_am_debugfs_attr irq_am_attrs[] = {
+	{"tune_state", 0400, irq_am_tune_state_show},
+	{"curr_level", 0400, irq_am_curr_level_show},
+	{},
+};
+#endif
 
 static void irq_am_try_step(struct irq_am *am)
 {
@@ -160,10 +215,51 @@ static void irq_am_program_moderation_work(struct work_struct *w)
 	am->state = IRQ_AM_START_MEASURING;
 }
 
+#ifdef CONFIG_DEBUG_FS
+static bool debugfs_create_files(struct dentry *parent, void *data,
+				 const struct irq_am_debugfs_attr *attr)
+{
+	d_inode(parent)->i_private = data;
+
+	for (; attr->name; attr++) {
+		if (!debugfs_create_file(attr->name, attr->mode, parent,
+					 (void *)attr, &irq_am_debugfs_fops))
+			return false;
+	}
+	return true;
+}
+
+static int irq_am_register_debugfs(struct irq_am *am)
+{
+	char name[20];
+
+	snprintf(name, sizeof(name), "am%u", am->id);
+	am->debugfs_dir = debugfs_create_dir(name,
+				irq_am_debugfs_root);
+	if (!am->debugfs_dir)
+		return -ENOMEM;
+
+	if (!debugfs_create_files(am->debugfs_dir, am,
+				irq_am_attrs))
+		return -ENOMEM;
+	return 0;
+}
+
+static void irq_am_deregister_debugfs(struct irq_am *am)
+{
+	debugfs_remove_recursive(am->debugfs_dir);
+}
+
+#else
+static int irq_am_register_debugfs(struct irq_am *am) {}
+static void irq_am_deregister_debugfs(struct irq_am *am) {}
+#endif
 
 void irq_am_cleanup(struct irq_am *am)
 {
 	flush_work(&am->work);
+	irq_am_deregister_debugfs(am);
+	ida_simple_remove(&am_ida, am->id);
 }
 EXPORT_SYMBOL_GPL(irq_am_cleanup);
 
@@ -177,6 +273,19 @@ void irq_am_init(struct irq_am *am, unsigned int nr_events,
 	am->nr_events = nr_events;
 	am->curr_level = start_level;
 	am->program = fn;
+	am->id = ida_simple_get(&am_ida, 0, 0, GFP_KERNEL);
+	WARN_ON(am->id < 0);
 	INIT_WORK(&am->work, irq_am_program_moderation_work);
+	if (irq_am_register_debugfs(am))
+		pr_warn("irq-am %d failed to register debugfs\n", am->id);
 }
 EXPORT_SYMBOL_GPL(irq_am_init);
+
+static __init int irq_am_setup(void)
+{
+#ifdef CONFIG_DEBUG_FS
+	irq_am_debugfs_root = debugfs_create_dir("irq_am", NULL);
+#endif
+	return 0;
+}
+subsys_initcall(irq_am_setup);
-- 
2.14.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

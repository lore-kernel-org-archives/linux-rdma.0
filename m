From: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v1 for-next] IB/usnic: Expose flows via debugfs
Date: Thu,  9 Jan 2014 15:40:58 -0800
Message-ID: <1389310858-20391-1-git-send-email-umalhi@cisco.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Depends on "[PATCH v1 for-next] IB/usnic: usNIC UDP Support" series.

V1 changes:
Respun because another patch in the dependency chain changed, making this patch
incompatible.

Signed-off-by: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/usnic/usnic_debugfs.c   | 91 ++++++++++++++++++++++++++-
 drivers/infiniband/hw/usnic/usnic_debugfs.h   |  4 ++
 drivers/infiniband/hw/usnic/usnic_ib.h        |  7 +++
 drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c |  8 ++-
 drivers/infiniband/hw/usnic/usnic_ib_qp_grp.h |  5 ++
 drivers/infiniband/hw/usnic/usnic_ib_sysfs.c  |  6 --
 6 files changed, 111 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/usnic/usnic_debugfs.c b/drivers/infiniband/hw/usnic/usnic_debugfs.c
index 91386df..6cb2e7c 100644
--- a/drivers/infiniband/hw/usnic/usnic_debugfs.c
+++ b/drivers/infiniband/hw/usnic/usnic_debugfs.c
@@ -22,8 +22,11 @@
 #include "usnic.h"
 #include "usnic_log.h"
 #include "usnic_debugfs.h"
+#include "usnic_ib_qp_grp.h"
+#include "usnic_transport.h"

 static struct dentry *debugfs_root;
+static struct dentry *flows_dentry;

 static ssize_t usnic_debugfs_buildinfo_read(struct file *f, char __user *data,
 						size_t count, loff_t *ppos)
@@ -48,17 +51,73 @@ static const struct file_operations usnic_debugfs_buildinfo_ops = {
 	.read = usnic_debugfs_buildinfo_read
 };

+static ssize_t flowinfo_read(struct file *f, char __user *data,
+				size_t count, loff_t *ppos)
+{
+	struct usnic_ib_qp_grp_flow *qp_flow;
+	int n;
+	int left;
+	char *ptr;
+	char buf[512];
+
+	qp_flow = f->private_data;
+	ptr = buf;
+	left = count;
+
+	if (*ppos > 0)
+		return 0;
+
+	spin_lock(&qp_flow->qp_grp->lock);
+	n = scnprintf(ptr, left,
+			"QP Grp ID: %d Transport: %s ",
+			qp_flow->qp_grp->grp_id,
+			usnic_transport_to_str(qp_flow->trans_type));
+	UPDATE_PTR_LEFT(n, ptr, left);
+	if (qp_flow->trans_type == USNIC_TRANSPORT_ROCE_CUSTOM) {
+		n = scnprintf(ptr, left, "Port_Num:%hu\n",
+					qp_flow->usnic_roce.port_num);
+		UPDATE_PTR_LEFT(n, ptr, left);
+	} else if (qp_flow->trans_type == USNIC_TRANSPORT_IPV4_UDP) {
+		n = usnic_transport_sock_to_str(ptr, left,
+				qp_flow->udp.sock);
+		UPDATE_PTR_LEFT(n, ptr, left);
+		n = scnprintf(ptr, left, "\n");
+		UPDATE_PTR_LEFT(n, ptr, left);
+	}
+	spin_unlock(&qp_flow->qp_grp->lock);
+
+	return simple_read_from_buffer(data, count, ppos, buf, ptr - buf);
+}
+
+static const struct file_operations flowinfo_ops = {
+	.owner = THIS_MODULE,
+	.open = simple_open,
+	.read = flowinfo_read,
+};
+
 void usnic_debugfs_init(void)
 {
 	debugfs_root = debugfs_create_dir(DRV_NAME, NULL);
 	if (IS_ERR(debugfs_root)) {
 		usnic_err("Failed to create debugfs root dir, check if debugfs is enabled in kernel configuration\n");
-		debugfs_root = NULL;
-		return;
+		goto out_clear_root;
+	}
+
+	flows_dentry = debugfs_create_dir("flows", debugfs_root);
+	if (IS_ERR_OR_NULL(flows_dentry)) {
+		usnic_err("Failed to create debugfs flow dir with err %ld\n",
+				PTR_ERR(flows_dentry));
+		goto out_free_root;
 	}

 	debugfs_create_file("build-info", S_IRUGO, debugfs_root,
 				NULL, &usnic_debugfs_buildinfo_ops);
+	return;
+
+out_free_root:
+	debugfs_remove_recursive(debugfs_root);
+out_clear_root:
+	debugfs_root = NULL;
 }

 void usnic_debugfs_exit(void)
@@ -69,3 +128,31 @@ void usnic_debugfs_exit(void)
 	debugfs_remove_recursive(debugfs_root);
 	debugfs_root = NULL;
 }
+
+void usnic_debugfs_flow_add(struct usnic_ib_qp_grp_flow *qp_flow)
+{
+	struct usnic_ib_qp_grp *qp_grp;
+
+	if (IS_ERR_OR_NULL(flows_dentry))
+		return;
+
+	qp_grp = qp_flow->qp_grp;
+
+	scnprintf(qp_flow->dentry_name, sizeof(qp_flow->dentry_name),
+			"%u", qp_flow->flow->flow_id);
+	qp_flow->dbgfs_dentry = debugfs_create_file(qp_flow->dentry_name,
+							S_IRUGO,
+							flows_dentry,
+							qp_flow,
+							&flowinfo_ops);
+	if (IS_ERR_OR_NULL(qp_flow->dbgfs_dentry)) {
+		usnic_err("Failed to create dbg fs entry for flow %u\n",
+				qp_flow->flow->flow_id);
+	}
+}
+
+void usnic_debugfs_flow_remove(struct usnic_ib_qp_grp_flow *qp_flow)
+{
+	if (!IS_ERR_OR_NULL(qp_flow->dbgfs_dentry))
+		debugfs_remove(qp_flow->dbgfs_dentry);
+}
diff --git a/drivers/infiniband/hw/usnic/usnic_debugfs.h b/drivers/infiniband/hw/usnic/usnic_debugfs.h
index 914a330..4087d24 100644
--- a/drivers/infiniband/hw/usnic/usnic_debugfs.h
+++ b/drivers/infiniband/hw/usnic/usnic_debugfs.h
@@ -18,8 +18,12 @@
 #ifndef USNIC_DEBUGFS_H_
 #define USNIC_DEBUGFS_H_

+#include "usnic_ib_qp_grp.h"
+
 void usnic_debugfs_init(void);

 void usnic_debugfs_exit(void);
+void usnic_debugfs_flow_add(struct usnic_ib_qp_grp_flow *qp_flow);
+void usnic_debugfs_flow_remove(struct usnic_ib_qp_grp_flow *qp_flow);

 #endif /*!USNIC_DEBUGFS_H_ */
diff --git a/drivers/infiniband/hw/usnic/usnic_ib.h b/drivers/infiniband/hw/usnic/usnic_ib.h
index 92d9d9a..111a86e 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib.h
+++ b/drivers/infiniband/hw/usnic/usnic_ib.h
@@ -109,4 +109,11 @@ struct usnic_ib_mr *to_umr(struct ib_mr *ibmr)
 	return container_of(ibmr, struct usnic_ib_mr, ibmr);
 }
 void usnic_ib_log_vf(struct usnic_ib_vf *vf);
+
+#define UPDATE_PTR_LEFT(N, P, L)			\
+do {							\
+	L -= (N);					\
+	P += (N);					\
+} while (0)
+
 #endif /* USNIC_IB_H_ */
diff --git a/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c b/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
index d6667a1..7967c8b 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
@@ -24,6 +24,7 @@
 #include "usnic_vnic.h"
 #include "usnic_fwd.h"
 #include "usnic_uiom.h"
+#include "usnic_debugfs.h"
 #include "usnic_ib_qp_grp.h"
 #include "usnic_ib_sysfs.h"
 #include "usnic_transport.h"
@@ -340,8 +341,10 @@ create_and_add_flow(struct usnic_ib_qp_grp *qp_grp,
 		return ERR_PTR(-EINVAL);
 	}

-	if (!IS_ERR_OR_NULL(qp_flow))
+	if (!IS_ERR_OR_NULL(qp_flow)) {
 		list_add_tail(&qp_flow->link, &qp_grp->flows_lst);
+		usnic_debugfs_flow_add(qp_flow);
+	}


 	return qp_flow;
@@ -349,6 +352,7 @@ create_and_add_flow(struct usnic_ib_qp_grp *qp_grp,

 static void release_and_remove_flow(struct usnic_ib_qp_grp_flow *qp_flow)
 {
+	usnic_debugfs_flow_remove(qp_flow);
 	list_del(&qp_flow->link);

 	switch (qp_flow->trans_type) {
@@ -728,9 +732,9 @@ void usnic_ib_qp_grp_destroy(struct usnic_ib_qp_grp *qp_grp)
 	WARN_ON(qp_grp->state != IB_QPS_RESET);
 	lockdep_assert_held(&qp_grp->vf->lock);

+	release_and_remove_all_flows(qp_grp);
 	usnic_ib_sysfs_qpn_remove(qp_grp);
 	qp_grp_and_vf_unbind(qp_grp);
-	release_and_remove_all_flows(qp_grp);
 	free_qp_grp_res(qp_grp->res_chunk_list);
 	kfree(qp_grp);
 }
diff --git a/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.h b/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.h
index a8ba1b9..b0aafe8 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.h
+++ b/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.h
@@ -19,6 +19,7 @@
 #ifndef USNIC_IB_QP_GRP_H_
 #define USNIC_IB_QP_GRP_H_

+#include <linux/debugfs.h>
 #include <rdma/ib_verbs.h>

 #include "usnic_ib.h"
@@ -62,6 +63,10 @@ struct usnic_ib_qp_grp_flow {
 	};
 	struct usnic_ib_qp_grp		*qp_grp;
 	struct list_head		link;
+
+	/* Debug FS */
+	struct dentry			*dbgfs_dentry;
+	char				dentry_name[32];
 };

 static const struct
diff --git a/drivers/infiniband/hw/usnic/usnic_ib_sysfs.c b/drivers/infiniband/hw/usnic/usnic_ib_sysfs.c
index 3e58842..27dc67c 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_sysfs.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_sysfs.c
@@ -30,12 +30,6 @@
 #include "usnic_ib_verbs.h"
 #include "usnic_log.h"

-#define UPDATE_PTR_LEFT(N, P, L)			\
-do {							\
-	L -= (N);					\
-	P += (N);					\
-} while (0)
-
 static ssize_t usnic_ib_show_fw_ver(struct device *device,
 					struct device_attribute *attr,
 					char *buf)
--
1.8.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

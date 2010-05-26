From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] IB/qib: fix powerpc compile warnings
Date: Wed, 26 May 2010 11:42:06 -0700
Message-ID: <20100526184205.11285.79404.stgit@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Fix the compile warnings for uninitialized variables in qib_fs.c
when compiling for powerpc.

Signed-off-by: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---

 drivers/infiniband/hw/qib/qib_fs.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_fs.c b/drivers/infiniband/hw/qib/qib_fs.c
index 7554704..8a354f7 100644
--- a/drivers/infiniband/hw/qib/qib_fs.c
+++ b/drivers/infiniband/hw/qib/qib_fs.c
@@ -143,7 +143,7 @@ static const struct file_operations driver_ops[] = {
 static ssize_t dev_counters_read(struct file *file, char __user *buf,
 				 size_t count, loff_t *ppos)
 {
-	u64 *counters;
+	u64 *counters = NULL;
 	struct qib_devdata *dd = private2dd(file);
 
 	return simple_read_from_buffer(buf, count, ppos, counters,
@@ -154,7 +154,7 @@ static ssize_t dev_counters_read(struct file *file, char __user *buf,
 static ssize_t dev_names_read(struct file *file, char __user *buf,
 			      size_t count, loff_t *ppos)
 {
-	char *names;
+	char *names = NULL;
 	struct qib_devdata *dd = private2dd(file);
 
 	return simple_read_from_buffer(buf, count, ppos, names,
@@ -175,7 +175,7 @@ static const struct file_operations cntr_ops[] = {
 static ssize_t portnames_read(struct file *file, char __user *buf,
 			      size_t count, loff_t *ppos)
 {
-	char *names;
+	char *names = NULL;
 	struct qib_devdata *dd = private2dd(file);
 
 	return simple_read_from_buffer(buf, count, ppos, names,
@@ -186,7 +186,7 @@ static ssize_t portnames_read(struct file *file, char __user *buf,
 static ssize_t portcntrs_1_read(struct file *file, char __user *buf,
 				size_t count, loff_t *ppos)
 {
-	u64 *counters;
+	u64 *counters = NULL;
 	struct qib_devdata *dd = private2dd(file);
 
 	return simple_read_from_buffer(buf, count, ppos, counters,
@@ -197,7 +197,7 @@ static ssize_t portcntrs_1_read(struct file *file, char __user *buf,
 static ssize_t portcntrs_2_read(struct file *file, char __user *buf,
 				size_t count, loff_t *ppos)
 {
-	u64 *counters;
+	u64 *counters = NULL;
 	struct qib_devdata *dd = private2dd(file);
 
 	return simple_read_from_buffer(buf, count, ppos, counters,

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

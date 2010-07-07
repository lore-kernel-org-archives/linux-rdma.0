From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: [PATCH 04/18] ib/qib: use generic_file_llseek
Date: Wed,  7 Jul 2010 23:40:06 +0200
Message-ID: <1278538820-1392-5-git-send-email-arnd@arndb.de>
References: <1278538820-1392-1-git-send-email-arnd@arndb.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1278538820-1392-1-git-send-email-arnd-r2nGTMty4D4@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: John Kacur <jkacur-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

When the default llseek action gets changed to
no_llseek, all file systems relying on the
current behaviour need to set explicit .llseek
operations.

In case of qib_fs, we want the files to be
seekable, so generic_file_llseek fits best.

Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 drivers/infiniband/hw/qib/qib_fs.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_fs.c b/drivers/infiniband/hw/qib/qib_fs.c
index 844954b..9f989c0 100644
--- a/drivers/infiniband/hw/qib/qib_fs.c
+++ b/drivers/infiniband/hw/qib/qib_fs.c
@@ -135,8 +135,8 @@ static ssize_t driver_names_read(struct file *file, char __user *buf,
 }
 
 static const struct file_operations driver_ops[] = {
-	{ .read = driver_stats_read, },
-	{ .read = driver_names_read, },
+	{ .read = driver_stats_read, .llseek = generic_file_llseek, },
+	{ .read = driver_names_read, .llseek = generic_file_llseek, },
 };
 
 /* read the per-device counters */
@@ -164,8 +164,8 @@ static ssize_t dev_names_read(struct file *file, char __user *buf,
 }
 
 static const struct file_operations cntr_ops[] = {
-	{ .read = dev_counters_read, },
-	{ .read = dev_names_read, },
+	{ .read = dev_counters_read, .llseek = generic_file_llseek, },
+	{ .read = dev_names_read, .llseek = generic_file_llseek, },
 };
 
 /*
@@ -210,9 +210,9 @@ static ssize_t portcntrs_2_read(struct file *file, char __user *buf,
 }
 
 static const struct file_operations portcntr_ops[] = {
-	{ .read = portnames_read, },
-	{ .read = portcntrs_1_read, },
-	{ .read = portcntrs_2_read, },
+	{ .read = portnames_read, .llseek = generic_file_llseek, },
+	{ .read = portcntrs_1_read, .llseek = generic_file_llseek, },
+	{ .read = portcntrs_2_read, .llseek = generic_file_llseek, },
 };
 
 /*
@@ -261,8 +261,8 @@ static ssize_t qsfp_2_read(struct file *file, char __user *buf,
 }
 
 static const struct file_operations qsfp_ops[] = {
-	{ .read = qsfp_1_read, },
-	{ .read = qsfp_2_read, },
+	{ .read = qsfp_1_read, .llseek = generic_file_llseek, },
+	{ .read = qsfp_2_read, .llseek = generic_file_llseek, },
 };
 
 static ssize_t flash_read(struct file *file, char __user *buf,
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

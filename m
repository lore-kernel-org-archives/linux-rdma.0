From: Bhumika Goyal <bhumirks-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/2] IB/qib: add const to bin_attribute structures
Date: Wed,  2 Aug 2017 15:31:29 +0530
Message-ID: <1501668090-22662-2-git-send-email-bhumirks@gmail.com>
References: <1501668090-22662-1-git-send-email-bhumirks@gmail.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1501668090-22662-1-git-send-email-bhumirks-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: julia.lawall-L2FTfq7BK8M@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Bhumika Goyal <bhumirks-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add const to bin_attribute structures as they are only passed to the
functions sysfs_{remove/create}_bin_file. The arguments passed are of
type const, so declare the structures to be const.

Done using Coccinelle.

@m disable optional_qualifier@
identifier s;
position p;
@@
static struct bin_attribute s@p={...};

@okay1@
position p;
identifier m.s;
@@
(
sysfs_create_bin_file(...,&s@p,...)
|
sysfs_remove_bin_file(...,&s@p,...)
)

@bad@
position p!={m.p,okay1.p};
identifier m.s;
@@
s@p

@change depends on !bad disable optional_qualifier@
identifier m.s;
@@
static
+const
struct bin_attribute s={...};

Signed-off-by: Bhumika Goyal <bhumirks-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_sysfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_sysfs.c b/drivers/infiniband/hw/qib/qib_sysfs.c
index fe4cf5e..ca2638d 100644
--- a/drivers/infiniband/hw/qib/qib_sysfs.c
+++ b/drivers/infiniband/hw/qib/qib_sysfs.c
@@ -247,7 +247,7 @@ static void qib_port_release(struct kobject *kobj)
 	.release = qib_port_release,
 };
 
-static struct bin_attribute cc_table_bin_attr = {
+static const struct bin_attribute cc_table_bin_attr = {
 	.attr = {.name = "cc_table_bin", .mode = 0444},
 	.read = read_cc_table_bin,
 	.size = PAGE_SIZE,
@@ -286,7 +286,7 @@ static ssize_t read_cc_setting_bin(struct file *filp, struct kobject *kobj,
 	return count;
 }
 
-static struct bin_attribute cc_setting_bin_attr = {
+static const struct bin_attribute cc_setting_bin_attr = {
 	.attr = {.name = "cc_settings_bin", .mode = 0444},
 	.read = read_cc_setting_bin,
 	.size = PAGE_SIZE,
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

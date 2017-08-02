From: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH 2/2] IB/hfi1: add const to bin_attribute structures
Date: Wed,  2 Aug 2017 15:31:30 +0530
Message-ID: <1501668090-22662-3-git-send-email-bhumirks@gmail.com>
References: <1501668090-22662-1-git-send-email-bhumirks@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1501668090-22662-1-git-send-email-bhumirks@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: julia.lawall@lip6.fr, mike.marciniszyn@intel.com, dennis.dalessandro@intel.com, dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
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

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/infiniband/hw/hfi1/sysfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/sysfs.c b/drivers/infiniband/hw/hfi1/sysfs.c
index 2f3bbca..6d2702ef 100644
--- a/drivers/infiniband/hw/hfi1/sysfs.c
+++ b/drivers/infiniband/hw/hfi1/sysfs.c
@@ -95,7 +95,7 @@ static void port_release(struct kobject *kobj)
 	/* nothing to do since memory is freed by hfi1_free_devdata() */
 }
 
-static struct bin_attribute cc_table_bin_attr = {
+static const struct bin_attribute cc_table_bin_attr = {
 	.attr = {.name = "cc_table_bin", .mode = 0444},
 	.read = read_cc_table_bin,
 	.size = PAGE_SIZE,
@@ -137,7 +137,7 @@ static ssize_t read_cc_setting_bin(struct file *filp, struct kobject *kobj,
 	return count;
 }
 
-static struct bin_attribute cc_setting_bin_attr = {
+static const struct bin_attribute cc_setting_bin_attr = {
 	.attr = {.name = "cc_settings_bin", .mode = 0444},
 	.read = read_cc_setting_bin,
 	.size = PAGE_SIZE,
-- 
1.9.1

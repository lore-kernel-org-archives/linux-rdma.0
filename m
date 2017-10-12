From: Bhumika Goyal <bhumirks-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB/cma: make config_item_type const
Date: Thu, 12 Oct 2017 14:20:00 +0200
Message-ID: <1507810800-8972-1-git-send-email-bhumirks@gmail.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: julia.lawall-L2FTfq7BK8M@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Bhumika Goyal <bhumirks-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a followup patch for: https://lkml.org/lkml/2017/10/11/375 and
https://patchwork.kernel.org/patch/9999649/

Make these structures const as they are either passed to the functions
having the argument as const or stored as a reference in the "ci_type"
const field of a config_item structure.

Done using Coccienlle.

Signed-off-by: Bhumika Goyal <bhumirks-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/cma_configfs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/core/cma_configfs.c b/drivers/infiniband/core/cma_configfs.c
index 54076a3..31dfee0 100644
--- a/drivers/infiniband/core/cma_configfs.c
+++ b/drivers/infiniband/core/cma_configfs.c
@@ -186,7 +186,7 @@ static ssize_t default_roce_tos_store(struct config_item *item,
 	NULL,
 };
 
-static struct config_item_type cma_port_group_type = {
+static const struct config_item_type cma_port_group_type = {
 	.ct_attrs	= cma_configfs_attributes,
 	.ct_owner	= THIS_MODULE
 };
@@ -263,7 +263,7 @@ static void release_cma_ports_group(struct config_item  *item)
 	.release = release_cma_ports_group
 };
 
-static struct config_item_type cma_ports_group_type = {
+static const struct config_item_type cma_ports_group_type = {
 	.ct_item_ops	= &cma_ports_item_ops,
 	.ct_owner	= THIS_MODULE
 };
@@ -272,7 +272,7 @@ static void release_cma_ports_group(struct config_item  *item)
 	.release = release_cma_dev
 };
 
-static struct config_item_type cma_device_group_type = {
+static const struct config_item_type cma_device_group_type = {
 	.ct_item_ops	= &cma_device_item_ops,
 	.ct_owner	= THIS_MODULE
 };
@@ -323,7 +323,7 @@ static struct config_group *make_cma_dev(struct config_group *group,
 	.make_group	= make_cma_dev,
 };
 
-static struct config_item_type cma_subsys_type = {
+static const struct config_item_type cma_subsys_type = {
 	.ct_group_ops	= &cma_subsys_group_ops,
 	.ct_owner	= THIS_MODULE,
 };
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Steven Roberts <robers97-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] NULL required to terminate attr array
Date: Tue, 9 May 2017 16:09:07 -0500
Message-ID: <20170509210907.GA29717@oc1783850105.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


This patch fixes a kernel panic when loading the hfi driver as a dynamic module.Addressing this patch will make performance tweaking the driver as a loadable mdule possible.

Signed-off-by: Steven Roberts <robers97-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

diff --git a/drivers/infiniband/hw/hfi1/sysfs.c b/drivers/infiniband/hw/hfi1/sys
index 50d140d..2f3bbca 100644
--- a/drivers/infiniband/hw/hfi1/sysfs.c
+++ b/drivers/infiniband/hw/hfi1/sysfs.c
@@ -196,7 +196,8 @@ static ssize_t cc_attr_store(struct kobject *kobj, struct at
 };
 
 static struct attribute *port_cc_default_attributes[] = {
-       &cc_prescan_attr.attr
+       &cc_prescan_attr.attr,
+       NULL
 };
 
 static struct kobj_type port_cc_ktype = {

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

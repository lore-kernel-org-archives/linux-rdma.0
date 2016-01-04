From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH] IB/sysfs: Fix sparse warning on attr_id
Date: Sun,  3 Jan 2016 22:44:25 -0500
Message-ID: <1451879065-6513-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Attributed ID was declared as an int while the value should really be big
endian 16.

Fixes: 35c4cbb17811 ("IB/core: Create get_perf_mad function in sysfs.c")

Reported-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/sysfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index 2daf83276cdf..3de93517efe4 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -77,7 +77,7 @@ struct port_table_attribute {
 	struct port_attribute	attr;
 	char			name[8];
 	int			index;
-	int			attr_id;
+	__be16			attr_id;
 };
 
 static ssize_t port_attr_show(struct kobject *kobj,
@@ -413,7 +413,7 @@ struct port_table_attribute port_pma_attr_ext_##_name = {		\
  * Get a Perfmgmt MAD block of data.
  * Returns error code or the number of bytes retrieved.
  */
-static int get_perf_mad(struct ib_device *dev, int port_num, int attr,
+static int get_perf_mad(struct ib_device *dev, int port_num, __be16 attr,
 		void *data, int offset, size_t size)
 {
 	struct ib_mad *in_mad;
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next v1 3/6] IB/core: Fix unable to change lifespan entry for hw_counters
Date: Mon, 16 Oct 2017 08:45:14 +0300
Message-ID: <20171016054517.30643-4-leon@kernel.org>
References: <20171016054517.30643-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171016054517.30643-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This patch fixes the case where 'lifespan' entry of the hw_counters
is not writable. Currently write callback is not exposed for for
the hw_counters sysfs operation. Due to this, modifying lifespan
value results into permission denied error in below example.

echo 10 > /sys/class/infiniband/mlx5_0/ports/1/hw_counters/lifespan
-bash: /sys/class/infiniband/mlx5_0/ports/1/hw_counters/lifespan:
Permission denied

This patch adds the hook to modify any attribute which implements
store() operation.

Fixes: b40f4757daa1 ("IB/core: Make device counter infrastructure dynamic")
Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/sysfs.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index abc5ab581f82..e30d86fa1855 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -108,8 +108,22 @@ static ssize_t port_attr_show(struct kobject *kobj,
 	return port_attr->show(p, port_attr, buf);
 }
 
+static ssize_t port_attr_store(struct kobject *kobj,
+			       struct attribute *attr,
+			       const char *buf, size_t count)
+{
+	struct port_attribute *port_attr =
+		container_of(attr, struct port_attribute, attr);
+	struct ib_port *p = container_of(kobj, struct ib_port, kobj);
+
+	if (!port_attr->store)
+		return -EIO;
+	return port_attr->store(p, port_attr, buf, count);
+}
+
 static const struct sysfs_ops port_sysfs_ops = {
-	.show = port_attr_show
+	.show	= port_attr_show,
+	.store	= port_attr_store
 };
 
 static ssize_t gid_attr_show(struct kobject *kobj,
-- 
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v4 for-next 08/14] IB/core: Report gid_type and gid_ndev through sysfs
Date: Tue, 19 May 2015 17:27:11 +0300
Message-ID: <1432045637-9090-9-git-send-email-matanb@mellanox.com>
References: <1432045637-9090-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432045637-9090-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Since we've added GID attributes to the RoCE GID table,
the users need a convenient way to query them.
Adding the GID type and relate net device to IB's sysfs.

The new attributes are available in:
/sys/class/infiniband/<device>/ports/<port>/gid_attrs/ndevs/<index>
/sys/class/infiniband/<device>/ports/<port>/gid_attrs/types/<index>

The <index> corresponds to the index of the respective GID in:
/sys/class/infiniband/<device>/ports/<port>/gids/<index>

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/core_priv.h      |   2 +
 drivers/infiniband/core/roce_gid_table.c |  12 ++
 drivers/infiniband/core/sysfs.c          | 184 ++++++++++++++++++++++++++++++-
 3 files changed, 196 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/core/core_priv.h
index 0383643..9eebd09 100644
--- a/drivers/infiniband/core/core_priv.h
+++ b/drivers/infiniband/core/core_priv.h
@@ -71,6 +71,8 @@ void ib_enum_roce_ports_of_netdev(roce_netdev_filter filter,
 				  roce_netdev_callback cb,
 				  void *cookie);
 
+const char *roce_gid_table_type_str(enum ib_gid_type gid_type);
+
 int roce_gid_table_get_gid(struct ib_device *ib_dev, u8 port, int index,
 			   union ib_gid *gid, struct ib_gid_attr *attr);
 
diff --git a/drivers/infiniband/core/roce_gid_table.c b/drivers/infiniband/core/roce_gid_table.c
index 5692bb8..ecaaaf4 100644
--- a/drivers/infiniband/core/roce_gid_table.c
+++ b/drivers/infiniband/core/roce_gid_table.c
@@ -50,6 +50,10 @@ enum gid_attr_find_mask {
 	GID_ATTR_FIND_MASK_DEFAULT	= 1UL << 3,
 };
 
+static const char * const gid_type_str[] = {
+	[IB_GID_TYPE_IB]	= "IB/RoCE v1\n",
+};
+
 static inline int start_port(struct ib_device *ib_dev)
 {
 	return (ib_dev->node_type == RDMA_NODE_IB_SWITCH) ? 0 : 1;
@@ -60,6 +64,14 @@ struct dev_put_rcu {
 	struct net_device	*ndev;
 };
 
+const char *roce_gid_table_type_str(enum ib_gid_type gid_type)
+{
+	if (gid_type < ARRAY_SIZE(gid_type_str) && gid_type_str[gid_type])
+		return gid_type_str[gid_type];
+
+	return "Invalid GID type";
+}
+
 static void put_ndev(struct rcu_head *rcu)
 {
 	struct dev_put_rcu *put_rcu =
diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index 5cee246..cfcddf0 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -37,12 +37,22 @@
 #include <linux/slab.h>
 #include <linux/stat.h>
 #include <linux/string.h>
+#include <linux/netdevice.h>
 
 #include <rdma/ib_mad.h>
 
+struct ib_port;
+
+struct gid_attr_group {
+	struct ib_port		*port;
+	struct kobject		kobj;
+	struct attribute_group	ndev;
+	struct attribute_group	type;
+};
 struct ib_port {
 	struct kobject         kobj;
 	struct ib_device      *ibdev;
+	struct gid_attr_group *gid_attr_group;
 	struct attribute_group gid_group;
 	struct attribute_group pkey_group;
 	u8                     port_num;
@@ -84,6 +94,24 @@ static const struct sysfs_ops port_sysfs_ops = {
 	.show = port_attr_show
 };
 
+static ssize_t gid_attr_show(struct kobject *kobj,
+			     struct attribute *attr, char *buf)
+{
+	struct port_attribute *port_attr =
+		container_of(attr, struct port_attribute, attr);
+	struct ib_port *p = container_of(kobj, struct gid_attr_group,
+					 kobj)->port;
+
+	if (!port_attr->show)
+		return -EIO;
+
+	return port_attr->show(p, port_attr, buf);
+}
+
+static const struct sysfs_ops gid_attr_sysfs_ops = {
+	.show = gid_attr_show
+};
+
 static ssize_t state_show(struct ib_port *p, struct port_attribute *unused,
 			  char *buf)
 {
@@ -281,6 +309,46 @@ static struct attribute *port_default_attrs[] = {
 	NULL
 };
 
+static size_t print_ndev(struct ib_gid_attr *gid_attr, char *buf)
+{
+	if (!gid_attr->ndev)
+		return -EINVAL;
+
+	return sprintf(buf, "%s\n", gid_attr->ndev->name);
+}
+
+static size_t print_gid_type(struct ib_gid_attr *gid_attr, char *buf)
+{
+	return sprintf(buf, "%s", roce_gid_table_type_str(gid_attr->gid_type));
+}
+
+static ssize_t _show_port_gid_attr(struct ib_port *p,
+				   struct port_attribute *attr,
+				   char *buf,
+				   size_t (*print)(struct ib_gid_attr *gid_attr,
+						   char *buf))
+{
+	struct port_table_attribute *tab_attr =
+		container_of(attr, struct port_table_attribute, attr);
+	union ib_gid gid;
+	struct ib_gid_attr gid_attr;
+	ssize_t ret;
+	va_list args;
+
+	rcu_read_lock();
+	ret = ib_query_gid(p->ibdev, p->port_num, tab_attr->index, &gid,
+			   &gid_attr);
+	if (ret)
+		goto err;
+
+	ret = print(&gid_attr, buf);
+
+err:
+	va_end(args);
+	rcu_read_unlock();
+	return ret;
+}
+
 static ssize_t show_port_gid(struct ib_port *p, struct port_attribute *attr,
 			     char *buf)
 {
@@ -296,6 +364,19 @@ static ssize_t show_port_gid(struct ib_port *p, struct port_attribute *attr,
 	return sprintf(buf, "%pI6\n", gid.raw);
 }
 
+static ssize_t show_port_gid_attr_ndev(struct ib_port *p,
+				       struct port_attribute *attr, char *buf)
+{
+	return _show_port_gid_attr(p, attr, buf, print_ndev);
+}
+
+static ssize_t show_port_gid_attr_gid_type(struct ib_port *p,
+					   struct port_attribute *attr,
+					   char *buf)
+{
+	return _show_port_gid_attr(p, attr, buf, print_gid_type);
+}
+
 static ssize_t show_port_pkey(struct ib_port *p, struct port_attribute *attr,
 			      char *buf)
 {
@@ -446,12 +527,41 @@ static void ib_port_release(struct kobject *kobj)
 	kfree(p);
 }
 
+static void ib_port_gid_attr_release(struct kobject *kobj)
+{
+	struct gid_attr_group *g = container_of(kobj, struct gid_attr_group,
+						kobj);
+	struct attribute *a;
+	int i;
+
+	if (g->ndev.attrs) {
+		for (i = 0; (a = g->ndev.attrs[i]); ++i)
+			kfree(a);
+
+		kfree(g->ndev.attrs);
+	}
+
+	if (g->type.attrs) {
+		for (i = 0; (a = g->type.attrs[i]); ++i)
+			kfree(a);
+
+		kfree(g->type.attrs);
+	}
+
+	kfree(g);
+}
+
 static struct kobj_type port_type = {
 	.release       = ib_port_release,
 	.sysfs_ops     = &port_sysfs_ops,
 	.default_attrs = port_default_attrs
 };
 
+static struct kobj_type gid_attr_type = {
+	.sysfs_ops	= &gid_attr_sysfs_ops,
+	.release	= ib_port_gid_attr_release
+};
+
 static void ib_device_release(struct device *device)
 {
 	struct ib_device *dev = container_of(device, struct ib_device, dev);
@@ -545,9 +655,23 @@ static int add_port(struct ib_device *device, int port_num,
 		return ret;
 	}
 
+	p->gid_attr_group = kzalloc(sizeof(*p->gid_attr_group), GFP_KERNEL);
+	if (!p->gid_attr_group) {
+		ret = -ENOMEM;
+		goto err_put;
+	}
+
+	p->gid_attr_group->port = p;
+	ret = kobject_init_and_add(&p->gid_attr_group->kobj, &gid_attr_type,
+				   &p->kobj, "gid_attrs");
+	if (ret) {
+		kfree(p->gid_attr_group);
+		goto err_put;
+	}
+
 	ret = sysfs_create_group(&p->kobj, &pma_group);
 	if (ret)
-		goto err_put;
+		goto err_put_gid_attrs;
 
 	p->gid_group.name  = "gids";
 	p->gid_group.attrs = alloc_group_attrs(show_port_gid, attr.gid_tbl_len);
@@ -560,12 +684,38 @@ static int add_port(struct ib_device *device, int port_num,
 	if (ret)
 		goto err_free_gid;
 
+	p->gid_attr_group->ndev.name = "ndevs";
+	p->gid_attr_group->ndev.attrs = alloc_group_attrs(show_port_gid_attr_ndev,
+							  attr.gid_tbl_len);
+	if (!p->gid_attr_group->ndev.attrs) {
+		ret = -ENOMEM;
+		goto err_remove_gid;
+	}
+
+	ret = sysfs_create_group(&p->gid_attr_group->kobj,
+				 &p->gid_attr_group->ndev);
+	if (ret)
+		goto err_free_gid_ndev;
+
+	p->gid_attr_group->type.name = "types";
+	p->gid_attr_group->type.attrs = alloc_group_attrs(show_port_gid_attr_gid_type,
+							  attr.gid_tbl_len);
+	if (!p->gid_attr_group->type.attrs) {
+		ret = -ENOMEM;
+		goto err_remove_gid_ndev;
+	}
+
+	ret = sysfs_create_group(&p->gid_attr_group->kobj,
+				 &p->gid_attr_group->type);
+	if (ret)
+		goto err_free_gid_type;
+
 	p->pkey_group.name  = "pkeys";
 	p->pkey_group.attrs = alloc_group_attrs(show_port_pkey,
 						attr.pkey_tbl_len);
 	if (!p->pkey_group.attrs) {
 		ret = -ENOMEM;
-		goto err_remove_gid;
+		goto err_remove_gid_type;
 	}
 
 	ret = sysfs_create_group(&p->kobj, &p->pkey_group);
@@ -593,6 +743,28 @@ err_free_pkey:
 	kfree(p->pkey_group.attrs);
 	p->pkey_group.attrs = NULL;
 
+err_remove_gid_type:
+	sysfs_remove_group(&p->gid_attr_group->kobj,
+			   &p->gid_attr_group->type);
+
+err_free_gid_type:
+	for (i = 0; i < attr.gid_tbl_len; ++i)
+		kfree(p->gid_attr_group->type.attrs[i]);
+
+	kfree(p->gid_attr_group->type.attrs);
+	p->gid_attr_group->type.attrs = NULL;
+
+err_remove_gid_ndev:
+	sysfs_remove_group(&p->gid_attr_group->kobj,
+			   &p->gid_attr_group->ndev);
+
+err_free_gid_ndev:
+	for (i = 0; i < attr.gid_tbl_len; ++i)
+		kfree(p->gid_attr_group->ndev.attrs[i]);
+
+	kfree(p->gid_attr_group->ndev.attrs);
+	p->gid_attr_group->ndev.attrs = NULL;
+
 err_remove_gid:
 	sysfs_remove_group(&p->kobj, &p->gid_group);
 
@@ -606,6 +778,9 @@ err_free_gid:
 err_remove_pma:
 	sysfs_remove_group(&p->kobj, &pma_group);
 
+err_put_gid_attrs:
+	kobject_put(&p->gid_attr_group->kobj);
+
 err_put:
 	kobject_put(&p->kobj);
 	return ret;
@@ -826,6 +1001,11 @@ static void free_port_list_attributes(struct ib_device *device)
 		sysfs_remove_group(p, &pma_group);
 		sysfs_remove_group(p, &port->pkey_group);
 		sysfs_remove_group(p, &port->gid_group);
+		sysfs_remove_group(&port->gid_attr_group->kobj,
+				   &port->gid_attr_group->ndev);
+		sysfs_remove_group(&port->gid_attr_group->kobj,
+				   &port->gid_attr_group->type);
+		kobject_put(&port->gid_attr_group->kobj);
 		kobject_put(p);
 	}
 
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2] IB/core: allow HCAs to create IB port sysfs files
Date: Tue, 17 Nov 2009 11:40:48 -0800
Message-ID: <1258486848.992.407.camel@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch adds a new function to sysfs.c so that HCAs can
create files in /sys/class/infiniband/<hca>/ports/<N>/.
There is no need for an unregister function since the kobject
reference will go to zero when ib_unregister_device() is called.

Signed-off-by: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---

Note that this patch replaces the earlier patch I sent
which exported struct ib_port.


 drivers/infiniband/core/sysfs.c |   19 +++++++++++++++++++
 include/rdma/ib_verbs.h         |    9 +++++++++
 2 files changed, 28 insertions(+), 0 deletions(-)


diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index 158a214..1be3c3f 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -857,3 +857,22 @@ void ib_sysfs_cleanup(void)
 {
 	class_unregister(&ib_class);
 }
+
+int ib_sysfs_create_port_files(struct ib_device *device,
+			       int (*create)(struct ib_device *dev, u8 port_num,
+					     struct kobject *kobj))
+{
+	struct kobject *p;
+	struct ib_port *port;
+	int ret = 0;
+
+	list_for_each_entry(p, &device->port_list, entry) {
+		port = container_of(p, struct ib_port, kobj);
+		ret = create(device, port->port_num, &port->kobj);
+		if (ret)
+			break;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL(ib_sysfs_create_port_files);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index c179318..a662486 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1186,6 +1186,15 @@ static inline int ib_copy_to_udata(struct ib_udata *udata, void *src, size_t len
 }
 
 /**
+ * ib_sysfs_create_port_files - iterate over port sysfs directories
+ * @device: the IB device
+ * @create: a function to create sysfs files in each port directory
+ */
+int ib_sysfs_create_port_files(struct ib_device *device,
+			       int (*create)(struct ib_device *dev, u8 port_num,
+					     struct kobject *kobj));
+
+/**
  * ib_modify_qp_is_ok - Check that the supplied attribute mask
  * contains all required attributes and no attributes not allowed for
  * the given QP state transition.



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

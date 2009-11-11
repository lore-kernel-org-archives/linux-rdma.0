From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] IB/core: export struct ib_port
Date: Wed, 11 Nov 2009 11:07:58 -0800
Message-ID: <1257966478.992.300.camel@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch moves the definition of struct ib_port from
sysfs.c to ib_verbs.h so that HCAs can create files in
/sys/class/infiniband/<hca>/ports/<N>/

Signed-off-by: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---

diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index 158a214..e01f3e7 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -39,14 +39,6 @@
 
 #include <rdma/ib_mad.h>
 
-struct ib_port {
-	struct kobject         kobj;
-	struct ib_device      *ibdev;
-	struct attribute_group gid_group;
-	struct attribute_group pkey_group;
-	u8                     port_num;
-};
-
 struct port_attribute {
 	struct attribute attr;
 	ssize_t (*show)(struct ib_port *, struct port_attribute *, char *buf);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index c179318..5d23957 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1154,6 +1154,14 @@ struct ib_device {
 	u8                           phys_port_cnt;
 };
 
+struct ib_port {
+	struct kobject         kobj;
+	struct ib_device      *ibdev;
+	struct attribute_group gid_group;
+	struct attribute_group pkey_group;
+	u8                     port_num;
+};
+
 struct ib_client {
 	char  *name;
 	void (*add)   (struct ib_device *);


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

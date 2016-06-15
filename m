From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH V1 01/13] IB/core: Add get FW version string to the core
Date: Wed, 15 Jun 2016 02:21:56 -0400
Message-ID: <1465971728-24104-2-git-send-email-ira.weiny@intel.com>
References: <1465971728-24104-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1465971728-24104-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org, faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Allow for a common core function to get firmware version strings
from the individual devices.

In later patches this format can then then be used to pass a
properly formated version string through the IPoIB layer.

The problem with the current code in the IPoIB layer is that it is
specific to certain hardware types.

Furthermore, this gives us a common function through which the core
can provide a common sysfs entry.  Eventually we may want to
remove the sysfs export but this provides for user space backwards
compatibility.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

---
Changes from V0:
	Add parameter names to function signature
	change default string assignment

 drivers/infiniband/core/device.c | 9 +++++++++
 include/rdma/ib_verbs.h          | 3 +++
 2 files changed, 12 insertions(+)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 5c155fa91eec..760ef603a468 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -311,6 +311,15 @@ static int read_port_immutable(struct ib_device *device)
 	return 0;
 }
 
+void ib_get_device_fw_str(struct ib_device *dev, char *str, size_t str_len)
+{
+	if (dev->get_dev_fw_str)
+		dev->get_dev_fw_str(dev, str, str_len);
+	else
+		str[0] = '\0';
+}
+EXPORT_SYMBOL(ib_get_device_fw_str);
+
 /**
  * ib_register_device - Register an IB device with IB core
  * @device:Device to register
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 7e440d41487a..1dc3d0d90202 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1956,6 +1956,7 @@ struct ib_device {
 	 * in fast paths.
 	 */
 	int (*get_port_immutable)(struct ib_device *, u8, struct ib_port_immutable *);
+	void (*get_dev_fw_str)(struct ib_device *, char *str, size_t str_len);
 };
 
 struct ib_client {
@@ -1991,6 +1992,8 @@ struct ib_client {
 struct ib_device *ib_alloc_device(size_t size);
 void ib_dealloc_device(struct ib_device *device);
 
+void ib_get_device_fw_str(struct ib_device *device, char *str, size_t str_len);
+
 int ib_register_device(struct ib_device *device,
 		       int (*port_callback)(struct ib_device *,
 					    u8, struct kobject *));
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

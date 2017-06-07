From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 10/13] IB/core: Add legacy driver's user-data
Date: Wed,  7 Jun 2017 15:22:49 +0300
Message-ID: <1496838172-39671-11-git-send-email-matanb@mellanox.com>
References: <1496838172-39671-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1496838172-39671-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In this phase, we don't want to change all the drivers to use
flexible driver's specific attributes. Therefore, we add two default
attributes: UHW_IN and UHW_OUT. These attributes are optional in some
commands and they encode the driver specific command data. We add
a function that extract this data and creates the legacy udata over
it.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/rdma_core.c        |  1 +
 drivers/infiniband/core/uverbs_std_types.c | 39 ++++++++++++++++++++++++++++++
 include/rdma/uverbs_ioctl.h                |  3 ---
 include/uapi/rdma/ib_user_ioctl_verbs.h    | 10 ++++++++
 4 files changed, 50 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/rdma_core.c b/drivers/infiniband/core/rdma_core.c
index de30016..f684f2f 100644
--- a/drivers/infiniband/core/rdma_core.c
+++ b/drivers/infiniband/core/rdma_core.c
@@ -36,6 +36,7 @@
 #include <rdma/uverbs_types.h>
 #include <linux/rcupdate.h>
 #include <rdma/uverbs_ioctl.h>
+#include <rdma/ib_user_ioctl_verbs.h>
 #include "uverbs.h"
 #include "core_priv.h"
 #include "rdma_core.h"
diff --git a/drivers/infiniband/core/uverbs_std_types.c b/drivers/infiniband/core/uverbs_std_types.c
index 4c97be8..caf82a0 100644
--- a/drivers/infiniband/core/uverbs_std_types.c
+++ b/drivers/infiniband/core/uverbs_std_types.c
@@ -209,6 +209,45 @@ static int uverbs_hot_unplug_completion_event_file(struct ib_uobject_file *uobj_
 	return 0;
 };
 
+/*
+ * This spec is used in order to pass information to the hardware driver in a
+ * legacy way. Every verb that could get driver specific data should get this
+ * spec.
+ */
+static DECLARE_UVERBS_ATTR_SPEC(
+	uverbs_uhw_compat_spec,
+	UVERBS_ATTR_PTR_IN_SZ(UVERBS_UHW_IN, 0, UA_FLAGS(UVERBS_ATTR_SPEC_F_MIN_SZ)),
+	UVERBS_ATTR_PTR_OUT_SZ(UVERBS_UHW_OUT, 0, UA_FLAGS(UVERBS_ATTR_SPEC_F_MIN_SZ)));
+
+static void create_udata(struct uverbs_attr_array *ctx, size_t num,
+			 struct ib_udata *udata)
+{
+	/*
+	 * This is for ease of conversion. The purpose is to convert all drivers
+	 * to use uverbs_attr_array instead of ib_udata.
+	 * Assume attr == 0 is input and attr == 1 is output.
+	 */
+	void __user *inbuf;
+	size_t inbuf_len = 0;
+	void __user *outbuf;
+	size_t outbuf_len = 0;
+
+	if (num > UVERBS_UDATA_DRIVER_DATA_GROUP) {
+		struct uverbs_attr_array *driver = &ctx[UVERBS_UDATA_DRIVER_DATA_GROUP];
+
+		if (uverbs_is_valid(driver, UVERBS_UHW_IN)) {
+			inbuf = driver->attrs[UVERBS_UHW_IN].ptr_attr.ptr;
+			inbuf_len = driver->attrs[UVERBS_UHW_IN].ptr_attr.len;
+		}
+
+		if (driver->num_attrs >= UVERBS_UHW_OUT &&
+		    uverbs_is_valid(driver, UVERBS_UHW_OUT)) {
+			outbuf = driver->attrs[UVERBS_UHW_OUT].ptr_attr.ptr;
+			outbuf_len = driver->attrs[UVERBS_UHW_OUT].ptr_attr.len;
+		}
+	}
+	INIT_UDATA_BUF_OR_NULL(udata, inbuf, outbuf, inbuf_len, outbuf_len);
+}
 DECLARE_UVERBS_TYPE(uverbs_type_comp_channel,
 		    &UVERBS_TYPE_ALLOC_FD(0,
 					  sizeof(struct ib_uverbs_completion_event_file),
diff --git a/include/rdma/uverbs_ioctl.h b/include/rdma/uverbs_ioctl.h
index 4a03659..c7b3439 100644
--- a/include/rdma/uverbs_ioctl.h
+++ b/include/rdma/uverbs_ioctl.h
@@ -46,9 +46,6 @@
  * =======================================
  */
 
-#define UVERBS_ID_GROUP_MASK 0xF000
-#define UVERBS_ID_GROUP_SHIFT 12
-
 enum uverbs_attr_type {
 	UVERBS_ATTR_TYPE_NA,
 	UVERBS_ATTR_TYPE_PTR_IN,
diff --git a/include/uapi/rdma/ib_user_ioctl_verbs.h b/include/uapi/rdma/ib_user_ioctl_verbs.h
index 9db94d0..4165738 100644
--- a/include/uapi/rdma/ib_user_ioctl_verbs.h
+++ b/include/uapi/rdma/ib_user_ioctl_verbs.h
@@ -33,6 +33,11 @@
 #ifndef IB_USER_IOCTL_VERBS_H
 #define IB_USER_IOCTL_VERBS_H
 
+#define UVERBS_ID_GROUP_MASK 0xF000
+#define UVERBS_ID_GROUP_SHIFT 12
+#define UVERBS_UDATA_DRIVER_DATA_GROUP	1
+#define UVERBS_UDATA_DRIVER_DATA_FLAG	(1UL << UVERBS_ID_GROUP_SHIFT)
+
 enum uverbs_common_types {
 	UVERBS_TYPE_DEVICE, /* No instances of DEVICE are allowed */
 	UVERBS_TYPE_PD,
@@ -50,5 +55,10 @@ enum uverbs_common_types {
 	UVERBS_TYPE_LAST,
 };
 
+enum {
+	UVERBS_UHW_IN,
+	UVERBS_UHW_OUT,
+};
+
 #endif
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

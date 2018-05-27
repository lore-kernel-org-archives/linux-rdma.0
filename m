From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next v1 06/13] IB/uverbs: Add read counters support
Date: Sun, 27 May 2018 13:23:39 +0300
Message-ID: <20180527102346.15149-7-leon@kernel.org>
References: <20180527102346.15149-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180527102346.15149-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Boris Pismenny <borisp@mellanox.com>, Matan Barak <matanb@mellanox.com>, Raed Salem <raeds@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Raed Salem <raeds@mellanox.com>

This patch exposes the read counters verb to user space
applications.
By that verb the user can read the hardware counters which
are associated with the counters object.

The application needs to provide a sufficient memory to
hold the statistics.

Reviewed-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Raed Salem <raeds@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 .../infiniband/core/uverbs_std_types_counters.c    | 59 +++++++++++++++++++++-
 include/uapi/rdma/ib_user_ioctl_cmds.h             |  7 +++
 2 files changed, 65 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/uverbs_std_types_counters.c b/drivers/infiniband/core/uverbs_std_types_counters.c
index a5bc50ceee13..b35fcd3718c8 100644
--- a/drivers/infiniband/core/uverbs_std_types_counters.c
+++ b/drivers/infiniband/core/uverbs_std_types_counters.c
@@ -80,6 +80,49 @@ static int UVERBS_HANDLER(UVERBS_METHOD_COUNTERS_CREATE)(struct ib_device *ib_de
 	return ret;
 }
 
+static int UVERBS_HANDLER(UVERBS_METHOD_COUNTERS_READ)(struct ib_device *ib_dev,
+						       struct ib_uverbs_file *file,
+						       struct uverbs_attr_bundle *attrs)
+{
+	struct ib_counters_read_attr read_attr = {};
+	const struct uverbs_attr *uattr;
+	struct ib_counters *counters =
+		uverbs_attr_get_obj(attrs, UVERBS_ATTR_READ_COUNTERS_HANDLE);
+	int ret;
+
+	if (!ib_dev->read_counters)
+		return -EOPNOTSUPP;
+
+	if (!atomic_read(&counters->usecnt))
+		return -EINVAL;
+
+	ret = uverbs_copy_from(&read_attr.flags, attrs,
+			       UVERBS_ATTR_READ_COUNTERS_FLAGS);
+	if (ret)
+		return ret;
+
+	uattr = uverbs_attr_get(attrs, UVERBS_ATTR_READ_COUNTERS_BUFF);
+	read_attr.ncounters = uattr->ptr_attr.len / sizeof(u64);
+	read_attr.counters_buff = kcalloc(read_attr.ncounters,
+					  sizeof(u64), GFP_KERNEL);
+	if (!read_attr.counters_buff)
+		return -ENOMEM;
+
+	ret = ib_dev->read_counters(counters,
+				    &read_attr,
+				    attrs);
+	if (ret)
+		goto err_read;
+
+	ret = uverbs_copy_to(attrs, UVERBS_ATTR_READ_COUNTERS_BUFF,
+			     read_attr.counters_buff,
+			     read_attr.ncounters * sizeof(u64));
+
+err_read:
+	kfree(read_attr.counters_buff);
+	return ret;
+}
+
 static DECLARE_UVERBS_NAMED_METHOD(UVERBS_METHOD_COUNTERS_CREATE,
 	&UVERBS_ATTR_IDR(UVERBS_ATTR_CREATE_COUNTERS_HANDLE,
 			 UVERBS_OBJECT_COUNTERS,
@@ -93,8 +136,22 @@ static DECLARE_UVERBS_NAMED_METHOD_WITH_HANDLER(UVERBS_METHOD_COUNTERS_DESTROY,
 			 UVERBS_ACCESS_DESTROY,
 			 UA_FLAGS(UVERBS_ATTR_SPEC_F_MANDATORY)));
 
+#define MAX_COUNTERS_BUFF_SIZE USHRT_MAX
+static DECLARE_UVERBS_NAMED_METHOD(UVERBS_METHOD_COUNTERS_READ,
+	&UVERBS_ATTR_IDR(UVERBS_ATTR_READ_COUNTERS_HANDLE,
+			 UVERBS_OBJECT_COUNTERS,
+			 UVERBS_ACCESS_READ,
+			 UA_FLAGS(UVERBS_ATTR_SPEC_F_MANDATORY)),
+	&UVERBS_ATTR_PTR_OUT(UVERBS_ATTR_READ_COUNTERS_BUFF,
+			     UVERBS_ATTR_SIZE(0, MAX_COUNTERS_BUFF_SIZE),
+			     UA_FLAGS(UVERBS_ATTR_SPEC_F_MANDATORY)),
+	&UVERBS_ATTR_PTR_IN(UVERBS_ATTR_READ_COUNTERS_FLAGS,
+			    UVERBS_ATTR_TYPE(__u32),
+			    UA_FLAGS(UVERBS_ATTR_SPEC_F_MANDATORY)));
+
 DECLARE_UVERBS_NAMED_OBJECT(UVERBS_OBJECT_COUNTERS,
 			    &UVERBS_TYPE_ALLOC_IDR(0, uverbs_free_counters),
 			    &UVERBS_METHOD(UVERBS_METHOD_COUNTERS_CREATE),
-			    &UVERBS_METHOD(UVERBS_METHOD_COUNTERS_DESTROY));
+			    &UVERBS_METHOD(UVERBS_METHOD_COUNTERS_DESTROY),
+			    &UVERBS_METHOD(UVERBS_METHOD_COUNTERS_READ));
 
diff --git a/include/uapi/rdma/ib_user_ioctl_cmds.h b/include/uapi/rdma/ib_user_ioctl_cmds.h
index c28ce62d2e40..888ac5975a6c 100644
--- a/include/uapi/rdma/ib_user_ioctl_cmds.h
+++ b/include/uapi/rdma/ib_user_ioctl_cmds.h
@@ -140,9 +140,16 @@ enum uverbs_attrs_destroy_counters_cmd_attr_ids {
 	UVERBS_ATTR_DESTROY_COUNTERS_HANDLE,
 };
 
+enum uverbs_attrs_read_counters_cmd_attr_ids {
+	UVERBS_ATTR_READ_COUNTERS_HANDLE,
+	UVERBS_ATTR_READ_COUNTERS_BUFF,
+	UVERBS_ATTR_READ_COUNTERS_FLAGS,
+};
+
 enum uverbs_methods_actions_counters_ops {
 	UVERBS_METHOD_COUNTERS_CREATE,
 	UVERBS_METHOD_COUNTERS_DESTROY,
+	UVERBS_METHOD_COUNTERS_READ,
 };
 
 #endif
-- 
2.14.3

From: Dan Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC PATCH v3 12/12] ib/core: Implement the Infiniband flush callback.
Date: Tue, 19 Apr 2016 22:51:29 +0300
Message-ID: <1461095489-18732-13-git-send-email-danielj@mellanox.com>
References: <1461095489-18732-1-git-send-email-danielj@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1461095489-18732-1-git-send-email-danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Register the callback at init and unregister it at cleanup.

When called walk the device list and call ib_security_cache_change for
each port on each device.

Signed-off-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

---
v2: Added patch to series.

v3:
1. Removed unrelated formatting changes in core_priv.h and security.c.
---
 drivers/infiniband/core/device.c |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index f39a2a1..3647098 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -335,6 +335,29 @@ static int setup_port_pkey_list(struct ib_device *device)
 	return 0;
 }
 
+static void ib_security_flush(void)
+{
+	struct ib_device *dev;
+
+	down_read(&lists_rwsem);
+	list_for_each_entry(dev, &device_list, core_list) {
+		int i;
+
+		for (i = rdma_start_port(dev); i <= rdma_end_port(dev); i++) {
+			u64 sp;
+			int ret = ib_get_cached_subnet_prefix(dev,
+							      i,
+							      &sp);
+
+			WARN_ONCE(ret,
+				  "ib_get_cached_subnet_prefix err: %d, this should never happen here\n",
+				  ret);
+			ib_security_cache_change(dev, i, sp);
+		}
+	}
+	up_read(&lists_rwsem);
+}
+
 /**
  * ib_register_device - Register an IB device with IB core
  * @device:Device to register
@@ -1016,6 +1039,8 @@ static int __init ib_core_init(void)
 		goto err_sysfs;
 	}
 
+	security_register_ib_flush_callback(&ib_security_flush);
+
 	ib_cache_setup();
 
 	return 0;
@@ -1031,6 +1056,7 @@ err:
 
 static void __exit ib_core_cleanup(void)
 {
+	security_unregister_ib_flush_callback();
 	ib_cache_cleanup();
 	ibnl_cleanup();
 	class_unregister(&ib_class);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

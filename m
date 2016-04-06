From: Dan Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC PATCH v2 13/13] ib/core: Implement the Infiniband flush callback.
Date: Thu,  7 Apr 2016 02:33:58 +0300
Message-ID: <1459985638-37233-14-git-send-email-danielj@mellanox.com>
References: <1459985638-37233-1-git-send-email-danielj@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1459985638-37233-1-git-send-email-danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
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
---
 drivers/infiniband/core/core_priv.h     |    3 ++-
 drivers/infiniband/core/core_security.c |    4 +---
 drivers/infiniband/core/device.c        |   26 ++++++++++++++++++++++++++
 3 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/core/core_priv.h
index 216c288..271d1e0 100644
--- a/drivers/infiniband/core/core_priv.h
+++ b/drivers/infiniband/core/core_priv.h
@@ -230,5 +230,6 @@ static inline int ib_security_open_shared_qp(struct ib_qp *qp,
 static inline void ib_security_close_shared_qp(struct ib_qp_security *sec)
 {
 }
-#endif
+
+#endif /* CONFIG_SECURITY_INFINIBAND */
 #endif /* _CORE_PRIV_H */
diff --git a/drivers/infiniband/core/core_security.c b/drivers/infiniband/core/core_security.c
index ebc66c1..1426731 100644
--- a/drivers/infiniband/core/core_security.c
+++ b/drivers/infiniband/core/core_security.c
@@ -581,7 +581,6 @@ void ib_security_cache_change(struct ib_device *device,
 			      u64 subnet_prefix)
 {
 	struct pkey_index_qp_list *pkey;
-
 	list_for_each_entry(pkey,
 			    &device->port_pkey_list[port_num].pkey_list,
 			    pkey_index_list) {
@@ -665,5 +664,4 @@ int ib_security_enforce_mad_agent_pkey_access(struct ib_device *dev,
 	return security_mad_agent_pkey_access(subnet_prefix, pkey, mad_agent);
 }
 EXPORT_SYMBOL(ib_security_enforce_mad_agent_pkey_access);
-
-#endif /* CONFIG_SECURITY_INFINIBAND */
+#endif
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

From: Dan Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v2 3/9] selinux lsm IB/core: Implement LSM notification system
Date: Fri, 15 Jul 2016 01:56:45 +0300
Message-ID: <1468537011-20407-4-git-send-email-danielj@mellanox.com>
References: <1468537011-20407-1-git-send-email-danielj@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1468537011-20407-1-git-send-email-danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: chrisw-69jw2NvuJkxg9hUCZPvPmw@public.gmane.org, paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org, sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add a generic notificaiton mechanism in the LSM. Interested consumers
can register a callback with the LSM and security modules can produce
events.

Because access to Infiniband QPs are enforced in the setup phase of a
connection security should be enforced again if the policy changes.
Register infiniband devices for policy change notification and check all
QPs on that device when the notification is received.

Add a call to the notification mechanism is from SELinux when the AVC
cache changes.

Signed-off-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

---
v2:
- new patch that has the generic notification, replaces selinux and
  IB/core patches related to the ib_flush callback. Yuval Shaia and Paul
  Moore
---
 drivers/infiniband/core/device.c |   46 ++++++++++++++++++++++++++++++
 include/linux/security.h         |   10 ++++++
 security/security.c              |   58 ++++++++++++++++++++++++++++++++++++++
 security/selinux/hooks.c         |    5 ++-
 security/selinux/selinuxfs.c     |    2 +
 5 files changed, 119 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 5b42e83..3219a7a 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -39,6 +39,7 @@
 #include <linux/init.h>
 #include <linux/mutex.h>
 #include <linux/netdevice.h>
+#include <linux/security.h>
 #include <rdma/rdma_netlink.h>
 #include <rdma/ib_addr.h>
 #include <rdma/ib_cache.h>
@@ -82,6 +83,10 @@ static LIST_HEAD(client_list);
 static DEFINE_MUTEX(device_mutex);
 static DECLARE_RWSEM(lists_rwsem);
 
+static void ib_policy_change_task(struct work_struct *work);
+static DECLARE_WORK(ib_policy_change_work, ib_policy_change_task);
+
+static u32 lsm_callback_id;
 
 static int ib_device_check_mandatory(struct ib_device *device)
 {
@@ -344,6 +349,37 @@ static int setup_port_pkey_list(struct ib_device *device)
 	return 0;
 }
 
+static void ib_policy_change_task(struct work_struct *work)
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
+static void ib_security_change(enum lsm_event event, void *ctx, void *lsm_data)
+{
+	if (event != LSM_POLICY_CHANGE)
+		return;
+
+	schedule_work(&ib_policy_change_work);
+}
+
 /**
  * ib_register_device - Register an IB device with IB core
  * @device:Device to register
@@ -1075,10 +1111,19 @@ static int __init ib_core_init(void)
 		goto err_sa;
 	}
 
+	ret = security_register_lsm_notifier(&ib_security_change, NULL,
+					     &lsm_callback_id);
+	if (ret) {
+		pr_warn("Couldn't register LSM notifier. ret %d\n", ret);
+		goto err_ibnl_clients;
+	}
+
 	ib_cache_setup();
 
 	return 0;
 
+err_ibnl_clients:
+	ib_remove_ibnl_clients();
 err_sa:
 	ib_sa_cleanup();
 err_mad:
@@ -1098,6 +1143,7 @@ err:
 
 static void __exit ib_core_cleanup(void)
 {
+	security_unregister_lsm_notifier(lsm_callback_id);
 	ib_cache_cleanup();
 	ib_remove_ibnl_clients();
 	ib_sa_cleanup();
diff --git a/include/linux/security.h b/include/linux/security.h
index 33e23c4..bf53911 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -69,6 +69,16 @@ struct audit_krule;
 struct user_namespace;
 struct timezone;
 
+enum lsm_event {
+	LSM_POLICY_CHANGE,
+};
+
+typedef void (*lsm_notifier)(enum lsm_event event, void *ctx, void *data);
+
+void security_lsm_notify(enum lsm_event event, void *data);
+int security_register_lsm_notifier(lsm_notifier func, void *ctx, u32 *id);
+void security_unregister_lsm_notifier(u32 id);
+
 /* These functions are in security/commoncap.c */
 extern int cap_capable(const struct cred *cred, struct user_namespace *ns,
 		       int cap, int audit);
diff --git a/security/security.c b/security/security.c
index 234982d..1263c1d 100644
--- a/security/security.c
+++ b/security/security.c
@@ -33,6 +33,18 @@
 /* Maximum number of letters for an LSM name string */
 #define SECURITY_NAME_MAX	10
 
+struct lsm_notifier_entry {
+	u32			callback_id;
+	lsm_notifier		func;
+	void			*ctx;
+	struct list_head	list;
+	struct rcu_head		rcu;
+};
+
+static LIST_HEAD(lsm_notifier_list);
+static DEFINE_SPINLOCK(lsm_notifier_lock);
+static u32 next_callback_id;
+
 /* Boot-time LSM user choice */
 static __initdata char chosen_lsm[SECURITY_NAME_MAX + 1] =
 	CONFIG_DEFAULT_SECURITY;
@@ -98,6 +110,52 @@ int __init security_module_enable(const char *module)
 	return !strcmp(module, chosen_lsm);
 }
 
+void security_lsm_notify(enum lsm_event event, void *data)
+{
+	struct lsm_notifier_entry *entry;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(entry, &lsm_notifier_list, list)
+		entry->func(event, entry->ctx, data);
+	rcu_read_unlock();
+}
+EXPORT_SYMBOL(security_lsm_notify);
+
+int security_register_lsm_notifier(lsm_notifier func, void *ctx, u32 *id)
+{
+	struct lsm_notifier_entry *entry;
+
+	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
+	if (!entry)
+		return -ENOMEM;
+
+	entry->func = func;
+	entry->ctx = ctx;
+
+	spin_lock(&lsm_notifier_lock);
+	entry->callback_id = next_callback_id++;
+	*id = entry->callback_id;
+	list_add_rcu(&entry->list, &lsm_notifier_list);
+	spin_unlock(&lsm_notifier_lock);
+
+	return 0;
+}
+EXPORT_SYMBOL(security_register_lsm_notifier);
+
+void security_unregister_lsm_notifier(u32 id)
+{
+	struct lsm_notifier_entry *entry;
+
+	list_for_each_entry_rcu(entry, &lsm_notifier_list, list) {
+		if (entry->callback_id == id) {
+			list_del_rcu(&entry->list);
+			kfree_rcu(entry, rcu);
+			break;
+		}
+	}
+}
+EXPORT_SYMBOL(security_unregister_lsm_notifier);
+
 /*
  * Hook list operation macros.
  *
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index a86d537..a363202 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -159,13 +159,14 @@ static int selinux_peerlbl_enabled(void)
 	return (selinux_policycap_alwaysnetwork || netlbl_enabled() || selinux_xfrm_enabled());
 }
 
-static int selinux_netcache_avc_callback(u32 event)
+static int selinux_cache_avc_callback(u32 event)
 {
 	if (event == AVC_CALLBACK_RESET) {
 		sel_netif_flush();
 		sel_netnode_flush();
 		sel_netport_flush();
 		synchronize_net();
+		security_lsm_notify(LSM_POLICY_CHANGE, NULL);
 	}
 	return 0;
 }
@@ -6235,7 +6236,7 @@ static __init int selinux_init(void)
 
 	security_add_hooks(selinux_hooks, ARRAY_SIZE(selinux_hooks));
 
-	if (avc_add_callback(selinux_netcache_avc_callback, AVC_CALLBACK_RESET))
+	if (avc_add_callback(selinux_cache_avc_callback, AVC_CALLBACK_RESET))
 		panic("SELinux: Unable to register AVC netcache callback\n");
 
 	if (selinux_enforcing)
diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index 1b1fd27..adc09e7 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -177,6 +177,8 @@ static ssize_t sel_write_enforce(struct file *file, const char __user *buf,
 			avc_ss_reset(0);
 		selnl_notify_setenforce(selinux_enforcing);
 		selinux_status_update_setenforce(selinux_enforcing);
+		if (!selinux_enforcing)
+			security_lsm_notify(LSM_POLICY_CHANGE, NULL);
 	}
 	length = count;
 out:
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

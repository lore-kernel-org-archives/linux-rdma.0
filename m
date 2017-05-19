From: Dan Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v7 3/9] selinux lsm IB/core: Implement LSM notification system
Date: Fri, 19 May 2017 15:48:53 +0300
Message-ID: <1495198139-69993-4-git-send-email-danielj@mellanox.com>
References: <1495198139-69993-1-git-send-email-danielj@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1495198139-69993-1-git-send-email-danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
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

Add a call to the notification mechanism from SELinux when the AVC
cache changes or setenforce is cleared.

Signed-off-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

---
v2:
- new patch that has the generic notification, replaces selinux and
  IB/core patches related to the ib_flush callback. Yuval Shaia and Paul
  Moore

v3:
- use notifier chains. Paul Moore

v4:
- Seperate avc callback for LSM notifier. Paul Moore

v5:
- Fix link error when CONFIG_SECURITY is not set. Build Robot

 drivers/infiniband/core/device.c | 53 ++++++++++++++++++++++++++++++++++++++++
 include/linux/security.h         | 23 +++++++++++++++++
 security/security.c              | 20 +++++++++++++++
 security/selinux/hooks.c         | 11 +++++++++
 security/selinux/selinuxfs.c     |  2 ++
 5 files changed, 109 insertions(+)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 92e0b89..63ebaab 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -39,6 +39,8 @@
 #include <linux/init.h>
 #include <linux/mutex.h>
 #include <linux/netdevice.h>
+#include <linux/security.h>
+#include <linux/notifier.h>
 #include <rdma/rdma_netlink.h>
 #include <rdma/ib_addr.h>
 #include <rdma/ib_cache.h>
@@ -82,6 +84,14 @@ static LIST_HEAD(client_list);
 static DEFINE_MUTEX(device_mutex);
 static DECLARE_RWSEM(lists_rwsem);
 
+static int ib_security_change(struct notifier_block *nb, unsigned long event,
+			      void *lsm_data);
+static void ib_policy_change_task(struct work_struct *work);
+static DECLARE_WORK(ib_policy_change_work, ib_policy_change_task);
+
+static struct notifier_block ibdev_lsm_nb = {
+	.notifier_call = ib_security_change,
+};
 
 static int ib_device_check_mandatory(struct ib_device *device)
 {
@@ -341,6 +351,40 @@ static int setup_port_pkey_list(struct ib_device *device)
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
+static int ib_security_change(struct notifier_block *nb, unsigned long event,
+			      void *lsm_data)
+{
+	if (event != LSM_POLICY_CHANGE)
+		return NOTIFY_DONE;
+
+	schedule_work(&ib_policy_change_work);
+
+	return NOTIFY_OK;
+}
+
 /**
  * ib_register_device - Register an IB device with IB core
  * @device:Device to register
@@ -1104,10 +1148,18 @@ static int __init ib_core_init(void)
 		goto err_sa;
 	}
 
+	ret = register_lsm_notifier(&ibdev_lsm_nb);
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
@@ -1127,6 +1179,7 @@ static int __init ib_core_init(void)
 
 static void __exit ib_core_cleanup(void)
 {
+	unregister_lsm_notifier(&ibdev_lsm_nb);
 	ib_cache_cleanup();
 	ib_remove_ibnl_clients();
 	ib_sa_cleanup();
diff --git a/include/linux/security.h b/include/linux/security.h
index 8c73ee0..f96e333 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -69,6 +69,10 @@ struct audit_krule;
 struct user_namespace;
 struct timezone;
 
+enum lsm_event {
+	LSM_POLICY_CHANGE,
+};
+
 /* These functions are in security/commoncap.c */
 extern int cap_capable(const struct cred *cred, struct user_namespace *ns,
 		       int cap, int audit);
@@ -164,6 +168,10 @@ struct security_mnt_opts {
 	int num_mnt_opts;
 };
 
+int call_lsm_notifier(enum lsm_event event, void *data);
+int register_lsm_notifier(struct notifier_block *nb);
+int unregister_lsm_notifier(struct notifier_block *nb);
+
 static inline void security_init_mnt_opts(struct security_mnt_opts *opts)
 {
 	opts->mnt_opts = NULL;
@@ -382,6 +390,21 @@ int security_inode_getsecctx(struct inode *inode, void **ctx, u32 *ctxlen);
 struct security_mnt_opts {
 };
 
+static inline int call_lsm_notifier(enum lsm_event event, void *data)
+{
+	return 0;
+}
+
+static inline int register_lsm_notifier(struct notifier_block *nb)
+{
+	return 0;
+}
+
+static inline  int unregister_lsm_notifier(struct notifier_block *nb)
+{
+	return 0;
+}
+
 static inline void security_init_mnt_opts(struct security_mnt_opts *opts)
 {
 }
diff --git a/security/security.c b/security/security.c
index a142a0b..6eef315 100644
--- a/security/security.c
+++ b/security/security.c
@@ -35,6 +35,8 @@
 #define SECURITY_NAME_MAX	10
 
 struct security_hook_heads security_hook_heads __lsm_ro_after_init;
+static ATOMIC_NOTIFIER_HEAD(lsm_notifier_chain);
+
 char *lsm_names;
 /* Boot-time LSM user choice */
 static __initdata char chosen_lsm[SECURITY_NAME_MAX + 1] =
@@ -162,6 +164,24 @@ void __init security_add_hooks(struct security_hook_list *hooks, int count,
 		panic("%s - Cannot get early memory.\n", __func__);
 }
 
+int call_lsm_notifier(enum lsm_event event, void *data)
+{
+	return atomic_notifier_call_chain(&lsm_notifier_chain, event, data);
+}
+EXPORT_SYMBOL(call_lsm_notifier);
+
+int register_lsm_notifier(struct notifier_block *nb)
+{
+	return atomic_notifier_chain_register(&lsm_notifier_chain, nb);
+}
+EXPORT_SYMBOL(register_lsm_notifier);
+
+int unregister_lsm_notifier(struct notifier_block *nb)
+{
+	return atomic_notifier_chain_unregister(&lsm_notifier_chain, nb);
+}
+EXPORT_SYMBOL(unregister_lsm_notifier);
+
 /*
  * Hook list operation macros.
  *
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index e298000..bc77c56 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -171,6 +171,14 @@ static int selinux_netcache_avc_callback(u32 event)
 	return 0;
 }
 
+static int selinux_lsm_notifier_avc_callback(u32 event)
+{
+	if (event == AVC_CALLBACK_RESET)
+		call_lsm_notifier(LSM_POLICY_CHANGE, NULL);
+
+	return 0;
+}
+
 /*
  * initialise the security for the init task
  */
@@ -6399,6 +6407,9 @@ static __init int selinux_init(void)
 	if (avc_add_callback(selinux_netcache_avc_callback, AVC_CALLBACK_RESET))
 		panic("SELinux: Unable to register AVC netcache callback\n");
 
+	if (avc_add_callback(selinux_lsm_notifier_avc_callback, AVC_CALLBACK_RESET))
+		panic("SELinux: Unable to register AVC LSM notifier callback\n");
+
 	if (selinux_enforcing)
 		printk(KERN_DEBUG "SELinux:  Starting in enforcing mode\n");
 	else
diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index ce71718..c8467dd 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -163,6 +163,8 @@ static ssize_t sel_write_enforce(struct file *file, const char __user *buf,
 			avc_ss_reset(0);
 		selnl_notify_setenforce(selinux_enforcing);
 		selinux_status_update_setenforce(selinux_enforcing);
+		if (!selinux_enforcing)
+			call_lsm_notifier(LSM_POLICY_CHANGE, NULL);
 	}
 	length = count;
 out:
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

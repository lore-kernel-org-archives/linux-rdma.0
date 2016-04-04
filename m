From: Dan Jurgens <danielj@mellanox.com>
Subject: [RFC PATCH 6/7] selinux: Implement IB Device SMI access vector
Date: Tue,  5 Apr 2016 00:48:23 +0300
Message-ID: <1459806504-16135-7-git-send-email-danielj@mellanox.com>
References: <1459806504-16135-1-git-send-email-danielj@mellanox.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1459806504-16135-1-git-send-email-danielj@mellanox.com>
Sender: owner-linux-security-module@vger.kernel.org
To: selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org
Cc: linux-rdma@vger.kernel.org, yevgenyp@mellanox.com, Daniel Jurgens <danielj@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Daniel Jurgens <danielj@mellanox.com>

Add a type and access vector for infiniband devices and their subnet
management interface. Implement the ibdev_smi hook to check that the
caller has permission to access the SMI specified by the device name and
port.  Add interface to query the SID for a IB device, which walks the
IBDEV ocontexts to find an entry for the given name and port.

Signed-off-by: Daniel Jurgens <danielj@mellanox.com>
Reviewed-by: Eli Cohen <eli@mellanox.com>
---
 include/linux/lsm_audit.h                        |    8 ++++
 security/selinux/hooks.c                         |   26 +++++++++++++
 security/selinux/include/classmap.h              |    2 +
 security/selinux/include/initial_sid_to_string.h |    1 +
 security/selinux/include/security.h              |    2 +
 security/selinux/ss/services.c                   |   43 ++++++++++++++++++++++
 6 files changed, 82 insertions(+), 0 deletions(-)

diff --git a/include/linux/lsm_audit.h b/include/linux/lsm_audit.h
index 8ff7eae..9177ed3 100644
--- a/include/linux/lsm_audit.h
+++ b/include/linux/lsm_audit.h
@@ -21,6 +21,7 @@
 #include <linux/path.h>
 #include <linux/key.h>
 #include <linux/skbuff.h>
+#include <rdma/ib_verbs.h>
 
 struct lsm_network_audit {
 	int netif;
@@ -50,6 +51,11 @@ struct lsm_pkey_audit {
 	u16	pkey;
 };
 
+struct lsm_ibdev_audit {
+	char	dev_name[IB_DEVICE_NAME_MAX];
+	u8	port;
+};
+
 /* Auxiliary data to use in generating the audit record. */
 struct common_audit_data {
 	char type;
@@ -65,6 +71,7 @@ struct common_audit_data {
 #define LSM_AUDIT_DATA_DENTRY	10
 #define LSM_AUDIT_DATA_IOCTL_OP	11
 #define LSM_AUDIT_DATA_PKEY	12
+#define LSM_AUDIT_DATA_IBDEV	13
 	union 	{
 		struct path path;
 		struct dentry *dentry;
@@ -82,6 +89,7 @@ struct common_audit_data {
 		char *kmod_name;
 		struct lsm_ioctlop_audit *op;
 		struct lsm_pkey_audit *pkey;
+		struct lsm_ibdev_audit *ibdev;
 	} u;
 	/* this union contains LSM specific data */
 	union {
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 829746b..22cdafc 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -5961,6 +5961,31 @@ out:
 	return err;
 }
 
+static int selinux_ibdev_smi(const char *dev_name, u8 port, void *security)
+{
+	struct common_audit_data ad;
+	int err;
+	u32 sid = 0;
+	struct infiniband_security_struct *sec = security;
+	struct lsm_ibdev_audit ibdev;
+
+	err = security_ibdev_sid(dev_name, port, &sid);
+
+	if (err)
+		goto out;
+
+	ad.type = LSM_AUDIT_DATA_IBDEV;
+	strncpy(ibdev.dev_name, dev_name, sizeof(ibdev.dev_name));
+	ibdev.port = port;
+	ad.u.ibdev = &ibdev;
+	err = avc_has_perm(sec->sid, sid,
+			   SECCLASS_INFINIBAND_DEVICE,
+			   INFINIBAND_DEVICE__SMI, &ad);
+
+out:
+	return err;
+}
+
 static int selinux_infiniband_alloc_security(void **security)
 {
 	struct infiniband_security_struct *sec;
@@ -6163,6 +6188,7 @@ static struct security_hook_list selinux_hooks[] = {
 
 #ifdef CONFIG_SECURITY_INFINIBAND
 	LSM_HOOK_INIT(pkey_access, selinux_pkey_access),
+	LSM_HOOK_INIT(ibdev_smi, selinux_ibdev_smi),
 	LSM_HOOK_INIT(infiniband_alloc_security,
 		      selinux_infiniband_alloc_security),
 	LSM_HOOK_INIT(infiniband_free_security,
diff --git a/security/selinux/include/classmap.h b/security/selinux/include/classmap.h
index 46eb7a1..86459d4 100644
--- a/security/selinux/include/classmap.h
+++ b/security/selinux/include/classmap.h
@@ -159,5 +159,7 @@ struct security_class_mapping secclass_map[] = {
 		      NULL } },
 	{ "infiniband_pkey",
 	  { "access", NULL } },
+	{ "infiniband_device",
+	  { "smi", NULL } },
 	{ NULL }
   };
diff --git a/security/selinux/include/initial_sid_to_string.h b/security/selinux/include/initial_sid_to_string.h
index 8f2eefc..56737c3 100644
--- a/security/selinux/include/initial_sid_to_string.h
+++ b/security/selinux/include/initial_sid_to_string.h
@@ -30,5 +30,6 @@ static const char *initial_sid_to_string[] =
     "scmp_packet",
     "devnull",
     "pkey",
+    "ibdev",
 };
 
diff --git a/security/selinux/include/security.h b/security/selinux/include/security.h
index 8f1a66e..692c3ce 100644
--- a/security/selinux/include/security.h
+++ b/security/selinux/include/security.h
@@ -182,6 +182,8 @@ int security_port_sid(u8 protocol, u16 port, u32 *out_sid);
 
 int security_pkey_sid(u64 subnet_prefix, u16 pkey_num, u32 *out_sid);
 
+int security_ibdev_sid(const char *dev_name, u8 port, u32 *out_sid);
+
 int security_netif_sid(char *name, u32 *if_sid);
 
 int security_node_sid(u16 domain, void *addr, u32 addrlen,
diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
index 2fc48c5..e49d276 100644
--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -53,6 +53,7 @@
 #include <linux/flex_array.h>
 #include <linux/vmalloc.h>
 #include <net/netlabel.h>
+#include <rdma/ib_verbs.h>
 
 #include "flask.h"
 #include "avc.h"
@@ -2270,6 +2271,48 @@ out:
 }
 
 /**
+ * security_ibdev_sid - Obtain the SID for a subnet management interface.
+ * @dev_name: device name
+ * @port: port number
+ * @out_sid: security identifier
+ */
+int security_ibdev_sid(const char *dev_name, u8 port, u32 *out_sid)
+{
+	struct ocontext *c;
+	int rc = 0;
+
+	read_lock(&policy_rwlock);
+
+	c = policydb.ocontexts[OCON_IBDEV];
+	while (c) {
+		if (c->u.ibdev.port == port &&
+		    !strncmp(c->u.ibdev.dev_name,
+			    dev_name,
+			    IB_DEVICE_NAME_MAX))
+			break;
+
+		c = c->next;
+	}
+
+	if (c) {
+		if (!c->sid[0]) {
+			rc = sidtab_context_to_sid(&sidtab,
+						   &c->context[0],
+						   &c->sid[0]);
+			if (rc)
+				goto out;
+		}
+		*out_sid = c->sid[0];
+	} else {
+		*out_sid = SECINITSID_IBDEV;
+	}
+
+out:
+	read_unlock(&policy_rwlock);
+	return rc;
+}
+
+/**
  * security_netif_sid - Obtain the SID for a network interface.
  * @name: interface name
  * @if_sid: interface SID
-- 
1.7.1


From: Dan Jurgens <danielj@mellanox.com>
Subject: [PATCH v2 8/9] selinux: Add IB Port SMP access vector
Date: Fri, 15 Jul 2016 01:56:50 +0300
Message-ID: <1468537011-20407-9-git-send-email-danielj@mellanox.com>
References: <1468537011-20407-1-git-send-email-danielj@mellanox.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1468537011-20407-1-git-send-email-danielj@mellanox.com>
Sender: owner-linux-security-module@vger.kernel.org
To: chrisw@sous-sol.org, paul@paul-moore.com, sds@tycho.nsa.gov, eparis@parisplace.org, dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com
Cc: selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org, linux-rdma@vger.kernel.org, yevgenyp@mellanox.com, Daniel Jurgens <danielj@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Daniel Jurgens <danielj@mellanox.com>

Add a type for Infiniband ports and an access vector for subnet
management packets. Implement the ib_port_smp hook to check that the
caller has permission to send and receive SMPs on the end port specified
by the device name and port. Add interface to query the SID for a IB
port, which walks the IB_PORT ocontexts to find an entry for the
given name and port.

Signed-off-by: Daniel Jurgens <danielj@mellanox.com>

---
v2:
- Shorted ib_end_port. Paul Moore
- Pass void blobs to security hooks. Paul Moore
- Log specific IB port info in audit log. Paul Moore
- Don't create a new intial sid, use unlabeled. Stephen Smalley
- Changed "smp" to "manage_subnet". Paul Moore
---
 include/linux/lsm_audit.h           |   32 ++++++++++++++++----------
 security/lsm_audit.c                |    5 ++++
 security/selinux/hooks.c            |   23 +++++++++++++++++++
 security/selinux/include/classmap.h |    2 +
 security/selinux/include/security.h |    2 +
 security/selinux/ss/services.c      |   42 +++++++++++++++++++++++++++++++++++
 6 files changed, 94 insertions(+), 12 deletions(-)

diff --git a/include/linux/lsm_audit.h b/include/linux/lsm_audit.h
index 8ff7eae..d2f6bda 100644
--- a/include/linux/lsm_audit.h
+++ b/include/linux/lsm_audit.h
@@ -21,6 +21,7 @@
 #include <linux/path.h>
 #include <linux/key.h>
 #include <linux/skbuff.h>
+#include <rdma/ib_verbs.h>
 
 struct lsm_network_audit {
 	int netif;
@@ -50,21 +51,27 @@ struct lsm_pkey_audit {
 	u16	pkey;
 };
 
+struct lsm_ib_port_audit {
+	char	dev_name[IB_DEVICE_NAME_MAX];
+	u8	port;
+};
+
 /* Auxiliary data to use in generating the audit record. */
 struct common_audit_data {
 	char type;
-#define LSM_AUDIT_DATA_PATH	1
-#define LSM_AUDIT_DATA_NET	2
-#define LSM_AUDIT_DATA_CAP	3
-#define LSM_AUDIT_DATA_IPC	4
-#define LSM_AUDIT_DATA_TASK	5
-#define LSM_AUDIT_DATA_KEY	6
-#define LSM_AUDIT_DATA_NONE	7
-#define LSM_AUDIT_DATA_KMOD	8
-#define LSM_AUDIT_DATA_INODE	9
-#define LSM_AUDIT_DATA_DENTRY	10
-#define LSM_AUDIT_DATA_IOCTL_OP	11
-#define LSM_AUDIT_DATA_PKEY	12
+#define LSM_AUDIT_DATA_PATH		1
+#define LSM_AUDIT_DATA_NET		2
+#define LSM_AUDIT_DATA_CAP		3
+#define LSM_AUDIT_DATA_IPC		4
+#define LSM_AUDIT_DATA_TASK		5
+#define LSM_AUDIT_DATA_KEY		6
+#define LSM_AUDIT_DATA_NONE		7
+#define LSM_AUDIT_DATA_KMOD		8
+#define LSM_AUDIT_DATA_INODE		9
+#define LSM_AUDIT_DATA_DENTRY		10
+#define LSM_AUDIT_DATA_IOCTL_OP		11
+#define LSM_AUDIT_DATA_PKEY		12
+#define LSM_AUDIT_DATA_IB_PORT		13
 	union 	{
 		struct path path;
 		struct dentry *dentry;
@@ -82,6 +89,7 @@ struct common_audit_data {
 		char *kmod_name;
 		struct lsm_ioctlop_audit *op;
 		struct lsm_pkey_audit *pkey;
+		struct lsm_ib_port_audit *ib_port;
 	} u;
 	/* this union contains LSM specific data */
 	union {
diff --git a/security/lsm_audit.c b/security/lsm_audit.c
index 2546d82..95632a9 100644
--- a/security/lsm_audit.c
+++ b/security/lsm_audit.c
@@ -410,6 +410,11 @@ static void dump_common_audit_data(struct audit_buffer *ab,
 				 a->u.pkey->pkey, &sbn_pfx);
 		break;
 	}
+	case LSM_AUDIT_DATA_IB_PORT:
+		audit_log_format(ab, " device=");
+		audit_log_untrustedstring(ab, a->u.ib_port->dev_name);
+		audit_log_format(ab, " port=%u", a->u.ib_port->port);
+		break;
 	} /* switch (a->type) */
 }
 
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index d9c4bfa..40ad0e8 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -6017,6 +6017,28 @@ static int selinux_ib_pkey_access(u64 subnet_prefix, u16 pkey_val, void *ib_sec)
 			    INFINIBAND_PKEY__ACCESS, &ad);
 }
 
+static int selinux_ib_port_manage_subnet(const char *dev_name, u8 port, void *ib_sec)
+{
+	struct common_audit_data ad;
+	int err;
+	u32 sid = 0;
+	struct ib_security_struct *sec = ib_sec;
+	struct lsm_ib_port_audit ib_port;
+
+	err = security_ib_port_sid(dev_name, port, &sid);
+
+	if (err)
+		return err;
+
+	ad.type = LSM_AUDIT_DATA_IB_PORT;
+	strncpy(ib_port.dev_name, dev_name, sizeof(ib_port.dev_name));
+	ib_port.port = port;
+	ad.u.ib_port = &ib_port;
+	return avc_has_perm(sec->sid, sid,
+			    SECCLASS_INFINIBAND_PORT,
+			    INFINIBAND_PORT__MANAGE_SUBNET, &ad);
+}
+
 static int selinux_ib_alloc_security(void **ib_sec)
 {
 	struct ib_security_struct *sec;
@@ -6219,6 +6241,7 @@ static struct security_hook_list selinux_hooks[] = {
 	LSM_HOOK_INIT(tun_dev_open, selinux_tun_dev_open),
 #ifdef CONFIG_SECURITY_INFINIBAND
 	LSM_HOOK_INIT(ib_pkey_access, selinux_ib_pkey_access),
+	LSM_HOOK_INIT(ib_port_manage_subnet, selinux_ib_port_manage_subnet),
 	LSM_HOOK_INIT(ib_alloc_security, selinux_ib_alloc_security),
 	LSM_HOOK_INIT(ib_free_security, selinux_ib_free_security),
 #endif
diff --git a/security/selinux/include/classmap.h b/security/selinux/include/classmap.h
index d42dd4d..9ba1238 100644
--- a/security/selinux/include/classmap.h
+++ b/security/selinux/include/classmap.h
@@ -167,5 +167,7 @@ struct security_class_mapping secclass_map[] = {
 	  { COMMON_CAP2_PERMS, NULL } },
 	{ "infiniband_pkey",
 	  { "access", NULL } },
+	{ "infiniband_port",
+	  { "manage_subnet", NULL } },
 	{ NULL }
   };
diff --git a/security/selinux/include/security.h b/security/selinux/include/security.h
index 8f1a66e..1d58583 100644
--- a/security/selinux/include/security.h
+++ b/security/selinux/include/security.h
@@ -182,6 +182,8 @@ int security_port_sid(u8 protocol, u16 port, u32 *out_sid);
 
 int security_pkey_sid(u64 subnet_prefix, u16 pkey_num, u32 *out_sid);
 
+int security_ib_port_sid(const char *dev_name, u8 port, u32 *out_sid);
+
 int security_netif_sid(char *name, u32 *if_sid);
 
 int security_node_sid(u16 domain, void *addr, u32 addrlen,
diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
index ba346da..4c97952 100644
--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -2270,6 +2270,48 @@ out:
 }
 
 /**
+ * security_ib_port_sid - Obtain the SID for a subnet management interface.
+ * @dev_name: device name
+ * @port: port number
+ * @out_sid: security identifier
+ */
+int security_ib_port_sid(const char *dev_name, u8 port, u32 *out_sid)
+{
+	struct ocontext *c;
+	int rc = 0;
+
+	read_lock(&policy_rwlock);
+
+	c = policydb.ocontexts[OCON_IB_PORT];
+	while (c) {
+		if (c->u.ib_port.port == port &&
+		    !strncmp(c->u.ib_port.dev_name,
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
+		*out_sid = SECINITSID_UNLABELED;
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


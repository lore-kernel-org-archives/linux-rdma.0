From: Dan Jurgens <danielj@mellanox.com>
Subject: [PATCH v5 8/9] selinux: Add IB Port SMP access vector
Date: Tue, 22 Nov 2016 21:40:37 +0200
Message-ID: <1479843638-67136-9-git-send-email-danielj@mellanox.com>
References: <1479843638-67136-1-git-send-email-danielj@mellanox.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1479843638-67136-1-git-send-email-danielj@mellanox.com>
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

v3:
- ib_port -> ib_endport. Paul Moore
- Don't log device name as untrusted string. Paul Moore
- Reorder parameters of LSM hook. Paul Moore
---
 include/linux/lsm_audit.h           |  8 +++++++
 security/lsm_audit.c                |  5 +++++
 security/selinux/hooks.c            | 25 ++++++++++++++++++++++
 security/selinux/include/classmap.h |  2 ++
 security/selinux/include/security.h |  2 ++
 security/selinux/ss/services.c      | 42 +++++++++++++++++++++++++++++++++++++
 6 files changed, 84 insertions(+)

diff --git a/include/linux/lsm_audit.h b/include/linux/lsm_audit.h
index 402b770..7047b4c 100644
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
 
+struct lsm_ib_endport_audit {
+	char	dev_name[IB_DEVICE_NAME_MAX];
+	u8	port_num;
+};
+
 /* Auxiliary data to use in generating the audit record. */
 struct common_audit_data {
 	char type;
@@ -66,6 +72,7 @@ struct common_audit_data {
 #define LSM_AUDIT_DATA_IOCTL_OP	11
 #define LSM_AUDIT_DATA_FILE	12
 #define LSM_AUDIT_DATA_PKEY	13
+#define LSM_AUDIT_DATA_IB_ENDPORT 14
 	union 	{
 		struct path path;
 		struct dentry *dentry;
@@ -84,6 +91,7 @@ struct common_audit_data {
 		struct lsm_ioctlop_audit *op;
 		struct file *file;
 		struct lsm_pkey_audit *pkey;
+		struct lsm_ib_endport_audit *ib_endport;
 	} u;
 	/* this union contains LSM specific data */
 	union {
diff --git a/security/lsm_audit.c b/security/lsm_audit.c
index b18d277..549fe9d 100644
--- a/security/lsm_audit.c
+++ b/security/lsm_audit.c
@@ -423,6 +423,11 @@ static void dump_common_audit_data(struct audit_buffer *ab,
 				 a->u.pkey->pkey, &sbn_pfx);
 		break;
 	}
+	case LSM_AUDIT_DATA_IB_ENDPORT:
+		audit_log_format(ab, " device=%s port_num=%u",
+				 a->u.ib_endport->dev_name,
+				 a->u.ib_endport->port_num);
+		break;
 	} /* switch (a->type) */
 }
 
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index e21f7690..0954dfe 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -6108,6 +6108,29 @@ static int selinux_ib_pkey_access(void *ib_sec, u64 subnet_prefix, u16 pkey_val)
 			    INFINIBAND_PKEY__ACCESS, &ad);
 }
 
+static int selinux_ib_endport_manage_subnet(void *ib_sec, const char *dev_name,
+					    u8 port_num)
+{
+	struct common_audit_data ad;
+	int err;
+	u32 sid = 0;
+	struct ib_security_struct *sec = ib_sec;
+	struct lsm_ib_endport_audit ib_endport;
+
+	err = security_ib_endport_sid(dev_name, port_num, &sid);
+
+	if (err)
+		return err;
+
+	ad.type = LSM_AUDIT_DATA_IB_ENDPORT;
+	strncpy(ib_endport.dev_name, dev_name, sizeof(ib_endport.dev_name));
+	ib_endport.port_num = port_num;
+	ad.u.ib_endport = &ib_endport;
+	return avc_has_perm(sec->sid, sid,
+			    SECCLASS_INFINIBAND_ENDPORT,
+			    INFINIBAND_ENDPORT__MANAGE_SUBNET, &ad);
+}
+
 static int selinux_ib_alloc_security(void **ib_sec)
 {
 	struct ib_security_struct *sec;
@@ -6313,6 +6336,8 @@ static struct security_hook_list selinux_hooks[] = {
 	LSM_HOOK_INIT(tun_dev_open, selinux_tun_dev_open),
 #ifdef CONFIG_SECURITY_INFINIBAND
 	LSM_HOOK_INIT(ib_pkey_access, selinux_ib_pkey_access),
+	LSM_HOOK_INIT(ib_endport_manage_subnet,
+		      selinux_ib_endport_manage_subnet),
 	LSM_HOOK_INIT(ib_alloc_security, selinux_ib_alloc_security),
 	LSM_HOOK_INIT(ib_free_security, selinux_ib_free_security),
 #endif
diff --git a/security/selinux/include/classmap.h b/security/selinux/include/classmap.h
index d42dd4d..f93b64b 100644
--- a/security/selinux/include/classmap.h
+++ b/security/selinux/include/classmap.h
@@ -167,5 +167,7 @@ struct security_class_mapping secclass_map[] = {
 	  { COMMON_CAP2_PERMS, NULL } },
 	{ "infiniband_pkey",
 	  { "access", NULL } },
+	{ "infiniband_endport",
+	  { "manage_subnet", NULL } },
 	{ NULL }
   };
diff --git a/security/selinux/include/security.h b/security/selinux/include/security.h
index 17afb7c..8a6e5e7 100644
--- a/security/selinux/include/security.h
+++ b/security/selinux/include/security.h
@@ -178,6 +178,8 @@ int security_port_sid(u8 protocol, u16 port, u32 *out_sid);
 
 int security_pkey_sid(u64 subnet_prefix, u16 pkey_num, u32 *out_sid);
 
+int security_ib_endport_sid(const char *dev_name, u8 port_num, u32 *out_sid);
+
 int security_netif_sid(char *name, u32 *if_sid);
 
 int security_node_sid(u16 domain, void *addr, u32 addrlen,
diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
index 085c54b..db40ce7 100644
--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -2244,6 +2244,48 @@ int security_pkey_sid(u64 subnet_prefix, u16 pkey_num, u32 *out_sid)
 }
 
 /**
+ * security_ib_endport_sid - Obtain the SID for a subnet management interface.
+ * @dev_name: device name
+ * @port: port number
+ * @out_sid: security identifier
+ */
+int security_ib_endport_sid(const char *dev_name, u8 port_num, u32 *out_sid)
+{
+	struct ocontext *c;
+	int rc = 0;
+
+	read_lock(&policy_rwlock);
+
+	c = policydb.ocontexts[OCON_IB_ENDPORT];
+	while (c) {
+		if (c->u.ib_endport.port_num == port_num &&
+		    !strncmp(c->u.ib_endport.dev_name,
+			     dev_name,
+			     IB_DEVICE_NAME_MAX))
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
2.7.4


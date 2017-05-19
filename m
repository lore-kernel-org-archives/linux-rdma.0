From: Dan Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v7 8/9] selinux: Add IB Port SMP access vector
Date: Fri, 19 May 2017 15:48:58 +0300
Message-ID: <1495198139-69993-9-git-send-email-danielj@mellanox.com>
References: <1495198139-69993-1-git-send-email-danielj@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1495198139-69993-1-git-send-email-danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: chrisw-69jw2NvuJkxg9hUCZPvPmw@public.gmane.org, paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org, sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add a type for Infiniband ports and an access vector for subnet
management packets. Implement the ib_port_smp hook to check that the
caller has permission to send and receive SMPs on the end port specified
by the device name and port. Add interface to query the SID for a IB
port, which walks the IB_PORT ocontexts to find an entry for the
given name and port.

Signed-off-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

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

v6:
- Remove brakets around single statement else. James Morris

v7:
- Synch ocontext names with userspace.  Also change lsm_audit_data names
  to the same style.  Stephen Smalley

 include/linux/lsm_audit.h           |  8 ++++++++
 security/lsm_audit.c                |  5 +++++
 security/selinux/hooks.c            | 25 ++++++++++++++++++++++
 security/selinux/include/classmap.h |  2 ++
 security/selinux/include/security.h |  2 ++
 security/selinux/ss/services.c      | 41 +++++++++++++++++++++++++++++++++++++
 6 files changed, 83 insertions(+)

diff --git a/include/linux/lsm_audit.h b/include/linux/lsm_audit.h
index 0df5639..22b5d4e 100644
--- a/include/linux/lsm_audit.h
+++ b/include/linux/lsm_audit.h
@@ -21,6 +21,7 @@
 #include <linux/path.h>
 #include <linux/key.h>
 #include <linux/skbuff.h>
+#include <rdma/ib_verbs.h>
 
 struct lsm_network_audit {
 	int netif;
@@ -50,6 +51,11 @@ struct lsm_ibpkey_audit {
 	u16	pkey;
 };
 
+struct lsm_ibendport_audit {
+	char	dev_name[IB_DEVICE_NAME_MAX];
+	u8	port;
+};
+
 /* Auxiliary data to use in generating the audit record. */
 struct common_audit_data {
 	char type;
@@ -66,6 +72,7 @@ struct common_audit_data {
 #define LSM_AUDIT_DATA_IOCTL_OP	11
 #define LSM_AUDIT_DATA_FILE	12
 #define LSM_AUDIT_DATA_IBPKEY	13
+#define LSM_AUDIT_DATA_IBENDPORT 14
 	union 	{
 		struct path path;
 		struct dentry *dentry;
@@ -84,6 +91,7 @@ struct common_audit_data {
 		struct lsm_ioctlop_audit *op;
 		struct file *file;
 		struct lsm_ibpkey_audit *ibpkey;
+		struct lsm_ibendport_audit *ibendport;
 	} u;
 	/* this union contains LSM specific data */
 	union {
diff --git a/security/lsm_audit.c b/security/lsm_audit.c
index c22c99f..28d4c3a 100644
--- a/security/lsm_audit.c
+++ b/security/lsm_audit.c
@@ -421,6 +421,11 @@ static void dump_common_audit_data(struct audit_buffer *ab,
 				 a->u.ibpkey->pkey, &sbn_pfx);
 		break;
 	}
+	case LSM_AUDIT_DATA_IBENDPORT:
+		audit_log_format(ab, " device=%s port_num=%u",
+				 a->u.ibendport->dev_name,
+				 a->u.ibendport->port);
+		break;
 	} /* switch (a->type) */
 }
 
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index b8add3a..da5fffe 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -6181,6 +6181,29 @@ static int selinux_ib_pkey_access(void *ib_sec, u64 subnet_prefix, u16 pkey_val)
 			    INFINIBAND_PKEY__ACCESS, &ad);
 }
 
+static int selinux_ib_endport_manage_subnet(void *ib_sec, const char *dev_name,
+					    u8 port_num)
+{
+	struct common_audit_data ad;
+	int err;
+	u32 sid = 0;
+	struct ib_security_struct *sec = ib_sec;
+	struct lsm_ibendport_audit ibendport;
+
+	err = security_ib_endport_sid(dev_name, port_num, &sid);
+
+	if (err)
+		return err;
+
+	ad.type = LSM_AUDIT_DATA_IBENDPORT;
+	strncpy(ibendport.dev_name, dev_name, sizeof(ibendport.dev_name));
+	ibendport.port = port_num;
+	ad.u.ibendport = &ibendport;
+	return avc_has_perm(sec->sid, sid,
+			    SECCLASS_INFINIBAND_ENDPORT,
+			    INFINIBAND_ENDPORT__MANAGE_SUBNET, &ad);
+}
+
 static int selinux_ib_alloc_security(void **ib_sec)
 {
 	struct ib_security_struct *sec;
@@ -6386,6 +6409,8 @@ static struct security_hook_list selinux_hooks[] __lsm_ro_after_init = {
 	LSM_HOOK_INIT(tun_dev_open, selinux_tun_dev_open),
 #ifdef CONFIG_SECURITY_INFINIBAND
 	LSM_HOOK_INIT(ib_pkey_access, selinux_ib_pkey_access),
+	LSM_HOOK_INIT(ib_endport_manage_subnet,
+		      selinux_ib_endport_manage_subnet),
 	LSM_HOOK_INIT(ib_alloc_security, selinux_ib_alloc_security),
 	LSM_HOOK_INIT(ib_free_security, selinux_ib_free_security),
 #endif
diff --git a/security/selinux/include/classmap.h b/security/selinux/include/classmap.h
index 0fec1c5..b9fe343 100644
--- a/security/selinux/include/classmap.h
+++ b/security/selinux/include/classmap.h
@@ -233,6 +233,8 @@ struct security_class_mapping secclass_map[] = {
 	  { COMMON_SOCK_PERMS, NULL } },
 	{ "infiniband_pkey",
 	  { "access", NULL } },
+	{ "infiniband_endport",
+	  { "manage_subnet", NULL } },
 	{ NULL }
   };
 
diff --git a/security/selinux/include/security.h b/security/selinux/include/security.h
index b04b438..622470c 100644
--- a/security/selinux/include/security.h
+++ b/security/selinux/include/security.h
@@ -181,6 +181,8 @@ int security_port_sid(u8 protocol, u16 port, u32 *out_sid);
 
 int security_ib_pkey_sid(u64 subnet_prefix, u16 pkey_num, u32 *out_sid);
 
+int security_ib_endport_sid(const char *dev_name, u8 port_num, u32 *out_sid);
+
 int security_netif_sid(char *name, u32 *if_sid);
 
 int security_node_sid(u16 domain, void *addr, u32 addrlen,
diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
index 7c86b86..dbaa3d0 100644
--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -2250,6 +2250,47 @@ int security_ib_pkey_sid(u64 subnet_prefix, u16 pkey_num, u32 *out_sid)
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
+	c = policydb.ocontexts[OCON_IBENDPORT];
+	while (c) {
+		if (c->u.ibendport.port == port_num &&
+		    !strncmp(c->u.ibendport.dev_name,
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
+	} else
+		*out_sid = SECINITSID_UNLABELED;
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

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

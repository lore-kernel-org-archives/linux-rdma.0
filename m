From: Dan Jurgens <danielj@mellanox.com>
Subject: [PATCH v7 7/9] selinux: Implement Infiniband PKey "Access" access vector
Date: Fri, 19 May 2017 15:48:57 +0300
Message-ID: <1495198139-69993-8-git-send-email-danielj@mellanox.com>
References: <1495198139-69993-1-git-send-email-danielj@mellanox.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1495198139-69993-1-git-send-email-danielj@mellanox.com>
Sender: owner-linux-security-module@vger.kernel.org
To: chrisw@sous-sol.org, paul@paul-moore.com, sds@tycho.nsa.gov, eparis@parisplace.org, dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com
Cc: selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org, linux-rdma@vger.kernel.org, yevgenyp@mellanox.com, Daniel Jurgens <danielj@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Daniel Jurgens <danielj@mellanox.com>

Add a type and access vector for PKeys. Implement the ib_pkey_access
hook to check that the caller has permission to access the PKey on the
given subnet prefix. Add an interface to get the PKey SID. Walk the PKey
ocontexts to find an entry for the given subnet prefix and pkey.

Signed-off-by: Daniel Jurgens <danielj@mellanox.com>

---
v2:
- Use void* blobs for security structs. Paul Moore
- Add pkey specific data to the audit log. Paul Moore
- Don't introduce a new initial sid, use unlabeled. Stephen Smalley

v3:
- Reorder parameters to pkey_access hook. Paul Moore

v6:
- Remove blank lines and brackets on single statement else. James Morris

v7:
- Synch ocontext naming with userspace. Also changed the LSM audit
  structure to be of the same style.  Stephen Smalley
- changed security_pkey_sid function to security_ib_pkey_sid.

 include/linux/lsm_audit.h           |  7 +++++++
 security/lsm_audit.c                | 11 ++++++++++
 security/selinux/hooks.c            | 22 ++++++++++++++++++++
 security/selinux/include/classmap.h |  2 ++
 security/selinux/include/security.h |  2 ++
 security/selinux/ss/services.c      | 40 +++++++++++++++++++++++++++++++++++++
 6 files changed, 84 insertions(+)

diff --git a/include/linux/lsm_audit.h b/include/linux/lsm_audit.h
index e58e577..0df5639 100644
--- a/include/linux/lsm_audit.h
+++ b/include/linux/lsm_audit.h
@@ -45,6 +45,11 @@ struct lsm_ioctlop_audit {
 	u16 cmd;
 };
 
+struct lsm_ibpkey_audit {
+	u64	subnet_prefix;
+	u16	pkey;
+};
+
 /* Auxiliary data to use in generating the audit record. */
 struct common_audit_data {
 	char type;
@@ -60,6 +65,7 @@ struct common_audit_data {
 #define LSM_AUDIT_DATA_DENTRY	10
 #define LSM_AUDIT_DATA_IOCTL_OP	11
 #define LSM_AUDIT_DATA_FILE	12
+#define LSM_AUDIT_DATA_IBPKEY	13
 	union 	{
 		struct path path;
 		struct dentry *dentry;
@@ -77,6 +83,7 @@ struct common_audit_data {
 		char *kmod_name;
 		struct lsm_ioctlop_audit *op;
 		struct file *file;
+		struct lsm_ibpkey_audit *ibpkey;
 	} u;
 	/* this union contains LSM specific data */
 	union {
diff --git a/security/lsm_audit.c b/security/lsm_audit.c
index 37f04da..c22c99f 100644
--- a/security/lsm_audit.c
+++ b/security/lsm_audit.c
@@ -410,6 +410,17 @@ static void dump_common_audit_data(struct audit_buffer *ab,
 		audit_log_format(ab, " kmod=");
 		audit_log_untrustedstring(ab, a->u.kmod_name);
 		break;
+	case LSM_AUDIT_DATA_IBPKEY: {
+		struct in6_addr sbn_pfx;
+
+		memset(&sbn_pfx.s6_addr, 0,
+		       sizeof(sbn_pfx.s6_addr));
+		memcpy(&sbn_pfx.s6_addr, &a->u.ibpkey->subnet_prefix,
+		       sizeof(a->u.ibpkey->subnet_prefix));
+		audit_log_format(ab, " pkey=0x%x subnet_prefix=%pI6c",
+				 a->u.ibpkey->pkey, &sbn_pfx);
+		break;
+	}
 	} /* switch (a->type) */
 }
 
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index d580268..b8add3a 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -6160,6 +6160,27 @@ static int selinux_key_getsecurity(struct key *key, char **_buffer)
 #endif
 
 #ifdef CONFIG_SECURITY_INFINIBAND
+static int selinux_ib_pkey_access(void *ib_sec, u64 subnet_prefix, u16 pkey_val)
+{
+	struct common_audit_data ad;
+	int err;
+	u32 sid = 0;
+	struct ib_security_struct *sec = ib_sec;
+	struct lsm_ibpkey_audit ibpkey;
+
+	err = security_ib_pkey_sid(subnet_prefix, pkey_val, &sid);
+	if (err)
+		return err;
+
+	ad.type = LSM_AUDIT_DATA_IBPKEY;
+	ibpkey.subnet_prefix = subnet_prefix;
+	ibpkey.pkey = pkey_val;
+	ad.u.ibpkey = &ibpkey;
+	return avc_has_perm(sec->sid, sid,
+			    SECCLASS_INFINIBAND_PKEY,
+			    INFINIBAND_PKEY__ACCESS, &ad);
+}
+
 static int selinux_ib_alloc_security(void **ib_sec)
 {
 	struct ib_security_struct *sec;
@@ -6364,6 +6385,7 @@ static struct security_hook_list selinux_hooks[] __lsm_ro_after_init = {
 	LSM_HOOK_INIT(tun_dev_attach, selinux_tun_dev_attach),
 	LSM_HOOK_INIT(tun_dev_open, selinux_tun_dev_open),
 #ifdef CONFIG_SECURITY_INFINIBAND
+	LSM_HOOK_INIT(ib_pkey_access, selinux_ib_pkey_access),
 	LSM_HOOK_INIT(ib_alloc_security, selinux_ib_alloc_security),
 	LSM_HOOK_INIT(ib_free_security, selinux_ib_free_security),
 #endif
diff --git a/security/selinux/include/classmap.h b/security/selinux/include/classmap.h
index 3e49a78..0fec1c5 100644
--- a/security/selinux/include/classmap.h
+++ b/security/selinux/include/classmap.h
@@ -231,6 +231,8 @@ struct security_class_mapping secclass_map[] = {
 	  { COMMON_SOCK_PERMS, NULL } },
 	{ "smc_socket",
 	  { COMMON_SOCK_PERMS, NULL } },
+	{ "infiniband_pkey",
+	  { "access", NULL } },
 	{ NULL }
   };
 
diff --git a/security/selinux/include/security.h b/security/selinux/include/security.h
index e202448..b04b438 100644
--- a/security/selinux/include/security.h
+++ b/security/selinux/include/security.h
@@ -179,6 +179,8 @@ int security_get_user_sids(u32 callsid, char *username,
 
 int security_port_sid(u8 protocol, u16 port, u32 *out_sid);
 
+int security_ib_pkey_sid(u64 subnet_prefix, u16 pkey_num, u32 *out_sid);
+
 int security_netif_sid(char *name, u32 *if_sid);
 
 int security_node_sid(u16 domain, void *addr, u32 addrlen,
diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
index 60d9b02..7c86b86 100644
--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -2210,6 +2210,46 @@ int security_port_sid(u8 protocol, u16 port, u32 *out_sid)
 }
 
 /**
+ * security_pkey_sid - Obtain the SID for a pkey.
+ * @subnet_prefix: Subnet Prefix
+ * @pkey_num: pkey number
+ * @out_sid: security identifier
+ */
+int security_ib_pkey_sid(u64 subnet_prefix, u16 pkey_num, u32 *out_sid)
+{
+	struct ocontext *c;
+	int rc = 0;
+
+	read_lock(&policy_rwlock);
+
+	c = policydb.ocontexts[OCON_IBPKEY];
+	while (c) {
+		if (c->u.ibpkey.low_pkey <= pkey_num &&
+		    c->u.ibpkey.high_pkey >= pkey_num &&
+		    c->u.ibpkey.subnet_prefix == subnet_prefix)
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


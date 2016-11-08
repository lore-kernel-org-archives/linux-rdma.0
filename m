From: Dan Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v4 7/9] selinux: Implement Infiniband PKey "Access" access vector
Date: Tue,  8 Nov 2016 23:06:23 +0200
Message-ID: <1478639185-47521-8-git-send-email-danielj@mellanox.com>
References: <1478639185-47521-1-git-send-email-danielj@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1478639185-47521-1-git-send-email-danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: chrisw-69jw2NvuJkxg9hUCZPvPmw@public.gmane.org, paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org, sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add a type and access vector for PKeys. Implement the ib_pkey_access
hook to check that the caller has permission to access the PKey on the
given subnet prefix. Add an interface to get the PKey SID. Walk the PKey
ocontexts to find an entry for the given subnet prefix and pkey.

issue: 736423
Change-Id: Ib3f7df9b5f98da77a6048855d146f9dcaceba336
Signed-off-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

---
v2:
- Use void* blobs for security structs. Paul Moore
- Add pkey specific data to the audit log. Paul Moore
- Don't introduce a new initial sid, use unlabeled. Stephen Smalley

v3:
- Reorder parameters to pkey_access hook. Paul Moore

Signed-off-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/linux/lsm_audit.h           |  7 +++++++
 security/lsm_audit.c                | 13 ++++++++++++
 security/selinux/hooks.c            | 23 +++++++++++++++++++++
 security/selinux/include/classmap.h |  2 ++
 security/selinux/include/security.h |  2 ++
 security/selinux/ss/services.c      | 41 +++++++++++++++++++++++++++++++++++++
 6 files changed, 88 insertions(+)

diff --git a/include/linux/lsm_audit.h b/include/linux/lsm_audit.h
index e58e577..402b770 100644
--- a/include/linux/lsm_audit.h
+++ b/include/linux/lsm_audit.h
@@ -45,6 +45,11 @@ struct lsm_ioctlop_audit {
 	u16 cmd;
 };
 
+struct lsm_pkey_audit {
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
+#define LSM_AUDIT_DATA_PKEY	13
 	union 	{
 		struct path path;
 		struct dentry *dentry;
@@ -77,6 +83,7 @@ struct common_audit_data {
 		char *kmod_name;
 		struct lsm_ioctlop_audit *op;
 		struct file *file;
+		struct lsm_pkey_audit *pkey;
 	} u;
 	/* this union contains LSM specific data */
 	union {
diff --git a/security/lsm_audit.c b/security/lsm_audit.c
index 37f04da..b18d277 100644
--- a/security/lsm_audit.c
+++ b/security/lsm_audit.c
@@ -410,6 +410,19 @@ static void dump_common_audit_data(struct audit_buffer *ab,
 		audit_log_format(ab, " kmod=");
 		audit_log_untrustedstring(ab, a->u.kmod_name);
 		break;
+	case LSM_AUDIT_DATA_PKEY: {
+		struct in6_addr sbn_pfx;
+
+		memset(&sbn_pfx.s6_addr, 0,
+		       sizeof(sbn_pfx.s6_addr));
+
+		memcpy(&sbn_pfx.s6_addr, &a->u.pkey->subnet_prefix,
+		       sizeof(a->u.pkey->subnet_prefix));
+
+		audit_log_format(ab, " pkey=0x%x subnet_prefix=%pI6c",
+				 a->u.pkey->pkey, &sbn_pfx);
+		break;
+	}
 	} /* switch (a->type) */
 }
 
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index f48759d..20fb292 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -6086,6 +6086,28 @@ static int selinux_key_getsecurity(struct key *key, char **_buffer)
 #endif
 
 #ifdef CONFIG_SECURITY_INFINIBAND
+static int selinux_ib_pkey_access(void *ib_sec, u64 subnet_prefix, u16 pkey_val)
+{
+	struct common_audit_data ad;
+	int err;
+	u32 sid = 0;
+	struct ib_security_struct *sec = ib_sec;
+	struct lsm_pkey_audit pkey;
+
+	err = security_pkey_sid(subnet_prefix, pkey_val, &sid);
+
+	if (err)
+		return err;
+
+	ad.type = LSM_AUDIT_DATA_PKEY;
+	pkey.subnet_prefix = subnet_prefix;
+	pkey.pkey = pkey_val;
+	ad.u.pkey = &pkey;
+	return avc_has_perm(sec->sid, sid,
+			    SECCLASS_INFINIBAND_PKEY,
+			    INFINIBAND_PKEY__ACCESS, &ad);
+}
+
 static int selinux_ib_alloc_security(void **ib_sec)
 {
 	struct ib_security_struct *sec;
@@ -6290,6 +6312,7 @@ static void selinux_ib_free_security(void *ib_sec)
 	LSM_HOOK_INIT(tun_dev_attach, selinux_tun_dev_attach),
 	LSM_HOOK_INIT(tun_dev_open, selinux_tun_dev_open),
 #ifdef CONFIG_SECURITY_INFINIBAND
+	LSM_HOOK_INIT(ib_pkey_access, selinux_ib_pkey_access),
 	LSM_HOOK_INIT(ib_alloc_security, selinux_ib_alloc_security),
 	LSM_HOOK_INIT(ib_free_security, selinux_ib_free_security),
 #endif
diff --git a/security/selinux/include/classmap.h b/security/selinux/include/classmap.h
index 1f1f4b2..d42dd4d 100644
--- a/security/selinux/include/classmap.h
+++ b/security/selinux/include/classmap.h
@@ -165,5 +165,7 @@ struct security_class_mapping secclass_map[] = {
 	  { COMMON_CAP_PERMS, NULL } },
 	{ "cap2_userns",
 	  { COMMON_CAP2_PERMS, NULL } },
+	{ "infiniband_pkey",
+	  { "access", NULL } },
 	{ NULL }
   };
diff --git a/security/selinux/include/security.h b/security/selinux/include/security.h
index 6bb9b0a..17afb7c 100644
--- a/security/selinux/include/security.h
+++ b/security/selinux/include/security.h
@@ -176,6 +176,8 @@ int security_get_user_sids(u32 callsid, char *username,
 
 int security_port_sid(u8 protocol, u16 port, u32 *out_sid);
 
+int security_pkey_sid(u64 subnet_prefix, u16 pkey_num, u32 *out_sid);
+
 int security_netif_sid(char *name, u32 *if_sid);
 
 int security_node_sid(u16 domain, void *addr, u32 addrlen,
diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
index 082b20c..085c54b 100644
--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -2203,6 +2203,47 @@ int security_port_sid(u8 protocol, u16 port, u32 *out_sid)
 }
 
 /**
+ * security_pkey_sid - Obtain the SID for a pkey.
+ * @subnet_prefix: Subnet Prefix
+ * @pkey_num: pkey number
+ * @out_sid: security identifier
+ */
+int security_pkey_sid(u64 subnet_prefix, u16 pkey_num, u32 *out_sid)
+{
+	struct ocontext *c;
+	int rc = 0;
+
+	read_lock(&policy_rwlock);
+
+	c = policydb.ocontexts[OCON_PKEY];
+	while (c) {
+		if (c->u.pkey.low_pkey <= pkey_num &&
+		    c->u.pkey.high_pkey >= pkey_num &&
+		    c->u.pkey.subnet_prefix == subnet_prefix)
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
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Dan Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC PATCH 2/7] selinux: Create policydb version for Infiniband support
Date: Tue,  5 Apr 2016 00:48:19 +0300
Message-ID: <1459806504-16135-3-git-send-email-danielj@mellanox.com>
References: <1459806504-16135-1-git-send-email-danielj@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1459806504-16135-1-git-send-email-danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Support for Infiniband requires the addition of two new object contexts,
one for infiniband PKeys and another IB Devices.  Added handlers to read
and write the new ocontext types when reading or writing a binary policy
representation.

Signed-off-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 security/selinux/include/security.h |    3 +-
 security/selinux/ss/policydb.c      |  129 +++++++++++++++++++++++++++++++----
 security/selinux/ss/policydb.h      |   13 +++-
 3 files changed, 128 insertions(+), 17 deletions(-)

diff --git a/security/selinux/include/security.h b/security/selinux/include/security.h
index 38feb55..a7e6ed2 100644
--- a/security/selinux/include/security.h
+++ b/security/selinux/include/security.h
@@ -36,13 +36,14 @@
 #define POLICYDB_VERSION_DEFAULT_TYPE	28
 #define POLICYDB_VERSION_CONSTRAINT_NAMES	29
 #define POLICYDB_VERSION_XPERMS_IOCTL	30
+#define POLICYDB_VERSION_INFINIBAND		31
 
 /* Range of policy versions we understand*/
 #define POLICYDB_VERSION_MIN   POLICYDB_VERSION_BASE
 #ifdef CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX
 #define POLICYDB_VERSION_MAX	CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX_VALUE
 #else
-#define POLICYDB_VERSION_MAX	POLICYDB_VERSION_XPERMS_IOCTL
+#define POLICYDB_VERSION_MAX	POLICYDB_VERSION_INFINIBAND
 #endif
 
 /* Mask for just the mount related flags */
diff --git a/security/selinux/ss/policydb.c b/security/selinux/ss/policydb.c
index 992a315..de2f0b1 100644
--- a/security/selinux/ss/policydb.c
+++ b/security/selinux/ss/policydb.c
@@ -17,6 +17,11 @@
  *
  *      Added support for the policy capability bitmap
  *
+ * Update: Mellanox Techonologies <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
+ *
+ *	Added Infiniband support
+ *
+ * Copyright (C) 2016 Mellanox Techonologies
  * Copyright (C) 2007 Hewlett-Packard Development Company, L.P.
  * Copyright (C) 2004-2005 Trusted Computer Solutions, Inc.
  * Copyright (C) 2003 - 2004 Tresys Technology, LLC
@@ -76,81 +81,86 @@ static struct policydb_compat_info policydb_compat[] = {
 	{
 		.version	= POLICYDB_VERSION_BASE,
 		.sym_num	= SYM_NUM - 3,
-		.ocon_num	= OCON_NUM - 1,
+		.ocon_num	= OCON_NUM - 3,
 	},
 	{
 		.version	= POLICYDB_VERSION_BOOL,
 		.sym_num	= SYM_NUM - 2,
-		.ocon_num	= OCON_NUM - 1,
+		.ocon_num	= OCON_NUM - 3,
 	},
 	{
 		.version	= POLICYDB_VERSION_IPV6,
 		.sym_num	= SYM_NUM - 2,
-		.ocon_num	= OCON_NUM,
+		.ocon_num	= OCON_NUM - 2,
 	},
 	{
 		.version	= POLICYDB_VERSION_NLCLASS,
 		.sym_num	= SYM_NUM - 2,
-		.ocon_num	= OCON_NUM,
+		.ocon_num	= OCON_NUM - 2,
 	},
 	{
 		.version	= POLICYDB_VERSION_MLS,
 		.sym_num	= SYM_NUM,
-		.ocon_num	= OCON_NUM,
+		.ocon_num	= OCON_NUM - 2,
 	},
 	{
 		.version	= POLICYDB_VERSION_AVTAB,
 		.sym_num	= SYM_NUM,
-		.ocon_num	= OCON_NUM,
+		.ocon_num	= OCON_NUM - 2,
 	},
 	{
 		.version	= POLICYDB_VERSION_RANGETRANS,
 		.sym_num	= SYM_NUM,
-		.ocon_num	= OCON_NUM,
+		.ocon_num	= OCON_NUM - 2,
 	},
 	{
 		.version	= POLICYDB_VERSION_POLCAP,
 		.sym_num	= SYM_NUM,
-		.ocon_num	= OCON_NUM,
+		.ocon_num	= OCON_NUM - 2,
 	},
 	{
 		.version	= POLICYDB_VERSION_PERMISSIVE,
 		.sym_num	= SYM_NUM,
-		.ocon_num	= OCON_NUM,
+		.ocon_num	= OCON_NUM - 2,
 	},
 	{
 		.version	= POLICYDB_VERSION_BOUNDARY,
 		.sym_num	= SYM_NUM,
-		.ocon_num	= OCON_NUM,
+		.ocon_num	= OCON_NUM - 2,
 	},
 	{
 		.version	= POLICYDB_VERSION_FILENAME_TRANS,
 		.sym_num	= SYM_NUM,
-		.ocon_num	= OCON_NUM,
+		.ocon_num	= OCON_NUM - 2,
 	},
 	{
 		.version	= POLICYDB_VERSION_ROLETRANS,
 		.sym_num	= SYM_NUM,
-		.ocon_num	= OCON_NUM,
+		.ocon_num	= OCON_NUM - 2,
 	},
 	{
 		.version	= POLICYDB_VERSION_NEW_OBJECT_DEFAULTS,
 		.sym_num	= SYM_NUM,
-		.ocon_num	= OCON_NUM,
+		.ocon_num	= OCON_NUM - 2,
 	},
 	{
 		.version	= POLICYDB_VERSION_DEFAULT_TYPE,
 		.sym_num	= SYM_NUM,
-		.ocon_num	= OCON_NUM,
+		.ocon_num	= OCON_NUM - 2,
 	},
 	{
 		.version	= POLICYDB_VERSION_CONSTRAINT_NAMES,
 		.sym_num	= SYM_NUM,
-		.ocon_num	= OCON_NUM,
+		.ocon_num	= OCON_NUM - 2,
 	},
 	{
 		.version	= POLICYDB_VERSION_XPERMS_IOCTL,
 		.sym_num	= SYM_NUM,
+		.ocon_num	= OCON_NUM - 2,
+	},
+	{
+		.version	= POLICYDB_VERSION_INFINIBAND,
+		.sym_num	= SYM_NUM,
 		.ocon_num	= OCON_NUM,
 	},
 };
@@ -2219,6 +2229,58 @@ static int ocontext_read(struct policydb *p, struct policydb_compat_info *info,
 					goto out;
 				break;
 			}
+			case OCON_PKEY: {
+				rc = next_entry(nodebuf, fp, sizeof(u32) * 6);
+				if (rc)
+					goto out;
+
+				c->u.pkey.subnet_prefix = be64_to_cpu(*((__be64 *)nodebuf));
+				/* The subnet prefix is stored as an IPv6
+				 * address in the policy.
+				 *
+				 * Check that the lower 2 DWORDS are 0.
+				 */
+				if (nodebuf[2] || nodebuf[3]) {
+					rc = -EINVAL;
+					goto out;
+				}
+
+				if (nodebuf[4] > 0xffff ||
+				    nodebuf[5] > 0xffff) {
+					rc = -EINVAL;
+					goto out;
+				}
+
+				c->u.pkey.low_pkey = le32_to_cpu(nodebuf[4]);
+				c->u.pkey.high_pkey = le32_to_cpu(nodebuf[5]);
+
+				rc = context_read_and_validate(&c->context[0],
+							       p,
+							       fp);
+				if (rc)
+					goto out;
+				break;
+			}
+			case OCON_IBDEV:
+				rc = next_entry(buf, fp, sizeof(u32) * 2);
+				if (rc)
+					goto out;
+				len = le32_to_cpu(buf[0]);
+
+				rc = str_read(&c->u.ibdev.dev_name, GFP_KERNEL,
+					      fp,
+					      len);
+				if (rc)
+					goto out;
+
+				c->u.ibdev.port = le32_to_cpu(buf[1]);
+
+				rc = context_read_and_validate(&c->context[0],
+							       p,
+							       fp);
+				if (rc)
+					goto out;
+				break;
 			}
 		}
 	}
@@ -3147,6 +3209,43 @@ static int ocontext_write(struct policydb *p, struct policydb_compat_info *info,
 				if (rc)
 					return rc;
 				break;
+			case OCON_PKEY: {
+				__be64 *sbn_pfx = (__be64 *)nodebuf;
+				*sbn_pfx = cpu_to_be64(c->u.pkey.subnet_prefix);
+
+				/*
+				 * The low order 2 bits were confirmed to be 0
+				 * when the policy was loaded. Write them out
+				 * as zero
+				 */
+				nodebuf[2] = 0;
+				nodebuf[3] = 0;
+
+				nodebuf[4] = cpu_to_le32(c->u.pkey.low_pkey);
+				nodebuf[5] = cpu_to_le32(c->u.pkey.high_pkey);
+
+				rc = put_entry(nodebuf, sizeof(u32), 6, fp);
+				if (rc)
+					return rc;
+				rc = context_write(p, &c->context[0], fp);
+				if (rc)
+					return rc;
+				break;
+			}
+			case OCON_IBDEV:
+				len = strlen(c->u.ibdev.dev_name);
+				buf[0] = cpu_to_le32(len);
+				buf[1] = cpu_to_le32(c->u.ibdev.port);
+				rc = put_entry(buf, sizeof(u32), 2, fp);
+				if (rc)
+					return rc;
+				rc = put_entry(c->u.ibdev.dev_name, 1, len, fp);
+				if (rc)
+					return rc;
+				rc = context_write(p, &c->context[0], fp);
+				if (rc)
+					return rc;
+				break;
 			}
 		}
 	}
diff --git a/security/selinux/ss/policydb.h b/security/selinux/ss/policydb.h
index 725d594..06c572e 100644
--- a/security/selinux/ss/policydb.h
+++ b/security/selinux/ss/policydb.h
@@ -187,6 +187,15 @@ struct ocontext {
 			u32 addr[4];
 			u32 mask[4];
 		} node6;        /* IPv6 node information */
+		struct {
+			u64 subnet_prefix;
+			u16 low_pkey;
+			u16 high_pkey;
+		} pkey;
+		struct {
+			char *dev_name;
+			u8 port;
+		} ibdev;
 	} u;
 	union {
 		u32 sclass;  /* security class for genfs */
@@ -222,7 +231,9 @@ struct genfs {
 #define OCON_NODE  4	/* nodes */
 #define OCON_FSUSE 5	/* fs_use */
 #define OCON_NODE6 6	/* IPv6 nodes */
-#define OCON_NUM   7
+#define OCON_PKEY  7    /* Infiniband PKEYs */
+#define OCON_IBDEV 8    /* Infiniband devices */
+#define OCON_NUM   9
 
 /* The policy database */
 struct policydb {
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

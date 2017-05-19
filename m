From: Dan Jurgens <danielj@mellanox.com>
Subject: [PATCH v7 5/9] selinux: Create policydb version for Infiniband support
Date: Fri, 19 May 2017 15:48:55 +0300
Message-ID: <1495198139-69993-6-git-send-email-danielj@mellanox.com>
References: <1495198139-69993-1-git-send-email-danielj@mellanox.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1495198139-69993-1-git-send-email-danielj@mellanox.com>
Sender: owner-linux-security-module@vger.kernel.org
To: chrisw@sous-sol.org, paul@paul-moore.com, sds@tycho.nsa.gov, eparis@parisplace.org, dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com
Cc: selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org, linux-rdma@vger.kernel.org, yevgenyp@mellanox.com, Daniel Jurgens <danielj@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Daniel Jurgens <danielj@mellanox.com>

Support for Infiniband requires the addition of two new object contexts,
one for infiniband PKeys and another IB Ports. Added handlers to read
and write the new ocontext types when reading or writing a binary policy
representation.

Signed-off-by: Daniel Jurgens <danielj@mellanox.com>
Reviewed-by: Eli Cohen <eli@mellanox.com>
---
v2:
- Shorten ib_end_port to ib_port. Paul Moore
- Added bounds checking to port number. Paul Moore
- Eliminated {} in OCON_PKEY case statement.  Yuval Shaia

v3:
- ib_port -> ib_endport. Paul Moore

v4:
- removed unneeded brackets in ocontext_read. Paul Moore

v7:
- Synchronized ocontext naming with userspace patches. Stephen Smalley

 security/selinux/include/security.h |   3 +-
 security/selinux/ss/policydb.c      | 112 +++++++++++++++++++++++++++++++-----
 security/selinux/ss/policydb.h      |  27 ++++++---
 3 files changed, 118 insertions(+), 24 deletions(-)

diff --git a/security/selinux/include/security.h b/security/selinux/include/security.h
index f979c35..e202448 100644
--- a/security/selinux/include/security.h
+++ b/security/selinux/include/security.h
@@ -36,10 +36,11 @@
 #define POLICYDB_VERSION_DEFAULT_TYPE	28
 #define POLICYDB_VERSION_CONSTRAINT_NAMES	29
 #define POLICYDB_VERSION_XPERMS_IOCTL	30
+#define POLICYDB_VERSION_INFINIBAND		31
 
 /* Range of policy versions we understand*/
 #define POLICYDB_VERSION_MIN   POLICYDB_VERSION_BASE
-#define POLICYDB_VERSION_MAX	POLICYDB_VERSION_XPERMS_IOCTL
+#define POLICYDB_VERSION_MAX   POLICYDB_VERSION_INFINIBAND
 
 /* Mask for just the mount related flags */
 #define SE_MNTMASK	0x0f
diff --git a/security/selinux/ss/policydb.c b/security/selinux/ss/policydb.c
index 87d645d..aa6500a 100644
--- a/security/selinux/ss/policydb.c
+++ b/security/selinux/ss/policydb.c
@@ -17,6 +17,11 @@
  *
  *      Added support for the policy capability bitmap
  *
+ * Update: Mellanox Techonologies
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
@@ -2206,6 +2216,51 @@ static int ocontext_read(struct policydb *p, struct policydb_compat_info *info,
 					goto out;
 				break;
 			}
+			case OCON_IBPKEY:
+				rc = next_entry(nodebuf, fp, sizeof(u32) * 4);
+				if (rc)
+					goto out;
+
+				c->u.ibpkey.subnet_prefix = be64_to_cpu(*((__be64 *)nodebuf));
+
+				if (nodebuf[2] > 0xffff ||
+				    nodebuf[3] > 0xffff) {
+					rc = -EINVAL;
+					goto out;
+				}
+
+				c->u.ibpkey.low_pkey = le32_to_cpu(nodebuf[2]);
+				c->u.ibpkey.high_pkey = le32_to_cpu(nodebuf[3]);
+
+				rc = context_read_and_validate(&c->context[0],
+							       p,
+							       fp);
+				if (rc)
+					goto out;
+				break;
+			case OCON_IBENDPORT:
+				rc = next_entry(buf, fp, sizeof(u32) * 2);
+				if (rc)
+					goto out;
+				len = le32_to_cpu(buf[0]);
+
+				rc = str_read(&c->u.ibendport.dev_name, GFP_KERNEL, fp, len);
+				if (rc)
+					goto out;
+
+				if (buf[1] > 0xff || buf[1] == 0) {
+					rc = -EINVAL;
+					goto out;
+				}
+
+				c->u.ibendport.port = le32_to_cpu(buf[1]);
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
@@ -3135,6 +3190,33 @@ static int ocontext_write(struct policydb *p, struct policydb_compat_info *info,
 				if (rc)
 					return rc;
 				break;
+			case OCON_IBPKEY:
+				*((__be64 *)nodebuf) = cpu_to_be64(c->u.ibpkey.subnet_prefix);
+
+				nodebuf[2] = cpu_to_le32(c->u.ibpkey.low_pkey);
+				nodebuf[3] = cpu_to_le32(c->u.ibpkey.high_pkey);
+
+				rc = put_entry(nodebuf, sizeof(u32), 4, fp);
+				if (rc)
+					return rc;
+				rc = context_write(p, &c->context[0], fp);
+				if (rc)
+					return rc;
+				break;
+			case OCON_IBENDPORT:
+				len = strlen(c->u.ibendport.dev_name);
+				buf[0] = cpu_to_le32(len);
+				buf[1] = cpu_to_le32(c->u.ibendport.port);
+				rc = put_entry(buf, sizeof(u32), 2, fp);
+				if (rc)
+					return rc;
+				rc = put_entry(c->u.ibendport.dev_name, 1, len, fp);
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
index 725d594..5d23eed 100644
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
+		} ibpkey;
+		struct {
+			char *dev_name;
+			u8 port;
+		} ibendport;
 	} u;
 	union {
 		u32 sclass;  /* security class for genfs */
@@ -215,14 +224,16 @@ struct genfs {
 #define SYM_NUM     8
 
 /* object context array indices */
-#define OCON_ISID  0	/* initial SIDs */
-#define OCON_FS    1	/* unlabeled file systems */
-#define OCON_PORT  2	/* TCP and UDP port numbers */
-#define OCON_NETIF 3	/* network interfaces */
-#define OCON_NODE  4	/* nodes */
-#define OCON_FSUSE 5	/* fs_use */
-#define OCON_NODE6 6	/* IPv6 nodes */
-#define OCON_NUM   7
+#define OCON_ISID	0 /* initial SIDs */
+#define OCON_FS		1 /* unlabeled file systems */
+#define OCON_PORT	2 /* TCP and UDP port numbers */
+#define OCON_NETIF	3 /* network interfaces */
+#define OCON_NODE	4 /* nodes */
+#define OCON_FSUSE	5 /* fs_use */
+#define OCON_NODE6	6 /* IPv6 nodes */
+#define OCON_IBPKEY	7 /* Infiniband PKeys */
+#define OCON_IBENDPORT	8 /* Infiniband end ports */
+#define OCON_NUM	9
 
 /* The policy database */
 struct policydb {
-- 
2.7.4


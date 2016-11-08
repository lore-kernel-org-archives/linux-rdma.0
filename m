From: Dan Jurgens <danielj@mellanox.com>
Subject: [PATCH v4 5/9] selinux: Create policydb version for Infiniband support
Date: Tue,  8 Nov 2016 23:06:21 +0200
Message-ID: <1478639185-47521-6-git-send-email-danielj@mellanox.com>
References: <1478639185-47521-1-git-send-email-danielj@mellanox.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1478639185-47521-1-git-send-email-danielj@mellanox.com>
Sender: owner-linux-security-module@vger.kernel.org
To: chrisw@sous-sol.org, paul@paul-moore.com, sds@tycho.nsa.gov, eparis@parisplace.org, dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com
Cc: selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org, linux-rdma@vger.kernel.org, yevgenyp@mellanox.com, liranl@mellanox.com, leonro@mellanox.com, Daniel Jurgens <danielj@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Daniel Jurgens <danielj@mellanox.com>

Support for Infiniband requires the addition of two new object contexts,
one for infiniband PKeys and another IB Ports. Added handlers to read
and write the new ocontext types when reading or writing a binary policy
representation.

issue: 736423
Change-Id: I906bf7a1e0bd59c3cccdce278e5fe98ba8c404b8
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

Signed-off-by: Daniel Jurgens <danielj@mellanox.com>
---
 security/selinux/include/security.h |   3 +-
 security/selinux/ss/policydb.c      | 129 +++++++++++++++++++++++++++++++-----
 security/selinux/ss/policydb.h      |  27 +++++---
 3 files changed, 135 insertions(+), 24 deletions(-)

diff --git a/security/selinux/include/security.h b/security/selinux/include/security.h
index 308a286..6bb9b0a 100644
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
index d719db4..24e16da 100644
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
@@ -76,81 +81,86 @@ struct policydb_compat_info {
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
@@ -2222,6 +2232,60 @@ static int ocontext_read(struct policydb *p, struct policydb_compat_info *info,
 					goto out;
 				break;
 			}
+			case OCON_PKEY:
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
+			case OCON_IB_ENDPORT:
+				rc = next_entry(buf, fp, sizeof(u32) * 2);
+				if (rc)
+					goto out;
+				len = le32_to_cpu(buf[0]);
+
+				rc = str_read(&c->u.ib_endport.dev_name, GFP_KERNEL, fp, len);
+				if (rc)
+					goto out;
+
+				if (buf[1] > 0xff || buf[1] == 0) {
+					rc = -EINVAL;
+					goto out;
+				}
+
+				c->u.ib_endport.port_num = le32_to_cpu(buf[1]);
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
@@ -3151,6 +3215,41 @@ static int ocontext_write(struct policydb *p, struct policydb_compat_info *info,
 				if (rc)
 					return rc;
 				break;
+			case OCON_PKEY:
+				*((__be64 *)nodebuf) = cpu_to_be64(c->u.pkey.subnet_prefix);
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
+			case OCON_IB_ENDPORT:
+				len = strlen(c->u.ib_endport.dev_name);
+				buf[0] = cpu_to_le32(len);
+				buf[1] = cpu_to_le32(c->u.ib_endport.port_num);
+				rc = put_entry(buf, sizeof(u32), 2, fp);
+				if (rc)
+					return rc;
+				rc = put_entry(c->u.ib_endport.dev_name, 1, len, fp);
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
index 725d594..edb329d 100644
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
+			u8 port_num;
+		} ib_endport;
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
+#define OCON_PKEY	7 /* Infiniband PKeys */
+#define OCON_IB_ENDPORT	8 /* Infiniband end ports */
+#define OCON_NUM	9
 
 /* The policy database */
 struct policydb {
-- 
1.8.3.1


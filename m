From: Dan Jurgens <danielj@mellanox.com>
Subject: [PATCH v7 9/9] selinux: Add a cache for quicker retreival of PKey SIDs
Date: Fri, 19 May 2017 15:48:59 +0300
Message-ID: <1495198139-69993-10-git-send-email-danielj@mellanox.com>
References: <1495198139-69993-1-git-send-email-danielj@mellanox.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1495198139-69993-1-git-send-email-danielj@mellanox.com>
Sender: owner-linux-security-module@vger.kernel.org
To: chrisw@sous-sol.org, paul@paul-moore.com, sds@tycho.nsa.gov, eparis@parisplace.org, dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com
Cc: selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org, linux-rdma@vger.kernel.org, yevgenyp@mellanox.com, Daniel Jurgens <danielj@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Daniel Jurgens <danielj@mellanox.com>

It is likely that the SID for the same PKey will be requested many
times. To reduce the time to modify QPs and process MADs use a cache to
store PKey SIDs.

This code is heavily based on the "netif" and "netport" concept
originally developed by James Morris <jmorris@redhat.com> and Paul Moore
<paul@paul-moore.com> (see security/selinux/netif.c and
security/selinux/netport.c for more information)

Signed-off-by: Daniel Jurgens <danielj@mellanox.com>

---
v2:
- Renamed the files to ibpkey. Paul Moore
- Fixed a bracket indentation mismatch in sel_pkey_find. Yuval Shaia
- Change spin_lock_bh to spin_lock_irqsave to resolve HARDIRQ lockdep
  warning.  Dan Jurgens

v6:
- Fixed sel_pkey_sid_slow error handling. James Morris

v7:
- Renamed sel_pkey* to sel_ib_pkey* in the pkey cache.

 security/selinux/Makefile         |   2 +-
 security/selinux/hooks.c          |   7 +-
 security/selinux/ibpkey.c         | 245 ++++++++++++++++++++++++++++++++++++++
 security/selinux/include/ibpkey.h |  31 +++++
 security/selinux/include/objsec.h |   6 +
 5 files changed, 288 insertions(+), 3 deletions(-)
 create mode 100644 security/selinux/ibpkey.c
 create mode 100644 security/selinux/include/ibpkey.h

diff --git a/security/selinux/Makefile b/security/selinux/Makefile
index 3411c33..ff5895e 100644
--- a/security/selinux/Makefile
+++ b/security/selinux/Makefile
@@ -5,7 +5,7 @@
 obj-$(CONFIG_SECURITY_SELINUX) := selinux.o
 
 selinux-y := avc.o hooks.o selinuxfs.o netlink.o nlmsgtab.o netif.o \
-	     netnode.o netport.o exports.o \
+	     netnode.o netport.o ibpkey.o exports.o \
 	     ss/ebitmap.o ss/hashtab.o ss/symtab.o ss/sidtab.o ss/avtab.o \
 	     ss/policydb.o ss/services.o ss/conditional.o ss/mls.o ss/status.o
 
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index da5fffe..b14e2eb 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -91,6 +91,7 @@
 #include "netif.h"
 #include "netnode.h"
 #include "netport.h"
+#include "ibpkey.h"
 #include "xfrm.h"
 #include "netlabel.h"
 #include "audit.h"
@@ -174,8 +175,10 @@ static int selinux_netcache_avc_callback(u32 event)
 
 static int selinux_lsm_notifier_avc_callback(u32 event)
 {
-	if (event == AVC_CALLBACK_RESET)
+	if (event == AVC_CALLBACK_RESET) {
+		sel_ib_pkey_flush();
 		call_lsm_notifier(LSM_POLICY_CHANGE, NULL);
+	}
 
 	return 0;
 }
@@ -6168,7 +6171,7 @@ static int selinux_ib_pkey_access(void *ib_sec, u64 subnet_prefix, u16 pkey_val)
 	struct ib_security_struct *sec = ib_sec;
 	struct lsm_ibpkey_audit ibpkey;
 
-	err = security_ib_pkey_sid(subnet_prefix, pkey_val, &sid);
+	err = sel_ib_pkey_sid(subnet_prefix, pkey_val, &sid);
 	if (err)
 		return err;
 
diff --git a/security/selinux/ibpkey.c b/security/selinux/ibpkey.c
new file mode 100644
index 0000000..e3614ee
--- /dev/null
+++ b/security/selinux/ibpkey.c
@@ -0,0 +1,245 @@
+/*
+ * Pkey table
+ *
+ * SELinux must keep a mapping of Infinband PKEYs to labels/SIDs.  This
+ * mapping is maintained as part of the normal policy but a fast cache is
+ * needed to reduce the lookup overhead.
+ *
+ * This code is heavily based on the "netif" and "netport" concept originally
+ * developed by
+ * James Morris <jmorris@redhat.com> and
+ * Paul Moore <paul@paul-moore.com>
+ *   (see security/selinux/netif.c and security/selinux/netport.c for more
+ *   information)
+ *
+ */
+
+/*
+ * (c) Mellanox Technologies, 2016
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/types.h>
+#include <linux/rcupdate.h>
+#include <linux/list.h>
+#include <linux/spinlock.h>
+
+#include "ibpkey.h"
+#include "objsec.h"
+
+#define SEL_PKEY_HASH_SIZE       256
+#define SEL_PKEY_HASH_BKT_LIMIT   16
+
+struct sel_ib_pkey_bkt {
+	int size;
+	struct list_head list;
+};
+
+struct sel_ib_pkey {
+	struct pkey_security_struct psec;
+	struct list_head list;
+	struct rcu_head rcu;
+};
+
+static LIST_HEAD(sel_ib_pkey_list);
+static DEFINE_SPINLOCK(sel_ib_pkey_lock);
+static struct sel_ib_pkey_bkt sel_ib_pkey_hash[SEL_PKEY_HASH_SIZE];
+
+/**
+ * sel_ib_pkey_hashfn - Hashing function for the pkey table
+ * @pkey: pkey number
+ *
+ * Description:
+ * This is the hashing function for the pkey table, it returns the bucket
+ * number for the given pkey.
+ *
+ */
+static unsigned int sel_ib_pkey_hashfn(u16 pkey)
+{
+	return (pkey & (SEL_PKEY_HASH_SIZE - 1));
+}
+
+/**
+ * sel_ib_pkey_find - Search for a pkey record
+ * @subnet_prefix: subnet_prefix
+ * @pkey_num: pkey_num
+ *
+ * Description:
+ * Search the pkey table and return the matching record.  If an entry
+ * can not be found in the table return NULL.
+ *
+ */
+static struct sel_ib_pkey *sel_ib_pkey_find(u64 subnet_prefix, u16 pkey_num)
+{
+	unsigned int idx;
+	struct sel_ib_pkey *pkey;
+
+	idx = sel_ib_pkey_hashfn(pkey_num);
+	list_for_each_entry_rcu(pkey, &sel_ib_pkey_hash[idx].list, list) {
+		if (pkey->psec.pkey == pkey_num &&
+		    pkey->psec.subnet_prefix == subnet_prefix)
+			return pkey;
+	}
+
+	return NULL;
+}
+
+/**
+ * sel_ib_pkey_insert - Insert a new pkey into the table
+ * @pkey: the new pkey record
+ *
+ * Description:
+ * Add a new pkey record to the hash table.
+ *
+ */
+static void sel_ib_pkey_insert(struct sel_ib_pkey *pkey)
+{
+	unsigned int idx;
+
+	/* we need to impose a limit on the growth of the hash table so check
+	 * this bucket to make sure it is within the specified bounds
+	 */
+	idx = sel_ib_pkey_hashfn(pkey->psec.pkey);
+	list_add_rcu(&pkey->list, &sel_ib_pkey_hash[idx].list);
+	if (sel_ib_pkey_hash[idx].size == SEL_PKEY_HASH_BKT_LIMIT) {
+		struct sel_ib_pkey *tail;
+
+		tail = list_entry(
+			rcu_dereference_protected(
+				sel_ib_pkey_hash[idx].list.prev,
+				lockdep_is_held(&sel_ib_pkey_lock)),
+			struct sel_ib_pkey, list);
+		list_del_rcu(&tail->list);
+		kfree_rcu(tail, rcu);
+	} else {
+		sel_ib_pkey_hash[idx].size++;
+	}
+}
+
+/**
+ * sel_ib_pkey_sid_slow - Lookup the SID of a pkey using the policy
+ * @subnet_prefix: subnet prefix
+ * @pkey_num: pkey number
+ * @sid: pkey SID
+ *
+ * Description:
+ * This function determines the SID of a pkey by querying the security
+ * policy.  The result is added to the pkey table to speedup future
+ * queries.  Returns zero on success, negative values on failure.
+ *
+ */
+static int sel_ib_pkey_sid_slow(u64 subnet_prefix, u16 pkey_num, u32 *sid)
+{
+	int ret;
+	struct sel_ib_pkey *pkey;
+	struct sel_ib_pkey *new = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&sel_ib_pkey_lock, flags);
+	pkey = sel_ib_pkey_find(subnet_prefix, pkey_num);
+	if (pkey) {
+		*sid = pkey->psec.sid;
+		spin_unlock_irqrestore(&sel_ib_pkey_lock, flags);
+		return 0;
+	}
+
+	ret = security_ib_pkey_sid(subnet_prefix, pkey_num, sid);
+	if (ret)
+		goto out;
+
+	/* If this memory allocation fails still return 0. The SID
+	 * is valid, it just won't be added to the cache.
+	 */
+	new = kzalloc(sizeof(*new), GFP_ATOMIC);
+	if (!new)
+		goto out;
+
+	new->psec.subnet_prefix = subnet_prefix;
+	new->psec.pkey = pkey_num;
+	new->psec.sid = *sid;
+	sel_ib_pkey_insert(new);
+
+out:
+	spin_unlock_irqrestore(&sel_ib_pkey_lock, flags);
+	return ret;
+}
+
+/**
+ * sel_ib_pkey_sid - Lookup the SID of a PKEY
+ * @subnet_prefix: subnet_prefix
+ * @pkey_num: pkey number
+ * @sid: pkey SID
+ *
+ * Description:
+ * This function determines the SID of a PKEY using the fastest method
+ * possible.  First the pkey table is queried, but if an entry can't be found
+ * then the policy is queried and the result is added to the table to speedup
+ * future queries.  Returns zero on success, negative values on failure.
+ *
+ */
+int sel_ib_pkey_sid(u64 subnet_prefix, u16 pkey_num, u32 *sid)
+{
+	struct sel_ib_pkey *pkey;
+
+	rcu_read_lock();
+	pkey = sel_ib_pkey_find(subnet_prefix, pkey_num);
+	if (pkey) {
+		*sid = pkey->psec.sid;
+		rcu_read_unlock();
+		return 0;
+	}
+	rcu_read_unlock();
+
+	return sel_ib_pkey_sid_slow(subnet_prefix, pkey_num, sid);
+}
+
+/**
+ * sel_ib_pkey_flush - Flush the entire pkey table
+ *
+ * Description:
+ * Remove all entries from the pkey table
+ *
+ */
+void sel_ib_pkey_flush(void)
+{
+	unsigned int idx;
+	struct sel_ib_pkey *pkey, *pkey_tmp;
+	unsigned long flags;
+
+	spin_lock_irqsave(&sel_ib_pkey_lock, flags);
+	for (idx = 0; idx < SEL_PKEY_HASH_SIZE; idx++) {
+		list_for_each_entry_safe(pkey, pkey_tmp,
+					 &sel_ib_pkey_hash[idx].list, list) {
+			list_del_rcu(&pkey->list);
+			kfree_rcu(pkey, rcu);
+		}
+		sel_ib_pkey_hash[idx].size = 0;
+	}
+	spin_unlock_irqrestore(&sel_ib_pkey_lock, flags);
+}
+
+static __init int sel_ib_pkey_init(void)
+{
+	int iter;
+
+	if (!selinux_enabled)
+		return 0;
+
+	for (iter = 0; iter < SEL_PKEY_HASH_SIZE; iter++) {
+		INIT_LIST_HEAD(&sel_ib_pkey_hash[iter].list);
+		sel_ib_pkey_hash[iter].size = 0;
+	}
+
+	return 0;
+}
+
+subsys_initcall(sel_ib_pkey_init);
diff --git a/security/selinux/include/ibpkey.h b/security/selinux/include/ibpkey.h
new file mode 100644
index 0000000..b17a19e
--- /dev/null
+++ b/security/selinux/include/ibpkey.h
@@ -0,0 +1,31 @@
+/*
+ * pkey table
+ *
+ * SELinux must keep a mapping of pkeys to labels/SIDs.  This
+ * mapping is maintained as part of the normal policy but a fast cache is
+ * needed to reduce the lookup overhead.
+ *
+ */
+
+/*
+ * (c) Mellanox Technologies, 2016
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef _SELINUX_IB_PKEY_H
+#define _SELINUX_IB_PKEY_H
+
+void sel_ib_pkey_flush(void);
+
+int sel_ib_pkey_sid(u64 subnet_prefix, u16 pkey, u32 *sid);
+
+#endif
diff --git a/security/selinux/include/objsec.h b/security/selinux/include/objsec.h
index b7f15f7..6ebc61e 100644
--- a/security/selinux/include/objsec.h
+++ b/security/selinux/include/objsec.h
@@ -144,6 +144,12 @@ struct ib_security_struct {
 	u32 sid;        /* SID of the queue pair or MAD agent */
 };
 
+struct pkey_security_struct {
+	u64	subnet_prefix; /* Port subnet prefix */
+	u16	pkey;	/* PKey number */
+	u32	sid;	/* SID of pkey */
+};
+
 extern unsigned int selinux_checkreqprot;
 
 #endif /* _SELINUX_OBJSEC_H_ */
-- 
2.7.4


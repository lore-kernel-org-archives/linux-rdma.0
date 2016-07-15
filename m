From: kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 9/9] selinux: Add a cache for quicker retreival of
 PKey SIDs
Date: Fri, 15 Jul 2016 17:06:23 +0800
Message-ID: <201607151753.7mPKKPSZ%fengguang.wu@intel.com>
References: <1468537011-20407-10-git-send-email-danielj@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1468537011-20407-10-git-send-email-danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: kbuild-all-JC7UmRfGjtg@public.gmane.org, chrisw-69jw2NvuJkxg9hUCZPvPmw@public.gmane.org, paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org, sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

[auto build test WARNING on next-20160713]
[cannot apply to pcmoore-selinux/next rdma/master v4.7-rc7 v4.7-rc6 v4.7-rc5 v4.7-rc7]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Dan-Jurgens/SELinux-support-for-Infiniband-RDMA/20160715-122805
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

   include/linux/compiler.h:232:8: sparse: attribute 'no_sanitize_address': unknown attribute
>> security/selinux/ibpkey.c:116:24: sparse: incompatible types in comparison expression (different address spaces)

vim +116 security/selinux/ibpkey.c

   100	 * Description:
   101	 * Add a new pkey record to the hash table.
   102	 *
   103	 */
   104	static void sel_pkey_insert(struct sel_pkey *pkey)
   105	{
   106		unsigned int idx;
   107	
   108		/* we need to impose a limit on the growth of the hash table so check
   109		 * this bucket to make sure it is within the specified bounds
   110		 */
   111		idx = sel_pkey_hashfn(pkey->psec.pkey);
   112		list_add_rcu(&pkey->list, &sel_pkey_hash[idx].list);
   113		if (sel_pkey_hash[idx].size == SEL_PKEY_HASH_BKT_LIMIT) {
   114			struct sel_pkey *tail;
   115	
 > 116			tail = list_entry(
   117				rcu_dereference_protected(
   118					sel_pkey_hash[idx].list.prev,
   119					lockdep_is_held(&sel_pkey_lock)),
   120				struct sel_pkey, list);
   121			list_del_rcu(&tail->list);
   122			kfree_rcu(tail, rcu);
   123		} else {
   124			sel_pkey_hash[idx].size++;

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

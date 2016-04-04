From: Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>
Subject: Re: [RFC PATCH 1/7] security: Add LSM hooks for Infiniband security
Date: Mon, 4 Apr 2016 16:48:46 -0700
Message-ID: <5702FD5E.9010003@schaufler-ca.com>
References: <1459806504-16135-1-git-send-email-danielj@mellanox.com>
 <1459806504-16135-2-git-send-email-danielj@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <selinux-bounces-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
In-Reply-To: <1459806504-16135-2-git-send-email-danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Post: <mailto:selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
List-Help: <mailto:selinux-request-+05T5uksL2qpZYMLLGbcSA@public.gmane.org?subject=help>
Errors-To: selinux-bounces-+05T5uksL2qpZYMLLGbcSA@public.gmane.org
Sender: "Selinux" <selinux-bounces-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
To: Dan Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 4/4/2016 2:48 PM, Dan Jurgens wrote:
> From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> Add five new hooks
>  1. Allocate security contexts for Infiniband objects
>  2. Free security contexts for Infiniband objects
>  3. Enforce access to Pkeys
>  4. Enforce access to Infiniband devices subnet management interfaces.
>  5. A hook to be implemented by IB core to receive notifications of
>     security policy or enforcement changes.  Restricting a QPs access to
>     a pkey will be done during setup and not on a per packet basis
>     access must be enforced again.
>
> Because IB core is usually compiled as a module it must be able to
> delete it's hooks.  Remove the SELinux specific ifdef around
> security_delete_hooks and update the comment.  Also EXPORT_SYMBOL for
> security_hook_heads so IB core can access it to add and delete the hook.

The LSM infrastructure does not actually support dynamic
loading and unloading of modules. It happens that the SELinux
code is structured so that it can be safely unloaded if
the policy has not been loaded.

> Signed-off-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  include/linux/lsm_hooks.h |   43 ++++++++++++++++++++++++++++++++-----
>  include/linux/security.h  |   37 ++++++++++++++++++++++++++++++++
>  security/Kconfig          |    9 +++++++
>  security/security.c       |   52 +++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 135 insertions(+), 6 deletions(-)
>
> diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
> index 71969de..c0c7a40 100644
> --- a/include/linux/lsm_hooks.h
> +++ b/include/linux/lsm_hooks.h
> @@ -8,6 +8,7 @@
>   * Copyright (C) 2001 Silicon Graphics, Inc. (Trust Technology Group)
>   * Copyright (C) 2015 Intel Corporation.
>   * Copyright (C) 2015 Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>
> + * Copyright (C) 2016 Mellanox Techonologies. <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>   *
>   *	This program is free software; you can redistribute it and/or modify
>   *	it under the terms of the GNU General Public License as published by
> @@ -877,6 +878,21 @@
>   *	associated with the TUN device's security structure.
>   *	@security pointer to the TUN devices's security structure.
>   *
> + * Security hooks for Infiniband
> + *
> + * @pkey_access:
> + *	Check permission when modifing a QP or transmitting and receiving MADs.
> + * @ibdev_smi:
> + *	Check permissions to access the devices subnet management interface (SMI).
> + * @infiniband_alloc_security:
> + *	Allocate a security structure to be used by Infiniband QPs and MAD
> + *	agents.
> + * @infiniband_free_security:
> + *	Free an Infiniband security structure.
> + * @infiniband_flush:
> + *	Security modules can use this hook to notify IB core of policy changes
> + *	or when enforcement changes.
> + *
>   * Security hooks for XFRM operations.
>   *
>   * @xfrm_policy_alloc_security:
> @@ -1577,6 +1593,14 @@ union security_list_options {
>  	int (*tun_dev_open)(void *security);
>  #endif	/* CONFIG_SECURITY_NETWORK */
>  
> +#ifdef CONFIG_SECURITY_INFINIBAND
> +	int (*pkey_access)(u64 subnet_prefix, u16 pkey, void *security);
> +	int (*ibdev_smi)(const char *dev_name, u8 port, void *security);
> +	int (*infiniband_alloc_security)(void **security);
> +	void (*infiniband_free_security)(void *security);

Please attach the security blobs to objects (like an inode) rather
than just passing a blob pointer. It's going to make module stacking
lots easier. 

> +	void (*infiniband_flush)(void);
> +#endif	/* CONFIG_SECURITY_INFINIBAND */
> +
>  #ifdef CONFIG_SECURITY_NETWORK_XFRM
>  	int (*xfrm_policy_alloc_security)(struct xfrm_sec_ctx **ctxp,
>  					  struct xfrm_user_sec_ctx *sec_ctx,
> @@ -1805,6 +1829,13 @@ struct security_hook_heads {
>  	struct list_head tun_dev_open;
>  	struct list_head skb_owned_by;
>  #endif	/* CONFIG_SECURITY_NETWORK */
> +#ifdef CONFIG_SECURITY_INFINIBAND
> +	struct list_head pkey_access;
> +	struct list_head ibdev_smi;
> +	struct list_head infiniband_alloc_security;
> +	struct list_head infiniband_free_security;
> +	struct list_head infiniband_flush;
> +#endif	/* CONFIG_SECURITY_INFINIBAND */
>  #ifdef CONFIG_SECURITY_NETWORK_XFRM
>  	struct list_head xfrm_policy_alloc_security;
>  	struct list_head xfrm_policy_clone_security;
> @@ -1862,7 +1893,6 @@ static inline void security_add_hooks(struct security_hook_list *hooks,
>  		list_add_tail_rcu(&hooks[i].list, hooks[i].head);
>  }
>  
> -#ifdef CONFIG_SECURITY_SELINUX_DISABLE
>  /*
>   * Assuring the safety of deleting a security module is up to
>   * the security module involved. This may entail ordering the
> @@ -1870,10 +1900,12 @@ static inline void security_add_hooks(struct security_hook_list *hooks,
>   * the module once a policy is loaded or any number of other
>   * actions better imagined than described.
>   *
> - * The name of the configuration option reflects the only module
> - * that currently uses the mechanism. Any developer who thinks
> - * disabling their module is a good idea needs to be at least as
> - * careful as the SELinux team.
> + * Any developer who thinks disabling their module is a good
> + * idea needs to be at least as careful as the SELinux team.
> + *
> + * ib_core is usually built as a module.  It may register a
> + * single instance to a single hook (infiniband_flush), and
> + * must be able to delete it when the module is unloaded.
>   */
>  static inline void security_delete_hooks(struct security_hook_list *hooks,
>  						int count)
> @@ -1883,7 +1915,6 @@ static inline void security_delete_hooks(struct security_hook_list *hooks,
>  	for (i = 0; i < count; i++)
>  		list_del_rcu(&hooks[i].list);
>  }
> -#endif /* CONFIG_SECURITY_SELINUX_DISABLE */
>  
>  extern int __init security_module_enable(const char *module);
>  extern void __init capability_add_hooks(void);
> diff --git a/include/linux/security.h b/include/linux/security.h
> index 4824a4c..fde0a92 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -6,6 +6,7 @@
>   * Copyright (C) 2001 Networks Associates Technology, Inc <ssmalley-M06CiZnz2FM@public.gmane.org>
>   * Copyright (C) 2001 James Morris <jmorris-G2x6lROWQUcJY7gZg3T8ig@public.gmane.org>
>   * Copyright (C) 2001 Silicon Graphics, Inc. (Trust Technology Group)
> + * Copyright (C) 2016 Mellanox Techonologies. <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>   *
>   *	This program is free software; you can redistribute it and/or modify
>   *	it under the terms of the GNU General Public License as published by
> @@ -1350,6 +1351,42 @@ static inline int security_tun_dev_open(void *security)
>  }
>  #endif	/* CONFIG_SECURITY_NETWORK */
>  
> +#ifdef CONFIG_SECURITY_INFINIBAND
> +int security_pkey_access(u64 subnet_prefix, u16 pkey, void *security);
> +int security_ibdev_smi(const char *dev_name, u8 port, void *security);
> +int security_infiniband_alloc_security(void **security);
> +void security_infiniband_free_security(void *security);
> +void security_infiniband_flush(void);
> +#else	/* CONFIG_SECURITY_INFINIBAND */
> +static inline int security_pkey_access(u64 subnet_prefix,
> +				       u16 pkey,
> +				       void *security)
> +{
> +	return 0;
> +}
> +
> +static inline int security_ibdev_smi(const char *dev_name,
> +				     u8 port,
> +				     void *security)
> +{
> +	return 0;
> +}
> +
> +static inline int security_infiniband_alloc_security(void **security)
> +{
> +	*security = NULL;
> +	return 0;
> +}
> +
> +static inline void security_infiniband_free_security(void *security)
> +{
> +}
> +
> +static inline void security_infiniband_flush(void)
> +{
> +}
> +#endif	/* CONFIG_SECURITY_INFINIBAND */
> +
>  #ifdef CONFIG_SECURITY_NETWORK_XFRM
>  
>  int security_xfrm_policy_alloc(struct xfrm_sec_ctx **ctxp,
> diff --git a/security/Kconfig b/security/Kconfig
> index e452378..bac790a 100644
> --- a/security/Kconfig
> +++ b/security/Kconfig
> @@ -49,6 +49,15 @@ config SECURITY_NETWORK
>  	  implement socket and networking access controls.
>  	  If you are unsure how to answer this question, answer N.
>  
> +config SECURITY_INFINIBAND
> +	bool "Infiniband Security Hooks"
> +	depends on SECURITY && INFINIBAND
> +	help
> +	  This enables the Infiniband security hooks.
> +	  If enabled, a security module can use these hooks to
> +	  implement Infiniband access controls.
> +	  If you are unsure how to answer this question, answer N.
> +
>  config SECURITY_NETWORK_XFRM
>  	bool "XFRM (IPSec) Networking Security Hooks"
>  	depends on XFRM && SECURITY_NETWORK
> diff --git a/security/security.c b/security/security.c
> index e8ffd92..a3e3e35 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -4,6 +4,7 @@
>   * Copyright (C) 2001 WireX Communications, Inc <chris-ZMHXrckZAt0AvxtiuMwx3w@public.gmane.org>
>   * Copyright (C) 2001-2002 Greg Kroah-Hartman <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
>   * Copyright (C) 2001 Networks Associates Technology, Inc <ssmalley-M06CiZnz2FM@public.gmane.org>
> + * Copyright (C) 2016 Mellanox Technologies.  <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>   *
>   *	This program is free software; you can redistribute it and/or modify
>   *	it under the terms of the GNU General Public License as published by
> @@ -1396,6 +1397,44 @@ EXPORT_SYMBOL(security_tun_dev_open);
>  
>  #endif	/* CONFIG_SECURITY_NETWORK */
>  
> +#ifdef CONFIG_SECURITY_INFINIBAND
> +
> +int security_pkey_access(u64 subnet_prefix, u16 pkey, void *security)
> +{
> +	return call_int_hook(pkey_access,
> +			0,
> +			subnet_prefix,
> +			pkey,
> +			security);

Please stick with the local convention for parameters.

	return call_int_hook(pkey_access, 0, subnet_perfix, pkey, security);

all on one line.
 

> +}
> +EXPORT_SYMBOL(security_pkey_access);
> +
> +int security_ibdev_smi(const char *dev_name, u8 port, void *security)
> +{
> +	return call_int_hook(ibdev_smi, 0, dev_name, port, security);
> +}
> +EXPORT_SYMBOL(security_ibdev_smi);
> +
> +int security_infiniband_alloc_security(void **security)
> +{
> +	return call_int_hook(infiniband_alloc_security, 0, security);
> +}
> +EXPORT_SYMBOL(security_infiniband_alloc_security);
> +
> +void security_infiniband_free_security(void *security)
> +{
> +	call_void_hook(infiniband_free_security, security);
> +}
> +EXPORT_SYMBOL(security_infiniband_free_security);
> +
> +void security_infiniband_flush(void)
> +{
> +	call_void_hook(infiniband_flush);
> +}
> +EXPORT_SYMBOL(security_infiniband_flush);
> +
> +#endif	/* CONFIG_SECURITY_INFINIBAND */
> +
>  #ifdef CONFIG_SECURITY_NETWORK_XFRM
>  
>  int security_xfrm_policy_alloc(struct xfrm_sec_ctx **ctxp,
> @@ -1848,6 +1887,18 @@ struct security_hook_heads security_hook_heads = {
>  	.tun_dev_open =	LIST_HEAD_INIT(security_hook_heads.tun_dev_open),
>  	.skb_owned_by =	LIST_HEAD_INIT(security_hook_heads.skb_owned_by),
>  #endif	/* CONFIG_SECURITY_NETWORK */
> +
> +#ifdef CONFIG_SECURITY_INFINIBAND
> +	.pkey_access = LIST_HEAD_INIT(security_hook_heads.pkey_access),
> +	.ibdev_smi = LIST_HEAD_INIT(security_hook_heads.ibdev_smi),
> +	.infiniband_alloc_security =
> +		LIST_HEAD_INIT(security_hook_heads.infiniband_alloc_security),
> +	.infiniband_free_security =
> +		LIST_HEAD_INIT(security_hook_heads.infiniband_free_security),
> +	.infiniband_flush =
> +		LIST_HEAD_INIT(security_hook_heads.infiniband_flush),
> +#endif	/* CONFIG_SECURITY_INFINIBAND */
> +
>  #ifdef CONFIG_SECURITY_NETWORK_XFRM
>  	.xfrm_policy_alloc_security =
>  		LIST_HEAD_INIT(security_hook_heads.xfrm_policy_alloc_security),
> @@ -1891,3 +1942,4 @@ struct security_hook_heads security_hook_heads = {
>  		LIST_HEAD_INIT(security_hook_heads.audit_rule_free),
>  #endif /* CONFIG_AUDIT */
>  };
> +EXPORT_SYMBOL(security_hook_heads);

_______________________________________________
Selinux mailing list
Selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org
To unsubscribe, send email to Selinux-leave-+05T5uksL2pAGbPMOrvdOA@public.gmane.org
To get help, send an email containing "help" to Selinux-request-+05T5uksL2pAGbPMOrvdOA@public.gmane.org

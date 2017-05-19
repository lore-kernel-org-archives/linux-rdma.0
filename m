From: Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>
Subject: Re: [PATCH v7 2/9] IB/core: Enforce PKey security on QPs
Date: Fri, 19 May 2017 15:13:06 -0400
Message-ID: <CAHC9VhQw79kMRoXQ-tkk41cUaYZywxYfBpYtHhyzfpZJLZsMYA@mail.gmail.com>
References: <1495198139-69993-1-git-send-email-danielj@mellanox.com> <1495198139-69993-3-git-send-email-danielj@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1495198139-69993-3-git-send-email-danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: chrisw-69jw2NvuJkxg9hUCZPvPmw@public.gmane.org, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, Eric Paris <eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, May 19, 2017 at 8:48 AM, Dan Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> Add new LSM hooks to allocate and free security contexts and check for
> permission to access a PKey.

...

> diff --git a/security/security.c b/security/security.c
> index 54b1e39..a142a0b 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -4,6 +4,7 @@
>   * Copyright (C) 2001 WireX Communications, Inc <chris-ZMHXrckZAt0AvxtiuMwx3w@public.gmane.org>
>   * Copyright (C) 2001-2002 Greg Kroah-Hartman <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
>   * Copyright (C) 2001 Networks Associates Technology, Inc <ssmalley-M06CiZnz2FM@public.gmane.org>
> + * Copyright (C) 2016 Mellanox Technologies
>   *
>   *     This program is free software; you can redistribute it and/or modify
>   *     it under the terms of the GNU General Public License as published by
> @@ -1511,6 +1512,27 @@ EXPORT_SYMBOL(security_tun_dev_open);
>
>  #endif /* CONFIG_SECURITY_NETWORK */
>
> +#ifdef CONFIG_SECURITY_INFINIBAND
> +
> +int security_ib_pkey_access(void *sec, u64 subnet_prefix, u16 pkey)
> +{
> +       return call_int_hook(ib_pkey_access, 0, sec, subnet_prefix, pkey);
> +}
> +EXPORT_SYMBOL(security_ib_pkey_access);
> +
> +int security_ib_alloc_security(void **sec)
> +{
> +       return call_int_hook(ib_alloc_security, 0, sec);
> +}
> +EXPORT_SYMBOL(security_ib_alloc_security);
> +
> +void security_ib_free_security(void *sec)
> +{
> +       call_void_hook(ib_free_security, sec);
> +}
> +EXPORT_SYMBOL(security_ib_free_security);
> +#endif /* CONFIG_SECURITY_INFINIBAND */
> +
>  #ifdef CONFIG_SECURITY_NETWORK_XFRM
>
>  int security_xfrm_policy_alloc(struct xfrm_sec_ctx **ctxp,
> @@ -1658,3 +1680,366 @@ int security_audit_rule_match(u32 secid, u32 field, u32 op, void *lsmrule,
>                                 actx);
>  }
>  #endif /* CONFIG_AUDIT */
> +
> +struct security_hook_heads security_hook_heads __lsm_ro_after_init = {
> +       .binder_set_context_mgr =
> +               LIST_HEAD_INIT(security_hook_heads.binder_set_context_mgr),
> +       .binder_transaction =
> +               LIST_HEAD_INIT(security_hook_heads.binder_transaction),
> +       .binder_transfer_binder =
> +               LIST_HEAD_INIT(security_hook_heads.binder_transfer_binder),
> +       .binder_transfer_file =
> +               LIST_HEAD_INIT(security_hook_heads.binder_transfer_file),

FYI, the security_hook_heads initialization was recently removed in
3dfc9b02864b ("LSM: Initialize security_hook_heads upon
registration."), you don't need this code in your patch anymore.

In the interest of moving things along I'm going to drop this block
from the patch (it's trivial), but please make note in case a respin
is needed.

-- 
paul moore
www.paul-moore.com
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 03/12] selinux: Implement Infiniband flush callback
Date: Thu, 30 Jun 2016 18:10:06 +0300
Message-ID: <20160630151005.GC22107@yuval-lap.uk.oracle.com>
References: <1466711578-64398-1-git-send-email-danielj@mellanox.com>
 <1466711578-64398-4-git-send-email-danielj@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1466711578-64398-4-git-send-email-danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: chrisw-69jw2NvuJkxg9hUCZPvPmw@public.gmane.org, paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org, sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 23, 2016 at 10:52:49PM +0300, Dan Jurgens wrote:
> From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> Because access for infiniband is enforced in the setup phase of a
> connection there must be a way to notify ib_core if the policy or
> enforcement setting have changed.
> 
> Added register and unregister_ib_flush_callback hooks so infiniband can
> setup notification of policy and enforment changes.  In the AVC reset

Extra space before " In"

> callback function call the ib_flush callback if it's registered. Also
> renamed the callback function, the previous name was 'net' specific.
> 
> Signed-off-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  security/selinux/hooks.c | 36 ++++++++++++++++++++++++++++++++++--
>  1 file changed, 34 insertions(+), 2 deletions(-)
> 
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index a86d537..6a8841d 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -94,6 +94,9 @@
>  #include "audit.h"
>  #include "avc_ss.h"
>  
> +static void (*ib_flush_callback)(void);

Do we really want to have such ib_ prefix in security/ directory?

> +static DEFINE_MUTEX(ib_flush_mutex);
> +
>  /* SECMARK reference count */
>  static atomic_t selinux_secmark_refcount = ATOMIC_INIT(0);
>  
> @@ -159,13 +162,17 @@ static int selinux_peerlbl_enabled(void)
>  	return (selinux_policycap_alwaysnetwork || netlbl_enabled() || selinux_xfrm_enabled());
>  }
>  
> -static int selinux_netcache_avc_callback(u32 event)
> +static int selinux_cache_avc_callback(u32 event)
>  {
>  	if (event == AVC_CALLBACK_RESET) {
>  		sel_netif_flush();
>  		sel_netnode_flush();
>  		sel_netport_flush();
>  		synchronize_net();
> +		mutex_lock(&ib_flush_mutex);

Suggesting to have the lock inside the callback (unless you accept my
suggestion below)

> +		if (ib_flush_callback)
> +			ib_flush_callback();

How about some generic mechanism (such as a list) in case more
modules/drivers would like to register callbacks?
( assuming this is no longer RFC :) )

> +		mutex_unlock(&ib_flush_mutex);
>  	}
>  	return 0;
>  }
> @@ -5993,6 +6000,23 @@ static int selinux_key_getsecurity(struct key *key, char **_buffer)
>  
>  #endif
>  
> +#ifdef CONFIG_SECURITY_INFINIBAND
> +static void selinux_register_ib_flush_callback(void (*callback)(void))
> +{
> +	mutex_lock(&ib_flush_mutex);
> +	ib_flush_callback = callback;
> +	mutex_unlock(&ib_flush_mutex);
> +}
> +
> +static void selinux_unregister_ib_flush_callback(void)
> +{
> +	mutex_lock(&ib_flush_mutex);
> +	ib_flush_callback = NULL;
> +	mutex_unlock(&ib_flush_mutex);
> +}
> +
> +#endif
> +
>  static struct security_hook_list selinux_hooks[] = {
>  	LSM_HOOK_INIT(binder_set_context_mgr, selinux_binder_set_context_mgr),
>  	LSM_HOOK_INIT(binder_transaction, selinux_binder_transaction),
> @@ -6174,6 +6198,12 @@ static struct security_hook_list selinux_hooks[] = {
>  	LSM_HOOK_INIT(tun_dev_attach_queue, selinux_tun_dev_attach_queue),
>  	LSM_HOOK_INIT(tun_dev_attach, selinux_tun_dev_attach),
>  	LSM_HOOK_INIT(tun_dev_open, selinux_tun_dev_open),
> +#ifdef CONFIG_SECURITY_INFINIBAND
> +	LSM_HOOK_INIT(register_ib_flush_callback,
> +		      selinux_register_ib_flush_callback),
> +	LSM_HOOK_INIT(unregister_ib_flush_callback,
> +		      selinux_unregister_ib_flush_callback),
> +#endif
>  
>  #ifdef CONFIG_SECURITY_NETWORK_XFRM
>  	LSM_HOOK_INIT(xfrm_policy_alloc_security, selinux_xfrm_policy_alloc),
> @@ -6233,9 +6263,11 @@ static __init int selinux_init(void)
>  					    0, SLAB_PANIC, NULL);
>  	avc_init();
>  
> +	ib_flush_callback = NULL;
> +
>  	security_add_hooks(selinux_hooks, ARRAY_SIZE(selinux_hooks));
>  
> -	if (avc_add_callback(selinux_netcache_avc_callback, AVC_CALLBACK_RESET))
> +	if (avc_add_callback(selinux_cache_avc_callback, AVC_CALLBACK_RESET))
>  		panic("SELinux: Unable to register AVC netcache callback\n");
>  
>  	if (selinux_enforcing)
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

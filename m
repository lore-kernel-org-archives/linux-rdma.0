From: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH rdma-next V2 5/5] IB/core: Integrate IB address resolution
 module into core
Date: Wed, 18 May 2016 06:43:07 +0000
Message-ID: <VI1PR05MB13910C6D09E0B6B9D477B1EAD2490@VI1PR05MB1391.eurprd05.prod.outlook.com>
References: <1462563928-29164-1-git-send-email-leon@kernel.org>
 <1462563928-29164-6-git-send-email-leon@kernel.org>
 <ea50f1d2-6f05-66f7-18f7-0a569fd9cea5@redhat.com>
 <VI1PR05MB1391AD099C536541E79A09F9D2760@VI1PR05MB1391.eurprd05.prod.outlook.com>
 <db369e8e-7993-dfb8-d459-2c4f3d6e5b14@redhat.com>
 <20160516163048.GB4662@leon.nu>
 <298657b0-6e57-745b-5eb3-001984bffbc3@redhat.com>
 <VI1PR05MB13915036338162B126E55CC2D2480@VI1PR05MB1391.eurprd05.prod.outlook.com>
 <eea7049c-5a27-1498-8e8b-674d69468fbb@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <eea7049c-5a27-1498-8e8b-674d69468fbb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Doug Ledford [mailto:dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org]
> Sent: Tuesday, May 17, 2016 6:49 PM
> To: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [PATCH rdma-next V2 5/5] IB/core: Integrate IB address
> resolution module into core
> 
> On 05/17/2016 04:29 AM, Mark Bloch wrote:
> >
> >
> >> -----Original Message-----
> >> From: Doug Ledford [mailto:dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org]
> >> Sent: Monday, May 16, 2016 8:43 PM
> >> To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
> >> Cc: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >> Subject: Re: [PATCH rdma-next V2 5/5] IB/core: Integrate IB address
> >> resolution module into core
> >> Can you build netlink in and then init the ib_addr module after the
> >> netlink init is complete?  Wouldn't that resolve the dependency ordering
> >> issue without changing the module names?
> > Sorry, but I don't understand what do you mean by this.
> > If you would like to keep the current module structure (ib_core.ko and
> ib_addr.ko)
> > The only way to use ibnl from within addr.c is to move the ibnl initialization
> to addr.c
> > and build netlink.c as part of ib_addr.ko, but it seems kind of strange if
> > ib_addr is responsible to initialize ibnl.
> 
> Not according to what I was looking at.  In the original patch, you
> moved addr.c into ib_core and changed addr_init and addr_cleanup from
> static to normal.  You were then able to control whether the addr code
> went before or after the netlink code by rearranging the order of init
> sequences in device.c:ib_core_init().  It is entirely possible that you
> could leave ib_addr as a module, change addr_init to rdma_addr_init and
> EXPORT_SYMBOL it, and likewise with the cleanup function, and remove the
> module_init(addr_init); and module_exit(addr_cleanup); from the addr.c
> file.  This would then allow you to control when ib_addr was inited by
> adding a call to rdma_addr_init() in device.c:ib_core_init() just like
> you had in your patch.  It would solve the problem and give you complete
> control while being transparent to user space.  This is what I mean:
> 
> commit ec5394412286e325b83b6c64d026f4d7bab40ccd
> Author: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Date:   Tue May 17 11:43:57 2016 -0400
> 
>     IB/core: change module init ordering
> 
>     Change ib_addr to be init'ed by ib_core and not by the module load
>     process.  This gives us precise controle of when the module is
>     initialized while still preserving the existing module names and load
>     ordering.  This is to be backward compatible with existing, older
>     SysV init scripts.  When those older systems are dead and gone, we
>     can revisit this and change the module names and load orders however
>     we want.
> 
>     Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 
> diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
> index 337353d86cfa..fda808546e0e 100644
> --- a/drivers/infiniband/core/addr.c
> +++ b/drivers/infiniband/core/addr.c
> @@ -634,7 +634,17 @@ static struct notifier_block nb = {
>         .notifier_call = netevent_callback
>  };
> 
> -static int __init addr_init(void)
> +/*
> + * This is a little unorthodox.  We export our init function so that the
> + * ib_core module can call it at the right time after the other modules
> + * we depend on have registered.  We do this solely because there are
> some
> + * user space init scripts that expect ib_addr to be loaded prior to
> ib_core
> + * and due to recent changes, we need the ib netlink code brought up
> before
> + * we bring this code up and that code is now in ib_core.  When the older
> + * SysV init script systems that have these init scripts are dead and gone,
> + * we can revisit this and possibly just include addr.c in ib_core.
> + */
> +int rdma_addr_init(void)
>  {
>         addr_wq = create_singlethread_workqueue("ib_addr");
>         if (!addr_wq)
> @@ -644,13 +654,12 @@ static int __init addr_init(void)
>         rdma_addr_register_client(&self);
>         return 0;
>  }
> +EXPORT_SYMBOL(rdma_addr_init);
> 
> -static void __exit addr_cleanup(void)
> +void rdma_addr_cleanup(void)
>  {
>         rdma_addr_unregister_client(&self);
>         unregister_netevent_notifier(&nb);
>         destroy_workqueue(addr_wq);
>  }
> -
> -module_init(addr_init);
> -module_exit(addr_cleanup);
> +EXPORT_SYMBOL(rdma_addr_cleanup);
> diff --git a/drivers/infiniband/core/core_priv.h
> b/drivers/infiniband/core/core_priv.h
> index eab32215756b..e0a5187ea98c 100644
> --- a/drivers/infiniband/core/core_priv.h
> +++ b/drivers/infiniband/core/core_priv.h
> @@ -137,4 +137,7 @@ static inline bool rdma_is_upper_dev_rcu(struct
> net_device *dev,
>         return _upper == upper;
>  }
> 
> +int rdma_addr_init(void);
> +void rdma_addr_cleanup(void);
> +
>  #endif /* _CORE_PRIV_H */
> diff --git a/drivers/infiniband/core/device.c
> b/drivers/infiniband/core/device.c
> index 10979844026a..4fdf87a485cc 100644
> --- a/drivers/infiniband/core/device.c
> +++ b/drivers/infiniband/core/device.c
> @@ -983,10 +983,18 @@ static int __init ib_core_init(void)
>                 goto err_sysfs;
>         }
> 
> +       ret = rdma_addr_init();
> +       if (ret) {
> +               pr_warn("Couldn't init IB address resolution module\n");
> +               goto err_ibnl;
> +       }
> +
>         ib_cache_setup();
> 
>         return 0;
> 
> +err_ibnl:
> +       ibnl_cleanup();
>  err_sysfs:
>         class_unregister(&ib_class);
>  err_comp:
> @@ -999,6 +1007,7 @@ err:
>  static void __exit ib_core_cleanup(void)
>  {
>         ib_cache_cleanup();
> +       rdma_addr_cleanup();
>         ibnl_cleanup();
>         class_unregister(&ib_class);
>         destroy_workqueue(ib_comp_wq);
> 
> 
> 
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>               GPG KeyID: 0E572FDD
> 
I'm not sure it will solve the problem. it has been a while since
I've looked into how Linux handles modules so I might be wrong, but:
When we build a module that has to use a symbol from a different module
The symbol is unresolved (in has no address in the .ko file) the moment we load the module,
The kernel searches for the address of the symbol, maps the module into memory
and writes the correct address.

Now in our case, verbs.c is part of ib_core.ko, and it uses rdma_addr_find_l2_eth_by_grh (which is in addr.c, part of ib_addr.ko)
So the moment we try to load ib_core we need to have ib_addr already in memory (because we need the address of rdma_addr_find_l2_eth_by_grh)
modprobe knows about that (because it sees there is a dependency between ib_core and ib_addr) so it tries to load ib_addr.ko first.
ib_addr uses ibnl, so it has  an unresolved symbol, which means ib_core.ko needs to be loaded before it, this is why we
have a cycle. 

After all the theoretical mambo jambo, I had to check it and this is what I got:
Using your code + my ibnl patches, the module_install step fails:
	depmod: ERROR: Found 2 modules in dependency cycles!
	depmod: ERROR: Cycle detected: ib_core -> ib_addr -> ib_core

Mark.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

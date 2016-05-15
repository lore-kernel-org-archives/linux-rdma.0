From: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH rdma-next V2 5/5] IB/core: Integrate IB address resolution
 module into core
Date: Sun, 15 May 2016 10:51:41 +0000
Message-ID: <VI1PR05MB1391AD099C536541E79A09F9D2760@VI1PR05MB1391.eurprd05.prod.outlook.com>
References: <1462563928-29164-1-git-send-email-leon@kernel.org>
 <1462563928-29164-6-git-send-email-leon@kernel.org>
 <ea50f1d2-6f05-66f7-18f7-0a569fd9cea5@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ea50f1d2-6f05-66f7-18f7-0a569fd9cea5-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Doug Ledford
> Sent: Friday, May 13, 2016 10:34 PM
> To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Subject: Re: [PATCH rdma-next V2 5/5] IB/core: Integrate IB address
> resolution module into core
> 
> On 05/06/2016 03:45 PM, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > IB address resolution is declared as a module (ib_addr.ko) which loads
> > itself before IB core module (ib_core.ko).
> >
> > It causes to the scenario where IB netlink which is initialized by IB
> > core can't be used by ib_addr.ko.
> >
> > In order to solve it, we are converting ib_addr.ko to be part of
> > IB core module.
> 
> > diff --git a/drivers/infiniband/core/device.c
> b/drivers/infiniband/core/device.c
> > index 1097984..8894ad0 100644
> > --- a/drivers/infiniband/core/device.c
> > +++ b/drivers/infiniband/core/device.c
> > @@ -977,16 +977,24 @@ static int __init ib_core_init(void)
> >  		goto err_comp;
> >  	}
> >
> > +	ret = addr_init();
> > +	if (ret) {
> > +		pr_warn("Could't init IB address resolution\n");
> > +		goto err_sysfs;
> > +	}
> > +
> >  	ret = ibnl_init();
> >  	if (ret) {
> >  		pr_warn("Couldn't init IB netlink interface\n");
> > -		goto err_sysfs;
> > +		goto err_addr;
> >  	}
> 
> It's unclear to me how this change helps things.  Theoretically, if you
> load ib_addr before ib_core (and therefore before any ibnl_init() is
> run) and that prevents ib_addr from using the ibnl infrastructure, then
> you would think that building ib_addr into ib_core and then running the
> addr_init() before the ibnl_init() would have exactly the same problem.
> I don't see what issue is resolved by this patch.
You are right, this patch doesn't solve the problem of using ibnl inside ib_addr,
But this patch didn't try to do that, all it did was to integrate ib_addr into ib_core,
It tried to preserve the current order of dependencies . 

If this change is accepted, the order will be switched in the patches that add
ibnl usage inside addr.c, another option is to pull this patch with the correct order
into that series, this way we won't have to touch this area twice.

> But, just as importantly, after reading addr.c to see how it uses the ibnl
> infrastructure, I don't even see what the original problem can be.
As it stands today:
- ibnl is part of ib_core.
- ib_core needs ib_addr.

So if we add ibnl usage to ib_addr it means ib_addr will need ib_core,
which causes a dependency cycle.

> Please elaborate more on what actual problem we are solving with this
> because I am loathe to change the module structure without good cause
> (in particular, I know at least the Red Hat init scripts and systemd
> units know about module names, so this requires changes to user space
> scripts and that's a big no-no if it can be avoided).
> 
> 
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>               GPG KeyID: 0E572FDD
> 


Mark Bloch.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

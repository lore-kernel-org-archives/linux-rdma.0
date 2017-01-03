From: Kenneth Lee <liguozhu-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>
Subject: Re: [PATCH v3] IB/umem: Release pid in error and ODP flow
Date: Tue, 3 Jan 2017 10:32:50 +0800
Message-ID: <20170103023250.GA228559@Turing-Arch-b>
References: <1483093109-188428-1-git-send-email-liguozhu@hisilicon.com>
 <20170101064712.GQ26885@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170101064712.GQ26885-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, robin.murphy-5wv7dgnIgG8@public.gmane.org, jroedel-l3A5Bk7waGM@public.gmane.org, egtvedt-BrfabpQBY5qlHtIdYg32fQ@public.gmane.org, vgupta-HKixBCOQz3hWk0Htik3J/w@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, lstoakes-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, krzk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sebott-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Jan 01, 2017 at 08:47:12AM +0200, Leon Romanovsky wrote:
> Date: Sun, 1 Jan 2017 08:47:12 +0200
> From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> To: Kenneth Lee <liguozhu-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>
> CC: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
>  robin.murphy-5wv7dgnIgG8@public.gmane.org, jroedel-l3A5Bk7waGM@public.gmane.org, egtvedt-BrfabpQBY5qlHtIdYg32fQ@public.gmane.org,
>  vgupta-HKixBCOQz3hWk0Htik3J/w@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, lstoakes-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
>  krzk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sebott-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org,
>  linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [PATCH v3] IB/umem: Release pid in error and ODP flow
> User-Agent: Mutt/1.7.2 (2016-11-26)
> Message-ID: <20170101064712.GQ26885-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
> 
> On Fri, Dec 30, 2016 at 06:18:29PM +0800, Kenneth Lee wrote:
> > There are two bugfixes in this patch:
> >
> > Fixes: 87773dd56d54 ("IB: ib_umem_release() should decrement mm->pinned_vm from ib_umem_get")
> > 	This patch introduce the get_task_pid but not put it back on all error
> > 	path
> >
> > Fixes: 8ada2c1c0c1d ("IB/core: Add support for on demand paging regions")
> > 	This patch introduce a ODP flow without release pid before enter it
> >
> >
> > Signed-off-by: Kenneth Lee <liguozhu-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>
> > Reviewed-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > ---
> > Change from v1 to v2:
> >   Correcting the patch title and description
> > Change from v2 to v3:
> >   Update the title and add "Fixes" fields in the description
> 
> OK,
> 
> I see that you still didn't read Documentation/SubmittingPatches. You
> must read that document before you are sending patches.
> 
> But I'll stop here, the code is correct (it fixes bugs) and commit message
> more usefull than before.
> 
> 
> >
> >  drivers/infiniband/core/umem.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
> > index 1e62a5f..4609b92 100644
> > --- a/drivers/infiniband/core/umem.c
> > +++ b/drivers/infiniband/core/umem.c
> > @@ -134,6 +134,7 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
> >  		 IB_ACCESS_REMOTE_ATOMIC | IB_ACCESS_MW_BIND));
> >
> >  	if (access & IB_ACCESS_ON_DEMAND) {
> > +		put_pid(umem->pid);
> >  		ret = ib_umem_odp_get(context, umem);
> >  		if (ret) {
> >  			kfree(umem);
> > @@ -149,6 +150,7 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
> >
> >  	page_list = (struct page **) __get_free_page(GFP_KERNEL);
> >  	if (!page_list) {
> > +		put_pid(umem->pid);
> >  		kfree(umem);
> >  		return ERR_PTR(-ENOMEM);
> >  	}
> > --
> > 1.9.1
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

Thanks,

I did read the doc, but maybe I mis-understant some points. Could you please
point it out?

And sorry. please ignore the last message. I forget to use a bottom-post style.



-- 
			-Kenneth(Hisilicon)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

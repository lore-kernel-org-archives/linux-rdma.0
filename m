From: Kenneth Lee <liguozhu-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>
Subject: Re: [PATCH v2] ib umem: bugfix: mixed put_pid()s in ib_umem_get()
Date: Fri, 30 Dec 2016 18:24:10 +0800
Message-ID: <20161230102410.GA144330@Turing-Arch-b>
References: <1483000048-183875-1-git-send-email-liguozhu@hisilicon.com>
 <20161229081756.GI26885@mtr-leonro.local>
 <20161230045011.GA79815@Turing-Arch-b>
 <20161230065510.GL26885@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161230065510.GL26885-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, robin.murphy-5wv7dgnIgG8@public.gmane.org, jroedel-l3A5Bk7waGM@public.gmane.org, egtvedt-BrfabpQBY5qlHtIdYg32fQ@public.gmane.org, vgupta-HKixBCOQz3hWk0Htik3J/w@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, lstoakes-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, krzk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sebott-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Dec 30, 2016 at 08:55:10AM +0200, Leon Romanovsky wrote:
> Date: Fri, 30 Dec 2016 08:55:10 +0200
> From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> To: Kenneth Lee <liguozhu-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>
> CC: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
>  robin.murphy-5wv7dgnIgG8@public.gmane.org, jroedel-l3A5Bk7waGM@public.gmane.org, egtvedt-BrfabpQBY5qlHtIdYg32fQ@public.gmane.org,
>  vgupta-HKixBCOQz3hWk0Htik3J/w@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, lstoakes-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
>  krzk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sebott-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org,
>  linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [PATCH v2] ib umem: bugfix: mixed put_pid()s in ib_umem_get()
> User-Agent: Mutt/1.7.2 (2016-11-26)
> Message-ID: <20161230065510.GL26885-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
> 
> On Fri, Dec 30, 2016 at 12:50:11PM +0800, Kenneth Lee wrote:
> > Hi, Leon,
> >
> > 1. I do change the title except for the version number itself:) But my English
> > is quite bad, maybe the title is still quite stupid. I can update it according
> > to your advice.
> 
> Yes, please
> The main points are:
> 1. Remove "bugifix", it is not needed.
> 2. Use description in the title and not function names.
> 
> >
> > 2. I catched the bug by reading the final code, not by bisect-ing the old
> > commit. Do you means I should find out which commit introducing the bug? It will
> > not be easily to say which it is because it is a "missing bug", rather than a
> > "introduced bug". Indicate the commit may not help to remove a patch/commit from
> > the stable tree.
> 
> The fixes line won't cause for removal of commit, but to addition of
> yours on top of their code base.
> 
> git blame is your friend.
> 
> one fixes line is:
> Fixes: 8ada2c1c0c1d ("IB/core: Add support for on demand paging regions")
> 
> and the second line is !!!!! NOT !!!!!, you need to go deeper in the logs !!!!!!
> Fixes: f7c6a7b5d599 ("IB/uverbs: Export ib_umem_get()/ib_umem_release() to modules")
> 
> >
> > Could you please give more suggestion? Thanks.
> 
> Please, don't use top-posting for this mailing list.
> It is really-really annoying.
> 
> >
> > On Thu, Dec 29, 2016 at 10:17:56AM +0200, Leon Romanovsky wrote:
> > > Date: Thu, 29 Dec 2016 10:17:56 +0200
> > > From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > > To: Kenneth Lee <liguozhu-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>
> > > CC: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
> > >  robin.murphy-5wv7dgnIgG8@public.gmane.org, jroedel-l3A5Bk7waGM@public.gmane.org, egtvedt-BrfabpQBY5qlHtIdYg32fQ@public.gmane.org,
> > >  vgupta-HKixBCOQz3hWk0Htik3J/w@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, lstoakes-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
> > >  krzk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sebott-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org,
> > >  linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > Subject: Re: [PATCH v2] ib umem: bugfix: mixed put_pid()s in ib_umem_get()
> > > User-Agent: Mutt/1.7.2 (2016-11-26)
> > > Message-ID: <20161229081756.GI26885-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
> > >
> > > On Thu, Dec 29, 2016 at 04:27:28PM +0800, Kenneth Lee wrote:
> > > > There are two bugfixes in this patch:
> > > >
> > > > 1. When the execution go to the ib_umem_odp_get() path, pid should be put
> > > >    back.
> > > > 2. When the memory allocation fail, the pid also should be put back before
> > > >    exit.
> > > >
> > > > Signed-off-by: Kenneth Lee <liguozhu-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>
> > > > Reviewed-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > > > ---
> > > > Change from v1 to v2:
> > > >   Correcting the patch title and description
> > >
> > > I don't see any changes except version in the title.
> > > What about anything like this?
> > > [PATCH v3] IB/umem: Release pid in error and ODP flows
> > >
> > > And Fixes line please, it will help to forward it to stable trees.
> > >
> > > Thanks
> >
> >
> >
> > --
> > 			-Kenneth(Hisilicon)

Very helpful. Thank you. I will send the Patch v3 soon.

-- 
			-Kenneth(Hisilicon)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

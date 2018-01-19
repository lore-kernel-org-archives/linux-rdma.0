From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next] RDMA/mlx5; Remove redundant allocation warning
 print
Date: Fri, 19 Jan 2018 20:54:28 +0200
Message-ID: <20180119185427.GB2624@yuvallap>
References: <20180118123424.21062-1-leon@kernel.org>
 <20180118200211.GA17561@yuvallap>
 <20180119105840.GA1393@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180119105840.GA1393-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > >
> > > Fixes: d69a24e03659 ("IB/mlx5: Move IB event processing onto a workqueue")
> >
> > Didn't found it in:
> > https://kernel.googlesource.com/pub/scm/linux/kernel/git/leon/linux-rdma/
> > branch rdma-next and didn't find it.
> > Where should i look?
> 
> In official place:
> https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git/commit/?h=for-next&id=d69a24e036596877ce08c25ab8e63a202412fd9e

I see,
I thought that "rdma-next" in subject stands for branch name, apparently
not. So saying rdma-next you actually refer to for-next, right?

> 
> >

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

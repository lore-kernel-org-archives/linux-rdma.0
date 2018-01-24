From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: get_maintainer.pl bug?
Date: Wed, 24 Jan 2018 09:28:02 -0700
Message-ID: <20180124162802.GB16845@ziepe.ca>
References: <20180124112323.GA8265@yuvallap>
 <20180124115445.GH1393@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180124115445.GH1393-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 24, 2018 at 01:54:45PM +0200, Leon Romanovsky wrote:
> On Wed, Jan 24, 2018 at 01:23:24PM +0200, Yuval Shaia wrote:
> > Hi,
> > This is what i get when running scripts/get_maintainer.pl drivers/infiniband/:
> >
> > Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> (supporter:INFINIBAND SUBSYSTEM)
> > Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org> (supporter:INFINIBAND SUBSYSTEM)
> > linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org (open list:INFINIBAND SUBSYSTEM)
> > linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org (open list)
> >
> > However section "INFINIBAND SUBSYSTEM" pointed out a different address for
> > Jason:
> >
> > INFINIBAND SUBSYSTEM
> > M:      Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > M:      Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > L:      linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > W:      http://www.openfabrics.org/
> > Q:      http://patchwork.kernel.org/project/linux-rdma/list/
> > T:      git git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git
> > S:      Supported
> > F:      Documentation/devicetree/bindings/infiniband/
> > F:      Documentation/infiniband/
> > F:      drivers/infiniband/
> > F:      include/uapi/linux/if_infiniband.h
> > F:      include/uapi/rdma/
> > F:      include/rdma/
> >
> > So
> > - Which one is the correct one?
> > - What am i doing wrong when using scripts/get_maintainer.pl?
> 
> Both are correct, and the jgg-uk2M96/98Pc@public.gmane.org email is taken from .mailmap
> file.

Yes, I prefer the ziepe one for bulk/automatic sorts of email, that is
why it is in the mailamp.

Thanks,
Jason

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

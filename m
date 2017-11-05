From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core] librdmacm: Remove unneeded condition
Date: Sun, 5 Nov 2017 11:30:15 +0200
Message-ID: <20171105093014.GA3948@yuvallap>
References: <20171102135134.5728-1-yuval.shaia@oracle.com>
 <1509635426.2484.9.camel@wdc.com>
 <20171102164528.GM18874@ziepe.ca>
 <20171105072657.GF31774@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171105072657.GF31774-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Nov 05, 2017 at 09:26:58AM +0200, Leon Romanovsky wrote:
> On Thu, Nov 02, 2017 at 10:45:28AM -0600, Jason Gunthorpe wrote:
> > On Thu, Nov 02, 2017 at 03:10:27PM +0000, Bart Van Assche wrote:
> > > On Thu, 2017-11-02 at 15:51 +0200, Yuval Shaia wrote:
> > > > The check makes no difference - remove it.
> > >
> > > Shouldn't the description have been "Passing zero as third argument to
> > > memcpy() is allowed so the if-test is not necessary. Hence leave it out"?
> >
> > +1
> 
> Yuval ?

Thanks Leon,
Just post new pull request with the revised commit message.
If still v1 is needed here for review then i'll post it.

> 
> Thanks
> 
> >
> > Jason
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

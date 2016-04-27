From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V1 for-next 0/2] Add support for reporting LSO
 capabilities
Date: Wed, 27 Apr 2016 11:14:51 -0600
Message-ID: <20160427171451.GA17172@obsidianresearch.com>
References: <1461765892-1285-1-git-send-email-matanb@mellanox.com>
 <20160427164230.GB11617@obsidianresearch.com>
 <20160427170903.GA11554@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160427170903.GA11554-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Apr 27, 2016 at 08:09:03PM +0300, Leon Romanovsky wrote:
> On Wed, Apr 27, 2016 at 10:42:30AM -0600, Jason Gunthorpe wrote:
> > On Wed, Apr 27, 2016 at 05:04:50PM +0300, Matan Barak wrote:
> > 
> > > This patch series enables hardware to report Large Segment Offload(LSO)
> > > capabilities from kernel to user space. LSO enabled NIC will accept big chuck of
> > > data with size greater than MTU. The LSO engine will split them into
> > > separate packets and insert the headers automatically. With LSO, CPU is
> > > offloaded from dealing with much less throughput of data.
> > 
> > I also feel like we should stop changing the current uAPI until we get
> > the new one in place.
> 
> This functionality doesn't relate to ABI change and don't change
> current/future interfaces.

What do you mean it doesn't change current interfaces? That is all
this patch does.

> There is no need to stop changes like this.

Why do we need to keep churning the uAPI now that we are committed to
deprecating it?

It seems like the discussion is closing on something implementable.

And again, we discussed at the Collab Summit that ABI patches like
this would be OK'd by a multi-vendor group - that hasn't happened yet
for this patch either.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

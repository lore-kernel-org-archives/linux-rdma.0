From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH RFC 2/3] svcrdma: Use device rdma_read_access_flags
Date: Wed, 11 Nov 2015 00:02:25 -0800
Message-ID: <20151111080225.GA31508@infradead.org>
References: <1447152255-28231-1-git-send-email-sagig@mellanox.com>
 <1447152255-28231-3-git-send-email-sagig@mellanox.com>
 <20151110114145.GA2810@infradead.org>
 <5641D920.5000409@mellanox.com>
 <20151110120432.GA8230@infradead.org>
 <20151110182546.GI12667@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151110182546.GI12667-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 10, 2015 at 11:25:46AM -0700, Jason Gunthorpe wrote:
> I like this, my only comment is we should have a rdma_cap for this
> behavior, rdma_cap_needs_rdma_read_mr(pd) or something?

Yes, that's better than checking the protocol.

> > +		if (!(dev->device_cap_flags &
> > IB_DEVICE_MEM_MGT_EXTENSIONS)) {
> 
> Lets enforce this in the core, if rdma_cap_needs_rdma_read_mr is set
> the the device must also set IB_DEVICE_MEM_MGT_EXTENSIONS, check at
> device creation time.

The iWarp verbs spec requires them to be supported, so that should not
be an issue.

> > +	} else if (rdma_ib_or_roce(dev, newxprt->sc_cm_id->port_num)) {
> > +		/*
> > +		 * For IB or RoCE life is easy, no unsafe write access is
> > +		 * required and multiple SGEs are supported, so we don't need
> > +		 * to use MRs.
> > +		 */
> > +		newxprt->sc_reader = rdma_read_chunk_lcl;
> > +	} else {
> > +		/*
> > +		 * Neither iWarp nor IB-ish, we're out of luck.
> > +		 */
> >  		goto errout;
> 
> No need for the else, !rdma_cap_needs_rdma_read_mr means pd->local_dma_lkey is okay
> to use.

What would happen if someone tried to use NFS on usnic without this?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

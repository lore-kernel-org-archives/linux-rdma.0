From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH RFC 2/3] svcrdma: Use device rdma_read_access_flags
Date: Tue, 10 Nov 2015 11:25:46 -0700
Message-ID: <20151110182546.GI12667@obsidianresearch.com>
References: <1447152255-28231-1-git-send-email-sagig@mellanox.com>
 <1447152255-28231-3-git-send-email-sagig@mellanox.com>
 <20151110114145.GA2810@infradead.org>
 <5641D920.5000409@mellanox.com>
 <20151110120432.GA8230@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151110120432.GA8230-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 10, 2015 at 04:04:32AM -0800, Christoph Hellwig wrote:
> On Tue, Nov 10, 2015 at 01:46:40PM +0200, Sagi Grimberg wrote:
> > 
> > 
> > On 10/11/2015 13:41, Christoph Hellwig wrote:
> > >Oh, and while we're at it.  Can someone explain why we're even
> > >using rdma_read_chunk_frmr for IB?  It seems to work around the
> > >fact tat iWarp only allow a single RDMA READ SGE, but it's used
> > >whenever the device has IB_DEVICE_MEM_MGT_EXTENSIONS, which seems
> > >wrong.
> > 
> > I think Steve can answer it better than I can. I think that it is
> > just to have a single code path for both IB and iWARP. I agree that
> > the condition seems wrong and for small transfers rdma_read_chunk_frmr
> > is really a performance loss.
> 
> Well, the code path already exists, but only is used fi
> IB_DEVICE_MEM_MGT_EXTENSIONS isn't set.  Below is an untested patch
> that demonstrates how I think svcrdma should setup the reads.  Note
> that this also allows to entirely remove it's allphys MR.
> 
> Note that as a followon this would also allow to remove the
> non-READ_W_INV code path from rdma_read_chunk_frmr as a future
> step.

I like this, my only comment is we should have a rdma_cap for this
behavior, rdma_cap_needs_rdma_read_mr(pd) or something?

> +	if (rdma_protocol_iwarp(dev, newxprt->sc_cm_id->port_num)) {

Use here

> +		/*
> +		 * iWARP requires remote write access for the data sink, and
> +		 * only supports a single SGE for RDMA_READ requests, so we'll
> +		 * have to use a memory registration for each RDMA_READ.
> +		 */
> +		if (!(dev->device_cap_flags &
> IB_DEVICE_MEM_MGT_EXTENSIONS)) {

Lets enforce this in the core, if rdma_cap_needs_rdma_read_mr is set
the the device must also set IB_DEVICE_MEM_MGT_EXTENSIONS, check at
device creation time.

> +	} else if (rdma_ib_or_roce(dev, newxprt->sc_cm_id->port_num)) {
> +		/*
> +		 * For IB or RoCE life is easy, no unsafe write access is
> +		 * required and multiple SGEs are supported, so we don't need
> +		 * to use MRs.
> +		 */
> +		newxprt->sc_reader = rdma_read_chunk_lcl;
> +	} else {
> +		/*
> +		 * Neither iWarp nor IB-ish, we're out of luck.
> +		 */
>  		goto errout;

No need for the else, !rdma_cap_needs_rdma_read_mr means pd->local_dma_lkey is okay
to use.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

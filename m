From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH WIP 01/43] IB: Modify ib_create_mr API
Date: Wed, 22 Jul 2015 09:44:21 -0700
Message-ID: <20150722164421.GA6443@infradead.org>
References: <1437548143-24893-1-git-send-email-sagig@mellanox.com>
 <1437548143-24893-2-git-send-email-sagig@mellanox.com>
 <20150722163405.GA26909@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150722163405.GA26909-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jul 22, 2015 at 10:34:05AM -0600, Jason Gunthorpe wrote:
> > +/**
> > + * ib_alloc_mr() - Allocates a memory region
> > + * @pd:            protection domain associated with the region
> > + * @mr_type:       memory region type
> > + * @max_entries:   maximum registration entries available
> > + * @flags:         create flags
> > + */
> 
> Can you update this comment to elaborate some more on what the
> parameters are? 'max_entries' is the number of s/g elements or
> something?
> 
> > +enum ib_mr_type {
> > +	IB_MR_TYPE_FAST_REG,
> > +	IB_MR_TYPE_SIGNATURE,
> >  };
> 
> Sure would be nice to have some documentation for what these things
> do..

Agreed on both counts.  Otherwise this looks pretty good to me.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

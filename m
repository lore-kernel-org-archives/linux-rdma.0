From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: rdma-core 12 breaks libibverbs ABI
Date: Thu, 26 Jan 2017 11:09:26 -0700
Message-ID: <20170126180926.GB20330@obsidianresearch.com>
References: <1485446147.4194.4.camel@profitbricks.com>
 <20170126171325.GA16562@obsidianresearch.com>
 <20170126173548.GA15006@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170126173548.GA15006-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jan 26, 2017 at 09:35:48AM -0800, Christoph Hellwig wrote:
> On Thu, Jan 26, 2017 at 10:13:25AM -0700, Jason Gunthorpe wrote:
> > I missed asking for this when the ibv_cmd_create_ah@IBVERBS_1.4 patch
> > was merged, but before we release 13 we need to drop all the ibv_cmd_*
> > entry points from the public headers so that nothing outside rdma-core
> > can link to these symbols.
> 
> A good thing would be to move all these symbols into a @IBVERBS_PRIVATE
> namespace, similar to what glibc does for it's internal library only
> exports.

Makes sense for clarity.

I guess we should remove the public headers and change the symbol
version all at once in '13'? This would instantly make all out of tree
providers totally unworkable.

Or go back to providing strong compat to the providers as Ben
suggested..  In this case someone will have to vote for this with a
patch to put the missing symbol back...

I know mlx voted for the first path - Ira?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

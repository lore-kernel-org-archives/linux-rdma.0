From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/mad: Ensure fairness in ib_mad_completion_handler
Date: Tue, 29 Dec 2015 12:40:14 -0500
Message-ID: <20151229174014.GA329@phlsvsds.ph.intel.com>
References: <1449784350-30214-1-git-send-email-ira.weiny@intel.com> <20151229091730.GA8445@infradead.org> <56825797.5030008@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <56825797.5030008-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 29, 2015 at 11:51:19AM +0200, Sagi Grimberg wrote:
> 
> >Please just convert the mad handler to the new CQ API in
> >drivers/infiniband/core/cq.c.  If you have any question about it I'd be
> >glad to help you.
> 
> +1 on this suggestion.
> 
> We had these sorts of questions in our ULPs as well. The CQ API should
> take care of all that for you and leaves you to just handle the
> completions...

I saw your work and agree it would be nice but it will take some time to
convert and debug the MAD stack.  I'll try and find some time but it is
unlikely I will anytime soon.

We can hit this bug regularly with hfi1 but have not hit with qib or mlx4.  I
leave it up to Doug if he wants to take this fix before someone finds time to
convert the MAD stack.

Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

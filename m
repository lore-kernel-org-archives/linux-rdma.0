From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 10/10] verbs: Add a compatibility arch.h
Date: Mon, 13 Feb 2017 09:39:10 -0700
Message-ID: <20170213163910.GA25430@obsidianresearch.com>
References: <1486677212-3188-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1486677212-3188-11-git-send-email-jgunthorpe@obsidianresearch.com>
 <20170212090531.GC14015@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170212090531.GC14015-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Feb 12, 2017 at 11:05:31AM +0200, Leon Romanovsky wrote:

> > +/* Barrier macros are no longer provided by libibverbs */
> > +
> > +#endif /* INFINIBAND_ARCH_H */
> 
> Is it possible to drop this file anyway?

It looks like there is enough stuff out there that uses it to get
htonll that it isn't a good idea at this time. This provides build
warning motivation for those people to move away and we can check
progress again in a year.. No harm to us in carrying an obsolete
header.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

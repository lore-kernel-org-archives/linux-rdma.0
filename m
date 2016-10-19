From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: New providers in rdma-core
Date: Wed, 19 Oct 2016 11:13:26 -0600
Message-ID: <20161019171326.GA29879@obsidianresearch.com>
References: <CALq1K=+nEP0jFOCxj30HA0+bg0L1bF5+xiBcAC2bRwUz+M6+eQ@mail.gmail.com>
 <20161019163913.GA30843@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161019163913.GA30843-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 19, 2016 at 09:39:13AM -0700, Christoph Hellwig wrote:

> Requiring installed super updtodate kernel headers isn't going to
> help development.  It would be good to keep a copy of the kernel
> headers in the rdma-core repo, similar to what most kernel tools
> tied to bleeding edge ABIs do.

Yes, this is already happening, eg rdma/rdma_user_rxe.h is cached in
the tree, and I have a patch to move the rdma_netlink.h to that scheme
as well.

cmake has a scheme where it detects if the system header is too
old/missing and if so transparently arranges things so that

 #include <rdma/rdma_user_rxe.h>

Uses the internal copy.

I also want to add a cmake option to use the kernel headers from a
kernel tree - nobody has been testing that changes to the kernel
headers work with the user space either, and eg the changes the
netlink broke stuff :/

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: New providers in rdma-core
Date: Wed, 19 Oct 2016 09:39:13 -0700
Message-ID: <20161019163913.GA30843@infradead.org>
References: <CALq1K=+nEP0jFOCxj30HA0+bg0L1bF5+xiBcAC2bRwUz+M6+eQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALq1K=+nEP0jFOCxj30HA0+bg0L1bF5+xiBcAC2bRwUz+M6+eQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 19, 2016 at 07:18:04PM +0300, Leon Romanovsky wrote:
> Hi All,
> 
> I want to remind you that latest kernel is exposing different vendor
> specific structures (include/uapi/rdma/*-abi.,h) and new coming user
> space drivers should use these headers directly and not copy/paste the
> code from them.
> 
> In the future, we will convert already accepted drivers too.

Requiring installed super updtodate kernel headers isn't going to
help development.  It would be good to keep a copy of the kernel
headers in the rdma-core repo, similar to what most kernel tools
tied to bleeding edge ABIs do.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

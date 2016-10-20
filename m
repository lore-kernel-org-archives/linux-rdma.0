From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: New providers in rdma-core
Date: Thu, 20 Oct 2016 10:35:13 -0600
Message-ID: <20161020163513.GB28181@obsidianresearch.com>
References: <CALq1K=+nEP0jFOCxj30HA0+bg0L1bF5+xiBcAC2bRwUz+M6+eQ@mail.gmail.com>
 <20161019163913.GA30843@infradead.org>
 <6b57d79c-dbd3-cd9b-061e-27a3d3968845@vmware.com>
 <20161019175926.GD29879@obsidianresearch.com>
 <12243e3b-87cf-2bd4-d097-1dd0a7907f41@vmware.com>
 <20161019200911.GA2666@obsidianresearch.com>
 <SN1PR07MB2207D6CF5ADA67FCFCAA3A2EF8D50@SN1PR07MB2207.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <SN1PR07MB2207D6CF5ADA67FCFCAA3A2EF8D50-mikhvbZlbf8TSoR2DauN2+FPX92sqiQdvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 20, 2016 at 09:24:30AM +0000, Amrani, Ram wrote:

> The idea looks good to me.
> But still, I'm missing something - in order for libraries and the kernel to use the 
> same headers they should reside in the same repository.
> Is that the long-term goal? And wouldn't that be mixing user/kernel spaces?

See the discussion here:

http://www.spinics.net/lists/linux-rdma/msg42067.html

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

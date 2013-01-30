From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: RDMA/cxgb4: Support on-chip SQs
Date: Wed, 30 Jan 2013 16:49:52 -0600
Message-ID: <5109A390.506@opengridcomputing.com>
References: <20130130210006.GA22134@elgon.mountain> <51099270.5070406@opengridcomputing.com> <20130130214425.GA5674@obsidianresearch.com> <CAL1RGDXQW44TTaCZ0rzBAXG1oK3EsiKJXj5+cA1jUJHb85VFNQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDXQW44TTaCZ0rzBAXG1oK3EsiKJXj5+cA1jUJHb85VFNQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 1/30/2013 4:34 PM, Roland Dreier wrote:
> On Wed, Jan 30, 2013 at 1:44 PM, Jason Gunthorpe
> <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
>> So instead of virt_to_phys you should use dma_addr??
> No, you clearly can't use the bus address. That has no relationship to
> the CPU view, even in cases as common as VT-d on x86.
>

By the way, this usage of virt_to_phys() is not new to the commit that 
Dan referenced.  It has been there since day one of the iw_cxgb[34] 
drivers.   This doesn't mean its correct however. :)


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

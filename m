From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: RDMA/cxgb4: Support on-chip SQs
Date: Mon, 25 Mar 2013 09:14:32 -0700
Message-ID: <CAL1RGDXVGAARM_8Tj0pSArEvH0PyD7yaK33535RoJFQ58WY-Hw@mail.gmail.com>
References: <20130130210006.GA22134@elgon.mountain> <51099270.5070406@opengridcomputing.com>
 <20130323213038.GA14080@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130323213038.GA14080@mwanda>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, Mar 23, 2013 at 2:30 PM, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> In the end, we decided this was correct as-is?
>
> I'm about to complain to the caif network people about the
> dma_alloc_coherent() -> virt_to_phys() thing, but the truth is I
> don't understand this stuff very well and I'm not sure when it's ok
> or not.


I'm not sure it's strictly correct in all cases, but we don't really
have anything better to replace it with at the moment.

If there is a platform where it breaks, and they want to use one of
these drivers, then I guess we'll have to add more core infrastructure
to provide a way to map this type of memory into userspace.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 10/11] IB: only keep a single key in struct ib_mr
Date: Mon, 23 Nov 2015 20:48:33 +0100
Message-ID: <20151123194833.GC17760@lst.de>
References: <1448214409-7729-1-git-send-email-hch@lst.de> <1448214409-7729-11-git-send-email-hch@lst.de> <20151123194124.GF32085@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151123194124.GF32085-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 23, 2015 at 12:41:24PM -0700, Jason Gunthorpe wrote:
> I like this too, but, I'm a little worried this makes the API more
> confusing - ideally, we'd get rid of all the IB_ACCESS stuff from
> within the kernel completely.

That's my plan - at least for MRs.  The only place still using it
are ib_get_dma_mr and FRM. Both of them should be switche=D1=95 to this
new API - ib_get_dma_mr is trivial and will follow next, while for
=46MRs I was going to look to change the code to mirror what Sagi did
to FRs.  That is if we can't get rid of FMRs entirely soon.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

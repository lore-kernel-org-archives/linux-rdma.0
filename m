From: Liran Liss <liss.liran-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 10/11] IB: only keep a single key in struct ib_mr
Date: Fri, 25 Dec 2015 18:46:07 +0200
Message-ID: <CAMHdiBC75n+u9BSMsKxJwcaBnGL68_3UBeQQtHp_CD5KGcUTnQ@mail.gmail.com>
References: <1448214409-7729-1-git-send-email-hch@lst.de>
	<1448214409-7729-11-git-send-email-hch@lst.de>
	<56791542.6020604@dev.mellanox.co.il>
	<20151222131326.GA25267@lst.de>
	<56795514.9090704@dev.mellanox.co.il>
	<20151222135927.GA26311@lst.de>
	<56798126.9000003@dev.mellanox.co.il>
	<20151222210939.GA8212@obsidianresearch.com>
	<7sikrilf3ik3fjsgppqxh9gn.1451043246057@email.android.com>
	<CAMHdiBDv9mScD+5o90OQ_tmAKw9o48_jfao6W+EBOZkUg+wReA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAMHdiBDv9mScD+5o90OQ_tmAKw9o48_jfao6W+EBOZkUg+wReA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
Cc: sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

> > >fill mr->key by the lkey or rkey based on that and everything will
> > >work fine.
> >
> > But the ULP *can* register a memory buffer with local and remote
> > access permissions.
> Not in the new API.
>
> If a ULP ever comes along that does need that then they can start with
> two MRs and then eventually upgrade the kapi to have some kind of
> efficient bidir MR mode.

ULPs are *already* using the same registrations for both local and
remote access.
So, currently, this is a no-go.
Sorry.

Let's make the required adjustments, which don't violate specs, and
then continue.

>
> What we've seen on the list lately is that every single ULP seems to
> have technical problems running the stack properly. We need to get off
> this idea that the spec has to govern the kapi - that didn't lead us
> any place nice.
>

Oh, please.
Our stack connects millions of endpoints in production using multiple
ULPs for the last 15 years with full interoperability because of
specs.

I am sure that we can keep improving our APIs while adhering to
industry standards, as we have done very successfully until now.

--Liran
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

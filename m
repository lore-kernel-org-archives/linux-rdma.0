From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH v3 05/15] xprtrdma: Remove last ib_reg_phys_mr() call site
Date: Tue, 21 Jul 2015 16:22:52 -0500
Message-ID: <00c901d0c3fb$66e7cfa0$34b76ee0$@opengridcomputing.com>
References: <20150720185624.10997.51574.stgit@manet.1015granger.net> <20150720190311.10997.12636.stgit@manet.1015granger.net> <55AD5B48.3010906@talpey.com> <20150720210544.GA9655@obsidianresearch.com> <015101d0c331$69e31d10$3da95730$@opengridcomputing.com> <55AD7065.8040809@talpey.com> <015701d0c33d$36b53110$a41f9330$@opengridcomputing.com> <55AD8F05.6070409@talpey.com> <000301d0c3c2$3f892a50$be9b7ef0$@opengridcomputing.com> <55AEAFCE.60207@talpey.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: 
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Tom Talpey' <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: 'Chuck Lever' <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > >>>> B) why bother to check? Are machines with <4GB interesting, and worth
> > >>>> supporting a special optimization?
> > >>>
> > >>> No, but cxgb3 is still interesting to user applications, and perhaps NFSRDMA using FRMRs.
> > >>
> > >> I'm obviously not making myself clear. I am suggesting that cxgb3 fail
> > >> the ib_get_dma_mr() verb, regardless of installed memory.
> > >>
> > >> I am not suggesting it fail to load, or fail other memreg requests. It
> > >> should work normally in all other respects.
> > >
> > > Even with its limitation, doesn't it have utility for someone using cxgb3 in an embedded 32b environment?
> >
> > Sure, do you mean making it conditional on #if sizeof(physaddr) <= 32?
> > That would make sense I guess.
> 
> No, a runtime check.  x64 platforms will work too if the mem size takes <= 32b to describe.

Jason/Doug, do you think it should allow dma mr allocaton iff totalmem_pages < 4GB?  Or do a check on the sizeof totalmem_pages and
only allow dma mrs if it is <= 4?


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

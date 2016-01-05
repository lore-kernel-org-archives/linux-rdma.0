From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 10/11] IB: only keep a single key in struct ib_mr
Date: Tue, 5 Jan 2016 10:46:36 -0700
Message-ID: <20160105174636.GD16269@obsidianresearch.com>
References: <1448214409-7729-11-git-send-email-hch@lst.de>
 <56791542.6020604@dev.mellanox.co.il>
 <20151222131326.GA25267@lst.de>
 <56795514.9090704@dev.mellanox.co.il>
 <20151222135927.GA26311@lst.de>
 <56798126.9000003@dev.mellanox.co.il>
 <20151222210939.GA8212@obsidianresearch.com>
 <7sikrilf3ik3fjsgppqxh9gn.1451043246057@email.android.com>
 <CAMHdiBDv9mScD+5o90OQ_tmAKw9o48_jfao6W+EBOZkUg+wReA@mail.gmail.com>
 <CAMHdiBC75n+u9BSMsKxJwcaBnGL68_3UBeQQtHp_CD5KGcUTnQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAMHdiBC75n+u9BSMsKxJwcaBnGL68_3UBeQQtHp_CD5KGcUTnQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Liran Liss <liss.liran-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Dec 25, 2015 at 06:46:07PM +0200, Liran Liss wrote:
> > From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> 
> > > >fill mr->key by the lkey or rkey based on that and everything will
> > > >work fine.
> > >
> > > But the ULP *can* register a memory buffer with local and remote
> > > access permissions.
> > Not in the new API.
> >
> > If a ULP ever comes along that does need that then they can start with
> > two MRs and then eventually upgrade the kapi to have some kind of
> > efficient bidir MR mode.
> 
> ULPs are *already* using the same registrations for both local and
> remote access.

Where? Out of tree?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

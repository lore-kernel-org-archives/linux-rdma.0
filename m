From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 10/11] IB: only keep a single key in struct ib_mr
Date: Wed, 6 Jan 2016 07:08:06 +0100
Message-ID: <20160106060806.GA16509@lst.de>
References: <56791542.6020604@dev.mellanox.co.il> <20151222131326.GA25267@lst.de> <56795514.9090704@dev.mellanox.co.il> <20151222135927.GA26311@lst.de> <56798126.9000003@dev.mellanox.co.il> <20151222210939.GA8212@obsidianresearch.com> <7sikrilf3ik3fjsgppqxh9gn.1451043246057@email.android.com> <CAMHdiBDv9mScD+5o90OQ_tmAKw9o48_jfao6W+EBOZkUg+wReA@mail.gmail.com> <CAMHdiBC75n+u9BSMsKxJwcaBnGL68_3UBeQQtHp_CD5KGcUTnQ@mail.gmail.com> <20160105174636.GD16269@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160105174636.GD16269-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Liran Liss <liss.liran-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 05, 2016 at 10:46:36AM -0700, Jason Gunthorpe wrote:
> > ULPs are *already* using the same registrations for both local and
> > remote access.
> 
> Where? Out of tree?

I haven't found anything in-tree for sure.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

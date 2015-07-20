From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Kernel fast memory registration API proposal [RFC]
Date: Mon, 20 Jul 2015 10:18:21 -0600
Message-ID: <20150720161821.GA18336@obsidianresearch.com>
References: <559F8BD1.9080308@dev.mellanox.co.il>
 <55AB3976.7060202@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55AB3976.7060202-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Jul 19, 2015 at 08:45:26AM +0300, Sagi Grimberg wrote:
> 
> >/**
> >   * ib_mr_set_sg() - populate memory region buffers
> >   *     array from a SG list
> >   * @mr:          memory region
> >   * @sg:          sg list
> >   * @sg_nents:    number of elements in the sg
> >   *
> >   * Can fail if the HW is not able to register this
> >   * sg list. In case of failure - caller is responsible
> >   * to handle it (bounce-buffer, multiple registrations...)
> >   */
> >int ib_mr_set_sg(struct ib_mr *mr,
> >                  struct scatterlist *sg,
> >                  unsigned short sg_nents);
> 
> I'm thinking now that this should have an input argument
> of block_size. Maybe in the future ULPs would want to register
> huge pages, it will be a shame to map it into PAGE_SIZE chunks...

Why wouldn't it just transparently support huge pages? sg seems to
have enough information.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

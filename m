From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v1] IB/ipoib: Report SG feature regardless of HW UD CSUM
 capability
Date: Tue, 19 Jul 2016 13:34:53 -0600
Message-ID: <20160719193453.GA28288@obsidianresearch.com>
References: <1468827648-17275-1-git-send-email-yuval.shaia@oracle.com>
 <20160718171921.GA3193@obsidianresearch.com>
 <20160719125556.GA14768@yuval-lap.uk.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160719125556.GA14768-Hxa29pjIrETlQW142y8m19+IiqhCXseY@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 19, 2016 at 03:55:57PM +0300, Yuval Shaia wrote:
> On Mon, Jul 18, 2016 at 11:19:21AM -0600, Jason Gunthorpe wrote:
> > On Mon, Jul 18, 2016 at 12:40:48AM -0700, Yuval Shaia wrote:
> > > Decouple SG support from HW ability to do UD checksum.
> > > This coupling is for historical reasons and removed with 'commit
> > > ec5f06156423 ("net: Kill link between CSUM and SG features.")'
> > 
> > Shouldn't this also check that the QP's sg limit is something
> > appropriate? At least > 1 ..
> 
> What is special with 1?

One means the hardware doesn't support SG at all.

Is there a reason to sg_linearize down to ipoib if we know the
hardware doesn't support SG at all? Presumably it is better to let the
netstack deal with that case.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

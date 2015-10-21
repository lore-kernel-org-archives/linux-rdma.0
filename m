From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: merge struct ib_device_attr into struct ib_device V2
Date: Wed, 21 Oct 2015 10:43:56 -0600
Message-ID: <20151021164356.GA17666@obsidianresearch.com>
References: <CAJ3xEMhEE=Qp=LcYQYJB3rjfhdgd28QG_ZXbpFUCUubGD2uAGQ@mail.gmail.com>
 <56263CE6.5010005@dev.mellanox.co.il>
 <CAJ3xEMjmfNmiTiNctobN=BKvwB-oaMZtBxdqL5zVyvvG_M1KiQ@mail.gmail.com>
 <56265702.1030209@dev.mellanox.co.il>
 <CAJ3xEMh12RjU9ws3r5djigHdkMGnT35+uouRAMzGxj2jhmgKFA@mail.gmail.com>
 <20151021063830.GA19027@lst.de>
 <56273459.6050007@mellanox.com>
 <20151021065134.GA19210@lst.de>
 <56273AA1.6060607@mellanox.com>
 <5627B3BA.7060700@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5627B3BA.7060700-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 21, 2015 at 08:48:10AM -0700, Bart Van Assche wrote:
> On 10/21/2015 12:11 AM, Or Gerlitz wrote:
> >haven't found any review or ack to your giant patch that touches the
> > whole subsystem (drivers, core and ULPs) expect from Sagi's -- lets
> > hear more opinions.
> 
> Although I have not yet had the time to review the entire patch, removing
> ib_query_device() seems a great idea to me and an idea that I welcome very
> much. The ib_device_attr structure is too large to be allocated on the
> stack. This means that with Christoph's patch it is no longer needed to call
> kmalloc() + ib_query_device() + kfree() when a device attribute is needed
> from kernel code.

I agree, this is absolutely the right way to go.

The bikeshedding is not important, nobody has come up with a reason
why we need to maintain the attr structure as-is and Christoph already
has a patch - I say go with it.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

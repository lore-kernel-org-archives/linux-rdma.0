From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 8/9] Remove most checks of __BYTE_ORDER
Date: Wed, 5 Oct 2016 11:33:59 -0600
Message-ID: <20161005173359.GF18636@obsidianresearch.com>
References: <1475182076-5411-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1475182076-5411-9-git-send-email-jgunthorpe@obsidianresearch.com>
 <00e001d21a98$3265f6e0$9731e4a0$@opengridcomputing.com>
 <20160929222802.GC27229@obsidianresearch.com>
 <20161005153701.GA12295@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161005153701.GA12295-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Tatyana Nikolova' <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Hal Rosenstock' <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Yishai Hadas' <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Devesh Sharma' <Devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, 'Sean Hefty' <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Bart Van Assche' <bvanassche-HInyCGIudOg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 05, 2016 at 08:37:01AM -0700, Christoph Hellwig wrote:
> On Thu, Sep 29, 2016 at 04:28:02PM -0600, Jason Gunthorpe wrote:
> > In the kernel the swapping behavior of 'writel' is architecture (and
> > sometimes even platform) specific. Looking at the kernel headers
> > suggests that BE PPC needs an explicit swap and BE ARM does not (eg
> > the hardware swaps). Maybe. There are a lot of layers of macros in
> > this area..
> 
> read{s,l,q} and write{s,l,q} in the kernel always perform an implicit
> bytestap, that is the device is expected to use a LE layout.  This
> is not architecture specific, otherwise hell would break lose.

Right, stated differently, the kernel requires that writel()/etc
always produce the same PCI-E packet on the wire. (eg writel(1)
produces a TLP with bit 0 of the data payload set)

But each arch implements its own set of instructions to get there,
that is what I mean by architecture specific.

> But none of this has an affect on userspace mappings of registers, as
> those don't go through the kernel read{s,l,q} and write{s,l,q}
> helpers,

Not going through the kernel's writel is the whole problem. The writel
helper generates the arch-specific instruction sequence required to
issue generate the required PCI-E packet.

Today (at best, some drivers do not even do this) our userspace
assumes all archs implement writel as:

   *(u32 *)reg = cpu_to_le32(val);

Which is a good start, but not portable to every arch the kernel
supports.

> Btw, one thing that would be useful is to introduce endiane annoatations
> for sparse in rdma-core.   I've added these to a few userspace projects
> already, here is the most recent example:
> 
> https://github.com/linux-nvme/nvme-cli/commit/126b8beb35b76fe9f61b137e34aea66b64c07b25

Yeah, it would be nice to get that working too. I guess we need to
standardize on the cpu_to_xx macro style as a first step?

The __iomem annotation would be nice as well.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

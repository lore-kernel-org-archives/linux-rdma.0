From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 8/9] Remove most checks of __BYTE_ORDER
Date: Thu, 6 Oct 2016 04:40:45 -0700
Message-ID: <20161006114045.GA25762@infradead.org>
References: <1475182076-5411-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1475182076-5411-9-git-send-email-jgunthorpe@obsidianresearch.com>
 <00e001d21a98$3265f6e0$9731e4a0$@opengridcomputing.com>
 <20160929222802.GC27229@obsidianresearch.com>
 <20161005153701.GA12295@infradead.org>
 <20161005173359.GF18636@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161005173359.GF18636-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Tatyana Nikolova' <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Hal Rosenstock' <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Yishai Hadas' <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Devesh Sharma' <Devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, 'Sean Hefty' <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Bart Van Assche' <bvanassche-HInyCGIudOg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 05, 2016 at 11:33:59AM -0600, Jason Gunthorpe wrote:
> Right, stated differently, the kernel requires that writel()/etc
> always produce the same PCI-E packet on the wire. (eg writel(1)
> produces a TLP with bit 0 of the data payload set)

Exactly.

> Not going through the kernel's writel is the whole problem. The writel
> helper generates the arch-specific instruction sequence required to
> issue generate the required PCI-E packet.

All the architectures (including your quoted above ARM example) seem
to do the byte swap in software.  That seems to be important for
accesses like memcpy_{to,from}_io, which would be painful to handle.

But yes, in theory an architecture could do it any way it wants.

> Today (at best, some drivers do not even do this) our userspace
> assumes all archs implement writel as:
> 
>    *(u32 *)reg = cpu_to_le32(val);
> 
> Which is a good start, but not portable to every arch the kernel
> supports.

It should do the right thing for every architecture that matters.
Thay beeing said having an iomem abstraction certainly makes sense
for various reasons, and handling any oddball architecture (or rather
PCI hostbridge implemtation, I would not expect something this
broken to be universal) would come as a bonus.

> Yeah, it would be nice to get that working too. I guess we need to
> standardize on the cpu_to_xx macro style as a first step?

Any style will work as long as it separate the swap directions,
but for a low-level Linux projects using the kernel style certainly
makes sene.

> The __iomem annotation would be nice as well.

I can look into that as well.  Usuaully the first step before adding
sparse annotations is fixing all the misc sparse warnings, as typical
userspace projects have a not too stellar code quality.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

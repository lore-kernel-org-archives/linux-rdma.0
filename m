From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 8/9] Remove most checks of __BYTE_ORDER
Date: Thu, 29 Sep 2016 16:28:02 -0600
Message-ID: <20160929222802.GC27229@obsidianresearch.com>
References: <1475182076-5411-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1475182076-5411-9-git-send-email-jgunthorpe@obsidianresearch.com>
 <00e001d21a98$3265f6e0$9731e4a0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <00e001d21a98$3265f6e0$9731e4a0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Tatyana Nikolova' <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Hal Rosenstock' <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Yishai Hadas' <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Devesh Sharma' <Devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, 'Sean Hefty' <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Bart Van Assche' <bvanassche-HInyCGIudOg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 29, 2016 at 04:26:52PM -0500, Steve Wise wrote:

> > +/* Generally speaking, PCI systems auto-byteswap on PCI accesses, so this is
> > +   probably wrong */
> > +#define cpu_to_pci32(val) htole32(val)
> 
> If this was wrong, then nothing would work.  So I think you should
> remove the comment.

I added the comment because cxgb* was the only provider that seemed to
be obviously byte swapping MMIO.

Since htole32 is a NOP on x86 and ARM64 the driver would work fine
with or without it. Do you know this driver works on big endian
powerpc? That would help answer the question for sure.

I looked at this some more, and I still don't really know what is the
right answer.

In the kernel the swapping behavior of 'writel' is architecture (and
sometimes even platform) specific. Looking at the kernel headers
suggests that BE PPC needs an explicit swap and BE ARM does not (eg
the hardware swaps). Maybe. There are a lot of layers of macros in
this area..

However, I can't find an obvious swap in mlx4, which I think is the
most widely tested provider. Does it work on BE PPC?

One of the things I'd like to see done is to consolidate the mmio
accessors.. The note was a reminder to try and figure out what is
actually right here.. Appreciate any help!

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 8/9] Remove most checks of __BYTE_ORDER
Date: Wed, 5 Oct 2016 08:37:01 -0700
Message-ID: <20161005153701.GA12295@infradead.org>
References: <1475182076-5411-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1475182076-5411-9-git-send-email-jgunthorpe@obsidianresearch.com>
 <00e001d21a98$3265f6e0$9731e4a0$@opengridcomputing.com>
 <20160929222802.GC27229@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160929222802.GC27229-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Tatyana Nikolova' <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Hal Rosenstock' <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Yishai Hadas' <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Devesh Sharma' <Devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, 'Sean Hefty' <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Bart Van Assche' <bvanassche-HInyCGIudOg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 29, 2016 at 04:28:02PM -0600, Jason Gunthorpe wrote:
> In the kernel the swapping behavior of 'writel' is architecture (and
> sometimes even platform) specific. Looking at the kernel headers
> suggests that BE PPC needs an explicit swap and BE ARM does not (eg
> the hardware swaps). Maybe. There are a lot of layers of macros in
> this area..

read{s,l,q} and write{s,l,q} in the kernel always perform an implicit
bytestap, that is the device is expected to use a LE layout.  This
is not architecture specific, otherwise hell would break lose.

If the device has a BE layout you'll need to use ioread*be/iowrite*be
instead.

But none of this has an affect on userspace mappings of registers, as
those don't go through the kernel read{s,l,q} and write{s,l,q} helpers,
so if you mmap the resource directly your need to manually byte swap
to whatever the hardware expects - which seems to be LE for Chelsio
and BE for Mellanox.

Btw, one thing that would be useful is to introduce endiane annoatations
for sparse in rdma-core.   I've added these to a few userspace projects
already, here is the most recent example:

https://github.com/linux-nvme/nvme-cli/commit/126b8beb35b76fe9f61b137e34aea66b64c07b25


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

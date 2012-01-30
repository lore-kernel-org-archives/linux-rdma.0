From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH/RFC G-U-P experts] IB/umem: Modernize our get_user_pages() parameters
Date: Mon, 30 Jan 2012 11:19:18 -0800
Message-ID: <CAL1RGDWm6q9SxO_X5PR8Z7_V6wiYmoHqdPfX++8=Ph1v5HiZ6Q@mail.gmail.com>
References: <1327557574-6125-1-git-send-email-roland@kernel.org>
 <alpine.LSU.2.00.1201261133230.1369@eggly.anvils> <CAG4TOxNEV2VY9wOE86p9RnKGqpruB32ci9Wq3yBt8O2zc7f05w@mail.gmail.com>
 <CAL1RGDVBR49QrAbkZ0Wa9Gh98HTwjtsQbFQ4Ws3Ra7rEjT1Mng@mail.gmail.com>
 <alpine.LSU.2.00.1201271819260.3402@eggly.anvils> <20120128192553.GA16231@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120128192553.GA16231-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sat, Jan 28, 2012 at 11:25 AM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> I know accessing system memory (eg obtained via mmap on
> /sys/bus/pci/devices/0000:00:02.0/resource0) has been asked for in the
> past, and IIRC, the problem was that some of the common code, (GUP?)
> errored on these maps. I don't know if Roland's case is similar.

I think the problem there is that this is done via remap_pfn_range()
or similar, and the mapping has no underlying pages at all.  So we
would need a new interface that gives us different information for
such cases.

This is quite a bit trickier since I don't think the DMA API even has
a way to express getting a "device A" bus address for some memory
that is in a BAR for "device B".  So I'm not trying to address this case
(yet).  First I'd like to deal with as many flavors of page-backed
mappings as I can.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

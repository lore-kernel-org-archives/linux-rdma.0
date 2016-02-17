From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [RFC 0/7] Peer-direct memory
Date: Wed, 17 Feb 2016 00:44:12 -0800
Message-ID: <20160217084412.GA13616@infradead.org>
References: <1455207177-11949-1-git-send-email-artemyko@mellanox.com>
 <20160211191838.GA23675@obsidianresearch.com>
 <56C08EC8.10207@mellanox.com>
 <20160216182212.GA21071@obsidianresearch.com>
 <CAPSaadxbFCOcKV=c3yX7eGw9Wqzn3jvPRZe2LMWYmiQcijT4nw@mail.gmail.com>
 <CAPSaadx3vNBSxoWuvjrTp2n8_-DVqofttFGZRR+X8zdWwV86nw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAPSaadx3vNBSxoWuvjrTp2n8_-DVqofttFGZRR+X8zdWwV86nw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: davide rossetti <davide.rossetti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Kovalyov Artemy <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "leon-Dj0/KMMU01E@public.gmane.org" <leon-Dj0/KMMU01E@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

[disclaimer: I've been involved with ZONE_DEVICE support and the pmem
 driver and wrote parts of the code and discussed a lot of the tradeoffs
 on how we handle I/O to memory in BARs]

On Tue, Feb 16, 2016 at 08:13:58PM -0800, davide rossetti wrote:
> 1) I see mm as appropriate for real memory, i.e. something that
> user-space apps can pass around.

mm is memory management, and this clearly falls under the umbrella,
so it absolutely needs to be under mm/ and reviewed by the linux-mm
crowd.

> This is not totally true for BAR
> memory, for instance:
>  a) as long as CPU initiated atomic ops are not supported on BAR space
> of PCIe devices.
>  b) OTOT, CPU reading from BAR is awful (BW being abysmal,~10MB/s),
> while high BW writing requires use of vector instructions (at least on
> x86_64).
> Bottom line is, BAR mappings are not like plain memory.

That doesn't change how the are managed.  We've always suppored mapping
BARs to userspace in various drivers, and the only real news with things
like the pmem driver with DAX or some of the things people want to do
with the NVMe controller memoery buffer is that there are much bigger
quantities of it, and:

 a) people want to be able  have cachable mappings of various kinds
    instead of the old uncachable default.
 b) we want to be able to DMA (including RDMA) to the regions in the
    BARs.

a) is something that needs smaller amounts in all kinds of areas to be
done properly, but in principle GPU drivers have been doing this forever
using all kinds of hacks.

b) is the real issue.  The Linux DMA support code doesn't really operate
on just physical addresses, but on page structures, and we don't
allocate for BARs.  We investigated two ways to address this:  1) allow
DMA operations without struct page and 2) create struct page structures
for BARs that we want to be able to use DMA operations on.  For various
reasons version 2) was favored and this is how we ended up with
ZONE_DEVICE.  Read the linux-mm and linux-nvdimm lists for the lenghty
discussions how we ended up here.

Additional issues like which instructions to use for access build on top
of these basic building blocks.

> 2) Instead, I see appropriate that two sophisticated devices, like an
> IB NIC and a storage/accelerator device, can freely target each other
> for I/O, i.e. exchanging peer-to-peer PCIe transactions. And as long
> as the existing sophisticated initiators are confined to the RDMA
> subsystem, that is where this support belongs to.

It doesn't.  There is absolutely nothing RDMA specific here - please
work with the overall community to do the right thing here.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC 0/7] Peer-direct memory
Date: Fri, 19 Feb 2016 10:54:58 -0800
Message-ID: <CAA9_cmfSixFu6roxjQ7z6N7tgDKgK2oEYrwb=7=MmjgnxOhEkA@mail.gmail.com>
References: <1455207177-11949-1-git-send-email-artemyko@mellanox.com>
	<20160211191838.GA23675@obsidianresearch.com>
	<56C08EC8.10207@mellanox.com>
	<20160216182212.GA21071@obsidianresearch.com>
	<CAPSaadxbFCOcKV=c3yX7eGw9Wqzn3jvPRZe2LMWYmiQcijT4nw@mail.gmail.com>
	<CAPSaadx3vNBSxoWuvjrTp2n8_-DVqofttFGZRR+X8zdWwV86nw@mail.gmail.com>
	<20160217084412.GA13616@infradead.org>
	<56C490DF.1090100@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56C490DF.1090100-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, davide rossetti <davide.rossetti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Kovalyov Artemy <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 17, 2016 at 7:25 AM, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> On 17/02/2016 10:44, Christoph Hellwig wrote:
>> That doesn't change how the are managed.  We've always suppored mapping
>> BARs to userspace in various drivers, and the only real news with things
>> like the pmem driver with DAX or some of the things people want to do
>> with the NVMe controller memoery buffer is that there are much bigger
>> quantities of it, and:
>>
>>  a) people want to be able  have cachable mappings of various kinds
>>     instead of the old uncachable default.
> What if we do want an uncachable mapping for our device's BAR. Can we still
> expose it under ZONE_DEVICE?
>
>>  b) we want to be able to DMA (including RDMA) to the regions in the
>>     BARs.
>>
>> a) is something that needs smaller amounts in all kinds of areas to be
>> done properly, but in principle GPU drivers have been doing this forever
>> using all kinds of hacks.
>>
>> b) is the real issue.  The Linux DMA support code doesn't really operate
>> on just physical addresses, but on page structures, and we don't
>> allocate for BARs.  We investigated two ways to address this:  1) allow
>> DMA operations without struct page and 2) create struct page structures
>> for BARs that we want to be able to use DMA operations on.  For various
>> reasons version 2) was favored and this is how we ended up with
>> ZONE_DEVICE.  Read the linux-mm and linux-nvdimm lists for the lenghty
>> discussions how we ended up here.
>
> I was wondering what are your thoughts regarding the other questions we raised
> about ZONE_DEVICE.
>
> How can we overcome the section-alignment requirement in the current code? Our
> HCA's BARs are usually smaller than 128MB.

This may not help, but note that the section-alignment only bites when
trying to have 2 mappings with different lifetimes in a single
section.  It's otherwise fine to map a full section for a smaller
single range, you'll just end up with pages that won't be used.
However, this assumes that you are fine with everything in that
section being mapped cacheable, you couldn't mix uncacheable mappings
in that same range.

> Sagi also asked how should a peer device who got a ZONE_DEVICE page know it
> should stop using it (the CMB example).

ZONE_DEVICE pages come with a per-cpu reference counter via
page->pgmap.  See get_dev_pagemap(), get_zone_device_page(), and
put_zone_device_page().

However this gets confusing quickly when a 'pfn' and a 'page' start
referencing mmio space instead of host memory.  It seems like we need
new data types because a dma_addr_t does not necessarily reflect the
peer-to-peer address as seen by the device.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

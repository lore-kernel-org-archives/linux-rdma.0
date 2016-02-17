From: Haggai Eran <haggaie@mellanox.com>
Subject: Re: [RFC 0/7] Peer-direct memory
Date: Wed, 17 Feb 2016 17:25:19 +0200
Message-ID: <56C490DF.1090100@mellanox.com>
References: <1455207177-11949-1-git-send-email-artemyko@mellanox.com>
 <20160211191838.GA23675@obsidianresearch.com> <56C08EC8.10207@mellanox.com>
 <20160216182212.GA21071@obsidianresearch.com>
 <CAPSaadxbFCOcKV=c3yX7eGw9Wqzn3jvPRZe2LMWYmiQcijT4nw@mail.gmail.com>
 <CAPSaadx3vNBSxoWuvjrTp2n8_-DVqofttFGZRR+X8zdWwV86nw@mail.gmail.com>
 <20160217084412.GA13616@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20160217084412.GA13616@infradead.org>
Sender: owner-linux-mm@kvack.org
To: Christoph Hellwig <hch@infradead.org>, davide rossetti <davide.rossetti@gmail.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Kovalyov Artemy <artemyko@mellanox.com>, "dledford@redhat.com" <dledford@redhat.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Leon Romanovsky <leonro@mellanox.com>, Sagi Grimberg <sagig@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On 17/02/2016 10:44, Christoph Hellwig wrote:
> That doesn't change how the are managed.  We've always suppored mapping
> BARs to userspace in various drivers, and the only real news with things
> like the pmem driver with DAX or some of the things people want to do
> with the NVMe controller memoery buffer is that there are much bigger
> quantities of it, and:
> 
>  a) people want to be able  have cachable mappings of various kinds
>     instead of the old uncachable default.
What if we do want an uncachable mapping for our device's BAR. Can we still 
expose it under ZONE_DEVICE?

>  b) we want to be able to DMA (including RDMA) to the regions in the
>     BARs.
> 
> a) is something that needs smaller amounts in all kinds of areas to be
> done properly, but in principle GPU drivers have been doing this forever
> using all kinds of hacks.
> 
> b) is the real issue.  The Linux DMA support code doesn't really operate
> on just physical addresses, but on page structures, and we don't
> allocate for BARs.  We investigated two ways to address this:  1) allow
> DMA operations without struct page and 2) create struct page structures
> for BARs that we want to be able to use DMA operations on.  For various
> reasons version 2) was favored and this is how we ended up with
> ZONE_DEVICE.  Read the linux-mm and linux-nvdimm lists for the lenghty
> discussions how we ended up here.

I was wondering what are your thoughts regarding the other questions we raised
about ZONE_DEVICE.

How can we overcome the section-alignment requirement in the current code? Our 
HCA's BARs are usually smaller than 128MB.

Sagi also asked how should a peer device who got a ZONE_DEVICE page know it 
should stop using it (the CMB example).

Regards,
Haggai



--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

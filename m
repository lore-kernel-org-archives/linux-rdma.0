From: Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH 16/16] dma-mapping: use exact allocation in
 dma_alloc_contiguous
Date: Fri, 14 Jun 2019 16:05:33 +0100
Message-ID: <4113cd5f-5c13-e9c7-bc5e-dcf0b60e7054@arm.com>
References: <20190614134726.3827-1-hch@lst.de>
 <20190614134726.3827-17-hch@lst.de>
 <a90cf7ec5f1c4166b53c40e06d4d832a@AcuMS.aculab.com>
 <20190614145001.GB9088@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190614145001.GB9088@lst.de>
Content-Language: en-GB
Sender: netdev-owner@vger.kernel.org
To: 'Christoph Hellwig' <hch@lst.de>, David Laight <David.Laight@ACULAB.COM>
Cc: Maxime Ripard <maxime.ripard@bootlin.com>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>, "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, David Airlie <airlied@linux.ie>, "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>, Intel Linux Wireless <linuxwifi@intel.com>, "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Jani Nikula <jani.nikula@linux.intel.com>, Ian Abbott <abbotti@mev.co.uk>, Rodrigo Vivi <rodrigo.vivi@intel.com>, Sean Paul <sean@p>
List-Id: linux-rdma@vger.kernel.org

On 14/06/2019 15:50, 'Christoph Hellwig' wrote:
> On Fri, Jun 14, 2019 at 02:15:44PM +0000, David Laight wrote:
>> Does this still guarantee that requests for 16k will not cross a 16k boundary?
>> It looks like you are losing the alignment parameter.
> 
> The DMA API never gave you alignment guarantees to start with,
> and you can get not naturally aligned memory from many of our
> current implementations.

Well, apart from the bit in DMA-API-HOWTO which has said this since 
forever (well, before Git history, at least):

"The CPU virtual address and the DMA address are both
guaranteed to be aligned to the smallest PAGE_SIZE order which
is greater than or equal to the requested size.  This invariant
exists (for example) to guarantee that if you allocate a chunk
which is smaller than or equal to 64 kilobytes, the extent of the
buffer you receive will not cross a 64K boundary."

That said, I don't believe this particular patch should make any 
appreciable difference - alloc_pages_exact() is still going to give back 
the same base address as the rounded up over-allocation would, and 
PAGE_ALIGN()ing the size passed to get_order() already seemed to be 
pointless.

Robin.

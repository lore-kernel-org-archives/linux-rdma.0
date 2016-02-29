From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 02/13] IB/core: allow passing mapping an offset into the
 SG in ib_map_mr_sg
Date: Mon, 29 Feb 2016 14:08:42 +0200
Message-ID: <56D434CA.3090902@dev.mellanox.co.il>
References: <1456596631-19418-1-git-send-email-hch@lst.de>
 <1456596631-19418-3-git-send-email-hch@lst.de>
 <56D30AF7.1060205@dev.mellanox.co.il> <20160229111557.GA11499@lst.de>
 <56D42D10.8080101@dev.mellanox.co.il> <20160229115611.GA12790@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20160229115611.GA12790@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-rdma@vger.kernel.org, swise@opengridcomputing.com, sagig@mellanox.com, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org



On 29/02/2016 13:56, Christoph Hellwig wrote:
> On Mon, Feb 29, 2016 at 01:35:44PM +0200, Sagi Grimberg wrote:
>>> But for lager SG entries we need it to calculate the correct
>>> base address.
>>
>> I'm not sure if this is true either. Can you explain why?
>
> Assume we get a SG entry that is exactly 2 pages (8k) long.  But we
> also have an offset of 6k into it, so we need to skip into the
> second page to make the following work:
>
>>
>> The Memory region mapping is described by:
>> 1. page vector: [addr0, addr1, addr2,...]
>> 2. iova: the first byte offset
>> 3. length: the total byte count of the mr
>> 4. page_size: size of each page in the page vector
>>
>> This means that the HCA assumes that each address in
>> the page vector has the size of page_size, also the region
>> can start at some offset (iova - addr0), and it has some length.
>
> Exactly.
>
> For the above case we don't need the page at sg_dma_address(), though.
> We need the one after it, so we need to make sure the page address
> is calculated for the second page in the SG entry.
>
> If we add sg_offset to dma_addr is in my page this means we get the
> right page address from this line:
>
> 		u64 page_addr = dma_addr & page_mask;
>
> without that's we'd get the address of the first page, which doesn't
> actually contain any data we want to map.

Yea, makes sense...

I get it now! Thanks!

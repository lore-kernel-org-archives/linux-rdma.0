From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 02/13] IB/core: allow passing mapping an offset into the
 SG in ib_map_mr_sg
Date: Mon, 29 Feb 2016 13:35:44 +0200
Message-ID: <56D42D10.8080101@dev.mellanox.co.il>
References: <1456596631-19418-1-git-send-email-hch@lst.de>
 <1456596631-19418-3-git-send-email-hch@lst.de>
 <56D30AF7.1060205@dev.mellanox.co.il> <20160229111557.GA11499@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160229111557.GA11499-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


> I looked at this in a bit more detail, and I think we need both.
>
> For PAGE_SIZE or smaller SG entries you're correct, and we don't
> need the offset for dma_addr.  But it doesn't harm either.

I think it can harm us.

> But for lager SG entries we need it to calculate the correct
> base address.

I'm not sure if this is true either. Can you explain why?

The Memory region mapping is described by:
1. page vector: [addr0, addr1, addr2,...]
2. iova: the first byte offset
3. length: the total byte count of the mr
4. page_size: size of each page in the page vector

This means that the HCA assumes that each address in
the page vector has the size of page_size, also the region
can start at some offset (iova - addr0), and it has some length.

So say the HCA wants to write 8k to the MR:
first page_size (4k) will be written starting from addr0, and
the next page_size (4k) will be written starting from addr1.
If you set addr0 = page_addr + offset then the HW will assume it can
access addr0 + page_size which is not what we want.

I think that the page vectors should contain page addresses and not
incorporate offsets.

Thoughts?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

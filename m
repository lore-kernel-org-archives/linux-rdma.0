From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 02/13] IB/core: allow passing mapping an offset into the
 SG in ib_map_mr_sg
Date: Sun, 28 Feb 2016 16:57:59 +0200
Message-ID: <56D30AF7.1060205@dev.mellanox.co.il>
References: <1456596631-19418-1-git-send-email-hch@lst.de>
 <1456596631-19418-3-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456596631-19418-3-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


> @@ -1593,6 +1592,7 @@ EXPORT_SYMBOL(ib_map_mr_sg);
>    * @mr:            memory region
>    * @sgl:           dma mapped scatterlist
>    * @sg_nents:      number of entries in sg
> + * @sg_offset:     offset in byes into sg
>    * @set_page:      driver page assignment function pointer
>    *
>    * Core service helper for drivers to convert the largest
> @@ -1603,10 +1603,8 @@ EXPORT_SYMBOL(ib_map_mr_sg);
>    * Returns the number of sg elements that were assigned to
>    * a page vector.
>    */
> -int ib_sg_to_pages(struct ib_mr *mr,
> -		   struct scatterlist *sgl,
> -		   int sg_nents,
> -		   int (*set_page)(struct ib_mr *, u64))
> +int ib_sg_to_pages(struct ib_mr *mr, struct scatterlist *sgl, int sg_nents,
> +		unsigned int sg_offset, int (*set_page)(struct ib_mr *, u64))
>   {
>   	struct scatterlist *sg;
>   	u64 last_end_dma_addr = 0;
> @@ -1618,8 +1616,8 @@ int ib_sg_to_pages(struct ib_mr *mr,
>   	mr->length = 0;
>
>   	for_each_sg(sgl, sg, sg_nents, i) {
> -		u64 dma_addr = sg_dma_address(sg);
> -		unsigned int dma_len = sg_dma_len(sg);
> +		u64 dma_addr = sg_dma_address(sg) + sg_offset;
> +		unsigned int dma_len = sg_dma_len(sg) - sg_offset;
>   		u64 end_dma_addr = dma_addr + dma_len;
>   		u64 page_addr = dma_addr & page_mask;
>
> @@ -1652,6 +1650,8 @@ next_page:
>   		mr->length += dma_len;
>   		last_end_dma_addr = end_dma_addr;
>   		last_page_off = end_dma_addr & ~page_mask;
> +
> +		sg_offset = 0;
>   	}

This looks wrong...

The SG offset should not be taken into account in the address
translation vector that is given to the HW. The sg_offset needs to
be accounted in the mr->iova:

mr->iova = sg_dma_address(&sgl[0]) + sg_offset;

I think the page mappings should stay as the are.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

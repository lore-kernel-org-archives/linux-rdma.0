From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH WIP 28/43] IB/core: Introduce new fast registration API
Date: Tue, 28 Jul 2015 14:20:22 +0300
Message-ID: <55B76576.8010409@mellanox.com>
References: <1437548143-24893-1-git-send-email-sagig@mellanox.com>
 <1437548143-24893-29-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1437548143-24893-29-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 22/07/2015 09:55, Sagi Grimberg wrote:
> +/**
> + * ib_sg_to_pages() - Convert a sg list to a page vector
> + * @dev:           ib device
> + * @sgl:           dma mapped scatterlist
> + * @sg_nents:      number of entries in sg
> + * @max_pages:     maximum pages allowed
> + * @pages:         output page vector
> + * @npages:        output number of mapped pages
> + * @length:        output total byte length
> + * @offset:        output first byte offset
> + *
> + * Core service helper for drivers to convert a scatter
> + * list to a page vector. The assumption is that the
> + * sg must meet the following conditions:
> + * - Only the first sg is allowed to have an offset
> + * - All the elements are of the same size - PAGE_SIZE
> + * - The last element is allowed to have length less than
> + *   PAGE_SIZE
> + *
> + * If any of those conditions is not met, the routine will
> + * fail with EINVAL.
> + */
> +int ib_sg_to_pages(struct scatterlist *sgl,
> +		   unsigned short sg_nents,
> +		   unsigned short max_pages,
> +		   u64 *pages, u32 *npages,
> +		   u32 *length, u64 *offset)
> +{
> +	struct scatterlist *sg;
> +	u64 last_end_dma_addr = 0, last_page_addr = 0;
> +	unsigned int last_page_off = 0;
> +	int i, j = 0;
> +
> +	/* TODO: We can do better with huge pages */
> +
> +	*offset = sg_dma_address(&sgl[0]);
> +	*length = 0;
> +
> +	for_each_sg(sgl, sg, sg_nents, i) {
> +		u64 dma_addr = sg_dma_address(sg);
> +		unsigned int dma_len = sg_dma_len(sg);
> +		u64 end_dma_addr = dma_addr + dma_len;
> +		u64 page_addr = dma_addr & PAGE_MASK;
> +
> +		*length += dma_len;
> +
> +		/* Fail we ran out of pages */
> +		if (unlikely(j > max_pages))
> +			return -EINVAL;
> +
> +		if (i && sg->offset) {
> +			if (unlikely((last_end_dma_addr) != dma_addr)) {
> +				/* gap - fail */
> +				goto err;
> +			}
> +			if (last_page_off + dma_len < PAGE_SIZE) {
> +				/* chunk this fragment with the last */
> +				last_end_dma_addr += dma_len;
> +				last_page_off += dma_len;
> +				continue;
> +			} else {
> +				/* map starting from the next page */
> +				page_addr = last_page_addr + PAGE_SIZE;
> +				dma_len -= PAGE_SIZE - last_page_off;
> +			}
> +		}
> +
> +		do {
> +			pages[j++] = page_addr;
I think this line could overrun the pages buffer. The test above only checks
at the beginning of the sg, but with an sg larger than PAGE_SIZE, you could
still overrun.

> +			page_addr += PAGE_SIZE;
> +		} while (page_addr < end_dma_addr);
> +
> +		last_end_dma_addr = end_dma_addr;
> +		last_page_addr = end_dma_addr & PAGE_MASK;
> +		last_page_off = end_dma_addr & ~PAGE_MASK;
> +	}
> +
> +	*npages = j;
> +
> +	return 0;
> +err:
> +	pr_err("RDMA alignment violation\n");
> +	for_each_sg(sgl, sg, sg_nents, i) {
> +		u64 dma_addr = sg_dma_address(sg);
> +		unsigned int dma_len = sg_dma_len(sg);
> +
> +		pr_err("sg[%d]: offset=0x%x, dma_addr=0x%llx, dma_len=0x%x\n",
> +			i, sg->offset, dma_addr, dma_len);
> +	}
> +
> +	return -EINVAL;
> +}
> +EXPORT_SYMBOL(ib_sg_to_pages);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

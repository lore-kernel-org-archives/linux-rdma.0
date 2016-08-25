From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 06/15] IB/pvrdma: Add helper functions
Date: Thu, 25 Aug 2016 09:16:43 +0300
Message-ID: <20160825061643.GB10342@yuval-lap>
References: <1470266864-16888-1-git-send-email-aditr@vmware.com>
 <1470266864-16888-7-git-send-email-aditr@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1470266864-16888-7-git-send-email-aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Aug 03, 2016 at 04:27:35PM -0700, Adit Ranadive wrote:
> This patch adds helper functions to store guest page addresses in a page
> directory structure. The page directory pointer is passed down to the
> backend which then maps the entire memory for the RDMA object by
> traversing the directory. We add some more helper functions for converting
> to/from RDMA stack address handles from/to PVRDMA ones.
> 
> Reviewed-by: Jorgen Hansen <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Reviewed-by: George Zhang <georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/hw/pvrdma/pvrdma_misc.c | 309 +++++++++++++++++++++++++++++
>  1 file changed, 309 insertions(+)
>  create mode 100644 drivers/infiniband/hw/pvrdma/pvrdma_misc.c
> 
> diff --git a/drivers/infiniband/hw/pvrdma/pvrdma_misc.c b/drivers/infiniband/hw/pvrdma/pvrdma_misc.c
> new file mode 100644
> index 0000000..97a1fcd
> --- /dev/null
> +++ b/drivers/infiniband/hw/pvrdma/pvrdma_misc.c
> @@ -0,0 +1,309 @@
> +/*
> + * Copyright (c) 2012-2016 VMware, Inc.  All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of EITHER the GNU General Public License
> + * version 2 as published by the Free Software Foundation or the BSD
> + * 2-Clause License. This program is distributed in the hope that it
> + * will be useful, but WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED
> + * WARRANTY OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.
> + * See the GNU General Public License version 2 for more details at
> + * http://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program available in the file COPYING in the main
> + * directory of this source tree.
> + *
> + * The BSD 2-Clause License
> + *
> + *     Redistribution and use in source and binary forms, with or
> + *     without modification, are permitted provided that the following
> + *     conditions are met:
> + *
> + *      - Redistributions of source code must retain the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer.
> + *
> + *      - Redistributions in binary form must reproduce the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer in the documentation and/or other materials
> + *        provided with the distribution.
> + *
> + * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
> + * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
> + * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
> + * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
> + * COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
> + * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
> + * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
> + * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
> + * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
> + * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
> + * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
> + * OF THE POSSIBILITY OF SUCH DAMAGE.
> + */
> +
> +#include <linux/errno.h>
> +#include <linux/slab.h>
> +#include <linux/bitmap.h>
> +
> +#include "pvrdma.h"
> +
> +int pvrdma_page_dir_init(struct pvrdma_dev *dev, struct pvrdma_page_dir *pdir,
> +			 u64 npages, bool alloc_pages)
> +{
> +	u64 i;
> +
> +	if (npages > PVRDMA_PAGE_DIR_MAX_PAGES)
> +		return -EINVAL;
> +
> +	memset(pdir, 0, sizeof(*pdir));
> +
> +	pdir->dir = dma_alloc_coherent(&dev->pdev->dev, PAGE_SIZE,
> +				       &pdir->dir_dma, GFP_KERNEL);
> +	if (!pdir->dir)
> +		goto err;
> +
> +	pdir->ntables = PVRDMA_PAGE_DIR_TABLE(npages - 1) + 1;
> +	pdir->tables = kcalloc(pdir->ntables, sizeof(*pdir->tables),
> +			       GFP_KERNEL);
> +	if (!pdir->tables)
> +		goto err;
> +
> +	for (i = 0; i < pdir->ntables; i++) {
> +		u64 *table;
> +		dma_addr_t table_base;
> +
> +		table = dma_alloc_coherent(&dev->pdev->dev, PAGE_SIZE,
> +					   &table_base, GFP_KERNEL);
> +		if (!table)
> +			goto err;
> +
> +		pdir->tables[i] = table;
> +		pdir->dir[i] = table_base;
> +	}
> +
> +	pdir->npages = npages;
> +
> +	if (alloc_pages) {
> +		pdir->pages = kcalloc(npages, sizeof(*pdir->pages),
> +				      GFP_KERNEL);
> +		if (!pdir->pages)
> +			goto err;
> +
> +		for (i = 0; i < pdir->npages; i++) {
> +			void *page;
> +			dma_addr_t page_dma;
> +
> +			page = dma_alloc_coherent(&dev->pdev->dev, PAGE_SIZE,
> +						  &page_dma, GFP_KERNEL);
> +			if (!page)
> +				goto err;
> +
> +			pdir->pages[i] = page;
> +			pvrdma_page_dir_insert_dma(pdir, i, page_dma);
> +		}
> +	}
> +
> +	return 0;
> +
> +err:
> +	pvrdma_page_dir_cleanup(dev, pdir);
> +
> +	return -ENOMEM;
> +}
> +
> +static u64 *pvrdma_page_dir_table(struct pvrdma_page_dir *pdir, u64 idx)
> +{
> +	return pdir->tables[PVRDMA_PAGE_DIR_TABLE(idx)];
> +}
> +
> +dma_addr_t pvrdma_page_dir_get_dma(struct pvrdma_page_dir *pdir, u64 idx)
> +{
> +	return pvrdma_page_dir_table(pdir, idx)[PVRDMA_PAGE_DIR_PAGE(idx)];
> +}
> +
> +static void pvrdma_page_dir_cleanup_pages(struct pvrdma_dev *dev,
> +					  struct pvrdma_page_dir *pdir)
> +{
> +	if (pdir->pages) {
> +		u64 i;
> +
> +		for (i = 0; i < pdir->npages && pdir->pages[i]; i++) {
> +			dma_addr_t page_dma = pvrdma_page_dir_get_dma(pdir, i);
> +
> +			dma_free_coherent(&dev->pdev->dev, PAGE_SIZE,
> +					  pdir->pages[i], page_dma);
> +		}
> +
> +		kfree(pdir->pages);
> +	}
> +}
> +
> +static void pvrdma_page_dir_cleanup_tables(struct pvrdma_dev *dev,
> +					   struct pvrdma_page_dir *pdir)
> +{
> +	if (pdir->tables) {
> +		int i;
> +
> +		pvrdma_page_dir_cleanup_pages(dev, pdir);
> +
> +		for (i = 0; i < pdir->ntables; i++) {
> +			u64 *table = pdir->tables[i];
> +
> +			if (table)
> +				dma_free_coherent(&dev->pdev->dev, PAGE_SIZE,
> +						  table, pdir->dir[i]);
> +		}
> +
> +		kfree(pdir->tables);
> +	}
> +}
> +
> +void pvrdma_page_dir_cleanup(struct pvrdma_dev *dev,
> +			     struct pvrdma_page_dir *pdir)
> +{
> +	if (pdir->dir) {
> +		pvrdma_page_dir_cleanup_tables(dev, pdir);
> +		dma_free_coherent(&dev->pdev->dev, PAGE_SIZE,
> +				  pdir->dir, pdir->dir_dma);
> +	}
> +}
> +
> +int pvrdma_page_dir_insert_dma(struct pvrdma_page_dir *pdir, u64 idx,
> +			       dma_addr_t daddr)
> +{
> +	u64 *table;
> +
> +	if (idx >= pdir->npages)
> +		return -EINVAL;
> +
> +	table = pvrdma_page_dir_table(pdir, idx);
> +	table[PVRDMA_PAGE_DIR_PAGE(idx)] = daddr;
> +
> +	return 0;
> +}
> +
> +int pvrdma_page_dir_insert_umem(struct pvrdma_page_dir *pdir,
> +				struct ib_umem *umem, u64 offset)
> +{
> +	u64 i = offset;
> +	int j, entry;
> +	int ret = 0, len = 0;
> +	struct scatterlist *sg;
> +
> +	if (offset >= pdir->npages)
> +		return -EINVAL;
> +
> +	for_each_sg(umem->sg_head.sgl, sg, umem->nmap, entry) {
> +		len = sg_dma_len(sg) >> PAGE_SHIFT;
> +		for (j = 0; j < len; j++) {
> +			dma_addr_t addr = sg_dma_address(sg) +
> +					  umem->page_size * j;
> +
> +			ret = pvrdma_page_dir_insert_dma(pdir, i, addr);
> +			if (ret)
> +				goto exit;
> +
> +			i++;
> +		}
> +	}
> +
> +exit:
> +	return ret;
> +}
> +
> +int pvrdma_page_dir_insert_page_list(struct pvrdma_page_dir *pdir,
> +				     u64 *page_list,
> +				     int num_pages)
> +{
> +	int i;
> +	int ret;
> +
> +	if (num_pages > pdir->npages)
> +		return -EINVAL;
> +
> +	for (i = 0; i < num_pages; i++) {
> +		ret = pvrdma_page_dir_insert_dma(pdir, i, page_list[i]);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +void ib_qp_cap_to_pvrdma(const struct ib_qp_cap *src, struct pvrdma_qp_cap *dst)

AFAIK convention is f(dst, src) for example memcpy.
This comment applied also to all the below xxx_to_yyy conversion functions.

> +{
> +	dst->max_send_wr = src->max_send_wr;
> +	dst->max_recv_wr = src->max_recv_wr;
> +	dst->max_send_sge = src->max_send_sge;
> +	dst->max_recv_sge = src->max_recv_sge;
> +	dst->max_inline_data = src->max_inline_data;
> +}
> +
> +void pvrdma_qp_cap_to_ib(const struct pvrdma_qp_cap *src, struct ib_qp_cap *dst)
> +{
> +	dst->max_send_wr = src->max_send_wr;
> +	dst->max_recv_wr = src->max_recv_wr;
> +	dst->max_send_sge = src->max_send_sge;
> +	dst->max_recv_sge = src->max_recv_sge;
> +	dst->max_inline_data = src->max_inline_data;
> +}
> +
> +void pvrdma_gid_to_ib(const union pvrdma_gid *src, union ib_gid *dst)
> +{
> +	BUILD_BUG_ON(sizeof(union pvrdma_gid) != sizeof(union ib_gid));
> +	memcpy(dst, src, sizeof(*src));

If we enforce size-computability then can you consider return cast of *src
instead of doing memcpy?

> +}
> +
> +void ib_gid_to_pvrdma(const union ib_gid *src, union pvrdma_gid *dst)
> +{
> +	BUILD_BUG_ON(sizeof(union pvrdma_gid) != sizeof(union ib_gid));
> +	memcpy(dst, src, sizeof(*src));

Ditto.

> +}
> +
> +void ib_global_route_to_pvrdma(const struct ib_global_route *src,
> +			       struct pvrdma_global_route *dst)
> +{
> +	ib_gid_to_pvrdma(&src->dgid, &dst->dgid);
> +	dst->flow_label = src->flow_label;
> +	dst->sgid_index = src->sgid_index;
> +	dst->hop_limit = src->hop_limit;
> +	dst->traffic_class = src->traffic_class;
> +}
> +
> +void pvrdma_global_route_to_ib(const struct pvrdma_global_route *src,
> +			       struct ib_global_route *dst)
> +{
> +	pvrdma_gid_to_ib(&src->dgid, &dst->dgid);
> +	dst->flow_label = src->flow_label;
> +	dst->sgid_index = src->sgid_index;
> +	dst->hop_limit = src->hop_limit;
> +	dst->traffic_class = src->traffic_class;
> +}
> +
> +void ib_ah_attr_to_pvrdma(const struct ib_ah_attr *src,
> +			  struct pvrdma_ah_attr *dst)
> +{
> +	ib_global_route_to_pvrdma(&src->grh, &dst->grh);
> +	dst->dlid = src->dlid;
> +	dst->sl = src->sl;
> +	dst->src_path_bits = src->src_path_bits;
> +	dst->static_rate = src->static_rate;
> +	dst->ah_flags = src->ah_flags;
> +	dst->port_num = src->port_num;
> +	memcpy(&dst->dmac, &src->dmac, sizeof(dst->dmac));
> +}
> +
> +void pvrdma_ah_attr_to_ib(const struct pvrdma_ah_attr *src,
> +			  struct ib_ah_attr *dst)
> +{
> +	pvrdma_global_route_to_ib(&src->grh, &dst->grh);
> +	dst->dlid = src->dlid;
> +	dst->sl = src->sl;
> +	dst->src_path_bits = src->src_path_bits;
> +	dst->static_rate = src->static_rate;
> +	dst->ah_flags = src->ah_flags;
> +	dst->port_num = src->port_num;
> +	memcpy(&dst->dmac, &src->dmac, sizeof(dst->dmac));

Since all of the above memcpy wrappers are called in non-data-path probably
(and correct me if i'm wrong) then we are fine with the price of copying
memory for the sake of pvrdma driver - rdma virtual HW computability.

> +}
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

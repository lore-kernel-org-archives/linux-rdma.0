From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 1/2] IB/core: dma map/unmap locking optimizations
Date: Wed, 15 Apr 2015 18:34:21 +0300
Message-ID: <552E84FD.4070700@dev.mellanox.co.il>
References: <1429111077-22739-1-git-send-email-guysh@mellanox.com> <1429111077-22739-2-git-send-email-guysh@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1429111077-22739-2-git-send-email-guysh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Guy Shapiro <guysh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 4/15/2015 6:17 PM, Guy Shapiro wrote:
> Currently, while mapping or unmapping pages for ODP, the umem mutex is locked
> and unlocked once for each page. Such lock/unlock operation take few tens to
> hundreds of nsecs. This makes a significant impact when mapping or unmapping few
> MBs of memory.
>
> To avoid this, the mutex should be locked only once per operation, and not per
> page.
>
> Signed-off-by: Guy Shapiro <guysh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Acked-by: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>   drivers/infiniband/core/umem_odp.c |    9 ++++-----
>   1 files changed, 4 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/infiniband/core/umem_odp.c b/drivers/infiniband/core/umem_odp.c
> index 8b8cc6f..aba4739 100644
> --- a/drivers/infiniband/core/umem_odp.c
> +++ b/drivers/infiniband/core/umem_odp.c
> @@ -446,7 +446,6 @@ static int ib_umem_odp_map_dma_single_page(
>   	int remove_existing_mapping = 0;
>   	int ret = 0;
>
> -	mutex_lock(&umem->odp_data->umem_mutex);
>   	/*
>   	 * Note: we avoid writing if seq is different from the initial seq, to
>   	 * handle case of a racing notifier. This check also allows us to bail
> @@ -479,8 +478,6 @@ static int ib_umem_odp_map_dma_single_page(
>   	}
>
>   out:
> -	mutex_unlock(&umem->odp_data->umem_mutex);
> -
>   	/* On Demand Paging - avoid pinning the page */
>   	if (umem->context->invalidate_range || !stored_page)
>   		put_page(page);
> @@ -586,6 +583,7 @@ int ib_umem_odp_map_dma_pages(struct ib_umem *umem, u64 user_virt, u64 bcnt,
>
>   		bcnt -= min_t(size_t, npages << PAGE_SHIFT, bcnt);
>   		user_virt += npages << PAGE_SHIFT;
> +		mutex_lock(&umem->odp_data->umem_mutex);
>   		for (j = 0; j < npages; ++j) {
>   			ret = ib_umem_odp_map_dma_single_page(
>   				umem, k, base_virt_addr, local_page_list[j],
> @@ -594,6 +592,7 @@ int ib_umem_odp_map_dma_pages(struct ib_umem *umem, u64 user_virt, u64 bcnt,
>   				break;
>   			k++;
>   		}
> +		mutex_unlock(&umem->odp_data->umem_mutex);
>
>   		if (ret < 0) {
>   			/* Release left over pages when handling errors. */
> @@ -633,9 +632,9 @@ void ib_umem_odp_unmap_dma_pages(struct ib_umem *umem, u64 virt,
>   	 * faults from completion. We might be racing with other
>   	 * invalidations, so we must make sure we free each page only
>   	 * once. */
> +	mutex_lock(&umem->odp_data->umem_mutex);
>   	for (addr = virt; addr < bound; addr += (u64)umem->page_size) {
>   		idx = (addr - ib_umem_start(umem)) / PAGE_SIZE;
> -		mutex_lock(&umem->odp_data->umem_mutex);
>   		if (umem->odp_data->page_list[idx]) {
>   			struct page *page = umem->odp_data->page_list[idx];
>   			struct page *head_page = compound_head(page);
> @@ -663,7 +662,7 @@ void ib_umem_odp_unmap_dma_pages(struct ib_umem *umem, u64 virt,
>   			umem->odp_data->page_list[idx] = NULL;
>   			umem->odp_data->dma_list[idx] = 0;
>   		}
> -		mutex_unlock(&umem->odp_data->umem_mutex);
>   	}
> +	mutex_unlock(&umem->odp_data->umem_mutex);
>   }
>   EXPORT_SYMBOL(ib_umem_odp_unmap_dma_pages);
>

Looks good.

Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH for-next 7/9] IB/usnic: Fix printk format warnings
Date: Sat, 21 Dec 2013 11:07:03 +0100
Message-ID: <52B56847.5070209@acm.org>
References: <1387298917-7365-1-git-send-email-umalhi@cisco.com> <1387298917-7365-8-git-send-email-umalhi@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1387298917-7365-8-git-send-email-umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 12/17/13 17:48, Upinder Malhi wrote:
> diff --git a/drivers/infiniband/hw/usnic/usnic_uiom.c b/drivers/infiniband/hw/usnic/usnic_uiom.c
> index 359897d..0477d70 100644
> --- a/drivers/infiniband/hw/usnic/usnic_uiom.c
> +++ b/drivers/infiniband/hw/usnic/usnic_uiom.c
> @@ -81,15 +81,16 @@ static void usnic_uiom_put_pages(struct list_head *chunk_list, int dirty)
>  	struct usnic_uiom_chunk *chunk, *tmp;
>  	struct page *page;
>  	int i;
> +	dma_addr_t pa;
>  
>  	list_for_each_entry_safe(chunk, tmp, chunk_list, list) {
>  		for (i = 0; i < chunk->nents; i++) {
>  			page = sg_page(&chunk->page_list[i]);
> +			pa = sg_phys(&chunk->page_list[i]);
>  			if (dirty)
>  				set_page_dirty_lock(page);
>  			put_page(page);
> -			usnic_dbg("pa: 0x%llx\n",
> -					sg_phys(&chunk->page_list[i]));
> +			usnic_dbg("pa: %pa\n", &pa);
>  		}
>  		kfree(chunk);
>  	}

Maybe I'm missing something, but is there any reason why in the above a
regular for-loop is used instead of for_each_sg() ?

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

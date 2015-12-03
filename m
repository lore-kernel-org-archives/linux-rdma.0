From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 5/6] IB core: Fix ib_sg_to_pages()
Date: Thu, 3 Dec 2015 01:18:06 -0800
Message-ID: <20151203091806.GB21893@infradead.org>
References: <565DE3EC.2070002@sandisk.com>
 <565DE49D.4020102@sandisk.com>
 <565DE7D0.4080408@dev.mellanox.co.il>
 <565DF0A5.6040102@sandisk.com>
 <565EBA78.3050201@dev.mellanox.co.il>
 <565FA75E.7010100@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <565FA75E.7010100-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> How about the patch below ?

The patch looks good to me, but while we touch this area, how about
throwing in a few cosmetic fixes as well?

> -		if (i && page_addr != dma_addr) {
> +		if (i && (page_addr != dma_addr || last_page_off != 0)) {
>  			if (last_end_dma_addr != dma_addr) {

Wo about we one or two sentences for each of the conditions here?

>  				/* gap */
> -				goto done;
> -
> +				break;
>  			} else if (last_page_off + dma_len <= mr->page_size) {
>  				/* chunk this fragment with the last */
>  				mr->length += dma_len;

It would be great to avoid the else clauses if we already to a
break/continue/goto to make the code flow more clear, e.g.


			/*
			 * Gap to the previous segment, we'll need to return
			 * and use another FR to map the reminder.
			 */
			if (last_end_dma_addr != dma_addr)
				break;

			/*
			 * See if this segment is contiguous to the
			 * previous one and just merge it in that case.
			 */
			if (last_page_off + dma_len <= mr->page_size) {
				last_end_dma_addr += dma_len;
				last_page_off += dma_len;
				mr->length += dma_len;
				continue;
			}

			/*
			 * New page-aligned segment to map:
			 */
			page_addr = last_page_addr + mr->page_size;
			dma_len -= mr->page_size - last_page_off;


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

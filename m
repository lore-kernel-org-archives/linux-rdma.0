From: Joerg Roedel <jroedel-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH v3 07/37] lib/dma-virt: Add dma_virt_ops
Date: Mon, 23 Jan 2017 17:03:41 +0100
Message-ID: <20170123160341.GM9529@suse.de>
References: <20170120210437.26389-1-bart.vanassche@sandisk.com>
 <20170120210437.26389-8-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170120210437.26389-8-bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christian Borntraeger <borntraeger-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Michael S . Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jan 20, 2017 at 01:04:07PM -0800, Bart Van Assche wrote:
> +static void *dma_virt_alloc(struct device *dev, size_t size,
> +			    dma_addr_t *dma_handle, gfp_t gfp,
> +			    unsigned long attrs)
> +{
> +	void *ret;
> +
> +	ret = (void *)__get_free_pages(gfp, get_order(size));
> +	if (ret)
> +		*dma_handle = (uintptr_t)ret;

Why do you cast to uintptr_t everywhere in this patch before assigning
to a dma_addr_t when you can cast directly to dma_addr_t?


	Joerg

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [PATCH 1/6] IB/uapi: expose uverbs WR opcodes
Date: Sun, 27 Dec 2015 08:04:19 +0200
Message-ID: <20151227060419.GA8501@leon.nu>
References: <1450967967-12479-1-git-send-email-hch@lst.de>
 <1450967967-12479-2-git-send-email-hch@lst.de>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1450967967-12479-2-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 24, 2015 at 03:39:22PM +0100, Christoph Hellwig wrote:
....
>  #define MLX5_IB_SEND_UMR_UPDATE_MTT (IB_SEND_RESERVED_START << 2)
>  #define MLX5_IB_QPT_REG_UMR	IB_QPT_RESERVED1
> -#define MLX5_IB_WR_UMR		IB_WR_RESERVED1
> +#define MLX5_IB_WR_UMR		(IB_WR_END + 0)
....
>  
> -	IB_WR_RESERVED10,
> +
> +	/* drivers may use any value greater or equal to IB_WR_END internally */
> +	IB_WR_END,
IB_WR_END --> IB_WR_KERNEL_LAST
>  };
>  
....
> +	IB_UVERBS_WR_END			= 9,
I think name IB_UVERBS_WR_LAST describes better than IB_UVERBS_WR_END.
> +};
> +
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

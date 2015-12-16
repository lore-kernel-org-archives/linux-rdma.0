From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH for-next V2 5/5] IB/mlx5: Mmap the HCA's core clock
 register to user-space
Date: Wed, 16 Dec 2015 16:47:03 +0200
Message-ID: <56717967.8010605@dev.mellanox.co.il>
References: <1450204213-5630-1-git-send-email-matanb@mellanox.com>
 <1450204213-5630-6-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450204213-5630-6-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



>   enum mlx5_ib_mmap_cmd {
>   	MLX5_IB_MMAP_REGULAR_PAGE		= 0,
> -	MLX5_IB_MMAP_GET_CONTIGUOUS_PAGES	= 1, /* always last */
> +	MLX5_IB_MMAP_GET_CONTIGUOUS_PAGES	= 1,
> +	/* 5 is chosen in order to be compatible with old versions of libmlx5 */
> +	MLX5_IB_MMAP_CORE_CLOCK			= 5,
>   };

Overall the patches look good so I'd suggest not to apply atop of
the contig pages patchset from Yishai which obviously involves some
debate. Although if this bit is the only conflict then perhaps doug can
take care of it...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

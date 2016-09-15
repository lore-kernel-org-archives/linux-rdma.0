From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [RFC rdma-next 2/3] IB/core: Export mlx5 vendor specific
 strucutres
Date: Wed, 14 Sep 2016 23:13:36 -0700
Message-ID: <20160915061336.GA4869@infradead.org>
References: <1473841649-8923-1-git-send-email-leon@kernel.org>
 <1473841649-8923-3-git-send-email-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1473841649-8923-3-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> index 4edb0f2..e804cc3 100644
> --- a/include/uapi/rdma/Kbuild
> +++ b/include/uapi/rdma/Kbuild
> @@ -7,3 +7,4 @@ header-y += rdma_netlink.h
>  header-y += rdma_user_cm.h
>  header-y += hfi/
>  header-y += rdma_user_rxe.h
> +header-y += providers/

Can we avoid the horrible providers name?  The directories for drivers
in the source tree so far are called hw/ and sw/ so we should stick to
that here as well.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

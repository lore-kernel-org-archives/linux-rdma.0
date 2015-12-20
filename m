From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 10/10] IB: remove the unused usecnt field from struct
 ib_mr
Date: Sun, 20 Dec 2015 09:25:05 +0200
Message-ID: <567657D1.5010700@mellanox.com>
References: <1450446906-10336-1-git-send-email-hch@lst.de>
 <1450446906-10336-11-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450446906-10336-11-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 12/18/2015 3:55 PM, Christoph Hellwig wrote:
>   
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index 284916d..e45776e 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -1306,7 +1306,6 @@ struct ib_mr {
>   	u64		   iova;
>   	u32		   length;
>   	unsigned int	   page_size;
> -	atomic_t	   usecnt; /* count number of MWs */
>   };

This comment is part of Roland's uverbs commit.

I wonder if LL driver supporting the  IB_WR_BIND_MW op
ref the MR on port send and deref it on completion?

Or.


>   
>   struct ib_mw {
> -- 1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

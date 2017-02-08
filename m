From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH rdma-rc] RDMA: Remove kernel private defines and
 reference to header from UAPI
Date: Wed, 8 Feb 2017 00:28:50 -0800
Message-ID: <20170208082850.GA11087@infradead.org>
References: <20170207174600.27218-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170207174600.27218-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>  #include <linux/types.h>
> -#include <rdma/ib_verbs.h>
> 
>  /*
>   * Increment this value if any changes that break userspace ABI
> @@ -548,11 +547,11 @@ enum {
>  };
> 
>  enum {
> -	IB_USER_LEGACY_LAST_QP_ATTR_MASK = IB_QP_DEST_QPN
> +	IB_USER_LEGACY_LAST_QP_ATTR_MASK = 1ULL << 20,
>  };
> 
>  enum {
> -	IB_USER_LAST_QP_ATTR_MASK = IB_QP_RATE_LIMIT
> +	IB_USER_LAST_QP_ATTR_MASK = 1ULL << 25,

I disagree with the upendcoding.  These constant should be moved to
the user verbs header instead.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

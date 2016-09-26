From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 2/5] utils: Create utils directory to put all
 common code and move min/max into it
Date: Mon, 26 Sep 2016 11:20:06 -0600
Message-ID: <20160926172006.GB22965@obsidianresearch.com>
References: <1474786207-2149-1-git-send-email-leon@kernel.org>
 <1474786207-2149-3-git-send-email-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1474786207-2149-3-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Sep 25, 2016 at 09:50:04AM +0300, Leon Romanovsky wrote:

> -#ifndef min
> -#define min(a, b) \
> -	({ typeof(a) _a = (a); \
> -	   typeof(b) _b = (b); \
> -	   _a < _b ? _a : _b; })
> -#endif
> -
> -#ifndef max
> -#define max(a, b) \
> -	({ typeof(a) _a = (a); \
> -	   typeof(b) _b = (b); \
> -	   _a > _b ? _a : _b; })
> -#endif

I'm not excited to replace the safer min above with the less safe min
below, that could actually break something.

> +/*
> + * This include contains all common mathematical functions
> + */
> +#ifndef min
> +#define min(a, b)	(((a) < (b)) ? (a) : (b))
> +#endif
> +
> +#ifndef max
> +#define max(a, b) 	(((a) > (b)) ? (a) : (b))
> +#endif
> +#endif /* _RDMA_MATH_H_ */

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

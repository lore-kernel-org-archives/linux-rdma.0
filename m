From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH rdma-next V1 2/4] IB/core: Support rate limit for packet
 pacing
Date: Thu, 1 Dec 2016 19:40:44 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB0BA789@ORSMSX109.amr.corp.intel.com>
References: <1480592596-20126-1-git-send-email-leon@kernel.org>
 <1480592596-20126-3-git-send-email-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1480592596-20126-3-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>  enum ib_qp_state {
> @@ -1151,6 +1152,7 @@ struct ib_qp_attr {
>  	u8			rnr_retry;
>  	u8			alt_port_num;
>  	u8			alt_timeout;
> +	u32			rate_limit;
>  };

And I still disagree with this approach, as there is already an existing field in the API that limits rate.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

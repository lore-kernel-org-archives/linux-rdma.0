From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH libmlx4 V3 1/2] Add RoCE IP based addressing support for
 UD QPs
Date: Wed, 21 May 2014 14:00:43 -0600
Message-ID: <20140521200043.GB26909@obsidianresearch.com>
References: <1400405952-14388-1-git-send-email-ogerlitz@r-vnc04.mtr.labs.mlnx>
 <1400405952-14388-2-git-send-email-ogerlitz@r-vnc04.mtr.labs.mlnx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1400405952-14388-2-git-send-email-ogerlitz-lZu6o6FoHf8DyJZ7l8Lk7nI+JuX82XLG@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, May 18, 2014 at 12:39:11PM +0300, Or Gerlitz wrote:
> From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> In order to implement IP based addressing for UD QPs, we need a way to
> resolve the addresses internally.
> The L2 params are passed to the provider driver using an extension verbs
> - drv_ibv_create_ah_ex.
   ^^^^^^
The name changed

> +struct ibv_ah *mlx4_create_ah_ex(struct ibv_pd *pd,
> +				 struct ibv_ah_attr_ex *attr_ex)
> +{
> +	struct ibv_port_attr port_attr;
> +	struct ibv_ah *ah;
> +	struct mlx4_ah *mah;
> +
> +	if (ibv_query_port(pd->context, attr_ex->port_num, &port_attr))
> +		return NULL;
> +
> +	ah = mlx4_create_ah_common(pd, (struct ibv_ah_attr *)attr_ex,
> +				   port_attr.link_layer);
> +
> +	if (NULL == ah)
> +		return NULL;

I'm seeing a real lack of error reporting here.

My prior question was never answered: Should we be consistently using
errno for functions that return pointers? If yes, you need to make
sure errno is set on these failure paths, and document the possible
values errno can take.

> +	/* check that ll is provided and valid */
> +	if (attr_ex->comp_mask & IBV_AH_ATTR_EX_LL) {
> +		if (ARPHRD_ETHER != attr_ex->ll.sa.sa_family ||
                  ^^^^^^^^^^^
As I mentioned before, ARPHDR_ETHER is not correct for sa_family.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

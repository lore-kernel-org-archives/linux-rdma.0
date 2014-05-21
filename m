From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH libibverbs V4 2/5] Extend create_ah in order to pass L2
 parameters to the provider
Date: Wed, 21 May 2014 13:55:49 -0600
Message-ID: <20140521195549.GA26909@obsidianresearch.com>
References: <1400405929-14313-1-git-send-email-ogerlitz@r-vnc04.mtr.labs.mlnx>
 <1400405929-14313-3-git-send-email-ogerlitz@r-vnc04.mtr.labs.mlnx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1400405929-14313-3-git-send-email-ogerlitz-lZu6o6FoHf8DyJZ7l8Lk7nI+JuX82XLG@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, May 18, 2014 at 12:38:46PM +0300, Or Gerlitz wrote:
> From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> In order to support IP based addressing, one needs to pass the L2
> parameters to the provider drive. This is done through a new extendable
                               ^^^^
'driver'

Please provide a man page. In this case you probably want to provide a
patch to the existing man/ibv_create_ah.3 to discuss the 2nd entry
point and new fields.

> +enum ibv_ah_attr_ex_attr_mask {
> +	IBV_AH_ATTR_EX_LL = 1UL << 0,
> +	IBV_AH_ATTR_EX_VID = 1UL << 1,
> +};

OK

> +struct ibv_ah_attr_ex {
> +	struct ibv_global_route	grh;
> +	uint16_t		dlid;
> +	uint8_t			sl;
> +	uint8_t			src_path_bits;
> +	uint8_t			static_rate;
> +	uint8_t			is_global;
> +	uint8_t			port_num;
> +	uint32_t		comp_mask;

OK

> +	union {
> +		struct sockaddr		sa;
> +		struct sockaddr_storage _s;
> +	} ll;
> +	uint16_t		vid;
> +};

Hard to know exactly what is going on here without a man page, but I
thought one of the points was to provide an ethernet L2 MAC address?
Shouldn't there be a mechanism for that?

I see this:

+       attr_ex.ll.sa.sa_family = ARPHRD_ETHER;

Which makes no sense, sa_family should be an AF_* constant.

So, I think this bit needs some kind of work. If you want to setup
ethernet, then setup ethernet:

uint64_t eth_dmac
uint16_t eth_vid;

and what about all the trendy new ethernet stuff, overlay networks,
etc? Can that be expressed in there?

> @@ -975,6 +998,8 @@ enum verbs_context_mask {
>  
>  struct verbs_context {
>  	/*  "grows up" - new fields go here */
> +	struct ibv_ah * (*create_ah_ex)(struct ibv_pd *pd,
> +					struct ibv_ah_attr_ex *attr);

Can you check if 'attr' should be const? I see the existing API isn't
const, but I am suspecting that is a mistake?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

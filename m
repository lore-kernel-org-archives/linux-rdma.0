From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-next 01/31] IB/core: Fix do not add RoCEv2 default
 GID when IPv6 is disabled
Date: Tue, 14 Nov 2017 17:18:17 -0700
Message-ID: <20171115001817.GH25894@ziepe.ca>
References: <20171114125218.20477-1-leon@kernel.org>
 <20171114125218.20477-2-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171114125218.20477-2-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 14, 2017 at 02:51:48PM +0200, Leon Romanovsky wrote:

> +	/* Default GID is created using unique GUID and local subnet prefix,
> +	 * as described in section 4.1.1 and 3.5.10 in IB spec 1.3.
> +	 * Therefore don't create RoCEv2 default GID based on it that
> +	 * resembles as IPv6 GID based on link local address when IPv6 is
> +	 * disabled in kernel.
> +	 */
> +	if (!IS_ENABLED(CONFIG_IPV6))
> +		gid_type_mask &= ~BIT(IB_GID_TYPE_ROCE_UDP_ENCAP);

There is also a sysctl to globally disable ipv6, I would think it
would be better to check than then a CONFIG symbol?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

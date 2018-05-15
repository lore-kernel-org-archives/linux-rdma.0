From: David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH v2 iproute2-next 1/3] rdma: update rdma_netlink.h to get
 new driver attributes
Date: Tue, 15 May 2018 13:37:03 -0600
Message-ID: <f419f21a-d57d-ba6c-419e-4fdf24eaa662@gmail.com>
References: <cover.1526312594.git.swise@opengridcomputing.com>
 <ef3d41db66cf503f717f92f6e595c065ea4dbe4e.1526312594.git.swise@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <ef3d41db66cf503f717f92f6e595c065ea4dbe4e.1526312594.git.swise@opengridcomputing.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>, leon@kernel.org
Cc: stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 5/14/18 9:42 AM, Steve Wise wrote:
> diff --git a/rdma/include/uapi/rdma/rdma_netlink.h b/rdma/include/uapi/rdma/rdma_netlink.h
> index 60416ed..40be0d8 100644
> --- a/rdma/include/uapi/rdma/rdma_netlink.h
> +++ b/rdma/include/uapi/rdma/rdma_netlink.h
> @@ -249,10 +249,22 @@ enum rdma_nldev_command {
>  	RDMA_NLDEV_NUM_OPS
>  };
>  
> +enum {
> +	RDMA_NLDEV_ATTR_ENTRY_STRLEN = 16,
> +};
> +
> +enum rdma_nldev_print_type {
> +	RDMA_NLDEV_PRINT_TYPE_UNSPEC,
> +	RDMA_NLDEV_PRINT_TYPE_HEX,
> +};
> +
>  enum rdma_nldev_attr {
>  	/* don't change the order or add anything between, this is ABI! */

I asked this before and did not get a response. As the comment above
states with an emphasis (!) ...

>  	RDMA_NLDEV_ATTR_UNSPEC,
>  
> +	/* Pad attribute for 64b alignment */
> +	RDMA_NLDEV_ATTR_PAD = RDMA_NLDEV_ATTR_UNSPEC,
> +

... are you really adding new attributes in the middle?

>  	/* Identifier for ib_device */
>  	RDMA_NLDEV_ATTR_DEV_INDEX,		/* u32 */
>  
> @@ -387,6 +399,20 @@ enum rdma_nldev_attr {
>  	RDMA_NLDEV_ATTR_RES_PD_ENTRY,		/* nested table */
>  	RDMA_NLDEV_ATTR_RES_LOCAL_DMA_LKEY,	/* u32 */
>  	RDMA_NLDEV_ATTR_RES_UNSAFE_GLOBAL_RKEY,	/* u32 */
> +	/*
> +	 * driver-specific attributes.
> +	 */
> +	RDMA_NLDEV_ATTR_DRIVER,			/* nested table */
> +	RDMA_NLDEV_ATTR_DRIVER_ENTRY,		/* nested table */
> +	RDMA_NLDEV_ATTR_DRIVER_STRING,		/* string */
> +	/*
> +	 * u8 values from enum rdma_nldev_print_type
> +	 */
> +	RDMA_NLDEV_ATTR_DRIVER_PRINT_TYPE,	/* u8 */
> +	RDMA_NLDEV_ATTR_DRIVER_S32,		/* s32 */
> +	RDMA_NLDEV_ATTR_DRIVER_U32,		/* u32 */
> +	RDMA_NLDEV_ATTR_DRIVER_S64,		/* s64 */
> +	RDMA_NLDEV_ATTR_DRIVER_U64,		/* u64 */

and again here.

>  
>  	/*
>  	 * Provides logical name and index of netdevice which is
> 

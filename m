From: David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH RFC iproute2-next 1/2] rdma: update rdma_netlink.h to get
 provider attrs
Date: Wed, 2 May 2018 09:17:22 -0600
Message-ID: <9b084ced-a9d3-5474-ba78-dfa06417773b@gmail.com>
References: <cover.1525100473.git.swise@opengridcomputing.com>
 <10f219db72dfb6e8d5d84ee009c97594b6d211c1.1525100473.git.swise@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <10f219db72dfb6e8d5d84ee009c97594b6d211c1.1525100473.git.swise@opengridcomputing.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>, leon@kernel.org
Cc: stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 4/30/18 8:36 AM, Steve Wise wrote:
> Signed-off-by: Steve Wise <swise@opengridcomputing.com>
> ---
>  rdma/include/uapi/rdma/rdma_netlink.h | 37 ++++++++++++++++++++++++++++++++++-
>  1 file changed, 36 insertions(+), 1 deletion(-)
> 
> diff --git a/rdma/include/uapi/rdma/rdma_netlink.h b/rdma/include/uapi/rdma/rdma_netlink.h
> index 45474f1..faea9d5 100644
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
>  	RDMA_NLDEV_ATTR_UNSPEC,
>  
> +	/* Pad attribute for 64b alignment */
> +	RDMA_NLDEV_ATTR_PAD = RDMA_NLDEV_ATTR_UNSPEC,

are you really inserting a new value here?

> +
>  	/* Identifier for ib_device */
>  	RDMA_NLDEV_ATTR_DEV_INDEX,		/* u32 */
>  
> @@ -387,8 +399,31 @@ enum rdma_nldev_attr {
>  	RDMA_NLDEV_ATTR_RES_PD_ENTRY,		/* nested table */
>  	RDMA_NLDEV_ATTR_RES_LOCAL_DMA_LKEY,	/* u32 */
>  	RDMA_NLDEV_ATTR_RES_UNSAFE_GLOBAL_RKEY,	/* u32 */
> +	/*
> +	 * provider-specific attributes.
> +	 */
> +	RDMA_NLDEV_ATTR_PROVIDER,		/* nested table */
> +	RDMA_NLDEV_ATTR_PROVIDER_ENTRY,		/* nested table */
> +	RDMA_NLDEV_ATTR_PROVIDER_STRING,	/* string */
> +	/*
> +	 * u8 values from enum rdma_nldev_print_type
> +	 */
> +	RDMA_NLDEV_ATTR_PROVIDER_PRINT_TYPE,	/* u8 */
> +	RDMA_NLDEV_ATTR_PROVIDER_S32,		/* s32 */
> +	RDMA_NLDEV_ATTR_PROVIDER_U32,		/* u32 */
> +	RDMA_NLDEV_ATTR_PROVIDER_S64,		/* s64 */
> +	RDMA_NLDEV_ATTR_PROVIDER_U64,		/* u64 */

and this sequence too.



>  
> -	/* Netdev information for relevant protocols, like RoCE and iWARP */
> +	/*
> +	 * Provides logical name and index of netdevice which is
> +	 * connected to physical port. This information is relevant
> +	 * for RoCE and iWARP.
> +	 *
> +	 * The netdevices which are associated with containers are
> +	 * supposed to be exported together with GID table once it
> +	 * will be exposed through the netlink. Because the
> +	 * associated netdevices are properties of GIDs.
> +	 */
>  	RDMA_NLDEV_ATTR_NDEV_INDEX,		/* u32 */
>  	RDMA_NLDEV_ATTR_NDEV_NAME,		/* string */
>  
> 

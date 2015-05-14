From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 5/5] IB/core: Convert management helpers to core capability
 bits
Date: Thu, 14 May 2015 10:16:03 -0400
Message-ID: <5554AE23.3020909@dev.mellanox.co.il>
References: <1431561779-13714-1-git-send-email-ira.weiny@intel.com> <1431561779-13714-6-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431561779-13714-6-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 5/13/2015 8:02 PM, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:

<snip...>

> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index de08dabcfa6a..29095fb6db5c 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -353,6 +353,40 @@ union rdma_protocol_stats {
>  	struct iw_protocol_stats	iw;
>  };
>  
> +/* Define bits for the various functionality this port needs to be supported by
> + * the core.
> + */
> +/* Management                           0x00000FFF */
> +#define RDMA_CORE_CAP_IB_MAD            0x00000001
> +#define RDMA_CORE_CAP_IB_SMI            0x00000002
> +#define RDMA_CORE_CAP_IB_CM             0x00000004
> +#define RDMA_CORE_CAP_IW_CM             0x00000008
> +#define RDMA_CORE_CAP_IB_SA             0x00000010
> +
> +/* Address format                       0x000FF000 */
> +#define RDMA_CORE_CAP_AF_IB             0x00001000
> +#define RDMA_CORE_CAP_ETH_AH            0x00002000
> +
> +/* Protocol                             0xFFF00000 */
> +#define RDMA_CORE_CAP_PROT_IB           0x00100000
> +#define RDMA_CORE_CAP_PROT_ROCE         0x00200000
> +#define RDMA_CORE_CAP_PROT_IWARP        0x00400000
> +
> +#define RDMA_CORE_PORT_IBA_IB          (RDMA_CORE_CAP_PROT_IB  \
> +					| RDMA_CORE_CAP_IB_MAD \
> +					| RDMA_CORE_CAP_IB_SMI \
> +					| RDMA_CORE_CAP_IB_CM  \
> +					| RDMA_CORE_CAP_IB_SA  \
> +					| RDMA_CORE_CAP_AF_IB)
> +#define RDMA_CORE_PORT_IBA_ROCE        (RDMA_CORE_CAP_PROT_ROCE \
> +					| RDMA_CORE_CAP_IB_MAD  \
> +					| RDMA_CORE_CAP_IB_CM   \
> +					| RDMA_CORE_CAP_IB_SA   \
> +					| RDMA_CORE_CAP_AF_IB   \
> +					| RDMA_CORE_CAP_ETH_AH)
> +#define RDMA_CORE_PORT_IWARP           (RDMA_CORE_CAP_PROT_IWARP \
> +					| RDMA_CORE_CAP_IW_CM)
> +
>  struct ib_port_attr {
>  	enum ib_port_state	state;
>  	enum ib_mtu		max_mtu;
> @@ -1484,6 +1518,7 @@ struct iw_cm_verbs;
>  struct ib_port_immutable {
>  	int                           pkey_tbl_len;
>  	int                           gid_tbl_len;
> +	u32                           core_cap_flags;
>  };
>  
>  struct ib_device {
> @@ -1515,8 +1550,6 @@ struct ib_device {
>  	int		           (*query_port)(struct ib_device *device,
>  						 u8 port_num,
>  						 struct ib_port_attr *port_attr);
> -	enum rdma_protocol_type    (*query_protocol)(struct ib_device *device,
> -						     u8 port_num);
>  	enum rdma_link_layer	   (*get_link_layer)(struct ib_device *device,
>  						     u8 port_num);
>  	int		           (*query_gid)(struct ib_device *device,
> @@ -1796,24 +1829,23 @@ static inline u8 rdma_end_port(const struct ib_device *device)
>  
>  static inline bool rdma_protocol_ib(struct ib_device *device, u8 port_num)
>  {
> -	return device->query_protocol(device, port_num) == RDMA_PROTOCOL_IB;
> +	return device->port_immutable[port_num].core_cap_flags & RDMA_CORE_CAP_PROT_IB;
>  }
>  
>  static inline bool rdma_protocol_iboe(struct ib_device *device, u8 port_num)

Should this helper be renamed rdma_protocol_roce (and change any
consumers of this helper to use that name) ? If so, should it be done in
this patch or follow on patch ?

-- Hal

<snip...>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

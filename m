From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 3/5] IB/core: Convert management helpers to core
 capability bits
Date: Tue, 12 May 2015 02:38:33 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373A8FCE4DE@ORSMSX109.amr.corp.intel.com>
References: <1431395218-27693-1-git-send-email-ira.weiny@intel.com>
 <1431395218-27693-4-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431395218-27693-4-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index fe7efbe..f93694f 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -353,6 +353,40 @@ union rdma_protocol_stats {
>  	struct iw_protocol_stats	iw;
>  };
> 
> +/* Define bits for the various functionality this port needs to be
> supported by
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
> +#define RDMA_CORE_CAP_PROT_IBOE         0x00200000

Use ROCE in place of IBOE for consistency with the definition below.

> +#define RDMA_CORE_CAP_PROT_IWARP        0x00400000
> +
> +#define RDMA_CORE_PORT_IBA_IB          (RDMA_CORE_CAP_PROT_IB  \
> +					| RDMA_CORE_CAP_IB_MAD \
> +					| RDMA_CORE_CAP_IB_SMI \
> +					| RDMA_CORE_CAP_IB_CM  \
> +					| RDMA_CORE_CAP_IB_SA  \
> +					| RDMA_CORE_CAP_AF_IB)
> +#define RDMA_CORE_PORT_IBA_ROCEE       (RDMA_CORE_CAP_PROT_IBOE \

Rename ROCEE to ROCE.

> +					| RDMA_CORE_CAP_IB_MAD  \
> +					| RDMA_CORE_CAP_IB_CM   \
> +					| RDMA_CORE_CAP_IB_SA   \
> +					| RDMA_CORE_CAP_AF_IB   \
> +					| RDMA_CORE_CAP_ETH_AH)
> +#define RDMA_CORE_PORT_IWARP           (RDMA_CORE_CAP_PROT_IWARP \
> +					| RDMA_CORE_CAP_IW_CM)

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

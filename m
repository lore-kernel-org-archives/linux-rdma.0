From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 2/2] libibverbs: Add support for XRC QPs
Date: Thu, 16 Jun 2011 18:05:28 +0300
Message-ID: <4DFA1BB8.9000305@mellanox.com>
References: <1828884A29C6694DAF28B7E6B8A8237302124E@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237302124E-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hefty, Sean wrote:
>  enum ibv_qp_type {
>  	IBV_QPT_RC = 2,
>  	IBV_QPT_UC,
> -	IBV_QPT_UD
> +	IBV_QPT_UD,
> +	IBV_QPT_XRC_SEND,
> +	IBV_QPT_XRC_RECV
>  };

Sean,

The upstream kernel (below) uses already the values 5 and 6 for
the IB RAW qp types

> enum ib_qp_type {
>         IB_QPT_SMI,
>         IB_QPT_GSI,
>         IB_QPT_RC,
>         IB_QPT_UC,
>         IB_QPT_UD,
>         IB_QPT_RAW_IPV6,
>         IB_QPT_RAW_ETHERTYPE
> };


ofed (below) uses 5 for XRC, 6/7 for IB raw qp types
and 8 for the new "eth packet qp", XRC and the packet QP
are used from user space with code which is out...
so if possible can we at least keep the packet qp type value
unchanged, as for XRC its different API...

> enum ib_qp_type {
>         IB_QPT_SMI,
>         IB_QPT_GSI,
>         IB_QPT_RC,
>         IB_QPT_UC,
>         IB_QPT_UD,
>         IB_QPT_XRC,
>         IB_QPT_RAW_IPV6,
>         IB_QPT_RAW_ETHERTYPE,
>         IB_QPT_RAW_PACKET
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

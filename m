From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-rc 5/9] IB/mlx4: Handle well-known-gid in mad_demux
 processing
Date: Sat, 5 Nov 2016 17:03:25 -0400
Message-ID: <d339ee5f-bf7e-dc35-3dd0-c6ff13a222b4@dev.mellanox.co.il>
References: <1478375842-21513-1-git-send-email-leonro@mellanox.com>
 <1478375842-21513-6-git-send-email-leonro@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1478375842-21513-6-git-send-email-leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/5/2016 3:57 PM, Leon Romanovsky wrote:
> From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
> 
> If OpenSM runs over ConnectX-3, and there are ConnectIB VFs active
> on the network, the OpenSM will receive QP1 packets containing a GRH
> where the destination GID is the "Well-Known GID" -- which is not a GID
> in the HCA Port's GID Table.
> 
> This GID must be tested-for separately -- and packets which contain
> this destination GID should be routed to slave 0 (the PF).
> 
> Fixes: 37bfc7c1e83f ('IB/mlx4: SR-IOV multiplex and demultiplex MADs')
> Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
> Signed-off-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/hw/mlx4/mad.c | 16 ++++++++++++----
>  include/rdma/ib_verbs.h          |  1 +
>  2 files changed, 13 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
> index b8e9013..f0b8272 100644
> --- a/drivers/infiniband/hw/mlx4/mad.c
> +++ b/drivers/infiniband/hw/mlx4/mad.c
> @@ -729,10 +729,18 @@ static int mlx4_ib_demux_mad(struct ib_device *ibdev, u8 port,
>  
>  	/* If a grh is present, we demux according to it */
>  	if (wc->wc_flags & IB_WC_GRH) {
> -		slave = mlx4_ib_find_real_gid(ibdev, port, grh->dgid.global.interface_id);
> -		if (slave < 0) {
> -			mlx4_ib_warn(ibdev, "failed matching grh\n");
> -			return -ENOENT;
> +		if (grh->dgid.global.interface_id ==
> +			cpu_to_be64(IB_SA_WELL_KNOWN_GUID) &&
> +		    grh->dgid.global.subnet_prefix ==
> +			cpu_to_be64(IB_SA_WELL_KNOWN_GID_PREFIX)) {
> +			slave = 0;
> +		} else {
> +			slave = mlx4_ib_find_real_gid(ibdev, port,
> +						      grh->dgid.global.interface_id);
> +			if (slave < 0) {
> +				mlx4_ib_warn(ibdev, "failed matching grh\n");
> +				return -ENOENT;
> +			}
>  		}
>  	}
>  	/* Class-specific handling */
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index 467a4b4..da5949f 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -100,6 +100,7 @@ enum rdma_node_type {
>  
>  enum {
>  	/* set the local administered indication */
> +	IB_SA_WELL_KNOWN_GID_PREFIX = 0xfe80000000000000ull,
>  	IB_SA_WELL_KNOWN_GUID	= BIT_ULL(57) | 2,

Isn't the SA well-known GID the concatenation of the subnet prefix
(which isn't necessarily the default link local one) and the GUID
0x0200000000000002 ?

-- Hal

>  };
>  
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCHv2 infiniband-diags] ibnetdisc.c: Add additional
 supported device IDs to is_mlnx_ext_port_info_supported
Date: Mon, 19 Jan 2015 22:26:25 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E0CC05B5D@CRSMSX101.amr.corp.intel.com>
References: <54B67807.5090507@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54B67807.5090507-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Hal Rosenstock
> Sent: Wednesday, January 14, 2015 6:07 AM
> To: Weiny, Ira
> Cc: linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)
> Subject: [PATCHv2 infiniband-diags] ibnetdisc.c: Add additional supported
> device IDs to is_mlnx_ext_port_info_supported
> 
> Similar to previous ibdiag_common.c patch, this adds additional device IDs to
> be supported to the ibnetdiscover internal is_mlnx_ext_port_info routine.
> These IDs are ConnectX-4, ConnectX-IB, and Switch-IB.
> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks applied.
Ira



> ---
> Change from v1:
> Changed ConnectX-3 to ConnectX-IB in patch description
> 
> diff --git a/libibnetdisc/src/ibnetdisc.c b/libibnetdisc/src/ibnetdisc.c index
> 121fe35..f3c6000 100644
> --- a/libibnetdisc/src/ibnetdisc.c
> +++ b/libibnetdisc/src/ibnetdisc.c
> @@ -203,9 +203,9 @@ static int is_mlnx_ext_port_info_supported(ibnd_port_t
> * port)  {
>  	uint16_t devid = (uint16_t) mad_get_field(port->node->info, 0,
> IB_NODE_DEVID_F);
> 
> -	if (devid == 0xc738)
> +	if (devid == 0xc738 || devid == 0xcb84)
>  		return 1;
> -	if (devid >= 0x1003 && devid <= 0x1011)
> +	if (devid >= 0x1003 && devid <= 0x1016)
>  		return 1;
>  	return 0;
>  }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the body
> of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

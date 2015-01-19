From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v3 infiniband-diags] ibdiag_common.c: Add more supported
 device IDs in is_mlnx_ext_port_info_supported
Date: Mon, 19 Jan 2015 22:26:39 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E0CC05B69@CRSMSX101.amr.corp.intel.com>
References: <54B677FE.6040508@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54B677FE.6040508-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Hal Rosenstock
> Sent: Wednesday, January 14, 2015 6:07 AM
> To: Weiny, Ira
> Cc: linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org); Or Gerlitz
> Subject: [PATCH v3 infiniband-diags] ibdiag_common.c: Add more supported
> device IDs in is_mlnx_ext_port_info_supported
> 
> Add support for some ConnectX-IB, ConnectX-4, and Switch-IB in
> is_mlnx_ext_port_info_supported.
> 
> This only affects tool(s) which invoke this routine
> (is_mlnx_ext_port_info_supported) which is currently just ibportstate.
> 
> is_mlnx_ext_port_info_supported determines whether or not the MLNX vendor
> extended port info SMP is sent which is used to determine FDR10 speed.
> 
> Not having the device in the list would only result in FDR10 being
> misinterpreted as QDR.
> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks, applied,
Ira 


> ---
> Change since v2:
> Changed ConnectX-3 to ConnectX-IB in patch description
> 
> Change since v1:
> Improved patch description
> 
> diff --git a/src/ibdiag_common.c b/src/ibdiag_common.c index
> 8c749c7..384d342 100644
> --- a/src/ibdiag_common.c
> +++ b/src/ibdiag_common.c
> @@ -499,9 +499,9 @@ conv_cnt_human_readable(uint64_t val64, float *val,
> int data)  int is_mlnx_ext_port_info_supported(uint32_t devid)  {
>  	if (ibd_ibnetdisc_flags & IBND_CONFIG_MLX_EPI) {
> -		if (devid == 0xc738)
> +		if (devid == 0xc738 || devid == 0xcb84)
>  			return 1;
> -		if (devid >= 0x1003 && devid <= 0x1011)
> +		if (devid >= 0x1003 && devid <= 0x1016)
>  			return 1;
>  	}
>  	return 0;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the body
> of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

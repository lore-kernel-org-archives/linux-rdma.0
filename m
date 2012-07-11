From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCHv2] infiniband-diags: Support MLNX ExtendedPortInfo for
 ConnectIB device
Date: Tue, 10 Jul 2012 17:41:50 -0700
Message-ID: <20120710174150.2e9d6e4189858392b07816ab@llnl.gov>
References: <4FF9C831.8010506@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4FF9C831.8010506-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, 08 Jul 2012 13:49:37 -0400
Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
> Change since v1:
> Added similar change to libibnetdisc
> Pointed out by Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> diff --git a/libibnetdisc/src/ibnetdisc.c b/libibnetdisc/src/ibnetdisc.c
> index a0cbe3e..3a7dd8f 100644
> --- a/libibnetdisc/src/ibnetdisc.c
> +++ b/libibnetdisc/src/ibnetdisc.c
> @@ -205,7 +205,7 @@ static int
> is_mlnx_ext_port_info_supported(ibnd_port_t * port)

I am not sure why but the patch line wrapped here.

Regardless I fixed it and applied, thanks,
Ira

> 
>  	if (devid == 0xc738)
>  		return 1;
> -	if (devid >= 0x1003 && devid <= 0x1010)
> +	if (devid >= 0x1003 && devid <= 0x1011)
>  		return 1;
>  	return 0;
>  }
> diff --git a/src/ibdiag_common.c b/src/ibdiag_common.c
> index 78882a2..ebe8797 100644
> --- a/src/ibdiag_common.c
> +++ b/src/ibdiag_common.c
> @@ -501,7 +501,7 @@ int is_mlnx_ext_port_info_supported(uint32_t devid)
>  	if (ibd_ibnetdisc_flags & IBND_CONFIG_MLX_EPI) {
>  		if (devid == 0xc738)
>  			return 1;
> -		if (devid >= 0x1003 && devid <= 0x1010)
> +		if (devid >= 0x1003 && devid <= 0x1011)
>  			return 1;
>  	}
>  	return 0;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ira Weiny
Member of Technical Staff
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

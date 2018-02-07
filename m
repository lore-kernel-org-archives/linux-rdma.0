From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH infiniband-diags] Add additional ConnectX-5 device ID to white lists
Date: Wed, 7 Feb 2018 00:31:38 -0500
Message-ID: <20180207053137.GB25132@phlsvsds.ph.intel.com>
References: <e0829b84-1f66-aee3-7ca5-3d06174cbc83@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <e0829b84-1f66-aee3-7ca5-3d06174cbc83-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Feb 02, 2018 at 08:49:56AM -0500, Hal Rosenstock wrote:
> 
> New Connect-X5 is device ID 0x1019
> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>

Thanks applied,
Ira

> ---
>  libibnetdisc/src/ibnetdisc.c | 2 +-
>  src/ibdiag_common.c          | 2 +-
>  src/vendstat.c               | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/libibnetdisc/src/ibnetdisc.c b/libibnetdisc/src/ibnetdisc.c
> index 61e30d4..26bd09a 100644
> --- a/libibnetdisc/src/ibnetdisc.c
> +++ b/libibnetdisc/src/ibnetdisc.c
> @@ -206,7 +206,7 @@ static int is_mlnx_ext_port_info_supported(ibnd_port_t * port)
>  	      devid == 0x1ba0 ||
>  	      (devid >= 0x1bd0 && devid <= 0x1bd5))))
>  		return 1;
> -	if ((devid >= 0x1003 && devid <= 0x1017) ||
> +	if ((devid >= 0x1003 && devid <= 0x1019) ||
>  	    ((vendorid == 0x119f) &&
>  	     /* Bull ConnectX3 */
>  	     (devid == 0x1b33 || devid == 0x1b73 ||
> diff --git a/src/ibdiag_common.c b/src/ibdiag_common.c
> index c33cacc..a57a04b 100644
> --- a/src/ibdiag_common.c
> +++ b/src/ibdiag_common.c
> @@ -550,7 +550,7 @@ int is_mlnx_ext_port_info_supported(uint32_t vendorid,
>  		      devid == 0x1ba0 ||
>  		      (devid >= 0x1bd0 && devid <= 0x1bd5))))
>  			return 1;
> -		if ((devid >= 0x1003 && devid <= 0x1017) ||
> +		if ((devid >= 0x1003 && devid <= 0x1019) ||
>  		    ((vendorid == 0x119f) &&
>  		     /* Bull ConnectX3 */
>  		     (devid == 0x1b33 || devid == 0x1b73 ||
> diff --git a/src/vendstat.c b/src/vendstat.c
> index c35c25d..f3b3d42 100644
> --- a/src/vendstat.c
> +++ b/src/vendstat.c
> @@ -148,7 +148,7 @@ static uint16_t ext_fw_info_device[][2] = {
>  	{0xcb20, 0xcb20},	/* Switch-IB */
>  	{0xcf08, 0xcf08},	/* Switch-IB2 */
>  	{0x01b3, 0x01b3},	/* IS-4 */
> -	{0x1003, 0x1017},	/* Connect-X */
> +	{0x1003, 0x1019},	/* Connect-X */
>  	{0x1b02, 0x1b02},	/* Bull SwitchX */
>  	{0x1b50, 0x1b50},	/* Bull SwitchX */
>  	{0x1ba0, 0x1ba0},	/* Bull SwitchIB */
> -- 
> 2.8.4
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

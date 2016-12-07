From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH infiniband-diags] Add Bull device ID support to device white lists
Date: Wed, 7 Dec 2016 09:53:39 -0500
Message-ID: <20161207145338.GD24724@phlsvsds.ph.intel.com>
References: <e5ad4256-53fe-9ecc-f880-89347134ec42@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <e5ad4256-53fe-9ecc-f880-89347134ec42-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 06, 2016 at 02:22:52PM -0500, Hal Rosenstock wrote:
> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks applied,
Ira

> ---
> diff --git a/libibnetdisc/src/ibnetdisc.c b/libibnetdisc/src/ibnetdisc.c
> index 6ef7805..223e097 100644
> --- a/libibnetdisc/src/ibnetdisc.c
> +++ b/libibnetdisc/src/ibnetdisc.c
> @@ -197,7 +197,7 @@ static int is_mlnx_ext_port_info_supported(ibnd_port_t * port)
>  {
>  	uint16_t devid = (uint16_t) mad_get_field(port->node->info, 0, IB_NODE_DEVID_F);
>  
> -	if ((devid >= 0xc738 && devid <= 0xc73b) || devid == 0xcb20 || devid == 0xcf08)
> +	if ((devid >= 0xc738 && devid <= 0xc73b) || devid == 0xcb20 || devid == 0xcf08 || devid == 0x1b02)
>  		return 1;
>  	if (devid >= 0x1003 && devid <= 0x1016)
>  		return 1;
> diff --git a/src/ibdiag_common.c b/src/ibdiag_common.c
> index 2a1e971..6809a1e 100644
> --- a/src/ibdiag_common.c
> +++ b/src/ibdiag_common.c
> @@ -530,7 +530,7 @@ int is_port_info_extended_supported(ib_portid_t * dest, int port,
>  int is_mlnx_ext_port_info_supported(uint32_t devid)
>  {
>  	if (ibd_ibnetdisc_flags & IBND_CONFIG_MLX_EPI) {
> -		if ((devid >= 0xc738 && devid <= 0xc73b) || devid == 0xcb20 || devid == 0xcf08)
> +		if ((devid >= 0xc738 && devid <= 0xc73b) || devid == 0xcb20 || devid == 0xcf08 || devid == 0x1b02)
>  			return 1;
>  		if (devid >= 0x1003 && devid <= 0x1016)
>  			return 1;
> diff --git a/src/vendstat.c b/src/vendstat.c
> index fb42a78..284ef93 100644
> --- a/src/vendstat.c
> +++ b/src/vendstat.c
> @@ -149,6 +149,7 @@ static uint16_t ext_fw_info_device[][2] = {
>  	{0xcf08, 0xcf08},	/* Switch-IB2 */
>  	{0x01b3, 0x01b3},	/* IS-4 */
>  	{0x1003, 0x1016},	/* Connect-X */
> +	{0x1b02, 0x1b02},	/* Bull */
>  	{0x0000, 0x0000}};
>  
>  static int is_ext_fw_info_supported(uint16_t device_id) {
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

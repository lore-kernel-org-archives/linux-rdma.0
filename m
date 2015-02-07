From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH infiniband-diags] Align infiniband-diags MLNX device IDs
 with OpenSM
Date: Sat, 7 Feb 2015 03:39:55 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E0CC2061B@CRSMSX101.amr.corp.intel.com>
References: <54C95A7F.10209@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54C95A7F.10209-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dan Ben-Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> 
> 
> Same device IDs as in opensm/osm_subnet.c:is_mlnx_ext_port_info_supported
> 
> Switch-IB is device ID 0xcb20 rather than 0xcb84
> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks applied,
Ira

> ---
> diff --git a/libibnetdisc/src/ibnetdisc.c b/libibnetdisc/src/ibnetdisc.c index
> f3c6000..e346905 100644
> --- a/libibnetdisc/src/ibnetdisc.c
> +++ b/libibnetdisc/src/ibnetdisc.c
> @@ -203,7 +203,7 @@ static int is_mlnx_ext_port_info_supported(ibnd_port_t
> * port)  {
>  	uint16_t devid = (uint16_t) mad_get_field(port->node->info, 0,
> IB_NODE_DEVID_F);
> 
> -	if (devid == 0xc738 || devid == 0xcb84)
> +	if ((devid >= 0xc738 && devid <= 0xc73b) || devid == 0xcb20)
>  		return 1;
>  	if (devid >= 0x1003 && devid <= 0x1016)
>  		return 1;
> diff --git a/src/ibdiag_common.c b/src/ibdiag_common.c index
> 666edbc..e09623d 100644
> --- a/src/ibdiag_common.c
> +++ b/src/ibdiag_common.c
> @@ -530,7 +530,7 @@ int is_port_info_extended_supported(ib_portid_t *
> dest, int port,  int is_mlnx_ext_port_info_supported(uint32_t devid)  {
>  	if (ibd_ibnetdisc_flags & IBND_CONFIG_MLX_EPI) {
> -		if (devid == 0xc738 || devid == 0xcb84)
> +		if ((devid >= 0xc738 && devid <= 0xc73b) || devid == 0xcb20)
>  			return 1;
>  		if (devid >= 0x1003 && devid <= 0x1016)
>  			return 1;
> diff --git a/src/vendstat.c b/src/vendstat.c index 7fc4a11..11ee73e 100644
> --- a/src/vendstat.c
> +++ b/src/vendstat.c
> @@ -144,8 +144,8 @@ typedef struct {
> 
>  static uint16_t ext_fw_info_device[][2] = {
>  	{0x0245, 0x0245},	/* Switch-X */
> -	{0xc738, 0xc738},	/* Switch-X */
> -	{0xcb84, 0xcb84},	/* Switch-IB */
> +	{0xc738, 0xc73b},	/* Switch-X */
> +	{0xcb20, 0xcb20},	/* Switch-IB */
>  	{0x01b3, 0x01b3},	/* IS-4 */
>  	{0x1003, 0x1016},	/* Connect-X */
>  	{0x0000, 0x0000}};
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

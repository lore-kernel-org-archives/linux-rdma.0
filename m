From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCHv2 infiniband-diags] vendstat.c: Add additional vendor
 IDs to ext_fw_info_device
Date: Mon, 19 Jan 2015 22:26:56 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E0CC05B7E@CRSMSX101.amr.corp.intel.com>
References: <54B6780E.1050907@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54B6780E.1050907-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Hal Rosenstock [mailto:hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org]
> Sent: Wednesday, January 14, 2015 6:07 AM
> To: Weiny, Ira
> Cc: linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)
> Subject: [PATCHv2 infiniband-diags] vendstat.c: Add additional vendor IDs to
> ext_fw_info_device
> 
> Add additional supported device IDs to ext_fw_info_device.
> These IDs are ConnectX-4, ConnectX-IB, and Switch-IB.
> This affects is_ext_fw_info_supported which determine which Mellanox
> specific vendor MADs are issued to a device.
> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks applied,
Ira


> ---
> Change since v1:
> Changed ConnectX-3 to Connect-IB in patch description
> 
> diff --git a/src/vendstat.c b/src/vendstat.c index f28ff02..7fc4a11 100644
> --- a/src/vendstat.c
> +++ b/src/vendstat.c
> @@ -145,8 +145,9 @@ typedef struct {
>  static uint16_t ext_fw_info_device[][2] = {
>  	{0x0245, 0x0245},	/* Switch-X */
>  	{0xc738, 0xc738},	/* Switch-X */
> +	{0xcb84, 0xcb84},	/* Switch-IB */
>  	{0x01b3, 0x01b3},	/* IS-4 */
> -	{0x1003, 0x1011},	/* Connect-X */
> +	{0x1003, 0x1016},	/* Connect-X */
>  	{0x0000, 0x0000}};
> 
>  static int is_ext_fw_info_supported(uint16_t device_id) {
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

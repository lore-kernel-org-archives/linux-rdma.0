From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH][TRIVIAL] infiniband-diags/vendstat.c: Commentary change
Date: Thu, 12 Jul 2012 16:58:55 -0700
Message-ID: <20120712165855.38b5aca3ad9a210890bdb05c@llnl.gov>
References: <4FFEA861.2060500@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4FFEA861.2060500-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 12 Jul 2012 06:35:13 -0400
Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

> 
> Add device names to go along with device IDs
> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks applied,
Ira

> ---
> diff --git a/src/vendstat.c b/src/vendstat.c
> index 1c493fa..8535792 100644
> --- a/src/vendstat.c
> +++ b/src/vendstat.c
> @@ -142,10 +142,10 @@ typedef struct {
>  } is4_config_counter_groups_t;
>  
>  static uint16_t ext_fw_info_device[][2] = {
> -	{0x0245, 0x0245},
> -	{0xc738, 0xc738},
> -	{0x01b3, 0x01b3},
> -	{0x1003, 0x1011},
> +	{0x0245, 0x0245},	/* Switch-X */
> +	{0xc738, 0xc738},	/* Switch-X */
> +	{0x01b3, 0x01b3},	/* IS-4 */
> +	{0x1003, 0x1011},	/* Connect-X */
>  	{0x0000, 0x0000}};
>  
>  static int is_ext_fw_info_supported(uint16_t device_id) {


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

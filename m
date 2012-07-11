From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: Subject: [PATCHv2] infiniband-diags/vendstat: updated devices
 supporting extended fw info
Date: Tue, 10 Jul 2012 17:42:05 -0700
Message-ID: <20120710174205.116c60a0953429867cd2e6f4@llnl.gov>
References: <4FFC4931.5080508@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4FFC4931.5080508-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Klein <danielk-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, 10 Jul 2012 18:24:33 +0300
Daniel Klein <danielk-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

> Changed devices ID to an array of device ID ranges.
> 
> Version 2:
> Added range for ConnectX devices: 0x1003 - 0x1011
> 
> Signed-off-by: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks applied,
Ira

> ---
>  src/vendstat.c |   21 +++++++++++++++++----
>  1 files changed, 17 insertions(+), 4 deletions(-)
> 
> diff --git a/src/vendstat.c b/src/vendstat.c
> index 413d202..6183a67 100644
> --- a/src/vendstat.c
> +++ b/src/vendstat.c
> @@ -58,8 +58,6 @@
>  /* Config space addresses */
>  #define IB_MLX_IS3_PORT_XMIT_WAIT	0x10013C
>  
> -#define IS4_DEV_ID 0x01b3
> -#define SX_DEV_ID 0x0245
>  
>  struct ibmad_port *srcport;
>  
> @@ -143,6 +141,22 @@ typedef struct {
>  	is4_group_select_t group_selects[COUNTER_GROUPS_NUM];
>  } is4_config_counter_groups_t;
>  
> +static uint16_t ext_fw_info_device[][2] = {
> +	{0x0245, 0x0245},
> +	{0xc738, 0xc738},
> +	{0x01b3, 0x01b3},
> +	{0x1003, 0x1011},
> +	{0x0000, 0x0000}};
> +
> +static int is_ext_fw_info_supported(uint16_t device_id) {
> +	int i;
> +	for (i = 0; ext_fw_info_device[i][0]; i++)
> +		if (ext_fw_info_device[i][0] <= device_id &&
> +		    device_id <= ext_fw_info_device[i][1])
> +			return 1;
> +	return 0;
> +}
> +
>  static int do_vendor(ib_portid_t *portid, struct ibmad_port *srcport,
>  		     uint8_t class, uint8_t method, uint16_t attr_id,
>  		     uint32_t attr_mod, void *data)
> @@ -398,8 +412,7 @@ int main(int argc, char **argv)
>  		      IB_MLX_IS3_GENERAL_INFO, 0, gi_is3))
>  		IBERROR("generalinfo query");
>  
> -	if (IS4_DEV_ID == ntohs(gi_is3->hw_info.device_id) ||
> -	    SX_DEV_ID == ntohs(gi_is3->hw_info.device_id)) {
> +	if (is_ext_fw_info_supported(ntohs(gi_is3->hw_info.device_id))) {
>  		gi_is4 = (is4_general_info_t *) &buf;
>  		fw_ver_major = ntohl(gi_is4->ext_fw_info.ext_major);
>  		fw_ver_minor = ntohl(gi_is4->ext_fw_info.ext_minor);
> -- 
> 1.7.1
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

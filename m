From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V1 for-next 1/3] IB/mlx5: Define mlx5 interface bits for
 IPoIB offloads
Date: Wed, 17 Feb 2016 10:47:48 +0200
Message-ID: <56C433B4.6030903@mellanox.com>
References: <1455695339-10389-1-git-send-email-erezsh@mellanox.com>
 <1455695339-10389-2-git-send-email-erezsh@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1455695339-10389-2-git-send-email-erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 2/17/2016 9:48 AM, Erez Shitrit wrote:
> The HW can supply several offloads for UD QP, added  offloads for
> checksumming for both TX and RX and LSO for TX.

all the patches have 1-2 blank lines in the begining of the change-log, 
please remove them.
>
> Two new bits were added in order to expose and enable these offloads:
> 1. HCA capability bit: declares the support for IPoIB basic offloads.
> 2. QPC bit which will be used in the QP creation flow, which set these
> abilities in the QP.
>
> Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>   include/linux/mlx5/mlx5_ifc.h | 8 ++++++--
>   1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
> index 51f1e54..5f61afe 100644
> --- a/include/linux/mlx5/mlx5_ifc.h
> +++ b/include/linux/mlx5/mlx5_ifc.h
> @@ -736,7 +736,11 @@ struct mlx5_ifc_cmd_hca_cap_bits {
>   	u8         cqe_version[0x4];
>   
>   	u8         compact_address_vector[0x1];
> -	u8         reserved_at_200[0xe];
> +	u8         reserved_at_200[0x1];
> +	u8         ipoib_basic_offloads_deprecated[0x1];
> +	u8         ipoib_enhanced_offloads[0x1];
> +	u8         ipoib_basic_offloads[0x1];
> \

You don't use two of these new bits anywhere in the code


> +	u8         reserved_at_204[0xa];
>   	u8         drain_sigerr[0x1];
>   	u8         cmdif_checksum[0x2];
>   	u8         sigerr_cqe[0x1];
> @@ -1780,7 +1784,7 @@ struct mlx5_ifc_qpc_bits {
>   	u8         log_sq_size[0x4];
>   	u8         reserved_at_55[0x6];
>   	u8         rlky[0x1];
> -	u8         reserved_at_5c[0x4];
> +	u8         ulp_stateless_offload_mode[0x4];
>   
>   	u8         counter_set_id[0x8];
>   	u8         uar_page[0x18];


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

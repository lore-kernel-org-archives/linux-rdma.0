From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH libibverbs 1/3] Add ibv_port_cap_flags
Date: Mon, 3 Feb 2014 09:50:06 +0200
Message-ID: <52EF4A2E.30904@mellanox.com>
References: <1391356482-4228-1-git-send-email-ogerlitz@mellanox.com> <1391356482-4228-2-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1391356482-4228-2-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 2/2/2014 5:54 PM, Or Gerlitz wrote:
> From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> Add an enum that describes ibv_port_cap_flags that complies
> with the respective kernel enum and modify the existing
> field in struct ibv_port_attr to be of that type.
>
> This value could be fetched when using ibv_query_port.
>
> Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>   include/infiniband/verbs.h |   24 +++++++++++++++++++++++-
>   1 files changed, 23 insertions(+), 1 deletions(-)
>
> diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
> index 5064636..ba29919 100644
> --- a/include/infiniband/verbs.h
> +++ b/include/infiniband/verbs.h
> @@ -186,12 +186,34 @@ enum {
>   	IBV_LINK_LAYER_ETHERNET,
>   };
>
> +enum ibv_port_cap_flags {
> +	IBV_PORT_SM				= 1 <<  1,
> +	IBV_PORT_NOTICE_SUP			= 1 <<  2,
> +	IBV_PORT_TRAP_SUP			= 1 <<  3,
> +	IBV_PORT_OPT_IPD_SUP			= 1 <<  4,
> +	IBV_PORT_AUTO_MIGR_SUP			= 1 <<  5,
> +	IBV_PORT_SL_MAP_SUP			= 1 <<  6,
> +	IBV_PORT_MKEY_NVRAM			= 1 <<  7,
> +	IBV_PORT_PKEY_NVRAM			= 1 <<  8,
> +	IBV_PORT_LED_INFO_SUP			= 1 <<  9,
> +	IBV_PORT_SYS_IMAGE_GUID_SUP		= 1 << 11,
> +	IBV_PORT_PKEY_SW_EXT_PORT_TRAP_SUP	= 1 << 12,
> +	IBV_PORT_EXTENDED_SPEEDS_SUP		= 1 << 14,
> +	IBV_PORT_CM_SUP				= 1 << 16,
> +	IBV_PORT_SNMP_TUNNEL_SUP		= 1 << 17,
> +	IBV_PORT_REINIT_SUP			= 1 << 18,
> +	IBV_PORT_DEVICE_MGMT_SUP		= 1 << 19,
> +	IBV_PORT_VENDOR_CLASS			= 1 << 24,
> +	IBV_PORT_CLIENT_REG_SUP			= 1 << 25,
> +	IBV_PORT_IP_BASED_GIDS			= 1 << 26,
> +};
> +
>   struct ibv_port_attr {
>   	enum ibv_port_state	state;
>   	enum ibv_mtu		max_mtu;
>   	enum ibv_mtu		active_mtu;
>   	int			gid_tbl_len;
> -	uint32_t		port_cap_flags;
> +	enum ibv_port_cap_flags	port_cap_flags;

This should be left as uint32_t as sizeof(enum...) != sizeof(uint32_t) 
in some platforms/compilers.
Thanks Ira for catching this.

>   	uint32_t		max_msg_sz;
>   	uint32_t		bad_pkey_cntr;
>   	uint32_t		qkey_viol_cntr;
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

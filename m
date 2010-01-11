From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: upstream mlx4/ib/4K mtu support
Date: Mon, 11 Jan 2010 16:44:58 +0200
Message-ID: <4B4B396A.6020901@dev.mellanox.co.il>
References: <Pine.LNX.4.64.1001111410240.28822@zuben.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.64.1001111410240.28822-aDiYczhfhVLdX2U7gxhm1tBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Or Gerlitz wrote:
> Hi Vlad, I came across this ofed patch which isn't upstream. Is it a must
> for making mlx4/ib/4K mtu working? was it rejected from upstream? why?
> 
> Or.
> 

Hi Or,
Yes, it is must for mlx4/ib/4K mtu.
I forgot to send it upstream.
I'll do this shortly.

Thanks,
Vladimir

> 
> mlx4/IB: Add set_4k_mtu module parameter.
> 
> It control Infiniband link MTU for all IB ports in a host.
> 
> Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
> ---
> Index: ofed_kernel-fixes/drivers/net/mlx4/port.c
> ===================================================================
> --- ofed_kernel-fixes.orig/drivers/net/mlx4/port.c	2009-11-09 02:20:06.000000000 +0200
> +++ ofed_kernel-fixes/drivers/net/mlx4/port.c	2009-11-09 02:21:46.000000000 +0200
> @@ -37,6 +37,10 @@
> 
>  #include "mlx4.h"
> 
> +int mlx4_ib_set_4k_mtu = 0;
> +module_param_named(set_4k_mtu, mlx4_ib_set_4k_mtu, int, 0444);
> +MODULE_PARM_DESC(set_4k_mtu, "attempt to set 4K MTU to all ConnectX ports");
> +
>  #define MLX4_MAC_VALID		(1ull << 63)
>  #define MLX4_MAC_MASK		0xffffffffffffULL
> 
> @@ -308,6 +312,9 @@
> 
>  	memset(mailbox->buf, 0, 256);
> 
> +	if (mlx4_ib_set_4k_mtu)
> +		((__be32 *) mailbox->buf)[0] |= cpu_to_be32((1 << 22) | (1 << 21) | (5 << 12) | (2 << 4));
> +
>  	((__be32 *) mailbox->buf)[1] = dev->caps.ib_port_def_cap[port];
>  	err = mlx4_cmd(dev, mailbox->dma, port, 0, MLX4_CMD_SET_PORT,
>  		       MLX4_CMD_TIME_CLASS_B);
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

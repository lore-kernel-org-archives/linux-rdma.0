From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 0269/1285] Replace numeric parameter like 0444 with macro
Date: Tue, 2 Aug 2016 08:14:10 -0700
Message-ID: <fd5c7644-7dcc-0cca-d38b-2379bca04dff@sandisk.com>
References: <20160802105508.31682-1-baolex.ni@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160802105508.31682-1-baolex.ni-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Baole Ni <baolex.ni-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org, erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, guysh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, chuansheng.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 08/02/2016 03:55 AM, Baole Ni wrote:
> I find that the developers often just specified the numeric value
> when calling a macro which is defined with a parameter for access permission.
> As we know, these numeric value for access permission have had the corresponding macro,
> and that using macro can improve the robustness and readability of the code,
> thus, I suggest replacing the numeric parameter with the macro.
>
> Signed-off-by: Chuansheng Liu <chuansheng.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Baole Ni <baolex.ni-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/ulp/ipoib/ipoib_main.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> index 5f58c41..eed3e3c 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> @@ -65,15 +65,15 @@ MODULE_VERSION(DRV_VERSION);
>  int ipoib_sendq_size __read_mostly = IPOIB_TX_RING_SIZE;
>  int ipoib_recvq_size __read_mostly = IPOIB_RX_RING_SIZE;
>
> -module_param_named(send_queue_size, ipoib_sendq_size, int, 0444);
> +module_param_named(send_queue_size, ipoib_sendq_size, int, S_IRUSR | S_IRGRP | S_IROTH);
>  MODULE_PARM_DESC(send_queue_size, "Number of descriptors in send queue");
> -module_param_named(recv_queue_size, ipoib_recvq_size, int, 0444);
> +module_param_named(recv_queue_size, ipoib_recvq_size, int, S_IRUSR | S_IRGRP | S_IROTH);
>  MODULE_PARM_DESC(recv_queue_size, "Number of descriptors in receive queue");
>
>  #ifdef CONFIG_INFINIBAND_IPOIB_DEBUG
>  int ipoib_debug_level;
>
> -module_param_named(debug_level, ipoib_debug_level, int, 0644);
> +module_param_named(debug_level, ipoib_debug_level, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
>  MODULE_PARM_DESC(debug_level, "Enable debug tracing if > 0");
>  #endif

Hello Baole,

Please change 0444 into S_IRUGO and 0644 into S_IRUGO | S_IWUSR. The 
latter form is more compact and hence makes the code easier to read.

Thanks,

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH 13/47] RDMA/cxgb4: Declare a local variable 'static'
Date: Fri, 6 Oct 2017 17:09:49 -0500
Message-ID: <01ba01d33eef$d3ed5a90$7bc80fb0$@opengridcomputing.com>
References: <20171006213333.6721-1-bart.vanassche@wdc.com> <20171006213333.6721-14-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171006213333.6721-14-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Bart Van Assche' <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> 
> Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
> Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> ---
>  drivers/infiniband/hw/cxgb4/cm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/hw/cxgb4/cm.c
b/drivers/infiniband/hw/cxgb4/cm.c
> index 2331e7d57704..49d9f9b870e5 100644
> --- a/drivers/infiniband/hw/cxgb4/cm.c
> +++ b/drivers/infiniband/hw/cxgb4/cm.c
> @@ -99,7 +99,7 @@ module_param(enable_tcp_window_scaling, int, 0644);
>  MODULE_PARM_DESC(enable_tcp_window_scaling,
>  		 "Enable tcp window scaling (default=1)");
> 
> -int c4iw_debug;
> +static int c4iw_debug;
>  module_param(c4iw_debug, int, 0644);
>  MODULE_PARM_DESC(c4iw_debug, "obsolete");

Can we just remove this now?  IE has it been 1 release since it was obsoleted?

Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

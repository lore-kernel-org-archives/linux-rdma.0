From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [infiniband:for-next 41/47]
 drivers/net/ethernet/mellanox/mlx4/resource_tracker.c:2875:3: warning: case
 value '7' not in enumerated type 'enum qp_transition'
Date: Sun, 1 Jun 2014 10:25:52 +0300
Message-ID: <20140601102552.7f5cda30@jpm-OptiPlex-GX620>
References: <53882b5a.UAE9BgmHCPuDMdrw%fengguang.wu@intel.com>
	<CAL1RGDXoVByoFadRiH7iRxWj9AdShEJtvpoj_5uNhkudGrwJPQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDXoVByoFadRiH7iRxWj9AdShEJtvpoj_5uNhkudGrwJPQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: kbuild test robot <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, kbuild-all-JC7UmRfGjtg@public.gmane.org, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 30 May 2014 15:43:39 -0700
Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org> wrote:

> Looks like this is actually a bug... assuming you guys agree the patch
> is correct, I'll add the following:
> 
> commit 165cb465f73c (HEAD, mlx4)
> Author: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
> Date:   Fri May 30 15:38:58 2014
> 
>     mlx4_core: Move handling of MLX4_QP_ST_MLX to proper switch
> statement
> 
>     The handling of MLX4_QP_ST_MLX in verify_qp_parameters() was
>     accidentally put inside the inner switch statement (that handles
> which transition of RC/UC/XRC QPs is happening).  Fix this by moving
> the case to the outer switch statement.
> 
>     The compiler pointed this out with:
> 
>         drivers/net/ethernet/mellanox/mlx4/resource_tracker.c: In
> function 'verify_qp_parameters':
>      >> drivers/net/ethernet/mellanox/mlx4/resource_tracker.c:2875:3:  
> warning: case value '7' not in enumerated type 'enum qp_transition'
> [-Wswitch]
>            case MLX4_QP_ST_MLX:
> 
>     Reported-by: kbuild test robot <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>     Fixes: 99ec41d0a48c ("mlx4: Add infrastructure for selecting VFs
> to enable QP0 via MLX proxy QPs")
>     Signed-off-by: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Acked-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

----
Thanks, Roland!  your fix is exactly right!

-Jack
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

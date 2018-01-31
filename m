From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/6] Trivial patches for SoftRoCE
Date: Wed, 31 Jan 2018 14:39:03 +0200
Message-ID: <20180131123901.GE10485@yuvallap>
References: <20180130073006.GA3244@yuvallap>
 <1517396819-29597-1-git-send-email-yanjun.zhu@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1517396819-29597-1-git-send-email-yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 31, 2018 at 06:06:53AM -0500, Zhu Yanjun wrote:
> Follow advice from Yuval and Leon, to the functions rxe_av_chk_attr,
> rxe_av_to_attr and rxe_av_fill_ip_info, the unnecessary parameter
> are removed and the funtion type are changed to void.
> 
> To track the changes to these functions, every change is made
> to a single patch.
> 
> Zhu Yanjun (6):
>   IB/rxe: remove redudant parameter in function
>   IB/rxe: change the function to void from int
>   IB/rxe: remove unnecessary parameter in rxe_av_to_attr
>   IB/rxe: change the function to void from int
>   IB/rxe: change the function rxe_av_fill_ip_info to void
>   IB/rxe: remove redudant parameter in rxe_av_fill_ip_info

Since all seems to be related i wonder why not in a single patch.
I assume they will squashed to one before merge, right?

Besides that, for all:

Reviewed-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

> 
>  drivers/infiniband/sw/rxe/rxe_av.c    | 14 ++++----------
>  drivers/infiniband/sw/rxe/rxe_loc.h   | 10 ++++------
>  drivers/infiniband/sw/rxe/rxe_qp.c    | 15 ++++++---------
>  drivers/infiniband/sw/rxe/rxe_verbs.c | 10 ++++------
>  4 files changed, 18 insertions(+), 31 deletions(-)
> 
> -- 
> 2.7.4
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

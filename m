From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH v2 0/7] i40iw: Fixes in i40iw for 4.15
Date: Fri, 1 Dec 2017 17:03:46 -0700
Message-ID: <20171202000346.GO7754@ziepe.ca>
References: <20171121184502.14056-1-henry.orosco@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171121184502.14056-1-henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 21, 2017 at 12:44:55PM -0600, Henry Orosco wrote:
> The following patches are for the 4.15 kernel.
> 
> Change Log
> 
> v1-v2:
>   Updated comments for "i40iw: Allocate a sdbuf per CQP WQE"
>   Removed "i40iw: Change accelerated flag to bool" from series
 
> Chien Tin Tung (2):
>   i40iw: Use sqsize to initialize cqp_requests elements
>   i40iw: Allocate a sdbuf per CQP WQE
> 
> Henry Orosco (1):
>   i40iw: Notify user of established connection after QP in RTS
> 
> Mustafa Ismail (3):
>   i40iw: Do not free sqbuf when event is I40IW_TIMER_TYPE_CLOSE
>   i40iw: Correct ARP index mask
>   i40iw: Reinitialize add_sd_cnt
> 
> Tatyana Nikolova (1):
>   i40iw: Move MPA request event for loopback after connect
> 
>  drivers/infiniband/hw/i40iw/i40iw_cm.c   | 28 +++++++++++++---------
>  drivers/infiniband/hw/i40iw/i40iw_ctrl.c | 41 ++++++++++++++++++++++----------
>  drivers/infiniband/hw/i40iw/i40iw_d.h    |  6 +++--
>  drivers/infiniband/hw/i40iw/i40iw_main.c |  3 ++-
>  4 files changed, 51 insertions(+), 27 deletions(-)

Applied to for-rc, Thanks

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

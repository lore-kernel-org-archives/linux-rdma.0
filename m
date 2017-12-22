From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-next 1/2] nes: Change accelerated flag to bool
Date: Fri, 22 Dec 2017 16:44:17 -0700
Message-ID: <20171222234417.GE17198@ziepe.ca>
References: <20171217182139.17096-1-shiraz.saleem@intel.com>
 <20171217182139.17096-2-shiraz.saleem@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171217182139.17096-2-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Dec 17, 2017 at 12:21:38PM -0600, Shiraz Saleem wrote:
> The accelerated flag only utilizes two values: 0 and 1.
> Modify accelerated flag in struct nes_cm_node to bool.
> 
> Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Reviewed-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>  drivers/infiniband/hw/nes/nes_cm.c | 2 +-
>  drivers/infiniband/hw/nes/nes_cm.h | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

I took this to for-next, the other one will wait until the -rc
dependent stuff gets done later..

Thanks,
Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

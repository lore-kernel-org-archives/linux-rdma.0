From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH] infiniband: cxgb4: use ktime_get for timestamps
Date: Mon, 11 Dec 2017 15:56:20 -0700
Message-ID: <20171211225620.GB7551@ziepe.ca>
References: <20171127114518.2662754-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171127114518.2662754-1-arnd-r2nGTMty4D4@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Bharat Potnuri <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ganesh Goudar <ganeshgr-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 27, 2017 at 12:44:53PM +0100, Arnd Bergmann wrote:
> The debugfs file prints the difference between host timestamps as a
> seconds/nanoseconds tuple, along with a 64-bit nanoseconds hardware
> timestamp. The host time is read using getnstimeofday() which is
> deprecated because of the y2038 overflow, and it suffers from time jumps
> during settimeofday() and leap seconds.
> 
> Converting to ktime_get_ts64() would solve those two, but I'm going
> a little further here by changing to ktime_get() and printing 64-bit
> nanoseconds on both host and hw timestamps.  This simplifies the code
> further and makes the output easier to understand.
> 
> The format of the debugfs file obviously changes here, but this should
> only be read by humans and not scripts, so I assume it's fine.
> 
> Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
>  drivers/infiniband/hw/cxgb4/device.c   | 34 +++++++++++++++-------------------
>  drivers/infiniband/hw/cxgb4/iw_cxgb4.h |  4 ++--
>  drivers/infiniband/hw/cxgb4/qp.c       |  6 +++---
>  drivers/infiniband/hw/cxgb4/t4.h       |  4 ++--
>  4 files changed, 22 insertions(+), 26 deletions(-)

Steve? This changes the format of the debugfs files, so please ack it
if it is Ok..

Thanks,
Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

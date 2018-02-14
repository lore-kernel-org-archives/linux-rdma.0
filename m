From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH v1] RDMA/hns: Replace __raw_write*(cpu_to_le*()) with LE
 write*()
Date: Wed, 14 Feb 2018 16:54:41 -0700
Message-ID: <20180214235441.GE16962@ziepe.ca>
References: <20180214181117.36808-1-andriy.shevchenko@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180214181117.36808-1-andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "Wei Hu(Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 14, 2018 at 08:11:17PM +0200, Andy Shevchenko wrote:
> There is no need to repeat the semantics of writel() and similar.
> Moreover sparse complains about this:
> 
> drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1690:22: expected unsigned long long val
> drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1690:22: got restricted __le64 <noident>
> 
> Fixing this by replacing __raw_write*(cpu_to_le*()) calls by plain
> write*() ones.
> 
> Note, write*() accessors are little endian by definition.
> 
> Reported-by: kbuild test robot <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
>  drivers/infiniband/hw/hns/hns_roce_hw_v1.c | 8 ++++----
>  drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 8 ++++----
>  2 files changed, 8 insertions(+), 8 deletions(-)

Yes, thanks, applied to -next

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

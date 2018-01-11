From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH 8/8] infiniband: add a Documentation driver-api chapter
 for Infiniband
Date: Wed, 10 Jan 2018 17:21:15 -0700
Message-ID: <20180111002115.GB16574@ziepe.ca>
References: <5a50180f.15c2620a.2e37c.486f@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5a50180f.15c2620a.2e37c.486f-ATjtLOhZ0NVl57MIdRCFDg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Randy Dunlap <rd.dunlab-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Jan 05, 2018 at 04:27:49PM -0800, Randy Dunlap wrote:
> Add a driver-api chapter for InfiniBand interfaces.
> 
> Signed-off-by: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>  Documentation/driver-api/index.rst      |    1 
>  Documentation/driver-api/infiniband.rst |  127 ++++++++++++++++++++++
>  2 files changed, 128 insertions(+)

Hi Randy,

I applied this series to rdma for-next, excluding 1 and 5 due to the
comments.

Thanks,
Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

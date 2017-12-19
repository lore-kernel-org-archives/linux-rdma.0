From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH for-next 09/11] rdma: Update maintainer contact for Intel
 RDMA drivers
Date: Tue, 19 Dec 2017 13:51:27 -0700
Message-ID: <20171219205127.GD14814@ziepe.ca>
References: <20171219034753.2126.78386.stgit@scvm10.sc.intel.com>
 <20171219035711.2126.47130.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171219035711.2126.47130.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Dec 18, 2017 at 07:57:13PM -0800, Dennis Dalessandro wrote:
> Ensure both Mike and I are listed as maintainer contacts for Intel's qib,
> hfi1, and rdmavt drivers.
> 
> Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>  MAINTAINERS |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index dafc9c3..d4b725e 100644
> +++ b/MAINTAINERS
> @@ -11053,7 +11053,8 @@ S:	Maintained
>  F:	drivers/firmware/qemu_fw_cfg.c
>  
>  QIB DRIVER
> -M:	Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> +M:	Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> +M:	Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>  L:	linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>  S:	Supported
>  F:	drivers/infiniband/hw/qib/

Please send an update for rdma-core as well

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

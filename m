From: "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] infiniband: hw: ipath: ipath_diag.c:  Cleaning up code
 that is not handled properly.
Date: Mon, 9 Jun 2014 13:57:38 +0000
Message-ID: <D2F193D21ECD8C45917AD3D5B26513301E43F7@CRSMSX101.amr.corp.intel.com>
References: <1402096136-9919-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1402096136-9919-1-git-send-email-rickard_strandqvist-IW2WV5XWFqGZkjO+N0TKoMugMpMbD5Xr@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rickard Strandqvist <rickard_strandqvist-IW2WV5XWFqGZkjO+N0TKoMugMpMbD5Xr@public.gmane.org>, infinipath <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Rickard Strandqvist
> Sent: Friday, June 6, 2014 7:09 PM
> To: infinipath; Roland Dreier
> Cc: Rickard Strandqvist; Hefty, Sean; Hal Rosenstock; linux-
> rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: [PATCH] infiniband: hw: ipath: ipath_diag.c: Cleaning up code that is
> not handled properly.
> 
> None of the code is adapted to handle a struct ipath_diag_pkt.
> 
> This was partly found using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist-IW2WV5XWFqGZkjO+N0TKoMugMpMbD5Xr@public.gmane.org>
> ---
>  drivers/infiniband/hw/ipath/ipath_diag.c |    6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/ipath/ipath_diag.c
> b/drivers/infiniband/hw/ipath/ipath_diag.c
> index e2f9a51..39ba797 100644
> --- a/drivers/infiniband/hw/ipath/ipath_diag.c
> +++ b/drivers/infiniband/hw/ipath/ipath_diag.c
> @@ -327,7 +327,6 @@ static ssize_t ipath_diagpkt_write(struct file *fp,  {
>  	u32 __iomem *piobuf;
>  	u32 plen, pbufn, maxlen_reserve;
> -	struct ipath_diag_pkt odp;
>  	struct ipath_diag_xpkt dp;
>  	u32 *tmpbuf = NULL;
>  	struct ipath_devdata *dd;
> @@ -341,11 +340,6 @@ static ssize_t ipath_diagpkt_write(struct file *fp,
>  			ret = -EFAULT;
>  			goto bail;
>  		}
> -	} else if (count == sizeof(odp)) {
> -		if (copy_from_user(&odp, data, sizeof(odp))) {
> -			ret = -EFAULT;
> -			goto bail;
> -		}
>  	} else {
>  		ret = -EINVAL;
>  		goto bail;
> --
> 1.7.10.4

Hi Rickard, 

Please see commit 7e6d3e5c70f13874fb06e6b67696ed90ce79bd48 in Roland's for-next branch. I added the missed support for using odp already.

Thanks
-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

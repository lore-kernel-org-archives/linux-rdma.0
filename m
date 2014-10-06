From: Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH 0/3] infiniband: ocrdma: Cleanups and unncessary memsets
Date: Mon, 6 Oct 2014 09:05:50 +0000
Message-ID: <32c2ebc5-dc06-4ecc-9fd6-dba1c7bbbab9@CMEXHTCAS2.ad.emulex.com>
References: <1412519605-16106-1-git-send-email-Jes.Sorensen@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1412519605-16106-1-git-send-email-Jes.Sorensen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Jes.Sorensen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <Jes.Sorensen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: linux-drivers <linux-drivers-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>, "roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org" <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Acked-By: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Jes.Sorensen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> Sent: Sunday, October 05, 2014 8:03 PM
> To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-drivers; roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org; dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> Subject: [PATCH 0/3] infiniband: ocrdma: Cleanups and unncessary memsets
> 
> From: Jes Sorensen <Jes.Sorensen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 
> Hi,
> 
> I was reading through some of this code for other reasons and this stood out
> and hurt my eyes. I don't have hardware to test on, but it at least compiles.
> 
> Cheers,
> Jes
> 
> 
> Jes Sorensen (3):
>   infinitiband: ocrdma: Don't memset() buffers we just allocated with
>     kzalloc()
>   infiniband: ocrdma: The kernel has a perfectly good BIT() macro - use
>     it
>   infiniband: ocrdma: Save the bit environment, spare unncessary
>     parenthesis
> 
>  drivers/infiniband/hw/ocrdma/ocrdma_hw.c  |  16 +-
> drivers/infiniband/hw/ocrdma/ocrdma_sli.h | 238 +++++++++++++++--------
> -------
>  2 files changed, 123 insertions(+), 131 deletions(-)
> 
> --
> 1.9.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the
> body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

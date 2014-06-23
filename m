From: Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH for-next 0/2] Bug fixes for nfs-rdma support
Date: Mon, 23 Jun 2014 16:19:35 +0000
Message-ID: <EE7902D3F51F404C82415C4803930ACD3FE0A1DF@CMEXMB1.ad.emulex.com>
References: <530c3deb-5384-41ae-83f7-affbdd1fef9a@CMEXHTCAS2.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <530c3deb-5384-41ae-83f7-affbdd1fef9a-3RiH6ntJJkOPfaB/Gd0HpljyZtpTMMwT@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> (roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org)" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Roland,

Please pull this series to 3.16 to make sure ocrdma works fine with upstreame NFS-RDMA.
-Regards
 Devesh

> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Devesh-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Sent: Monday, June 09, 2014 10:53 AM
> To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: Devesh Sharma
> Subject: [PATCH for-next 0/2] Bug fixes for nfs-rdma support
> 
> From: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
> 
> This series fixes the improper frmr-page-list-len size reported by
> query_device and a bug in CQ arming logic.
> 
> Devesh Sharma (2):
>   RDMA/ocrdma: Report actual value of max_fast_reg_page_list_len
>   RDMA/ocrdma: do not skip setting deffered_arm
> 
>  drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the
> body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

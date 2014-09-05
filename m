From: Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH REPOST 0/2] bug fixes ocrdma AH
Date: Fri, 5 Sep 2014 14:33:21 +0000
Message-ID: <EE7902D3F51F404C82415C4803930ACD3FE4F41F@CMEXMB1.ad.emulex.com>
References: <917d53ee-b46b-4ed0-8783-f409e185d315@CMEXHTCAS2.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <917d53ee-b46b-4ed0-8783-f409e185d315-3RiH6ntJJkOPfaB/Gd0HpljyZtpTMMwT@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Apologies for spamming, fixed formatting errors.

-Regards
 Devesh 

> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Devesh Sharma
> Sent: Friday, September 05, 2014 7:22 PM
> To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: Devesh Sharma
> Subject: [PATCH REPOST 0/2] bug fixes ocrdma AH
> 
> This series one major and one minor fixes.
> the first one fixes the broken UD path from user space seconde one fixes
> query-ah.
> 
> Devesh Sharma (2):
>   RDMA/ocrdma: resolve L2 address when creating user AH
>   RDMA/ocrdma: use right macro in query ah
> 
>  drivers/infiniband/hw/ocrdma/ocrdma_ah.c |   43
> +++++++++++++++++++++--------
>  1 files changed, 31 insertions(+), 12 deletions(-)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the
> body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: [PATCH] RDMA/ocrdma: Corrected Queue max values.
Date: Mon, 11 Jun 2012 09:43:43 -0700
Message-ID: <CAL1RGDV+9Fw1UKWbs+3xe-8DDN1F-J72b34umviXfH4_Q0OG4w@mail.gmail.com>
References: <bb3bb1ac-9ff5-4980-b851-cf598ea6bf30@exht1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <bb3bb1ac-9ff5-4980-b851-cf598ea6bf30-nbYkmrCdWxmgMrCBcu8zE0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <parav.pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mahesh.Vardhamanaiah-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch is almost formatted perfectly, except in the future when
you send someone else's patch, please include your own Signed-off-by
line as well at the end of the chain.  In other words, the email
should go

>From: Mahesh Vardhamanaiah <mahesh.vardhamanaiah-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
>
>Fixed  code to read the max wqe and max rqe values from
>mailbox response.
>
>Signed-off-by: Mahesh Vardhamanaiah <mahesh.vardhamanaiah-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
>Signed-off-by: Parav Pandit <parav.pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

because you are in the chain of people that handled this patch.

anyway, applied this time.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

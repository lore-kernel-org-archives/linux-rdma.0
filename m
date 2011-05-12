From: Nir Muchtar <nirmu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH V4 3/6] IB Core: Run Netlink
Date: Thu, 12 May 2011 14:56:41 +0000
Message-ID: <B166D7363A9EE34182C2C57BB1F09F1501CC04A8@MTRCASDAG01.mtl.com>
References: <1294068834-17778-1-git-send-email-nirm@voltaire.com>
 <1294068834-17778-4-git-send-email-nirm@voltaire.com>
 <BANLkTim_zvRjOuTvNdC2fGWMfYptYrVTTA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTim_zvRjOuTvNdC2fGWMfYptYrVTTA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Roland Dreier' <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "'nirmu-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org'" <nirmu-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> -----Original Message-----
> From: Roland Dreier [mailto:roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org]
> Sent: Tuesday, May 10, 2011 10:28 PM
> To: Nir Muchtar
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [PATCH V4 3/6] IB Core: Run Netlink
> 
> > +#include <net/ib_netlink.h>
> 
> Was the latest version of this actually tested?  Patch 1 put this header
> in
> <rdma/ib_netlink.h> as far as I can see, so I don't see how this could
> even build.
> 
>  - R.

Yes, it was tested.
I still had the original net/ib_netlink.h in my tree, so it managed to get built.
I'll fix and resend.

Thanks again,
Nir

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

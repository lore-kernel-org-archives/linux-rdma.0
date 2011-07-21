From: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH] IB/qib: defer hca error events to tasklet
Date: Thu, 21 Jul 2011 09:30:56 -0700
Message-ID: <35AAF1E4A771E142979F27B51793A4888839105AEA@AVEXMB1.qlogic.org>
References: <20110721132116.25683.74826.stgit@kop-dev-sles11-04.qlogic.org>
 <CAL1RGDXSHs5hDC3JC5ozTa4gLzumMzRKQWNij_=aDk-3=hsUvg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDXSHs5hDC3JC5ozTa4gLzumMzRKQWNij_=aDk-3=hsUvg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

There is no choice but a module parameter since the msix initialization is done at driver load, and is only needed after testing reveals that the change is necessary.

I agree that there are a lot of module parameters.   Some that don't allocate resources at load time could be "sys".

I can re-issue the patch with module_param and change the identifier.

The module parameters used throughout the code usually prepend a qib_ or and ib_qib_, and I was following precedent in the code.

The only "no prepend" I see is the sdma_descq_cnt, which could change as well to use module_param.

Mike

> -----Original Message-----
> From: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org [mailto:roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org] On Behalf
> Of Roland Dreier
> Sent: Thursday, July 21, 2011 11:47 AM
> To: Mike Marciniszyn
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [PATCH] IB/qib: defer hca error events to tasklet
>
> > +static ushort qib_krcvq01_no_msi;
> > +module_param_named(krcvq01_no_msi, qib_krcvq01_no_msi, ushort,
> S_IRUGO);
> > +MODULE_PARM_DESC(krcvq01_no_msi, "No MSI for kctx < 2");
>
> First, the obvious question: is there really no better way to handle
> this
> than to have yet another cryptically named module parameter for users
> to try both ways?
>
> Second, why can't this just be module_param() (why is _named needed?)?


This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

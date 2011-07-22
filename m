From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] IB/qib: defer hca error events to tasklet
Date: Fri, 22 Jul 2011 12:01:18 -0700
Message-ID: <CAL1RGDUCky+S5Uj-htnB6oiPseWjk2=M7SDto17gEtESfTGK8g@mail.gmail.com>
References: <20110721132116.25683.74826.stgit@kop-dev-sles11-04.qlogic.org>
 <CAL1RGDXSHs5hDC3JC5ozTa4gLzumMzRKQWNij_=aDk-3=hsUvg@mail.gmail.com> <35AAF1E4A771E142979F27B51793A4888839105AEA@AVEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <35AAF1E4A771E142979F27B51793A4888839105AEA-HolNjIBXvBOXx9kJd3VG2h2eb7JE58TQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 21, 2011 at 9:30 AM, Mike Marciniszyn
<mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org> wrote:
> There is no choice but a module parameter since the msix initializati=
on is done at driver load, and is only needed after testing reveals tha=
t the change is necessary.
>
> I agree that there are a lot of module parameters. =A0 Some that don'=
t allocate resources at load time could be "sys".
>
> I can re-issue the patch with module_param and change the identifier.
>
> The module parameters used throughout the code usually prepend a qib_=
 or and ib_qib_, and I was following precedent in the code.
>
> The only "no prepend" I see is the sdma_descq_cnt, which could change=
 as well to use module_param.

I looked over the code and I think it makes sense to match the
existing practice with module_param.
Longer term cleaning that up might be worthwhile, but even better
would be to get
rid of the need for so many knobs for users to adjust.

In any case I went ahead and applied this, since I don't think it's
worth quibbling over.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: "Latif, Faisal" <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 2/3] RDMA/nes: Print ip address for critcal errors
Date: Mon, 10 Oct 2011 12:00:34 -0700
Message-ID: <2EFBCAEF10980645BBCFB605689E08E904EC29E1CE@azsmsx506.amr.corp.intel.com>
References: <20110926013344.GA5260@FLATIF-MOBL4>
 <CAL1RGDU+xag8AtQ18yrZmqU24u9QM6cajhca4MmrCGtmPbxKLg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDU+xag8AtQ18yrZmqU24u9QM6cajhca4MmrCGtmPbxKLg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

Sorry for late reply. Yes %pI4 would be a lot cleaner. Do you want me t=
o resubmit this patch again?

Thanks
=46aisal


> -----Original Message-----
> From: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org [mailto:roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org] On Behal=
f
> Of Roland Dreier
> Sent: Thursday, October 06, 2011 2:54 PM
> To: Latif, Faisal
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [PATCH 2/3] RDMA/nes: Print ip address for critcal error=
s
>=20
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk(KERN_ERR PFX "Remote ip addr =3D=
 %u.%u.%u.%u\n",
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rem_addr[3], rem_addr=
[2], rem_addr[1],
> rem_addr[0]);
>=20
> Any reason this couldn't use %pI4 and be a lot cleaner?
>=20
>  - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

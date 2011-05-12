From: Nir Muchtar <nirmu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH V4 1/6] IB Netlink Infrastructure
Date: Thu, 12 May 2011 14:51:13 +0000
Message-ID: <B166D7363A9EE34182C2C57BB1F09F1501CC02A1@MTRCASDAG01.mtl.com>
References: <1294068834-17778-1-git-send-email-nirm@voltaire.com>
 <1294068834-17778-2-git-send-email-nirm@voltaire.com>
 <BANLkTi=J6ZTFCz12XkL4-ZeUsuAKODRjOw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1255
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTi=J6ZTFCz12XkL4-ZeUsuAKODRjOw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Roland Dreier' <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "'nirmu-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org'" <nirmu-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> -----Original Message-----
> From: Roland Dreier [mailto:roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org]
> Sent: Monday, May 09, 2011 10:35 PM
> To: Nir Muchtar
> Cc: rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [PATCH V4 1/6] IB Netlink Infrastructure
>=20
> > +int ibnl_add_client(int index, int nops,
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const struct ibnl_client_cbs =
cb_table[])
> > +{
> > + =A0 =A0 =A0 struct ibnl_client *cur;
> > + =A0 =A0 =A0 struct ibnl_client *nl_client =3D kmalloc(sizeof *nl_=
client,
> GFP_ATOMIC);
> > +
> > + =A0 =A0 =A0 if (!nl_client)
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
> > + =A0 =A0 =A0 nl_client->index =3D index;
> > + =A0 =A0 =A0 nl_client->nops =3D nops;
> > + =A0 =A0 =A0 nl_client->cb_table =3D cb_table;
> > + =A0 =A0 =A0 mutex_lock(&ibnl_mutex);
>=20
> quick question: why is GFP_ATOMIC used here?  It seems that since the
> function later does mutex_lock(), there can't be any problem with
> sleeping.
>=20
>  - R.

No reason. Typo...Thanks. I'll fix and resend.

Nir

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

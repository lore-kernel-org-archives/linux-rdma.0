From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 03/12] IB/ocrdma: Improve size determinations in ten
 functions
Date: Mon, 24 Apr 2017 21:02:22 +0300
Message-ID: <20170424180222.GL14088@mtr-leonro.local>
References: <fc421509-4069-da8a-b308-60b49ea91ada@users.sourceforge.net>
 <1492720999.3041.18.camel@redhat.com>
 <86425035-7da8-d2b1-8544-d4f7540d50c6@users.sourceforge.net>
 <755f6c2c-03a2-7248-a5e3-9190d119cdaf@users.sourceforge.net>
 <20170423073311.GA14088@mtr-leonro.local>
 <1f122892-7e67-a7ca-ae7f-7ac8e2b7a037@intel.com>
 <1493051938.3041.52.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="5joxkA65nhhP20dL"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1493051938.3041.52.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, SF Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--5joxkA65nhhP20dL
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 24, 2017 at 12:38:58PM -0400, Doug Ledford wrote:
> On Mon, 2017-04-24 at 08:54 -0400, Dennis Dalessandro wrote:
> > On 04/23/2017 03:33 AM, Leon Romanovsky wrote:
> > >
> > > On Sat, Apr 22, 2017 at 04:36:19PM +0200, SF Markus Elfring wrote:
> > > >
> > > > From: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
> > > > Date: Sat, 22 Apr 2017 13:26:49 +0200
> > > >
> > > > Replace the specification of data types by pointer dereferences
> > > > as the parameter for the operator "sizeof" to make the
> > > > corresponding size
> > > > determinations a bit safer according to the Linux coding style
> > > > convention.
> > > >
> > > > Signed-off-by: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
> > > > ---
> > > >
> > > > v2:
> > > > Changes were rebased on source files from Linux next-20170421.
> > > > These were recombined as requested by Doug Ledford.
> > >
> > > Hi Doug,
> > >
> > > I recommend you to be extra cautious with this blind automatic
> > > conversions. It requires inspection that every size before and
> > > after
> > > match each other.
> > >
> > > I already asked it and would be like to repeat it. Please DON'T
> > > take any
> > > patches from Markus, which are related to mlx4/mlx5/rxe without our
> > > explicit
> > > review of them.
> >
> > I agree with Leon here, and these sort of find/replace automagic=A0
> > clean-up patches make me nervous sometimes.
>
> OK, the easiest way to make sure that only the things you want from his
> patches get through is to have you pull them into a branch and submit
> them yourself.=A0=A0I'll only take the ones you submit to me, that way
> there is no confusion about whether or not you have checked them and
> approved them.

Fine to me.

Thanks

>
> > Markus, what have you done to ensure your patches don't break
> > anything?
> >
> > -Denny
> >
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> =A0 =A0 GPG KeyID: B826A3330E572FDD
> =A0 =A0
> Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =A01274 B826 A333 0E57 2FDD
>

--5joxkA65nhhP20dL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlj+Pa4ACgkQ5GN7iDZy
WKfaow/+IALl/tyr+f/8Q8glNA8C6B2hp5kmOStXNxfRsA+wPcQtyYj2PloLf+Dh
3Lr6JjHERk2cA1jjByB6Pumg9sBgbmFTWpTsb16Ag17wJQJQNGG0FeqW9H7LIKOS
ABqnxo6qgqmEqZujs5um4LdrhI8wYZzwyJOHXjiD4SJetaJ1DDcxQi6peZJwwCJI
ttCb6C+c/J846kUo6x9nw9r+3PYbBLa8ydGfjcTveRxXOSxgSFriSVkCufs/3NCX
ycat4EjGH172hHVyBlurBcJVejsNQOBAx1LPhvmLnRhiIBAZlFGRwV0aqtRo4Gpr
HF1XtFbbQd3QtZK3UjB21s6NGdkyR7LrEiOztgMPwZBlQdQiBgZdm0RoBDlI/cz0
qYixmc/0iGuYaVlwg0zYoMqLxRH91g2+tBCxZltDF56QQJFNn06KnZZj26jhIIU8
ejtLMhfGU2cPRvUv7VDgDGpflcUoXGkK7az/ykBegeVTZ9WFW09d/0XHcn1NXMq8
xtoAultPSzmPcec0Rr9nv+JVBKyXUbHHRRN7Wsjzpg73h4Cdruhl+7I+0xKXShfu
00xukuAp6h4TVESKm8ou6PAYlZitCiV/HTu8QSxwaYbpQXkTmA9eXPJQSNej3Yrd
7dVZvu+BZCisVgJg+24OCUACqoneGono8qW4bS1TUlhEkEkhF2g=
=g+48
-----END PGP SIGNATURE-----

--5joxkA65nhhP20dL--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

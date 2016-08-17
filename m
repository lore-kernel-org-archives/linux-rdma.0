From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 3/6] RDMA/hfi1: Avoid redeclaration error
Date: Wed, 17 Aug 2016 08:09:42 +0300
Message-ID: <20160817050942.GB5489@leon.nu>
References: <1471355123-6227-1-git-send-email-leon@kernel.org>
 <1471355123-6227-4-git-send-email-leon@kernel.org>
 <1471367729.2661.50.camel@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MW5yreqqjyrRcusr"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1471367729.2661.50.camel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--MW5yreqqjyrRcusr
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 16, 2016 at 05:15:39PM +0000, Dalessandro, Dennis wrote:
> On Tue, 2016-08-16 at 16:45 +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >=20
> > Plugging HFI1 IOCTL defines will cause to the following
> > build error for QIB:
> > =C2=A0 CC [M] drivers/infiniband/hw/qib/qib_sysfs.o
> > In file included from ./include/uapi/rdma/rdma_user_ioctl.h:39:0,
> > 		=C2=A0from include/uapi/rdma/ib_user_mad.h:38,
> > 		=C2=A0from include/rdma/ib_mad.h:43,
> > 		=C2=A0from include/rdma/ib_pma.h:38,
> > 		=C2=A0from drivers/infiniband/hw/qib/qib_mad.h:37,
> > 		=C2=A0from drivers/infiniband/hw/qib/qib_init.c:49:
> > ./include/uapi/rdma/hfi/hfi1_user.h:370:2: error: redeclaration of
> > enumerator =E2=80=98ur_rcvhdrtail=E2=80=99
> > =C2=A0 ur_rcvhdrtail =3D 0,
> > Move HFI1 structures to separate file to avoid this failure.
>=20
> I need to look at this some more. So does this mean this patch series
> don't build if you just take the first 2?

No, they build perfectly. This patch is needed for next patch "RDMA/core:
Move HFI1 IOCTL declarations to common file".

> qib should not need anything
> from hfi1_user.h so it should not be including it.

It doesn't include directly, but qib includes ib_user_mad.h, which will
be part of common rdma_user_ioctl.h file. This common file will call to
hfi1_user.h too.

>=20
> -Denny
>=20

--MW5yreqqjyrRcusr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXs/GWAAoJEORje4g2clincmQP/3LkZ0kC1SWZwI0uT9Z7vuUI
DPepumnx6jAwKeiqBSHxdEH5oC0VnWIrCebcgee8oOoKA2wPTfTrfN6FoTWfmcHU
aUm2HOFLzNsSkXgCZsA2gRysdGuE45H9qVO4J6Af2PBLeoFTEHS9YZZurHI6ASR1
R7D1WDQMsjJz1p+pOSK0nQKTtjgD9hGWz+AEdx6jAasHdvqo7Y6/BZlmAMCpGL4d
y6SsJz4SVRztJy2ec0qsBNBOsJ3sbguCG1TGAjysLhRooz87uGIjs64Jiqgf/L9J
n8BduQ7N5/0HYOoqYCsAucbMYUREMq/bmr9L9PI+3wfNJ0CZMhcvqS3nIx4uhqLo
bCYkezhbwGjJDfUc/r5ii3YBJtKlcktkhfIg2F9mcO4opgXkprKsMeDDDrFj928h
HA21flp6DRPLK3MMFJgHG8ERA3JMWgQTyPxnnvSQsF9S+zLmLA7+su4KJ49DzWOG
aXSFLximd4KaqU1u9DQCu1j+PA50XXWwlL2gJsr2hqsveIrknIiM7JjQVRMSHTV5
TvdpBHLfhY4SOuBljcUIwMgp/z9+qtFy8M6Nks+D/25rG3BpLtM2t1b11JvF+/wG
SwnUrickoZTha0sgFC5W5zvGS/1RPUxcyq2nzOR0/DhRuKNRALjFDACM9GQzlV65
kgZcnbH1EIkBDfXSfbd5
=t8Jo
-----END PGP SIGNATURE-----

--MW5yreqqjyrRcusr--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

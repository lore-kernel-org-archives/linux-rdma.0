From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 4/6] RDMA/core: Move HFI1 IOCTL declarations to
 common file
Date: Wed, 17 Aug 2016 17:16:13 +0300
Message-ID: <20160817141613.GH5489@leon.nu>
References: <1471355123-6227-1-git-send-email-leon@kernel.org>
 <1471355123-6227-5-git-send-email-leon@kernel.org>
 <20160817061630.GB27477@phlsvsds.ph.intel.com>
 <20160817065529.GG5489@leon.nu>
 <1471440949.19634.7.camel@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Yia77v5a8fyVHJSl"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1471440949.19634.7.camel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--Yia77v5a8fyVHJSl
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 17, 2016 at 01:35:53PM +0000, Dalessandro, Dennis wrote:
> On Wed, 2016-08-17 at 09:55 +0300, Leon Romanovsky wrote:
> > On Wed, Aug 17, 2016 at 02:16:31AM -0400, ira.weiny wrote:
> > > On Tue, Aug 16, 2016 at 04:45:21PM +0300, Leon Romanovsky wrote:
> > > > From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > > >=20
> > > > Move HFI1 IOCTL declarations to rdma_user_ioctl.h file.
> > >=20
> > > I have not tried with the patch but I'm 99% sure this will break
> > > the PSM2
> > > library build which includes hfi1_user.h.
> > >=20
> > > This is one of those things I have pondered in the past.=A0=A0Most of
> > > the rdma
> > > libraries don't actually use these definitions directly.=A0=A0PSM2
> > > does.
> >=20
> > I'm not so convinced about it.
> > "#include <rdma/rdma_user_ioctl.h>" was added to hfi1_user.h to share
> > all definitions. PSM2 library will see it.
>=20
> On face value that should be true. I would want to run it by the PSM
> folks and test it out though to be sure.

I agree,
Thanks.

--Yia77v5a8fyVHJSl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXtHGtAAoJEORje4g2clinV4EP/iniKF/ZJwdEMdfyzX35iy1K
3p6ZGZPDKQ2Hnh52ohOD+9VMxqhU2pcI8fL03Tl3Ab1u3FeCdQqCyEgMGRDEJISw
kACXO2cYGUKmjfDpR6GqpfWBhPnZgy7d0jD+Rqglja4p/ZhybSdE3QPUda2CLOGQ
JTy42gCchnCkDpU4lLMlKkBaNlSr0vLemh+MhSE9FqeqHSn215PlN7Lxc733KTlI
WYn4nEwOgI0lZbN9Lg0uIIBhgtv5lL6a9m+Zo53ugFVsBnRAby1elKKw2riPOzaJ
D1+Rm9wLzcB6SNxtSh9Msvt5Gsg7KvUnuIWA0tUvvSxh4Rk4zNH6O9hFkYSu0xOZ
hqQxULnOfLVVH4WIWXBO4KcwJurWv1OV/wZ0aJBG3y6XzOSnmV46xggwoZ3auFp+
kNvDqx3me70hMJzIiF9fZA/jnjPxVmFlhyzm/lkT51RRkBJ11qcahNEbk1AfI8vn
9ARVTy0mw6KJ9Q4iXG/dFeE5A7xMyKFazlmuQ2DDFC+RNPpxZXGzxbB1jPwtXIfl
VXS5DXTmSm0qzReM3JASQy97zPkwYcv12TCZ36EeLWODQoCnTuZHIMb5JB0vuNr6
BGrAyYOkjHG6ORUuyaf/1hvOiY/s5YSoo23FSR9DEhzJTreWv8gXJUHxqIMXQAXJ
5nWsKh55/dZL0IXMYaxQ
=DQsu
-----END PGP SIGNATURE-----

--Yia77v5a8fyVHJSl--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

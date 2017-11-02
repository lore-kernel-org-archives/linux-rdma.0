From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core 1/5] cbuild: Add udev dependency to package
 list of SuSE Leap
Date: Thu, 2 Nov 2017 19:42:20 +0200
Message-ID: <20171102174220.GD16127@mtr-leonro.local>
References: <20171102165556.22105-1-leon@kernel.org>
 <20171102165556.22105-2-leon@kernel.org>
 <3a06c93f-aa0f-93fa-1b74-af6388051f89@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="HHsIqWg7hQfWlXNC"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <3a06c93f-aa0f-93fa-1b74-af6388051f89-l3A5Bk7waGM@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--HHsIqWg7hQfWlXNC
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 02, 2017 at 06:32:09PM +0100, Nicolas Morey-Chaisemartin wrote:
> Leon, Jason, is there any news on switching the upstream validation to bu=
ild/validate for all distrib instead of just the "travis" one ?

This is the ultimate goal of this series.

After this series will be fixed and merged, we will have containerized SuSE=
/CentOS/Debian builds in travis,
and next step will be upload those artifacts to https://packagecloud.io/, s=
o people won't need to create
distro packages for master branch. It will be there for them.

In regards of schedule, there is already weekend in IL and Alaa will contin=
ue
to work on this series next week. After that, I'll setup and connect packag=
ecloud
to our account.

Actual validation on real HW is performed by vendors internally.

Thanks

>
> Nicolas
>
> Le 02/11/2017 =E0 17:55, Leon Romanovsky a =E9crit=A0:
> > From: Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > rpmbuild under SUSE requires udev and produces the following errors:
> >
> > error: Failed build dependencies:
> >         pkgconfig(udev) is needed by rdma-core-16-0.x86_64
> >
> > Signed-off-by: Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > ---
> >  buildlib/cbuild | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/buildlib/cbuild b/buildlib/cbuild
> > index 918bf233..d1455b6f 100755
> > --- a/buildlib/cbuild
> > +++ b/buildlib/cbuild
> > @@ -298,6 +298,7 @@ class leap(ZypperEnvironment):
> >          'cmake',
> >          'gcc',
> >          'libnl3-devel',
> > +        'udev',
> >          'libudev-devel',
> >          'make',
> >          'ninja',
> > --
> > 2.14.2
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

--HHsIqWg7hQfWlXNC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAln7WPwACgkQ5GN7iDZy
WKeBnxAAkrGiqZf/PaaIeNj68VSmbcmM/Bo33975GDqZbGqnZf6Uq5JeT5uh2dzp
p33qKrR4TpXb9SrMYzXZa8WBOXqh8wFu8jZnpNoWSTsgl5uaj5Lax7Qn6t+AaIRs
Mvtk4p7i6Z/Llo+5DoX26LQmemiUglcHECkv4aDfSCltek5v7NptyPqaRPIOGUYc
mm660AmbGQ/DJrmFmXiXsF2kRbyrIEQ5Upt0KhAWxSdpFebdvj0KVvYqKG32Wwek
YT6Wd1VAuLmt2GuccifWZ1P6+drXOaSoL4XCKaA0YOMZW9THgj8Ji8frUxwdPBXp
mwQeuX0qXh+siirK2PKKHV05HybpWdiQYRKSYEqqK1/hfkitOM/s868gu/e0ZWJX
LK1EFvnZzNNoKkkNSD71U+rOR+MKdJy+8P1zv84I2YE8uWio6m2WTKAJD+qrJU/c
hLxGjy1Krf7BB64r+V7L/ewQn32r0KY7t+rqHv6r/Ev3X+Ln6pGQ+ZxEOk7KAy3+
YqcVecWCzAc8bPtgOLlr7yHHbSOe1Kj+pdAaaQCx+AjQRUFxvcjnmA528KaZqSMZ
41TGWwxd+CmXrnz0zuCT+qVfsJkrvUAFFvZ1DKSrp3TUKL6mW5a1nW93AQHcTzdQ
585Ggh91JQ7H5m1ED1doTo/KrMGkAFena1qihg2JV2o5RffDgHg=
=qcYq
-----END PGP SIGNATURE-----

--HHsIqWg7hQfWlXNC--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

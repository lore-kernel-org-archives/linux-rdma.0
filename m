From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core 1/5] cbuild: Add udev dependency to package
 list of SuSE Leap
Date: Thu, 2 Nov 2017 20:32:57 +0200
Message-ID: <20171102183257.GI16127@mtr-leonro.local>
References: <20171102165556.22105-1-leon@kernel.org>
 <20171102165556.22105-2-leon@kernel.org>
 <3a06c93f-aa0f-93fa-1b74-af6388051f89@suse.de>
 <20171102174220.GD16127@mtr-leonro.local>
 <b2493da4-396e-5d24-ffa5-2fcccb9ee85c@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="/SXoEQDAiXmUSAYo"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <b2493da4-396e-5d24-ffa5-2fcccb9ee85c-l3A5Bk7waGM@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--/SXoEQDAiXmUSAYo
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 02, 2017 at 07:04:36PM +0100, Nicolas Morey-Chaisemartin wrote:
>
>
> Le 02/11/2017 =E0 18:42, Leon Romanovsky a =E9crit :
> > On Thu, Nov 02, 2017 at 06:32:09PM +0100, Nicolas Morey-Chaisemartin wr=
ote: >> Leon, Jason, is there any news on switching the upstream validation=
 to build/validate for all distrib instead of just the "travis" one ? > > T=
his is the ultimate goal of this series.
> Sounds good. In that case, it might be worth adding tumbleweed to the dis=
trib beeing built.
> Most of the SUSE bleeding-edge user are using TW as it provides the lates=
t kernel/packages.

The preference is to have one latest distribution per distro, otherwise
the CI will take a lot of time to complete. It makes sense to replace
leap with tumblweed.

>
> > > > After this series will be fixed and merged, we will have containeri=
zed SuSE/CentOS/Debian builds in travis, > and next step will be upload tho=
se artifacts to https://packagecloud.io/, so people won't need to create > =
distro packages for master branch. It will be there for them.
> FYI, I've already setup something in OBS that does it for the SUSE packag=
es:
> https://build.opensuse.org/package/show/science:HPC:Head/rdma-core
>
> I've a Jenkins job that pulls github and automatically update this OBS re=
pository.
> They definitly should *NOT* be used for anything but testing.
>
> > > > In regards of schedule, there is already weekend in IL and Alaa wil=
l continue > to work on this series next week. After that, I'll setup and c=
onnect packagecloud > to our account.
> Great !
>
> Nicolas
>

--/SXoEQDAiXmUSAYo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAln7ZNkACgkQ5GN7iDZy
WKetoQ/9Ed2lg58JayGAxXuEvAwLfNmjOFpkctraleTxuCBxFDPAscNDsi8DLFgz
O6TNM9fcHShZfCmvX9wrCOBlIQCW7IlbYTM0S/HOVVDw9iMywUgxa0B0RUI5ySci
/c+0oSTqyinvgjU7FSe2UyAWhmCEhvjjYGT6zNO/xhzJR4+eu6aWEhxUb12dK7yu
VvqN5ULDyxwgpURnawX7QKrg4A+599CcS600YPrI08hi6Cqz3NeC/7RlN9TKTzSf
9szLwiXLQK1I73pSFg4TSAk2v6552Ald/2xnOlJPhorCEE/u9qeCcBky9ZyxqxKN
Kfex5WYAUjdAZtsVp6xPmtwEhVsnofBOWtk6zxKAyULrg3D9m0TY0uEJAvbJq7OT
n3aFVe3CWpT+fk7CLw0adxvy0OfRhgJo3iVqY69t7JZ6w3aBtuyEllRQD3owGP2T
2pnTcRg/7rH9EZAaR9iqaytRJ9qZGWnj3+tlwAAZ0oE4dcqQNxRTov6rukLMs2ac
XUJGhysuR9BB/8aJta7Uf2FlzCXm2bame+wHvXJyHTz6m44k5C/oTkM6WTirtAUm
B47lvMbONEzKM0xNurqERizGUW9DBlG9E4zsfPPiEuDKvZbYSn3bZt/bn0M0Cq07
OT9haOtn47oXL7M+MA/6CJbjuWy9NlTGy1VBls66hoc98xaZ7Rw=
=yaR9
-----END PGP SIGNATURE-----

--/SXoEQDAiXmUSAYo--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

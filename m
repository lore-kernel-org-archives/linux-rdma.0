From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/2] IB/hfi1: Fixes for 4.7 rc-6
Date: Tue, 12 Jul 2016 10:58:30 -0400
Message-ID: <01f4b40f-e838-5e68-610c-394dbd195e7e@redhat.com>
References: <20160701225447.19381.90323.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="AFgEPqg4hgXD8CQoPLGtBuR4PMJWaNBvX"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160701225447.19381.90323.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Stable <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--AFgEPqg4hgXD8CQoPLGtBuR4PMJWaNBvX
Content-Type: multipart/mixed; boundary="jDqLcEJGP8bquimxNUG5xfLQIpRFFr3I2"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Stable <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Message-ID: <01f4b40f-e838-5e68-610c-394dbd195e7e-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/2] IB/hfi1: Fixes for 4.7 rc-6
References: <20160701225447.19381.90323.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
In-Reply-To: <20160701225447.19381.90323.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>

--jDqLcEJGP8bquimxNUG5xfLQIpRFFr3I2
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 7/1/2016 6:56 PM, Dennis Dalessandro wrote:
> Doug,
>=20
> Here are two more patches for the 4.7 RC if possible. One Mike has mark=
ed as
> stable.
>=20
> These apply on the RC-5 tree and should apply to your trees without any=
 issue.=20
>=20
> Patches can also be viewed in my repo at:
> https://github.com/ddalessa/kernel/tree/for-4.7
>=20
> ---
>=20
> Mike Marciniszyn (1):
>       IB/hfi1: Correct issues with sc5 computation
>=20
> Tadeusz Struk (1):
>       IB/hfi1: Fix sleep inside atomic issue in init_asic_data
>=20
>=20
>  drivers/infiniband/hw/hfi1/chip.c |   21 ++++++++++++++-------
>  drivers/infiniband/hw/hfi1/ud.c   |   23 +++--------------------
>  2 files changed, 17 insertions(+), 27 deletions(-)
>=20
> --
> -Denny
>=20

I applied the 1/2 patch from this series, and the v3, 2/2 patch from Mike=
=2E

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--jDqLcEJGP8bquimxNUG5xfLQIpRFFr3I2--

--AFgEPqg4hgXD8CQoPLGtBuR4PMJWaNBvX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXhQWWAAoJELgmozMOVy/demIP/i1tCt+0dhjlUPtfJwj8CN0h
FAGTwKae1h05HiwYGtT2ZcpcajB6D8WS8+u5yFZex9VJhoElsl5oT7JpLLkiqRWH
6AxhNj4bI+zJMSf7ITklI7sOXs/jnohqbMu3zd0BDJlPTOt3rIdBDaLhnG5Hkkza
LU2+xGcKBIkXbQKjrWITZjk3lXaVWU8p4wmhTBx/EbtrfA9cZoAf2KAxBC6E113T
L74XcIpPn6kDZBp8b+SSNT0HDRzaqZj79cgE+5ImMNstBFZVInVtG1XKPpR473M6
gU1V3zN9VPSNqEWAgexGS/PYVygdvXNglZr6DM8l+UFt1zY0PzZSOD+8j7MmN4y6
DGjHg0ls1jjUhBpBXYhVH85U98Dg1EcAa+4FVBIIHY5pFYXbM3zZ0mz8vi+hbp14
2l1jZssL8wSFQchebleSyep9jdIMuOGtPu9dT85M4OSK9aS8RO2paUmQ08Ekn+WI
FML8uLgsgXaX75JTLg8/q7y8731SK6tOpC3Uiqetqm2FwwyeKXxKtJSWFvSUE7uH
CVDIeNOFxcDXOcrKwS3IqLM0TFVwv8We+3HuQ98W5qewZ6UjJ1Jx8z1ddQZ9EJ5g
MmZmSA5KuYbhJqzw8K8UahO5oN/QSID/RHFZ7zgYv5PG1A8kZDTmX0cJdUzq0NFq
UeqyG8uDX1DRPmWj63lC
=CZYM
-----END PGP SIGNATURE-----

--AFgEPqg4hgXD8CQoPLGtBuR4PMJWaNBvX--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

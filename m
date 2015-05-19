From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: rdma kernel tree
Date: Tue, 19 May 2015 08:22:40 -0400
Message-ID: <1432038160.3114.16.camel@redhat.com>
References: <1828884A29C6694DAF28B7E6B8A82373A8FD8CF5@ORSMSX109.amr.corp.intel.com>
	 <1431485563.43876.93.camel@redhat.com>
	 <CAJ3xEMhRY6nLPFR8qT8S7KJvxRDmw6JwhsSKw7pTvFc5PpnrhQ@mail.gmail.com>
	 <1431530845.2377.30.camel@redhat.com>	<5554B7E8.4020902@mellanox.com>
	 <1431615776.3276.14.camel@redhat.com>
	 <CAJ3xEMjgpegf+D2BBZ8RPERkdUO3yH4U1LjiK+i4iF=_PtpQkA@mail.gmail.com>
	 <555ABD9D.3080303@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-0Nr/KZ5ht6rS3iCpBk4f"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <555ABD9D.3080303-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-0Nr/KZ5ht6rS3iCpBk4f
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2015-05-19 at 07:35 +0300, Or Gerlitz wrote:
> >> I pulled that via a bundle from patchworks.  I'll double check it.
> > Did  you check it out? fixed it out?
>=20
> I took a look now, you've rebased to-be-rebased/for-4.2 to 4.1-rc4 and=
=20

Correct.

> it seems this is what you are going to push into the kernel.org treem=20

Correct.

> but this series is still there with the zillion tested/reviewed/etc=20
> signature per one 2-3 patch, I think we've agreed this needs to be=20
> addressed prior to the upstream push, right?

Incorrect.  What you objected to before was the large Cc: list in the
patches.  That is gone.  What is there now is just the reviewed-by: list
of three people, and the tested-by list of two people.  As the entire
patch set as a whole was reviewed and tested by those people, it seems
accurate to me.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-0Nr/KZ5ht6rS3iCpBk4f
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVWysQAAoJELgmozMOVy/dXvcP/1NLCbfbmzljgIVBP4kAjLz9
D0Mv3Qj9yxjTW6JCBJTtZQx3J6NdEJYZ0pNeJW8FUYVg7ktks01cNqCqe2HOV+JC
oX2P9ZsL0E7RAZvYI/cxZ5m6+NZSkk57fG7DvvRoX7CUbBBtjTGbfhRuCNRneMip
627wJ7GURV888zedALGXBwqxEe6hTbX5KpE3ilyCtuBpbH19xPWPK7dTJIBNORWP
B5KeTguxd2ixBbbVFc3Uo1ngHhrJqCiPU2fJsyG+a0g0ekfzTDG/prLeXRf9vuNm
1Dgk5By4Wpwmk19gyJu8hYnkcZ9hww8f7lGDlEnvS/8QVSnX9Ykp33w7/NUYDg8k
1kEDEbq1t6YtmQpu9isx7/LPXeBw57VKhKqRrztvn61Pr5/A/7b2P5F5K6RBP6iz
2W+WZjJYHD/uDWJL4jRhJkiNM+Ajdseht/vuPuWyDxFOYAMzqgRXKVoR3iKviK+R
Fjex9Wjx+ljADa5SVH7JeCNr80qWITbzo9UWrBQcQQ1dH9HRFh7ijUp2ydBtutaR
fL0Wh6VQ+BiPk67B35YWlZ3LHtlStH8wjcykPBfjZhL8jneuMJpo4f8sl7VC7GBy
fg+aImd4x+9SKb9FpFqw6tPPacUSVpf9UuAQjAe3XZiudDJAo6IEwaMkHFn1vHz5
daaVn7EMUIE99ycqCMVu
=S6Jw
-----END PGP SIGNATURE-----

--=-0Nr/KZ5ht6rS3iCpBk4f--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

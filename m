From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: deprecating amso1100
Date: Tue, 21 Jul 2015 14:48:47 -0400
Message-ID: <1AE4059B-F6BD-48ED-A1C6-8A9024DDF217@redhat.com>
References: <55AE93E0.9060002@opengridcomputing.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2098\))
Content-Type: multipart/signed; boundary="Apple-Mail=_F4159262-1787-478F-AFC5-EFA3EB1F6DA3"; protocol="application/pgp-signature"; micalg=pgp-sha512
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55AE93E0.9060002-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--Apple-Mail=_F4159262-1787-478F-AFC5-EFA3EB1F6DA3
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8


> On Jul 21, 2015, at 2:48 PM, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> =
wrote:
>=20
> Hey Doug,
>=20
> How should I submit changes to deprecate amso1100?  The HW hasn't been =
sold since 2005, and the SW has definite bit rot.  Its time to remove =
it...
>=20
> Thanks,
>=20
> Steve.

Send me a git patch that uses git mv to move it to staging and we=E2=80=99=
ll leave it there for a release or two and then remove it after that.

=E2=80=94
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
	GPG Key ID: 0E572FDD






--Apple-Mail=_F4159262-1787-478F-AFC5-EFA3EB1F6DA3
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - https://gpgtools.org

iQIcBAEBCgAGBQJVrpQPAAoJELgmozMOVy/dyekQAJJXcFV1Lh0yQapuaQ/Hak0D
vnZoJ/2WFIaU5FxQEe1dFe7ZIslnERbCKgcoU+L+Zdq7E/Drm+CzdM2JcGOZXlKq
Cl1MKLBRg3bSf0fQLklzM34pk9TH6cfSU2zvwHB1u4Y5MdZY9+dWA6Rfr9MaRWw9
qOyGlp2ceiC4IqxSMA/Zk4cZk4zeeFPgg6jRG3NCyTjo2dFP0do0BtkwGVmkj+lH
Q1IVH0TEH37lxwFEAgu4bAZZH9ORIsaEFcj3WB3qDh36hmaC917mmOxqOWQB2zUw
Ya4nGUdlHMf+P4MSX0TzBoiliALQUFANnJbMtvKoNmreuPBI9DX02JU4I+Wh74PR
AMLgVdDksQiwtEj2PcWCBUNvnTCdFMRckKXxHyTioch4GoGTfqRPH5Zs9FVqnBnE
kt6d1p7DPVeewHnow/E3xVH3XRWkAm92yFkVIMOBvsZfDWTmhepqkg0dEkyW8wyD
HA4hkly1eiCU34H0jzRBxoH3/1v46h0unyWcPAejf0EjPLhSiHu44m11RkSYfm/o
+Qw36nSuHcGkXjDmFPqgRmgZrl+RcyMQASse2OcUuw15vG7ct91klHDNt9OJLbD9
4AvWLbZKIqUOxOQFN9hujnFPRLaEpESMKsL1vax/2g3w9tANBx9cvqSd3X3m3+Et
IUx5B4SXb2ghfx8gc1oL
=m++O
-----END PGP SIGNATURE-----

--Apple-Mail=_F4159262-1787-478F-AFC5-EFA3EB1F6DA3--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

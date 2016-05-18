From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: OFED release with RoCE v2 support
Date: Wed, 18 May 2016 11:15:45 -0400
Message-ID: <5a4ccdf6-94d9-3038-175d-e3500c7d3d13@redhat.com>
References: <BN4PR11MB094679B0C45AA332E6BEE7BBFF770@BN4PR11MB0946.namprd11.prod.outlook.com>
 <9C6B67F36DCAFC479B1CF6A967258A8C7DDB98D5@ORSMSX115.amr.corp.intel.com>
 <BN4PR11MB0946718DFF5ECF08958AC620FF490@BN4PR11MB0946.namprd11.prod.outlook.com>
 <9C6B67F36DCAFC479B1CF6A967258A8C7DDBA450@ORSMSX115.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="VqwVgoTN3V4L9J6b9d7vS8xbWRA6hg7vt"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <9C6B67F36DCAFC479B1CF6A967258A8C7DDBA450-8oqHQFITsIFqS6EAlXoojrfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robert J <robert.j.woodruff-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ameen Rahman <ameen.rahman-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--VqwVgoTN3V4L9J6b9d7vS8xbWRA6hg7vt
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 05/18/2016 10:24 AM, Woodruff, Robert J wrote:
>=20
>> Thanks for the quick response. =20
>=20
>> Do we have any rough estimate on when the next major release of  OFED =
will GA?
>=20
> In the past, when we move up to a new kernel version, it usually takes =
a fair amount of time for people to develop all the backports=20
> to the various Linux distro kernels.  From past experience, I would est=
imate at least 6 months, which would put the release
> at the end of the year or so. If you want to keep closer tabs on the ac=
tivities, you can subscribe to the ewg email list and/or attend the
> bi-weekly ewg conference calls.=20

In this case, I expect you guys to be hurting hard when you try to do
all the backports.  The problem is that in the last year we have made
lots of changes that depend on upstream kernel improvements both inside
the RDMA stack and out.  I suspect this backport cycle may be worse than
those in the past.  But I could be wrong...

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--VqwVgoTN3V4L9J6b9d7vS8xbWRA6hg7vt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXPIchAAoJELgmozMOVy/dTIYP/j7aY9FlGnxRGLnEcl9IAQL+
y5WcW+23zfErTE8FUuORDWLBvuvLJvme2yi0I6plbYUMCIadg94DJPNYDy0zO0nm
4TkZMnXiy6prx8c92dbq6T0SIRXA8QypPWNboChM7wo8PGKcvZHapa9cuILvu0Qe
Y7ZDw85x5Dw3CF7OhasVKExqaZtd5LtanEMdksXIolZNipxuBAFe5SFV4hWYtgTB
8tPfB7oZKvEvEv6Ziktbbp1XEKG+zOWcON/0s0kYKU6Pev8LHaoCYr6NWGkctw7w
yUR6dt6Zno1Vj6q02t60S1pU7F+TOQizMeIr4hDleRKKRxMFOM7wUa2Alv7ehQFd
mdqWeAJNlNb1EU1pS87ymZS25E1klGugClWm8xOsTrjFUicvIB58D92jIVa8PT2r
QEAhE5Fkolj2SGKMFyxmwfBeIajZUetSXjvF38Gi+GYVJaBl3cQJeKR7RG4uwm3f
o+umyZzw23eY23Xw3FuDvvxkvJYVUZdp2A8lc4QPd6r0VCI8magAxhos6M3S1Ewg
xlY5z21i3UF7gyZdlJ0cfwVLtZAVPQwbJu48y7qcXpAyxtvjjevSFE8F7c3rIBZh
cRaQLmm3rXyRQBxh56zI/6Mfel24IxoSfbGyzeQ9NNee4d7hUZhAGPWIHMBaAwaf
rSKxUMuGpzZ79BiKDX85
=n14W
-----END PGP SIGNATURE-----

--VqwVgoTN3V4L9J6b9d7vS8xbWRA6hg7vt--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

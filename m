From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: OFED release with RoCE v2 support
Date: Wed, 18 May 2016 11:37:53 -0400
Message-ID: <669ee5b8-11c6-e2c7-c60b-d1410c7e631b@redhat.com>
References: <BN4PR11MB094679B0C45AA332E6BEE7BBFF770@BN4PR11MB0946.namprd11.prod.outlook.com>
 <9C6B67F36DCAFC479B1CF6A967258A8C7DDB98D5@ORSMSX115.amr.corp.intel.com>
 <BN4PR11MB0946718DFF5ECF08958AC620FF490@BN4PR11MB0946.namprd11.prod.outlook.com>
 <9C6B67F36DCAFC479B1CF6A967258A8C7DDBA450@ORSMSX115.amr.corp.intel.com>
 <5a4ccdf6-94d9-3038-175d-e3500c7d3d13@redhat.com>
 <9C6B67F36DCAFC479B1CF6A967258A8C7DDBA58D@ORSMSX115.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="bWGdIT5TCniaaSW5Xn9UfpQ9eFfkWxp3x"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <9C6B67F36DCAFC479B1CF6A967258A8C7DDBA58D-8oqHQFITsIFqS6EAlXoojrfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robert J <robert.j.woodruff-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ameen Rahman <ameen.rahman-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--bWGdIT5TCniaaSW5Xn9UfpQ9eFfkWxp3x
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 05/18/2016 11:22 AM, Woodruff, Robert J wrote:
>> In this case, I expect you guys to be hurting hard when you try to do =
all the backports.  The problem is that in the last year we have made lot=
s >of changes that depend on upstream kernel improvements both inside the=
 RDMA stack and out.  I suspect this backport cycle may be worse >than th=
ose in the past.  But I could be wrong...
>=20
> Yes, and of course it depends on which distro kernel we attempt to back=
port to. For the later model RHEL 7.x and SLES 12 kernels, it may not
> be as bad, if those kernels have picked up the required upstream kernel=
 improvements. I am however worried that it might be too hard to try to b=
ackport to a RHEL 6.x series kernel. We'll have to evaluate that once we =
start work on the next major OFED.=20

I would not be surprised in the least if backports to an EL6 kernel are
a simple no-go for current upstream code.



--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--bWGdIT5TCniaaSW5Xn9UfpQ9eFfkWxp3x
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXPIxRAAoJELgmozMOVy/dElcQAKvzK4zIZNir386KV56qT9ml
tF/zZvHux+WxZwW8oNLQ9GfWrE0B3hvmygQ1dZfz4KNckim385h4NOBsjI4rLfzu
Y7hMela1DmGetoxqdOcxXrT/5IWfq4MguEYNGS9kWGOxIXX3c+2M8KB7pfIv1iBj
tVfHhS2yyBO1XWVyPcK0OE4GP4zm3eqO3g40n1xsdMqswca6eoc6QgTwUsSgFFoO
DcVcvfFRpO8dQQ0tnjJS9XMEoDI1UOrp7Q9Ailj8g0rwRyokm+F+hdXH8PJBtm/f
JKXYFUFODOECmGUP2W3sRi8kcudlMLXCvTIhbGCrpLcKnpUrvhycQI2e7kE+JCN4
Hidi3H5k4YZokI4LfjltlSWsEtAf6Z53HRfyHQreheDQ5zOvJlg/kVFHbWXdGVzd
lashQmG0Pmq+iJdoFhblzXWaU9ivjRw1CjUGSFibP/OHXaxaNCJyXILc8LBPyDRh
/eEoky/uqF6tzMg8aue4DzsqYjB+tE1BAwVvQfSNY/IjdH6IFus6TBeDIpqAkVDX
nmIT3ykhGYX2Exo7/+OzKYa5ndk6l3KUIOFtJJPqBDSApgfjfqXJd/SHoY5yjs+P
djB3Qsef4/Ql4qF/ipkVdlzf/dFO/EPc8/KOnBLywmNiiZpdUjmAyWt+TKKwNrdU
sbsQxcmen1XxGv9E+3sF
=cE6U
-----END PGP SIGNATURE-----

--bWGdIT5TCniaaSW5Xn9UfpQ9eFfkWxp3x--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

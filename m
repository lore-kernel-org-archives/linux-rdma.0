From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/5] IB/hfi1: sdma engine affinity improvements
Date: Mon, 3 Oct 2016 10:31:32 -0400
Message-ID: <7fdfedfb-f51b-e493-0e57-002df8727e48@redhat.com>
References: <20160925144248.12088.71489.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="0uVh92gnlGSq1xPGATlsp3aMHoK4Q4cWF"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160925144248.12088.71489.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--0uVh92gnlGSq1xPGATlsp3aMHoK4Q4cWF
Content-Type: multipart/mixed; boundary="uUrftLwg6VsWtklV4ISQpGUKifGqg70O0";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Message-ID: <7fdfedfb-f51b-e493-0e57-002df8727e48-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/5] IB/hfi1: sdma engine affinity improvements
References: <20160925144248.12088.71489.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
In-Reply-To: <20160925144248.12088.71489.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>

--uUrftLwg6VsWtklV4ISQpGUKifGqg70O0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 9/25/2016 10:44 AM, Dennis Dalessandro wrote:
> This patch series is a set of performance improvements that deal with h=
andling
> the affinity of sdma engines. This allows users more control over which=
 CPU
> cores are used by the driver for sdma engines. It includes a way to dum=
p out the
> current values and a handler for when the user changes irq affinity. Th=
e changes
> to sysfs are also documented.
>=20
> This applies on top of the last series submitted and can be seen in my =
GitHub:
> https://github.com/ddalessa/kernel/tree/for-4.9

I've taken this.  However, it does not escape me that this might have
been more appropriate as part of rdmavt and working with qib in addition
to hfi1.  I decided to let it pass as it is because I know the qib
driver is in deep maintenance mode and not active development, but what
about when hfi2 comes about?  Just keep that in mind.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--uUrftLwg6VsWtklV4ISQpGUKifGqg70O0--

--0uVh92gnlGSq1xPGATlsp3aMHoK4Q4cWF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJX8mvKAAoJELgmozMOVy/dNTwQAKz96mPpExENoIAG9akYppuC
qTbsnjmZp53Uc0JtRQAvTY7ARsiwcwXxpa94uhY9xemSo2avAV7AO+E+2iFJ1EYZ
Ogmt3aVOjgCxmy6vMniv7VzX1pB+9wVq0f6lY8Nj9100QBl8MLYwkzTL41AqEAJ4
9aerEeESDyrLjUa2peCrhmq4PjFTkWYTr4VFVg6AIuToq5DE91Kz4DB6xcOkHlqu
8FaIBtWJBJPF+hnuouZShMDZvy5vaAumqsH+allgRG6nmNTH6ifLeMzZjq8aRwKw
x5t2XC+ApeHOLMdqrHibktyZ2Cc7/yjt/eW6rZjr/oBWZIfltbcs7gf+HY+xdcqL
HH5HIdstgDHmpBZY2P6i5JO3XAMMs5HBWcJ2TFf5Mo0oiL4YhwcMQJhvZ0h1Hkv4
K1iAey54h6N4/Ei+cNy+Mi8UebphcLxxsI2t1twoLeb/duPQUG7cyJwDySxyykrT
Z1zRrr024cl4IFRDf1/t+xg4qiqfPVlj+BjRz/VISSfQzxvP6iHGQ3uctn5bySLh
tAUqdG82/I5qtL6G5ncBxX9x3nffK7RmhbxjEUze/MMMynP5BmEV6ib0+7T+YlS9
Oe2GdnMlCkgjLnJiv14oCf2Yft9NIajrzqvl4TaU66m0VtGrh6EDypSIkffB1onE
8yQSguPISkDqMzyRlsSd
=SRkG
-----END PGP SIGNATURE-----

--0uVh92gnlGSq1xPGATlsp3aMHoK4Q4cWF--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

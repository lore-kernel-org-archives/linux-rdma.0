From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] IB/qib: remove duplicate code
Date: Sat, 22 Jul 2017 13:20:47 -0400
Message-ID: <0d5d4e1c-ee2f-2ecb-bf25-b95954cbb5f7@redhat.com>
References: <20170607204202.GA29640@embeddedgus>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="I1TTXmw5dGw3Kw4bttp4jOdLP6RwKnEkH"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170607204202.GA29640@embeddedgus>
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <garsilva@embeddedor.com>, Mike Marciniszyn <infinipath@intel.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--I1TTXmw5dGw3Kw4bttp4jOdLP6RwKnEkH
Content-Type: multipart/mixed; boundary="wIDhNdKqQ4FpQ1iLHhpHE1F1F7nk6p5t3";
 protected-headers="v1"
From: Doug Ledford <dledford@redhat.com>
To: "Gustavo A. R. Silva" <garsilva@embeddedor.com>,
 Mike Marciniszyn <infinipath@intel.com>, Sean Hefty <sean.hefty@intel.com>,
 Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <0d5d4e1c-ee2f-2ecb-bf25-b95954cbb5f7@redhat.com>
Subject: Re: [PATCH] IB/qib: remove duplicate code
References: <20170607204202.GA29640@embeddedgus>
In-Reply-To: <20170607204202.GA29640@embeddedgus>

--wIDhNdKqQ4FpQ1iLHhpHE1F1F7nk6p5t3
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 6/7/2017 4:42 PM, Gustavo A. R. Silva wrote:
> Remove duplicate code.
>=20
> Addresses-Coverity-ID: 1226951
> Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>

This patch was accepted into 4.13-rc, thanks.

In addition, I no longer have the original email for another patch of
yours that was also accepted into 4.13-rc.  You created the patch in a
thread asking about the argument position for argument usage in
ib_init_ah_from_wc().  Your comment addition was accepted as well.


--=20
Doug Ledford <dledford@redhat.com>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--wIDhNdKqQ4FpQ1iLHhpHE1F1F7nk6p5t3--

--I1TTXmw5dGw3Kw4bttp4jOdLP6RwKnEkH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJZc4lvAAoJELgmozMOVy/d0IIP/1eqka0qwc/dn6+t1O53iTlZ
48DzeWVtQvKoI0BEesp3Goaq+YA8GTawSa1SqDyDaJmfL/C0CvyLRX6pEcIBg6zT
tyFHH/geWS/MrbVLGkQ1YdS8twLtFDB/4KKyAZX0w+9QTyzZuXj7U99fS7NK1xt9
s9oTkap+ih8IJD9zsp1zHXUMz3JT2SDWcDmTwB/fI+5xPMyITZyhoXAp3K5o76nH
O06RWTdZvMZEfj2DustGLTExDh41ckUg2inYvG5iJSSB5drZyXAEnnqFStWcrWM7
qwVbJ3NyiLsYDU0z2v0k5N4asG3WgfnHxxdImDd3lyIeLnVb7eLI0Wl4bPJ9HsAS
gVN0/3fqPB2q5Eh+cdEXiRi5q+CgrJHb3alsqIvPa6ilpX1iDghEOGBIClB+Ukq7
RJ0PNmVD8nKUfk/bCKaSVRXLhcIInEh8ji7RKr4fjqacGn2On89QQ55EZ4QE7Y7V
QZIlhuwd3IxMipSc9NMZQjUL9Xq35Me9NAV89B8xyvIrmqtBFOI2i8GIZp8xm1St
5L3ZD7hcRiZ5Vo12OncqvTnXWWjiSiJhNoQzE8YbrorAdIF222JdOD0gYwg/gPf0
/AvSg/P+cNqNtpwsSmKAPoZenEk+pmkqIH+zuJNrENcJF6h7CD5+D2g6t3qg1Vhc
ipKrJtyGpey+oAXq0Jj9
=rM+M
-----END PGP SIGNATURE-----

--I1TTXmw5dGw3Kw4bttp4jOdLP6RwKnEkH--

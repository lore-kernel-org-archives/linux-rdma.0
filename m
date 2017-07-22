From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] IB/cxgb3: Fix error codes in iwch_alloc_mr()
Date: Sat, 22 Jul 2017 13:28:33 -0400
Message-ID: <d300777c-6057-b7b7-f10a-0724879204dd@redhat.com>
References: <20170713074800.dlzwroi4jmuv5xfk@mwanda>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="c64psOxmBcDLURhi7X9IK3IfcEK8KTU6a"
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20170713074800.dlzwroi4jmuv5xfk@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>, Steve Wise <swise@chelsio.com>
Cc: Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--c64psOxmBcDLURhi7X9IK3IfcEK8KTU6a
Content-Type: multipart/mixed; boundary="2DWOvNiHhOxLMvHMx3lvPeTPEAhr6katW";
 protected-headers="v1"
From: Doug Ledford <dledford@redhat.com>
To: Dan Carpenter <dan.carpenter@oracle.com>, Steve Wise <swise@chelsio.com>
Cc: Sean Hefty <sean.hefty@intel.com>,
 Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org,
 kernel-janitors@vger.kernel.org
Message-ID: <d300777c-6057-b7b7-f10a-0724879204dd@redhat.com>
Subject: Re: [PATCH] IB/cxgb3: Fix error codes in iwch_alloc_mr()
References: <20170713074800.dlzwroi4jmuv5xfk@mwanda>
In-Reply-To: <20170713074800.dlzwroi4jmuv5xfk@mwanda>

--2DWOvNiHhOxLMvHMx3lvPeTPEAhr6katW
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 7/13/2017 3:48 AM, Dan Carpenter wrote:
> We accidentally don't set the error code on some error paths.  It means=

> return ERR_PTR(0) which is NULL and results in a NULL dereference in th=
e
> caller.
>=20
> Fixes: 13a239330abd ("RDMA/cxgb3: Don't ignore insert_handle() failures=
")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

This was accepted into 4.13-rc, thanks.

--=20
Doug Ledford <dledford@redhat.com>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--2DWOvNiHhOxLMvHMx3lvPeTPEAhr6katW--

--c64psOxmBcDLURhi7X9IK3IfcEK8KTU6a
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJZc4tBAAoJELgmozMOVy/dwJYP/AwMJR4PSGycbv/8xoTTYXaG
s0IC+s/RhuJjvPHzJwb6mVz9Vf+W5knp11gOzWxBmAINavXQXD0ceeeUkQ6wLtYi
2RpEihCgsKzoINS4K1gM1W1B8Rz63ReWDoWofWnD77RqpS0y3enBfmOqt/cvWmeP
zFNQXiUy0a5gr7G2GoQlx/6nb2NVqumtQAr/WOR1aR+fqUcu7Jns5v2f9y//r1rK
aNFKodd6NiBJQ7dCz38Y5+6RpjqvxG1W2pNdSM5HE1KBitDYprucLG9SzdwnTA4v
ebbnzDhr5iw5T+LChAhtmhGmpjciykjl3RI2aIikzt644oQzSIwCFJ8IiTh0dKuy
7/TEjaYncAKvGS/+hWt39VN5UN2Hac2oePow/KFtH5F5lHjbDyaEjNYYNJmrb/WJ
/+/hanVqIOIQ3GthzdKmcJYJ6Z8s9sHGv+p4ZKfSb3E5QZZD6+A3XRBXWKUt6h/M
EaCfY3HfZxQR5OafCXv5SFqog9CuSJ8i75ATfPSUpYon2y798IDD1pRYL2VvWxVz
1qFTf/bersaICx8kPjkqr3zQQ+0qgLxNGJoUjoXdmpg4E1BARFBiUCyd44M3vfC8
kVawNP84GcyRhlzDtlRPsBIhFDIbcK/xywArH1Stb+GUaD3EQgL42a6H3n34bMkW
JwfsOhDbVquvuTcdcrbZ
=0oLu
-----END PGP SIGNATURE-----

--c64psOxmBcDLURhi7X9IK3IfcEK8KTU6a--

From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] qedr: return -EINVAL if pd is null and avoid null ptr
 dereference
Date: Wed, 14 Dec 2016 11:25:06 -0500
Message-ID: <0fe01691-a030-de34-e984-31546c012cb2@redhat.com>
References: <20161018183928.8539-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="8twR3epAig4VVwtbllgwQxM1E7vv8X72x"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161018183928.8539-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Rajesh Borundia <rajesh.borundia@cavium.com>, Ram Amrani <Ram.Amrani@cavium.com>, linux-rdma@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--8twR3epAig4VVwtbllgwQxM1E7vv8X72x
Content-Type: multipart/mixed; boundary="hjmlgQFAtC63iQEGfUJqNFEewlx4nmNUB";
 protected-headers="v1"
From: Doug Ledford <dledford@redhat.com>
To: Colin King <colin.king@canonical.com>, Sean Hefty <sean.hefty@intel.com>,
 Hal Rosenstock <hal.rosenstock@gmail.com>,
 Rajesh Borundia <rajesh.borundia@cavium.com>,
 Ram Amrani <Ram.Amrani@cavium.com>, linux-rdma@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Message-ID: <0fe01691-a030-de34-e984-31546c012cb2@redhat.com>
Subject: Re: [PATCH] qedr: return -EINVAL if pd is null and avoid null ptr
 dereference
References: <20161018183928.8539-1-colin.king@canonical.com>
In-Reply-To: <20161018183928.8539-1-colin.king@canonical.com>

--hjmlgQFAtC63iQEGfUJqNFEewlx4nmNUB
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 10/18/2016 2:39 PM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
>=20
> Currently, if pd is null then we hit a null pointer derference
> on accessing pd->pd_id.  Instead of just printing an error message
> we should also return -EINVAL immediately.
>=20
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied, thanks.

--=20
Doug Ledford <dledford@redhat.com>
    GPG Key ID: 0E572FDD


--hjmlgQFAtC63iQEGfUJqNFEewlx4nmNUB--

--8twR3epAig4VVwtbllgwQxM1E7vv8X72x
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYUXJiAAoJELgmozMOVy/dl80QAI3saphpYf7ESf/ks0zia+ou
28Yuirm+EAQel6N77dDd/skAvavGRcSnW+pPi5dNNr4oASET7EU2hoxMxviDmBTf
NT7IdDudRKLumqQxST+10jldKAYXf81HG2vstLUkzAWz31Td9dfS4mQg/eIuc/YE
3FJBLNc9ZG1aln2It5zMCpNdQopExg4AtM80NAQi9t2hl+R+m6CXQ5h/N1mQJ0hN
lpXTHlrjnlwkGqRGF1XP5br6aFw7B/iCCwTNYBkJ6bMRUcUNhP98WscTv6LdlYs8
awdfmLYNVH8nQJ1xUFkDCO4UnzlmNxx40VYbi1uhLMp3+FVJCVHsyuQB5CXA3bPU
QcKyjUnap39AdmJSDHOFbiWegw2LqXjdnClJuSbfpLgEB+wfCD/xQ3ZXl6DLZVHX
xjXyoQ7kXY+ANVOmXeXMGbRDZaheW7GiKF1w70aVOY1NL+Oa3vLeD6vVKfW+cadu
gWuj1pW6LGZlD5hlGBUV9ZEZq/9aJape5PQ4oFEHmRA7AneeTYAGePuTeU/PNtSU
Qky0HhjNP557PqqfDjZuXcKmjRzX/v9AoI5isVNd0LqtLcygI+LCht3Q3ttEUvus
+0A+K6U06FrViiaIwlbpL2jB9UIc633jC3UBv7RiQ0ADb9c2ZdIxob1qwbIEbUq+
gFx7+YiWsCVT2WyK6B2F
=Hz1z
-----END PGP SIGNATURE-----

--8twR3epAig4VVwtbllgwQxM1E7vv8X72x--

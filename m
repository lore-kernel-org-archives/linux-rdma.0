From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH 2/2] RDMA/ocrdma: Fix error codes in ocrdma_create_srq()
Date: Sat, 22 Jul 2017 13:29:30 -0400
Message-ID: <730f032e-1960-1f32-3cb0-7ab8e6c51161@redhat.com>
References: <20170713074649.tmcxi3a3qpilyomq@mwanda>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="r0n4suKkrNVNg00tqRVKh5iEruwuHWr28"
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20170713074649.tmcxi3a3qpilyomq@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>, Selvin Xavier <selvin.xavier@broadcom.com>, Parav Pandit <parav.pandit@emulex.com>
Cc: Devesh Sharma <devesh.sharma@broadcom.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Leon Romanovsky <leon@kernel.org>, Dasaratharaman Chandramouli <dasaratharaman.chandramouli@intel.com>, Or Gerlitz <ogerlitz@mellanox.com>, ssh10 <mayhs11saini@gmail.com>, Artemy Kovalyov <artemyko@mellanox.com>, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--r0n4suKkrNVNg00tqRVKh5iEruwuHWr28
Content-Type: multipart/mixed; boundary="tvtGJ2ihw0IjAh3TCwOMXJ8pDHBe0lIUT";
 protected-headers="v1"
From: Doug Ledford <dledford@redhat.com>
To: Dan Carpenter <dan.carpenter@oracle.com>,
 Selvin Xavier <selvin.xavier@broadcom.com>,
 Parav Pandit <parav.pandit@emulex.com>
Cc: Devesh Sharma <devesh.sharma@broadcom.com>,
 Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock
 <hal.rosenstock@gmail.com>, Leon Romanovsky <leon@kernel.org>,
 Dasaratharaman Chandramouli <dasaratharaman.chandramouli@intel.com>,
 Or Gerlitz <ogerlitz@mellanox.com>, ssh10 <mayhs11saini@gmail.com>,
 Artemy Kovalyov <artemyko@mellanox.com>, linux-rdma@vger.kernel.org,
 kernel-janitors@vger.kernel.org
Message-ID: <730f032e-1960-1f32-3cb0-7ab8e6c51161@redhat.com>
Subject: Re: [PATCH 2/2] RDMA/ocrdma: Fix error codes in ocrdma_create_srq()
References: <20170713074649.tmcxi3a3qpilyomq@mwanda>
In-Reply-To: <20170713074649.tmcxi3a3qpilyomq@mwanda>

--tvtGJ2ihw0IjAh3TCwOMXJ8pDHBe0lIUT
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 7/13/2017 3:46 AM, Dan Carpenter wrote:
> If either of these allocations fail then we return ERR_PTR(0).  That's
> equivalent to NULL and results in a NULL pointer dereference in the
> caller.
>=20
> Fixes: fe2caefcdf58 ("RDMA/ocrdma: Add driver for Emulex OneConnect IBo=
E RDMA adapter")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

This was accepted into 4.13-rc, thanks.

--=20
Doug Ledford <dledford@redhat.com>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--tvtGJ2ihw0IjAh3TCwOMXJ8pDHBe0lIUT--

--r0n4suKkrNVNg00tqRVKh5iEruwuHWr28
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJZc4t6AAoJELgmozMOVy/dJmAQAJOkIjWbBfHqNSn+Al9MJ6nT
3OgcOaPHCPSKo49mv+aRo5tVHZy51GKw3VT4KSzOVEzfOWUBcoRT7mUgDPnDvhzQ
X77ppG8GlVE8hJaxhJ5hyZ7TOUCa/m2TiVRyj0DcKddrh+jkvJpabXiKZuhCWjro
bT9wV4VdyjG+ukOOB5Yto7ItDybbYhfrAkX0FNkdR2Uajz6gWYaSTz8jUTEq0wXX
FzMj0MtEEZMVUW4h3+zWvX7bFPqkCOLff7RTdx+zlBNGw4abrzNPFcWfSeAcF3UW
zjdZxLgOi5WQA7ztGVo4JB4EedqAaLjBTVXmZL6NeqlqDGG6uwhNHhIGB5VMvbwb
AOv7ftK4FnISbO22nK2lwhf+QE1yAQyuAKnGV779CUFE1w+vPepgX/tGMvxk7zER
13I03JDr2IuOD7OCwkNc1SwTIUJvWC+3zN5bltQJ+ftxB26XeiWMYmYJO8VOpslF
/Nt5zTPNtLZ7bjGiHKfi2pKczPpttcuemFt4wC2+nT1uFGrRjXClS/m7iPeHd0XX
B3jBhGvq17gVqG4+wuPyUfouoIlLPwX2cknuMVotNoIR3gTxiTshmkbEv0vHz8zM
Cp6USp+eNb1D7yMuWoL2yOSMc8zRLftUKeMTMOfHjvl58iudIY2VsrIGygHUfBeI
/9mGn0xs3EixBBP83pcY
=4W+U
-----END PGP SIGNATURE-----

--r0n4suKkrNVNg00tqRVKh5iEruwuHWr28--

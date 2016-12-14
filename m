From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH v2] IB/mlx5: avoid bogus -Wmaybe-uninitialized warning
Date: Wed, 14 Dec 2016 12:13:14 -0500
Message-ID: <2de76e2f-78ff-13d6-9c93-8f888d4508c1@redhat.com>
References: <20161024204830.620592-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="A8QoldgtgCEApbut1vvKthr5cBD1a13pN"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161024204830.620592-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: Matan Barak <matanb@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, Sagi Grimberg <sagig@mellanox.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Noa Osherovich <noaos@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--A8QoldgtgCEApbut1vvKthr5cBD1a13pN
Content-Type: multipart/mixed; boundary="HqMackWFg8MwxL2569QRrN4DuFQOAXvL5";
 protected-headers="v1"
From: Doug Ledford <dledford@redhat.com>
To: Arnd Bergmann <arnd@arndb.de>, Sean Hefty <sean.hefty@intel.com>,
 Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: Matan Barak <matanb@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>,
 Sagi Grimberg <sagig@mellanox.com>,
 Bart Van Assche <bart.vanassche@sandisk.com>,
 Noa Osherovich <noaos@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <2de76e2f-78ff-13d6-9c93-8f888d4508c1@redhat.com>
Subject: Re: [PATCH v2] IB/mlx5: avoid bogus -Wmaybe-uninitialized warning
References: <20161024204830.620592-1-arnd@arndb.de>
In-Reply-To: <20161024204830.620592-1-arnd@arndb.de>

--HqMackWFg8MwxL2569QRrN4DuFQOAXvL5
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 10/24/2016 4:48 PM, Arnd Bergmann wrote:
> We get a false-positive warning in linux-next for the mlx5 driver:
>=20
> infiniband/hw/mlx5/mr.c: In function =E2=80=98mlx5_ib_reg_user_mr=E2=80=
=99:
> infiniband/hw/mlx5/mr.c:1172:5: error: =E2=80=98order=E2=80=99 may be u=
sed uninitialized in this function [-Werror=3Dmaybe-uninitialized]
> infiniband/hw/mlx5/mr.c:1161:6: note: =E2=80=98order=E2=80=99 was decla=
red here
> infiniband/hw/mlx5/mr.c:1173:6: error: =E2=80=98ncont=E2=80=99 may be u=
sed uninitialized in this function [-Werror=3Dmaybe-uninitialized]
> infiniband/hw/mlx5/mr.c:1160:6: note: =E2=80=98ncont=E2=80=99 was decla=
red here
> infiniband/hw/mlx5/mr.c:1173:6: error: =E2=80=98page_shift=E2=80=99 may=
 be used uninitialized in this function [-Werror=3Dmaybe-uninitialized]
> infiniband/hw/mlx5/mr.c:1158:6: note: =E2=80=98page_shift=E2=80=99 was =
declared here
> infiniband/hw/mlx5/mr.c:1143:13: error: =E2=80=98npages=E2=80=99 may be=
 used uninitialized in this function [-Werror=3Dmaybe-uninitialized]
> infiniband/hw/mlx5/mr.c:1159:6: note: =E2=80=98npages=E2=80=99 was decl=
ared here
>=20
> I had a trivial workaround for gcc-5 or higher, but that didn't work
> on gcc-4.9 unfortunately.
>=20
> The only way I found to avoid the warnings for gcc-4.9, short of
> initializing each of the arguments first was to change the calling
> conventions to separate the error code from the umem pointer. This
> avoids casting the error codes from one pointer to another incompatible=

> pointer, and lets gcc figure out when that the data is actually valid
> whenever we return successfully.
>=20
> Acked-by: Leon Romanovsky <leonro@mellanox.com>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Thanks, applied (with fixups due to conflicts).

--=20
Doug Ledford <dledford@redhat.com>
    GPG Key ID: 0E572FDD


--HqMackWFg8MwxL2569QRrN4DuFQOAXvL5--

--A8QoldgtgCEApbut1vvKthr5cBD1a13pN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYUX2qAAoJELgmozMOVy/d9eQQALK6P9L5XnxB9cIAWlkDfHt+
i0X9e4CTP3tBiSiOb13QXukEn9PuUYKnSNMWyg+kHksHdI+ZYfu5OYyEbZY6wAey
Ufk+7KFJWknGy/+8bR2EMrwzB6uqsdZK4I3eEoOevf35CG3WDj1hlwP6MVOVnBdj
Ad2HrSir2nOB4kxZrbRm+zN/YlRMHkMDY+9RWReEhI1dJys26wVjLvYZCZUTKl4R
GH8leC2Kt2kcXMgK+tT0Wf4JGuZXhM0mAI8RDKvu8G3R5e2vP+8lWEc9lD+aPRuU
u2hDJJEdvzt3l4Z9ELSluW8ArVgWH7uWZfLj9xdYKPoEDd6bedrBbuvzuv1LWMcc
pmaxuPZni/5FvxJ6j81Y5rzCnaSvBZP8rN+1a8HR2xW02VmWvmFoLJ8KrBfsjX3k
iSMHZnFhoupnWnsQLq86VPk6y8s8F9QjdjRIjBxU148J3Zok6zh7kVq51ZP/Th0A
cET+VP0N/2caTrWVgDOK8EOvfCBPb4NTTcIM43H9T5B/w7xg7PLPYV+bWRSc+sH9
h2eCgQqUHOwVGbybSQVdc+5xSR4TV+tITb4f2rWQ9vyGSmrCL0YvUC4KOig2F9eU
kXelvO4O+7EHu7Ir9JrPML2jQyvRU7/YsB6Es9wOeNzIEfTG40j09EYjCuUxPI7h
sFB47OyGN67ON34J3t5R
=avE3
-----END PGP SIGNATURE-----

--A8QoldgtgCEApbut1vvKthr5cBD1a13pN--

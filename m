From: Leon Romanovsky <leonro@mellanox.com>
Subject: Re: [PATCH mlx5-next 00/11] Remove SRQ code from mlx5_core
Date: Tue, 4 Dec 2018 07:29:51 +0000
Message-ID: <20181204072947.GR6462@mtr-leonro.mtl.com>
References: <20181128185343.21669-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Xsn3knLL3qrmRbVI"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181128185343.21669-1-leon@kernel.org>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: RDMA mailing list <linux-rdma@vger.kernel.org>, Mark Bloch <markb@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

--Xsn3knLL3qrmRbVI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 28, 2018 at 08:53:32PM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
>
> Hi Doug and Jason,
>
> This series is intended to be applied on mlx5-next after Saeed's
> infrastructure changes series are accepted:
> https://patchwork.kernel.org/project/linux-rdma/list/?series=47809
>
> ----------------------------------------------------------------------
> The following patchset brings mlx5 SRQ functionality to the module
> which is actually using it - mlx5_ib. The original code being not used
> in mlx5_core/mlx5_en, but located there, caused to unneeded maintenance
> overhead.
>
> By moving mlx5 SRQ code to mlx5_ib, we successfully reduced ~200 LOC codes
> and minimized exports and headers pollution.
>
> The proposed patches are divided to three logical groups: move from
> netdev, fix IB part and cleanup.
>
> Thanks
>
> Leon Romanovsky (11):
>   net/mlx5: Align SRQ licenses and copyright information
>   net/mlx5: Remove dead transobj code
>   net/mlx5: Remove not-used lib/eq.h header file
>   net/mlx5: Remove references to local mlx5_core functions
>   net/mlx5: Move SRQ functions to RDMA part
>   RDMA/mlx5: Remove SRQ signature global flag
>   RDMA/mlx5: Use stages for callback to setup and release DEVX
>   RDMA/mlx5: Update SRQ functions signatures to mlx5_ib format
>   RDMA/mlx5: Initialize SRQ tables on mlx5_ib
>   RDMA/mlx5: Unfold create RMP function
>   RDMA/mlx5: Unfold modify RMP function
>

Applied to mlx5-next.

Thanks

--Xsn3knLL3qrmRbVI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJcBizrAAoJEORje4g2clinBZ8QAJXBrrtdu/fNtpsKW+dOlOFs
klIjZUFv7HbugAKq+X1f64bimzEL+V8R45VqXgbQ7mrcv2X4y08WU0Gq3divZ4vV
VNARRWmMTBb6jIEPA1boTE6xUQjmvCF32aTVk9q5B23nlRqdPKfmUakiu53Jfhpv
EB2MdWc+iK5InaktHxAGW9Znr/pfPeD1xiWEAM/TYy3e6KY2Dkdh4Hcvuj/NdzIL
rVHeEkvXzaoOqNiO+3qilHcJPfvVMK8kJq1uJbIlaVQlMzH6AMcF/G6itXcijOiM
gWbxzy3dlJORar6FNUVBd6hwQGd8OTygxu2c8A9toscrVZAq6/1Z5WPOdKlKYZYG
e+FYjA70XJuvRjbqiMYhjpRa/5LE02EaTCXaHW/U0kkc6/JqVhenMJVA6urZqfwN
VIBjrAnX51QQQ69Xg/MGGIITE1QJ80qDEHTnzraTelAfMBQ8MM1NXsS3iVOF6Pfg
6vXbJRTu6kOoboBuBaX7t9MgWP6S9WHwN/hMOXvt5nXv35BXiz+zkGQwtwYJTBac
4q0Efn7iOeif2arh/IIikcD3+I52ZVXFxCuN1sGLZJTh/Z9vwnTO1S8QtR5EjW3e
kHQs8McGswSV0mU/l4kVD2gYbDNd03BfRScJVQ8Q+vFp2ygt9w9jrUK/JWWofsQs
rBFpdTllyxUI4yDlYaQG
=uZRz
-----END PGP SIGNATURE-----

--Xsn3knLL3qrmRbVI--

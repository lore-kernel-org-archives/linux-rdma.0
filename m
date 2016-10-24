From: Leon Romanovsky <leonro@mellanox.com>
Subject: Re: [PATCH] IB/mlx5: avoid bogus -Wmaybe-uninitialized warning
Date: Mon, 24 Oct 2016 20:06:42 +0300
Message-ID: <20161024170642.GL25013@leon.nu>
References: <20161024151658.2413803-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="b/Q3JWIUAuLE0ZFy"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161024151658.2413803-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Matan Barak <matanb@mellanox.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Sagi Grimberg <sagig@mellanox.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Noa Osherovich <noaos@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--b/Q3JWIUAuLE0ZFy
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 24, 2016 at 05:16:42PM +0200, Arnd Bergmann wrote:
> We get a false-positive warning in linux-next for the mlx5 driver:
>
> infiniband/hw/mlx5/mr.c: In function =E2=80=98mlx5_ib_reg_user_mr=E2=80=
=99:
> infiniband/hw/mlx5/mr.c:1172:5: error: =E2=80=98order=E2=80=99 may be use=
d uninitialized in this function [-Werror=3Dmaybe-uninitialized]
> infiniband/hw/mlx5/mr.c:1161:6: note: =E2=80=98order=E2=80=99 was declare=
d here
> infiniband/hw/mlx5/mr.c:1173:6: error: =E2=80=98ncont=E2=80=99 may be use=
d uninitialized in this function [-Werror=3Dmaybe-uninitialized]
> infiniband/hw/mlx5/mr.c:1160:6: note: =E2=80=98ncont=E2=80=99 was declare=
d here
> infiniband/hw/mlx5/mr.c:1173:6: error: =E2=80=98page_shift=E2=80=99 may b=
e used uninitialized in this function [-Werror=3Dmaybe-uninitialized]
> infiniband/hw/mlx5/mr.c:1158:6: note: =E2=80=98page_shift=E2=80=99 was de=
clared here
> infiniband/hw/mlx5/mr.c:1143:13: error: =E2=80=98npages=E2=80=99 may be u=
sed uninitialized in this function [-Werror=3Dmaybe-uninitialized]
> infiniband/hw/mlx5/mr.c:1159:6: note: =E2=80=98npages=E2=80=99 was declar=
ed here
>
> I had a trivial workaround for gcc-5 or higher, but that didn't work
> on gcc-4.9 unfortunately.
>
> The only way I found to avoid the warnings for gcc-4.9, short of
> initializing each of the arguments first was to change the calling
> conventions to separate the error code from the umem pointer. This
> avoids casting the error codes from one pointer to another incompatible
> pointer, and lets gcc figure out when that the data is actually valid
> whenever we return successfully.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Thanks Arnd for fixing it.
I have a very small comment which is not related to functionality.

Rather than that,
Acked-by: Leon Romanovsky <leonro@mellanox.com>

> ---
>  drivers/infiniband/hw/mlx5/mr.c | 39 +++++++++++++++++++++--------------=
----
>  1 file changed, 21 insertions(+), 18 deletions(-)
>
> diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5=
/mr.c
> index d4ad672b905b..88d8d292677b 100644
> --- a/drivers/infiniband/hw/mlx5/mr.c
> +++ b/drivers/infiniband/hw/mlx5/mr.c
> @@ -815,29 +815,33 @@ static void prep_umr_unreg_wqe(struct mlx5_ib_dev *=
dev,
>  	umrwr->mkey =3D key;
>  }
>
> -static struct ib_umem *mr_umem_get(struct ib_pd *pd, u64 start, u64 leng=
th,
> -				   int access_flags, int *npages,
> -				   int *page_shift, int *ncont, int *order)
> +static int mr_umem_get(struct ib_pd *pd, u64 start, u64 length,
> +		       int access_flags, struct ib_umem ** umem,

I wonder if checkpatch does differentiate between "struct ib_umem ** umem"
and "struct ib_umem **umem". According to coding style, the second is prefe=
rable.

> +		       int *npages, int *page_shift, int *ncont,
> +		       int *order)

--b/Q3JWIUAuLE0ZFy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYDj+iAAoJEORje4g2clinwykP/0YY6HX9wvValhzqCy0kpvXN
7XxJkqqaLfEvzWV5lbSSUfV0XS7QCOYMa+u/Vm5JcgIJZa2ZwnJE1DD46f/oivNX
URfE0//40Hge6Omc95B5uGccyLv9lwR7FUbLhwoaKIxxWeeRv0SoWP8/37lSGNT0
68z7rPdjPnz5QeSYAhUma1gMQEseuAoJ4yyw8UZtObewhP15cxPDGgUkY7UhsaaS
e4NHdx/bnD+je5BSvLelXVc95R2O81GvQ6/QVWk1GhIdR+0WL06swSidAHO4zKyt
6/c4IEOm5aGxbYExCKZC42IWBH8bvc1Da4VKzor2tR+aYS4gEwSg2Crhsj0V1aw6
9LbMASKEr9JJMo0dAL1j7esCO2o7Nf49T0OzWSxj+0Vc6Rixm65vy5NeZOavqI5P
xe9Q8zsatQ4y30LFxyfMAChXfp9UOR/Crs4Kci7wGqU97fMg2SwwnXpUWmBJV36O
xTb2D4a4nKpwCtwPD6bF3NBp3A9Goe61Yzt5wMC4t7zdpAOtZM3xxI00PW6P/Ojv
kwpJK0yE2IUDgy/pSmJR5lT2MSPJBeHhIU/Op4ILce8H2LAm5LS1OpF7dZ1hYXr4
64JEFHTNiwiBJZHLYCTQ1pxVwvyjHtWn8dqxHtwuKqfOJxgJPQn/LhFqhLLCP5RU
zVrVY4n6Fvs2bKNug5km
=sXiz
-----END PGP SIGNATURE-----

--b/Q3JWIUAuLE0ZFy--

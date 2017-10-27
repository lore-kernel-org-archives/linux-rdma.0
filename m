From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] IB/mlx4: Use common error handling code in
 __mlx4_ib_create_flow()
Date: Fri, 27 Oct 2017 22:39:02 +0300
Message-ID: <20171027193902.GJ16127@mtr-leonro.local>
References: <0bcea3cf-91e3-01d5-8d80-34cd6b611fb1@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="GLa4d69Ev2s1FDzP"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <0bcea3cf-91e3-01d5-8d80-34cd6b611fb1@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-rdma@vger.kernel.org, Dennis Dalessandro <dennis.dalessandro@intel.com>, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Sean Hefty <sean.hefty@intel.com>, Yishai Hadas <yishaih@mellanox.com>, Yuval Shaia <yuval.shaia@oracle.com>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--GLa4d69Ev2s1FDzP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 26, 2017 at 06:12:31PM +0200, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Thu, 26 Oct 2017 17:54:15 +0200
>
> Add a jump target so that a bit of exception handling can be better reused
> at the end of this function.
>
> This issue was detected by using the Coccinelle software.
>
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  drivers/infiniband/hw/mlx4/main.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>

Doug,

I would like to refresh my request, please don't take ANY patches
for mlx4/mlx5/rxe from Markus without explicit acknowledge from our
side.

This change adds nothing except code churn.

Thanks

--GLa4d69Ev2s1FDzP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnzi1YACgkQ5GN7iDZy
WKf6eQ/8DLXf1KLQRHMwloNpbzR4y86fO0zXU5kJjZRbw5147zowPmFuo3XH6x8v
6GBkIZK10GQo23tJbMRmZH8ODMiN+1tW5po0JFbgn6LHdGVu7YfMDkaYjYs/vIgH
UpAdEKqYdGprdpPrcerODKmfy9AQnXYK527/lYSv3nidDdZs8+OS2er0by7gejUY
/oQ1kPAty24TC5ToDmD98p3J6TwBtVVz8qSn2TWqX+718D5AWaBf8N+GCUfpke3K
3tfozg3fWBdCAb1cbfSgKNNxgtXO+lWeDrfDphgyVZyP4ffXTUbhdEkGqrvItt6w
wMe0NaMiBApav6M8TU7eT4rwCuHRRdfAy/ruboMatTLZN4dLIQi4UZH4KrmHyUpG
oYmGuKNYnHA/JU5aBiU04Ev9fl0tCH1D/kMKamKyKY6FIwtHzTeoRUwDM2f2pPfA
7GodP6y2SpbvGY78qg0X1UR4DwKRQtZz1uL333G/OujENOQR+jSAOnPfIGb8uTkK
oeT5RIH4s1GQ/G9lCD9Bmi7KZ7g40Fp6hcLYoaIX6jhdLXh+4/oLhWCFZRIduUHF
wYspsgCiq5AkC/PIvqBuMXQBOE2jC5DdyA69KxzmjBc7rJVCbfQqh0ZkBV4uhEmX
IYC567dRvSyCjGqY5WyJtzIq2Ynd7a8+vUTFWy5FiYXAxtp6Q04=
=ObWh
-----END PGP SIGNATURE-----

--GLa4d69Ev2s1FDzP--

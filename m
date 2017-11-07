From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH v2] IB/ocrdma_hw: remove unnecessary code in
 ocrdma_mbx_dealloc_lkey
Date: Tue, 7 Nov 2017 16:50:18 +0200
Message-ID: <20171107145018.GJ18825@mtr-leonro.local>
References: <20171107083022.Horde.E7wKXkvErbmdKSHiwomsj7N@gator4166.hostgator.com>
 <20171107144517.GA25631@embeddedor.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="rmUrFcWP4LYae1gV"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171107144517.GA25631@embeddedor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Cc: Selvin Xavier <selvin.xavier@broadcom.com>, Devesh Sharma <devesh.sharma@broadcom.com>, Doug Ledford <dledford@redhat.com>, Yuval Shaia <yuval.shaia@oracle.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--rmUrFcWP4LYae1gV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 07, 2017 at 08:45:17AM -0600, Gustavo A. R. Silva wrote:
> Check on return value and goto label mbx_err are unnecessary.
>
> Addresses-Coverity-ID: 1268780
> Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
> Reviewed-by: Yuval Shaia <yuval.shaia@oracle.com>
> ---
> Changes in v2:
>  Remove assignment from "int status = -ENOMEM" as suggested by Leon Romanovsky.
>
>  drivers/infiniband/hw/ocrdma/ocrdma_hw.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)

Please use git send-email to send patches and not reply to the conversation.

Thanks,
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>

--rmUrFcWP4LYae1gV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloByCoACgkQ5GN7iDZy
WKdyCg/7BrubAO42DPyTfm+L2y/dXtXY5KAaIQ9BYf053t38kNGTkYj64oXp9AFz
C9mZO1wjB8wNxtsC1FjjAolVWSc7pvMnC9bwgP+gU7S4yZf3qqOS1w7Fjds5iPru
bcZqp61np94twrNIlDpBtqWss5+S1qUuPYvYC75rtczwZeozs4GMwvtka3a2cO6T
k41+W2AAc80jTU6j9VVq6wO2TzOA2OwLmS2HaukLh20sqecFX5x1YvZo2aMO2yBS
uyk9cIpZZ62DdVV3zp8Z15U2uT8I4ypq/KJ8o6lnh+F8o7ZWpDn2JfgiTCYPV+rE
sIhWDpIIQqwtJgbhrIoaMUR6ZzUtktb5/L4AlmCSSoAJUYogPyW26Wt23bTOs89U
qKm9CVQVVEwQoy2Ij4cr/q5Y3QoXGzgmH3EoAtvvuGt+V2DaJk4TfdDj0X+yvsnt
Amc19OomTJq59XtRZE0LBvLU7w/T8WHNIousAb6TT7d8pqgwPAQ0L9mSFhvx2miU
fLv0qfrb2T/iAuKvmfYd8YxGDhwOXi0tjMj8sMFkP4ehQpsc/sVkdlZEQJJMnbrn
qKh11KywUKajRqQFcI82cKa6l5d7UhGYf4dAphU22Kyu80pdGvjAvqoS11c1IoA8
AIyDyGjgbac8Hy0+h5SgbiD45118jj4Qu0zatJnEXeUjjqnrEXs=
=5FZ5
-----END PGP SIGNATURE-----

--rmUrFcWP4LYae1gV--

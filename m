From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] iw_cxgb4: make pointer reg_workq static
Date: Thu, 30 Nov 2017 16:13:02 +0200
Message-ID: <20171130141302.GA8126@mtr-leonro.local>
References: <20171130133006.19699-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="mYCpIKhGyMATD0i+"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171130133006.19699-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: Steve Wise <swise@chelsio.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--mYCpIKhGyMATD0i+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 30, 2017 at 01:30:06PM +0000, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
>
> The pointer reg_workq is local to the source and does not need to be
> in global scope, so make it static.
>
> Cleans up sparse warning:
> drivers/infiniband/hw/cxgb4/device.c:69:25: warning: symbol 'reg_workq'
> was not declared. Should it be static?
>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/infiniband/hw/cxgb4/device.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>

--mYCpIKhGyMATD0i+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlogEbYACgkQ5GN7iDZy
WKdD2Q//XeBrnkdrxpYDno/sBsvZOvMvxy9Ve+lTHHISoW9sEqszsf9NEE5Y/5yW
tFGIzK5ri8UDb95q4aRZ0JbdWmyO5J1sRVE74t+iiLoGjU1StFsGdIGIhATluJWG
sQfIDw6A3s7/v2Qw0s+HcrPosqbIjEXsE79m7o9ZuWY8MaPbeMEXzTAJgRvDpjRY
VS8zYBmradt9pMZCJ89gFQ2/dERQGzzxvXgKiBYoMeDjzJe3TYZ3bM/P9YM1U4nm
U7TqxXVrlSFc1kvt3vNkAMa0qGILunfBq+iZPoElZM21WbIJuwECzBMehQ2DHRpG
XoS1A/MYNIjz9qEqjPG6ypAkO+dnBX3Cntv/gnlepB8GyYGP8JGRxCt3ttIHPOOU
yF6vS+fwZsowy9Gwpo0dmXueQhhKUJmn3yg7bg2QYLFxploXCkGCG14rZil9BGFg
eEvls1Au0Jwb8+hZVmqiLPs4RuYOAfcsPF9SVVLmJfYz05HkSMgEGuz3uziIk0tC
azSTlZjvOGL8+sbdylDZ5BrjWJ3yNJQ1h1jlPS7+Iw0W8OMHTjgb65eLEMNhY11I
asy02PyZ9s0olbhf+zxCNKTc8TVJIDRnweyj8Ryu6bPj4ANN7AQYPFKX6FDD1OqZ
3BvjEuXetRFNBoEZnslr1ztZW0/Hob1P47vwf9++73RzUKXR9O0=
=2Tgr
-----END PGP SIGNATURE-----

--mYCpIKhGyMATD0i+--

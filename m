From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] RDMA/cxgb4: release hw resources on device removal
Date: Fri, 27 Apr 2018 12:27:37 -0400
Message-ID: <1524846457.11756.61.camel@redhat.com>
References: <20180423161237.3459-1-rajur@chelsio.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-nc0MpRUBN59Tbg0rp3Zd"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180423161237.3459-1-rajur@chelsio.com>
Sender: stable-owner@vger.kernel.org
To: Raju Rangoju <rajur@chelsio.com>, jgg@mellanox.com, linux-rdma@vger.kernel.org
Cc: swise@opengridcomputing.com, bharat@chelsio.com, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--=-nc0MpRUBN59Tbg0rp3Zd
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2018-04-23 at 21:42 +0530, Raju Rangoju wrote:
> The c4iw_rdev_close() logic was not releasing all the hw
> resources (PBL and RQT memory) during the device removal
> event (driver unload / system reboot). This can cause panic
> in gen_pool_destroy().
>=20
> The module remove function will wait for all the hw
> resources to be released during the device removal event.
>=20
> Fixes c12a67fe(iw_cxgb4: free EQ queue memory on last deref)
> Signed-off-by: Raju Rangoju <rajur@chelsio.com>
> Reviewed-by: Steve Wise <swise@opengridcomputing.com>
> Cc: stable@vger.kernel.org

Thanks, applied to for-rc.

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-nc0MpRUBN59Tbg0rp3Zd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlrjT3kACgkQuCajMw5X
L91svA//b1bY68jfuoZrzPUGdJ4MLB8wLoHorEKewC72Y8Ut8n+6roWi2lBByIae
jZriv4ymAtmUIVHU1uQx145ZYaU9gSXCbyYvxSYxtx71ZS9sR3LXtIUAO/QINSiR
+95JJGeAjQn9TuKU6nGU+O1shqtYIr4ac1zV0kNNvqGvn82dqY3AuWbuKL1LXaT8
WoPESYbvlN98tTRvyDsX7+amGPf4sUGbT3hNq3vmMpcMx3zGXdsPCJHcC6hfQvzX
pt/n+bm07aYaEGkrJo8Jsa6KJRrfuKAPC+Vmxa2YBQvY6OtI05irHl6QqASpIc8m
IsTj+UpPD9yp3yqm1WAxoNFKj84RMoQwd/gG2cU8odMjyFaIfvHgCCosk0QAhfd4
QfJINNrMxZ27ZHeencV3ZorETi4HLUhOweSL19Pr+SjojoUCspxA7LDZ1ZmbtCsg
0RmlC/KJOD3HkKVI5WraVwMgPjq1HsSF/fOqlf2xojM4FGfK0Psrj+xBv1M9jS/4
SFt7m8MHgVhRy9QlHlRLljCotvJmUFXQs3lseyc2YK2aokfNlPYXFFszwu4j3qEQ
++OsSCeJVgC6a/IUDe8LWqZk+gA4z/OcIs1kKL5SLR9pXeY50Aq9XasG2dAEOn2v
1hCgV1IK0RwCgBY93ngrdLD+mc9jW13M8XO/YgjOKx/mLoSivdc=
=xZfE
-----END PGP SIGNATURE-----

--=-nc0MpRUBN59Tbg0rp3Zd--

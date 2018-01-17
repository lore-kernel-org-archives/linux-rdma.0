From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 00/14] IB/srpt: Add RDMA/CM support
Date: Wed, 17 Jan 2018 18:14:30 -0500
Message-ID: <1516230870.3403.292.camel@redhat.com>
References: <20180117001418.7852-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-ChsVSKvIQn9/ZX7wdJu4"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180117001418.7852-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-ChsVSKvIQn9/ZX7wdJu4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2018-01-16 at 16:14 -0800, Bart Van Assche wrote:
> Hello Jason and Doug,
>=20
> This patch series not only adds RDMA/CM support to the SRP target driver =
but
> also fixes a number of race conditions in that driver.
>=20
> The RDMA/CM listener port number has to be specified as an ib_srpt kernel
> module parameter. The default value for that parameter is zero which mean=
s
> that RDMA/CM support is disabled.

Since srpt is already configured via the lIO framework, wouldn't that be
a better place for the listen port?  In fact, shouldn't it be part of a
portal like you have for iSERt?

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-ChsVSKvIQn9/ZX7wdJu4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlpf2NcACgkQuCajMw5X
L92PTA//e3YlCdFB3l98fPIYXg2wmW4unyIO3kjx+zqtv6BzShwLAO6fYusNmkWz
pr9nTo96RpJRloH7wF0/+FBRhkX6pi69OjMoPnT5mI3GAfozU9KxoIw5NjM+PKye
Z3/wYva8vhlgzx6AUi3dFwbBFmTsU/XKMQ2eFzF/0/lbyX2P7TrfEgr2AGrjTw20
D8oSqdE5Ty5/N4EYxORZ+wsmEyMkn5eChxr4oozeqQSGXuIB5QgjnJghF9yH5oGW
+6sKg8JRlSeH2tFQ//MAciVOhPnsd0OF8ocH4k+16m6wotMzoW5/ATxmoAMNBDpT
b6plRjIjxgQsJPVmfyXAHf+G6nw+JhZzneRBwgqpKQLKuwJE6/5BUeHtv4rSBK/R
YAbiZUi6aVYQbJitkui8k4qkMrk5f9Onezfn7XpPUSbFjJ/vcfMqxQqjYWSnRuit
j2rvtBzKWdxlRVHCU8taDEw+PuK9dDULomVvYJJm9slZr4Izr/mIm+9wMVPlEqhn
md0JgqWtJzGa2YdWRvMqw55A013LPAdc9EAodD+94DLxZNw9m1R24zj2QUgTDhh1
3gzouejgEZZGAmOCcQU9YsBmnhHkSNFPRcO6InjW9DWJFJ7OrFRvtZycxoVTWwaI
K4zey4iah5WtlDF2QoCXBSbD1dk4HIaT/JAIkTJEeLwtC7KsOw4=
=kfSp
-----END PGP SIGNATURE-----

--=-ChsVSKvIQn9/ZX7wdJu4--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

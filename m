From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: mlx5 driver load error
Date: Mon, 25 Jul 2016 10:00:59 +0300
Message-ID: <20160725070059.GA20674@leon.nu>
References: <CAF1ivSa1vtCzGX7tkyTwxQr7zbSZ-e=p8vJPFT=DANS7ZaE_eA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Qtzb1h6tVL0ohdDu"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAF1ivSa1vtCzGX7tkyTwxQr7zbSZ-e=p8vJPFT=DANS7ZaE_eA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ming Lin <mlin-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--Qtzb1h6tVL0ohdDu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 21, 2016 at 03:54:31PM -0700, Ming Lin wrote:
> Hi,
>=20
> I build k.o/for-4.8 branch(commit fb92d8fb1b9). But mlx5 driver doesn't w=
ork.
>=20
> root@host:~# lspci |grep -i mellanox
> 03:00.0 Ethernet controller: Mellanox Technologies MT27700 Family [Connec=
tX-4]
> 03:00.1 Ethernet controller: Mellanox Technologies MT27700 Family [Connec=
tX-4]
>=20
> root@host:~# dmesg |grep -i mlx5
> [    3.833348] mlx5_core 0000:03:00.0: firmware version: 12.12.1100
> [    4.024478] mlx5_core 0000:03:00.0: enable hca failed
> [    4.260086] mlx5_core 0000:03:00.0: mlx5_load_one failed with error co=
de -5
> [    4.333568] mlx5_core: probe of 0000:03:00.0 failed with error -5
> [    4.339977] mlx5_core 0000:03:00.1: firmware version: 12.12.1100
> [    4.410366] mlx5_core 0000:03:00.1: enable hca failed
> [    4.562862] mlx5_core 0000:03:00.1: mlx5_load_one failed with error co=
de -5
> [    4.570046] mlx5_core: probe of 0000:03:00.1 failed with error -5
>=20
> Could you help on this?

Hi Ming,
Sorry for slow response,

We tested this commit with this firmware version to eliminate the case
that it is related to FW and it works.

Can you please post your "grep MLX5 .config" output?

Thanks

>=20
> Thanks,
> Ming
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--Qtzb1h6tVL0ohdDu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXlbkrAAoJEORje4g2clinU60P/jOVOReQHvyv9jNeE9KAb/wu
rnDCOY83qp+7EVHVi1/27giiV3kjmTYyxe80bAqun5Qhq0dMEecpWHzKTo+zlcQI
ThuysHKDmpsVVP0eLfkWhcbUwcXYP/UzizYo4KcwAxW/DlfpHW9NsEYFLG1dqKjx
Y/66kfIrUuFWXDGE3Rwn1DknmCouZuD38iMUvE5FMTwmhEYwNRchMjIjZUydGWdp
xkmccZos4GWT0wHp1UDLyuypXtRmxKu3rVbJP8IMUJrNDYME+HLh1d43uWVV9c0V
5z1RcL2QUhfkL0rrzAn6IiDNxH4R5L4aK+afxLmcE9S6+RQgd/B9Fpwl0P1ZztCV
3JkcEsuJ/lq142mO7oQgbIxAedLc+680Tn+pWYl9pQtc9U+WA0G5fpJ6Ax4NzBCQ
K01y95tbuVDIMglBDopnl5ixfMBXe1aAkV9/CtHRvIOcbmCmMDvv7KIH9W60Sxrl
acW9QydUpP3RJi6fPc0m98Wal0TLRJcH7iB/WY0x5d7uhIB1O9ybnnVSkpUGWza5
QxPrAPF761nhJ6lOy0tNcp1pVhhoAg7LCo6GUMu+Os2/1RRkyDYFTSGjTFO/5iJF
/6pwKhRHxCKQbIQbdEMxryjKnGr/R+xJ7Aqxi+1lRtwCi1528NQUVQPgu3ey2yqy
TttU/Pd4BfF6+IaODxD8
=8Tom
-----END PGP SIGNATURE-----

--Qtzb1h6tVL0ohdDu--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

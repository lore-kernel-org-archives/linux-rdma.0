From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: RDMA miniconf: Persistent device naming
Date: Mon, 31 Jul 2017 14:36:33 +0300
Message-ID: <20170731113633.GU13672@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="H88uUF932U8Oj0a6"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--H88uUF932U8Oj0a6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi All,

I would like to propose the discussion about ability to add
persistent device naming to RDMA subsystem.

Right now, the devices receive their names by simple addition of new free
index to the name (mlx5_0, mlx5_1 ...). Such naming scheme depends on the
PCI probing and in case of device reset can rename device.

Such situation doesn't help to provide constant udev rules, reliable
ibverbs hotplug and advanced "set command" of RDMAtool which at some
point of time will require reinit of ib_device.

In this discussion, I want to present netdev implementation of such
feature, talk about implications on libibverbs and suggest possible
device name convention.

Thanks

--H88uUF932U8Oj0a6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAll/FkEACgkQ5GN7iDZy
WKeT/BAAs4eao18wUGG24/tDjnwXWXSlM3oPMQXLkXMe6xaxZCDIGF3kcWdOkprE
hKtu/kw9DTJrVpivmwbYcLkSXmDZlITwoCS9zMGy9URjLys7duHBGrKQsiYLaw/F
FG5ntFFhh/rIbyL5ZNxrfCZVHM2yxxhqiEe7MRFtKuimZxPaURf6em8Ja3xAaEYb
9n97bwKcpQXGQOhnXemetXf302CTxZSkx1V+u8tYDDRVl9EQATyHuAn92IVzpcVv
K5QnZ293M1x0tZLKIDV6cArMOpWlQ0R283Z7SoOtG3qgtI+F0Y9hvzx8yzbLshlR
qbaFbbLpfjiKTRkF/GrpmXak25fRNqEMDdkBD7GzF7UDiqJKCNEZwiwixTTF4kEL
tGPq1R10ppIanBoMJ2o3LtIPXYOeiNoJw0K+ybHbxjRChMVjMjrZjvRirirmz63C
d2UobCOJ4Bw6IKKVZlBeR5MzvPYn4RGVg0s0CsG/YdaiVzjnJfxrYIcD7S5ooGdQ
IwM5Vo/i8F7r4sv+VvvkSICnKXjeO4imLXKmlao5TljhzNOuQRQu19ixfPbBoZ2z
7efjHTcP6Hf/nXB628dEJoSsYxfqHatqQF+sLShlVUVFMB+cmtYXJzCKclTaHwCs
Ur7eI+kR4B7bEZktpj5K+JOSQqhnizoJgPw/RsrCYe+3zKeayvg=
=4Rk+
-----END PGP SIGNATURE-----

--H88uUF932U8Oj0a6--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: build failure on linus' latest master branch
Date: Tue, 11 Oct 2016 15:02:19 +0300
Message-ID: <20161011120219.GM9282@leon.nu>
References: <01ca01d2230c$b8ade6f0$2a09b4d0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="TlDjLAx2PuPdVSSH"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <01ca01d2230c$b8ade6f0$2a09b4d0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--TlDjLAx2PuPdVSSH
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 10, 2016 at 10:41:09AM -0500, Steve Wise wrote:
> Hey Leon, I hit this trying to compile Linus' latest master branch.
>
>  CC [M]  drivers/net/ethernet/mellanox/mlx5/core/pagealloc.o
> drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c: In function
> =E2reclaim_pages_cmd.clone.0=E2:
> drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c:347: error: call to
> =E2__compiletime_assert_347=E2 declared with attribute error: BUILD_BUG_O=
N failed:
> __mlx5_bit_off(manage_pages_out, pas[i]) % 64
> drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c: In function =E2give_=
pages=E2:
> drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c:290: error: call to
> =E2__compiletime_assert_290=E2 declared with attribute error: BUILD_BUG_O=
N failed:
> __mlx5_bit_off(manage_pages_in, pas[i]) % 64
> make[5]: *** [drivers/net/ethernet/mellanox/mlx5/core/pagealloc.o] Error 1
>
> Is there a fix for this?

We investigated a lot this failure and it appears on specific and very
old GCC 4.4.
http://www.spinics.net/lists/linux-rdma/msg39135.html
http://marc.info/?t=3D147614305200001&r=3D1&w=3D2

And the fix is http://marc.info/?l=3Dlinux-netdev&m=3D147615976207362&w=3D2

>
> Thanks,
>
> Steve.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--TlDjLAx2PuPdVSSH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX/NTLAAoJEORje4g2clinxJ0QAJGSssNvXUbeGBDgfmsGSIAN
tPG07Io06Qj8954620MFGXOqW2VoP4ahOainqr/2ikTXRmKEyvma36ymj/0kLPIL
jGYn1u9Yc1HiT19ZOIVYv22sZcuHPcpPdTBiXl+Nb6PdnhjJ++fTWKtWkoy7SpEt
6AED4QDUPOh9J+v8AJRwUkGEf5De05yOKLKhyquETIAXXGbOfy+vJpMP6UmdMP9+
XK2+DMddD5060OVBRdAxsyN6jalcJqanah+ahnASqoXcAZ7k6zjF7jnA5z6eo4Q+
eESJOcX8A17pQTOePQhJDScT43Sm6kgK1qRg09AFBwTdOHy8buQ+OK27HAlQP4K0
1ZBl7uSAKJDA+S5f5D+rDuzB/aipcVxvXZUz8M5aS+1duZONruqFSct1zMviu/XB
GG7l9+Mn5mjkH0JCZpjzGOVMpNXDwj3d73qXbnLcCJr7xxtKA+zhPNV77/kprFMi
637Mx2UlLImQ91WYWDzdRyTiXVeNOv5q5FWhPNxZLsth8K0HKekhpvnSckqUSBbL
u0L5ZyUWuOW9kpEgbsMkng1Foru+6iTgtdSTUlblupzXEuXwnT49ycNnxDoI2kTB
FGcz8dww1nETzWViBtfMnggxEevPyzoDMIUjXh0hIzqjN2KtAlN6uG33hBkZPgwR
4PCcSGG7EkkX/Ka/vuO6
=CW/H
-----END PGP SIGNATURE-----

--TlDjLAx2PuPdVSSH--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

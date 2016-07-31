From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] IB/mlx4: Allocation of CQ resize structure doesn't need
 to be atomic
Date: Sun, 31 Jul 2016 09:42:45 +0300
Message-ID: <20160731064245.GX4628@leon.nu>
References: <1469768323-8093-1-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1IWgL8yD8uKyf/Tu"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1469768323-8093-1-git-send-email-roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--1IWgL8yD8uKyf/Tu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 28, 2016 at 09:58:43PM -0700, Roland Dreier wrote:
> From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
>=20
> We allocate a small tracking structure as part of mlx4_ib_resize_cq().
> However, we don't need to use GFP_ATOMIC -- immediately after the
> allocation, we call mlx4_cq_resize(), which allocates a command
> mailbox with GFP_KERNEL and then sleeps on a firmware command, so we
> better not be in an atomic context.
>=20
> This actually has a real impact, because when this GFP_ATOMIC
> allocation fails (and GFP_ATOMIC does fail in practice) then a
> userspace consumer resizing a CQ will get a spurious failure that we
> can easily avoid.
>=20
> Signed-off-by: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--1IWgL8yD8uKyf/Tu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXnZ3lAAoJEORje4g2clinpsEP/3D9Xn+use53YJPSK05XfBgs
6ofXhaO284qK27qihdEWNbjDBbqw9VP8apd2wFb6s20KeZAPRtOAV96P4zeziUA6
0EbgmsBbf8/1IG2g4r2mxkL36p5Ji0p+d4MVht75SD1nZg6rfT7TWsM+eKsvqmRC
kHbRtyokIVOvkQzqAOcwCcRzb3TS/N400LGRhTXLe4aLJ+9qKqshn0wkeR4UNze0
SkgIvVVbcsVC1TnXjvHXajOW3G+qyEPPPqCu/DxUoIiHtCo35TznHoCfC7S3B5zf
SrL47L7tCElcObNHGGXWqlPjgN+lzDKh8E6Z/GspV9rkzmM6JUM2ntNbbJK32Zom
5S5FM1tcYOhBtiO9WxqjElW5yBbsVX8t+KpXoH23eGv3/5S8gBwKl0ubNV6jLeSw
dmxyv+jSzoO6KitTEujlCl5OX5cQ5MGCRfltur//r1AEUlWYdXQetP/BZzhZlt17
QORmzai0YS1iIoYVsZfKNJyJCrFBAmViQu6mZvWELoMl0ze9k95AhRiBV1fzfoEW
c2Z2Mo2c/JXtP7al14v/GiFE/aYHcNnLIUqJlnx1niOy38LvkuJsH4YwzSRLoWFJ
Eu06BAUxEr/2moFGNQ7ctlGMFP9kFWBCuOFpf2CUhoGZYrO7ubqdXJkVIoMxUk0G
UfvfuZPXFTXj8OToDrzk
=djYK
-----END PGP SIGNATURE-----

--1IWgL8yD8uKyf/Tu--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] IB/mlx4: Fix device managed flow steering support test
Date: Fri, 3 Jun 2016 18:06:39 +0300
Message-ID: <20160603150639.GN7477@leon.nu>
References: <33c3370d-3568-a9aa-906f-683b0e1b1a5f@sandisk.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5FetH82qe0Z6y/zI"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <33c3370d-3568-a9aa-906f-683b0e1b1a5f-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--5FetH82qe0Z6y/zI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 03, 2016 at 07:58:32AM -0700, Bart Van Assche wrote:
> Perform the test for device managed flow steering support even if
> memory windows are not supported. I noticed this because smatch
> reported inconsistent indentation for the device managed flow
> steering support test.
>=20
> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Reviewed-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
> Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks Bart,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--5FetH82qe0Z6y/zI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXUZz/AAoJEORje4g2clinDCcQAMXAIZa7UqFi5HE2PigZxmHx
dOzPyMvotMUdD0hN6LfTv6XqcanKxkexyj4nLn7pq5kQa+hdRZaRdW2V7gQsm0uV
+2kCA1EMzqgsqASuAFGkWk+Fu6UlTXuGbgJ7zDuJ6qQXQQPaHe08la9qlO/dqDF8
zd5Oqv6UadFAmxeSLG9jfdGmi9qCNSVmMC1ViJYVwqRo/DU4PkLo+wmhB5zMLqPu
nlUF9TchIh1FUteuCPBRZrUYNSc03sSjuSllX9KCHI1A5on801djGsaF5TpBTbRo
7dRJfvb67iY/9qw4gKXFLgjQOrW5/6awoNSxgXV9bjo96WTCNwzJbiWez4O4KXg3
1NiAFdJXHdg2XnnJ9a7qI73WN6DI8obsrEG6ptJR8bLVXdN7RAOtf+JYAPCVkBJj
gS9jjQ36MiDKKWzhO6XIc9OgYqUelhyEQarIj5qdl8TndSmW1w8+LUpuHqySB9Uz
79DBagdNT4TwkuHUVZSAIVRBh3IyXiX+hv9KD+biZMXcy+bzydW8EIe3QEUNmkXy
ZDOsO5SJJhgLtMw26AWac3HIwTivH5eZMZC7EomrC9Etpg+bDRWlufTGi3KL8jWR
i0TjVHe69Ir1FcLXHrKsmP23UhoTS1X5vtwf6L/32F5C7jKJ7tdFDjKqDkZcyxg5
rH4Jl5su3TXXKu0Po2wr
=AIcg
-----END PGP SIGNATURE-----

--5FetH82qe0Z6y/zI--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

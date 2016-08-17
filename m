From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: linux-next build error =?utf-8?B?ImNh?=
 =?utf-8?B?bGwgdG8g4oCYX19jb21waWxldGltZV9hc3NlcnRfMzQx4oCZIGRlY2xhcmVk?=
 =?utf-8?Q?_with_attribute_error=3A_BUILD=5FBUG=5FO?= =?utf-8?Q?N?= failed:
 __mlx5_bit_off(manage_pages_out, pas[i]) % 64"
Date: Wed, 17 Aug 2016 09:00:34 +0300
Message-ID: <20160817060034.GE5489@leon.nu>
References: <CACKvgLHp0jc_0drhk2u7GChhZkwBXhA0ps55=+J8NXp=u7u7Nw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TD8GDToEDw0WLGOL"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CACKvgLHp0jc_0drhk2u7GChhZkwBXhA0ps55=+J8NXp=u7u7Nw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vinson Lee <vlee-CC+yJ3UmIYqDUpFQwHEjaQ@public.gmane.org>
Cc: Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--TD8GDToEDw0WLGOL
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 16, 2016 at 11:57:23AM -0700, Vinson Lee wrote:
> Hi.
>=20
> Commit a533ed5e179c "net/mlx5: Pages management commands via mlx5 ifc"
> introduced this build error with GCC 4.4.

Hi Vinson,

Fenggauang reported this issue a couple of days before [1] and from our
investigation, we didn't find any reason for such failure [2]. It is
caused for specific compiler for structure which is aligned.

Any suggestions?

>=20
>   CC [M]  drivers/net/ethernet/mellanox/mlx5/core/pagealloc.o
> drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c: In function
> =E2=80=98reclaim_pages_cmd.clone.0=E2=80=99:
> drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c:341: error: call
> to =E2=80=98__compiletime_assert_341=E2=80=99 declared with attribute err=
or:
> BUILD_BUG_ON failed: __mlx5_bit_off(manage_pages_out, pas[i]) % 64
> drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c: In function =E2=80=
=98give_pages=E2=80=99:
> drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c:290: error: call
> to =E2=80=98__compiletime_assert_290=E2=80=99 declared with attribute err=
or:
> BUILD_BUG_ON failed: __mlx5_bit_off(manage_pages_in, pas[i]) % 64
> make[5]: *** [drivers/net/ethernet/mellanox/mlx5/core/pagealloc.o] Error 1

[1] https://lists.01.org/pipermail/kbuild-all/2016-August/023040.html
[2] https://lists.01.org/pipermail/kbuild-all/2016-August/023050.html

>=20
> Cheers,
> Vinson
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--TD8GDToEDw0WLGOL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXs/2CAAoJEORje4g2clinhioP/2T87qHNAFi6yM9eRYPP0t5i
tXf9zngbMcYLFiHp1MEaUkxnPJhbOx1iH1oDXLq2sNq22JSuxnp4TeuXk8E2ou1n
AFZ2yo7tyKwAgd197vLrTpF/KDiz7JPLjv2qSk6Nj/IzkEoH7O8E1ol45IZj+wjK
/FKQaEZTQp6fp/VVzBGhvT65+4Zy3tdIiMOot/bx5MtJ5wo6XltAwds2w9gImF80
rf2tnXyR5NRNeV6o8/wtgHqBM4oK7rEE0nw6yZio9wkcg/o3Bo5d5230/2vIMYBJ
Wk/s+pdzFwWIo3bntyIiRyGwWLxVz+VLyZpJUwDXjHP+m5pDDi3p4l/cCJv5tv7w
/mmIwZqn1w5Ntzw71JhiX167Atexg4jCX770dZXA/aXplB/GR+D7jJ5HfVPx6Bz6
tkZ+4DX+ipXxxY9H1wKK9rqWNdw9OfDWmgQTVEj7YqIqXxz93FtdXDSK8uW5wpTh
76rIPuilaqHZnlPAijAm31qyDREz4/cMh3K3FrM1h4c8ryjTqnSNBC2gNb2zeoRH
cXihrbh7VFCoQWwC4NCIHnqEPsy6j1irDxShpupPmiGyCtsdPWrOHTmtZErpS/+M
i+zkW+tGbnhJ4hikD1H3ha8FvGyFqAox+aJZ/m7kbIboGTiSigEc6rwOpiqaJKYX
EEimANkmcf4F2JCjZK4C
=wh+b
-----END PGP SIGNATURE-----

--TD8GDToEDw0WLGOL--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

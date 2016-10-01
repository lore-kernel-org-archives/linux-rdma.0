From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next V1 0/7] Extend flow steering IPv4 and IPv6
 specification.
Date: Sat, 1 Oct 2016 19:38:21 -0400
Message-ID: <aa7b3656-b225-415d-852b-5fdd1cc462c8@redhat.com>
References: <1472565516-11591-1-git-send-email-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="oWKEOXuvkpKwHIEJLDXFxNTGchRperVMl"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472565516-11591-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--oWKEOXuvkpKwHIEJLDXFxNTGchRperVMl
Content-Type: multipart/mixed; boundary="BgWHivo3GnWlXw7UJJbk6a21EhQdAbJDU";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <aa7b3656-b225-415d-852b-5fdd1cc462c8-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next V1 0/7] Extend flow steering IPv4 and IPv6
 specification.
References: <1472565516-11591-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
In-Reply-To: <1472565516-11591-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

--BgWHivo3GnWlXw7UJJbk6a21EhQdAbJDU
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 8/30/2016 9:58 AM, Leon Romanovsky wrote:
> This patch set extends the IPv4 and IPv6 flow specification.
>=20
> New fields in IPv4:
>  1. Type of Service
>  2. Time to Live
>  3. Flags
>  4. Protocol
>=20
> New fields in IPv6:
>  1. Traffic Class
>  2. Flow Label
>  3. Next Header
>  4. Hop Limit
>=20
> The first patch in this series adds support to extend the flow
> steering specification. Previously, user flow specification
> and kernel flow specification were must to be equal in their size.
>=20
> To support extensions, we change the flow specifications conditions
> test to be as following:
>  1. Every mask field that is given by the user and doesn't exist in
>     kernel is validated to be zero. Thus, new user-space would only fai=
l
>     if it's using (i.e field_mask !=3D 0) a field which doesn't exist i=
n
>     the current kernel version.
>  2. All types are known by the kernel.
>  3. If the kernel is newer than the user-space, all fields (and by
>     that, their masks) weren't given by the user are assumed as zeros
>     and ignored.
>  4. The ABI declares filters as 32bit aligned. This is necessary to
>     avoid unaligned access when reading the header.
>=20
> Changes from v0 to v1:
>  * Add Reviewed-by from Sagi G.
>  * Split mlx4, mlx5 and uverbs to separate patches
>  * Rename IB/core to be IB/uverbs
>=20
> Available in the "topic/ext-flow" topic branch of this git repo:
> git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git
>=20
> Or for browsing:
> https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/log/?h=
=3Dtopic/ext-flow

Extension was done in a way that made sense and adhered to the standard.
 All items added to the extension are generic flow variables that make
sense for anyone that would implement raw eth flow rules.  Series applied=
=2E

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--BgWHivo3GnWlXw7UJJbk6a21EhQdAbJDU--

--oWKEOXuvkpKwHIEJLDXFxNTGchRperVMl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJX8EjtAAoJELgmozMOVy/dqgQP/iqezzv9nylDmJUjhZOYlxPl
bvMfCzvlAS++K+vvggDQUiX+qnErzvgzHIYpE82IFxxJzENz2mAHQmmme+N9MZJZ
NGLp/MODs6YNgJbGT+RJO/6Gepa3WOif0ngzdWHw8VAGBRTswPdVYDxttkOSTKBY
oBLmN5GNHewYknrwotp8Wl8AQ/E7aauKdihS6jPgcbB+lR9Q00naQb+pZDkKGw2l
QGwx5Fhsub831BhogOy5TIKfdNrTJyeTYkOWj2Ze3dHGHH4Dxw+bapRvLDx/hrkR
gWh6G2QwY3FIMv0gX/wxsB5IV3ucTNxfw/IGUsvC+oC7qg/ahiv3mYFh86ig6maP
X/O3MuiZNxY3HddTRREow4JkGY93rUQUu75ybHPQCF23yLGmvcD6vMN0EMMRzAd+
tlM412WcaN3hdPOMapXGJF4f3NyD3hPOu3zSw9LqMBXYcmOyvTHFiHmthJpqQqU4
0UU0xio/0Np97KKzswE63XGj0Dhk0odmGZrZT6A1ZaJg3eIJXR817tT43n3OH91Y
nLp/hO+tvftHqJHA9DpRguuns2vzHp06Ih/r0NuP/7zW2/MGsVkVZYKfO8anBdTt
YjYhhP5Rh4hhOw2uxVSerVLty1iPlf9p9lzmRDisG1A2JP01RE0KT8UwMOfQmFdm
Iwv1il2vZ+/Ja53ib80u
=8P6q
-----END PGP SIGNATURE-----

--oWKEOXuvkpKwHIEJLDXFxNTGchRperVMl--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

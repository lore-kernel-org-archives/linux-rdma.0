From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next 0/7] Mellanox ConnectX-4/Connect-IB sniffer
 support
Date: Sat, 1 Oct 2016 19:36:20 -0400
Message-ID: <c2e39c46-38db-b44a-9e87-62d8e4edfa19@redhat.com>
References: <1472382994-32091-1-git-send-email-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="dFrqmGFqArJcJfTm4NwIHth97OKAh76uO"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472382994-32091-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--dFrqmGFqArJcJfTm4NwIHth97OKAh76uO
Content-Type: multipart/mixed; boundary="fTjqd8wmtBxiCj7ckvXRH4x6qD92Nxui7";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <c2e39c46-38db-b44a-9e87-62d8e4edfa19-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next 0/7] Mellanox ConnectX-4/Connect-IB sniffer
 support
References: <1472382994-32091-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
In-Reply-To: <1472382994-32091-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

--fTjqd8wmtBxiCj7ckvXRH4x6qD92Nxui7
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 8/28/2016 7:16 AM, Leon Romanovsky wrote:
> This patch set adds sniffer support to mlx5 flow steering.
> A sniffer rule could be created via ib_create_flow verb with
> IB_FLOW_ATTR_SNIFFER type. When the user adds a sniffer rule,
> its destination QP expects to receive all incoming and
> outgoing packets from the port. Only raw packet QPs are
> supported as destinations.
>=20
> In ConnectX-4 based adapters, each incoming packet is duplicated and
> sent to the sniffer RX flow table in addition to the NIC RX root flow
> table. Each out going packet is duplicated and sent to the sniffer TX
> flow table in addition to the wire.
>=20
> In order to sniff all the traffic, we add a single "*" rule both
> to the RX and TX sniffer flow tables. "*" rule is used to receive
> all the traffic, this rule don't contain any criteria.
>=20
> Available in the "topic/sniffer-verb" topic branch of this git repo:
> git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git
>=20
> Or for browsing:
> https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/log/?h=
=3Dtopic/sniffer-verb

The first two patches did not apply as I had already picked them up via
the 4.9 shared pull request.  The rest of the series was applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--fTjqd8wmtBxiCj7ckvXRH4x6qD92Nxui7--

--dFrqmGFqArJcJfTm4NwIHth97OKAh76uO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJX8Eh0AAoJELgmozMOVy/d7QgQAL/lSUhixNUARPDnU4xHjJR8
Vg6S6MQ1RqvCXZuM2zNm2qc3BaATuyEJdrXpC4NABY4CmaQESKBP+w5XPwigNftk
DkKUF3bTdk0XUAfujEMDyZrqTMXVANFPQNXbhkGr1JJad8dMgTNFnborJtXurrw7
K/Zi6gJv6hU/sgE/UnbljM5gK85EJF81UuhSkuiTY21REYrY2KKzq4J+9DkeFmDS
DEYb5fgyy0J2KyDfwIejd4JkgWo+d/sCr9QBnEgO9LFlDE1sLRS1w+EmgxUHCzIM
IK62OnduVaFchYCmcs8QOyxC7DrQ6A8TB0sfcF+ZR36xV2Od52XanuE8mveEeIeV
3mqSTi/Vpx8gszH8pd57y7MzDIDSfpNcBrQAUeKGX5E4UTPnNOAKxd66xIV8QJ2f
saY8wl/GHR3E25cwVn4T2asyZqek4Ei4jpG0IMsTTLKb0kaqT3ZC/vRJ3nzn4Cdu
54txnMSnUtjNbCdsdejzyfN0BduVynTsKZO5bi4Wjno1SLpwL4csiKH4dx9n/dzD
3bFPyxy4w7ZA0dZI7UkezQ8qGV6pgvT9+M08L6GaLDgtsxye1S082V/xBhxo598u
93oKiPO0pfzZ5tX+nv7yJxmpBrQeguiO8LoUt7v+EkqeMUBb6Pog4Sbga3X9Y+Tt
tSJBohfo9ymdiaI2OZkb
=LVO4
-----END PGP SIGNATURE-----

--dFrqmGFqArJcJfTm4NwIHth97OKAh76uO--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

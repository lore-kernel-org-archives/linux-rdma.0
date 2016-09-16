From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-rc V1 0/4] RXE fixes for 4.8
Date: Fri, 16 Sep 2016 14:31:33 -0400
Message-ID: <62a81c50-c4a7-7bf8-e2d2-48c4cc39b058@redhat.com>
References: <1473246247-16536-1-git-send-email-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="DmXt234IVMqhtOUBQUQcErbagKJxeI4FF"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1473246247-16536-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--DmXt234IVMqhtOUBQUQcErbagKJxeI4FF
Content-Type: multipart/mixed; boundary="aLMiNQ2G83c3wwrwsQSkvAB62cq9tt6RR";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Message-ID: <62a81c50-c4a7-7bf8-e2d2-48c4cc39b058-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-rc V1 0/4] RXE fixes for 4.8
References: <1473246247-16536-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
In-Reply-To: <1473246247-16536-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

--aLMiNQ2G83c3wwrwsQSkvAB62cq9tt6RR
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 9/7/2016 7:04 AM, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> Hi Doug,
>=20
> Please find the following four patches from Yonatan which
> fix numerous issues in RXE code.
>=20
> Thanks
>=20
> Changelog v0->v1:
>  * Patch 1:
>    * removed second call to register_netdevice_notifier()
>    * fix indentation issues
>    * separated rxe_net_init() into two functions
>=20
> Yonatan Cohen (4):
>   IB/rxe: Fix kernel panic in udp_setup_tunnel
>   IB/rxe: Fix duplicate atomic request handling
>   IB/rxe: Fix race condition between requester and completer
>   IB/rxe: Fix kmem_cache leak
>=20
>  drivers/infiniband/sw/rxe/rxe.c      | 25 ++++++++++++++--
>  drivers/infiniband/sw/rxe/rxe_comp.c | 13 ++++++++
>  drivers/infiniband/sw/rxe/rxe_net.c  | 55 ++++++++++++++++------------=
------
>  drivers/infiniband/sw/rxe/rxe_net.h  |  5 +++-
>  drivers/infiniband/sw/rxe/rxe_req.c  | 57 ++++++++++++++++++++++++++++=
--------
>  drivers/infiniband/sw/rxe/rxe_resp.c | 11 +++----
>  6 files changed, 114 insertions(+), 52 deletions(-)
>=20
> --
> 2.7.4
>=20

Thanks, series applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--aLMiNQ2G83c3wwrwsQSkvAB62cq9tt6RR--

--DmXt234IVMqhtOUBQUQcErbagKJxeI4FF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJX3DqFAAoJELgmozMOVy/drZcP/3B4t5FkcCkYyIsiF2bfHPl6
xDTrUJHIN7UWurGnma2PG8amlDHB3Ykm990Ano2LiJ5U1Js/p/ddlXt1uLcQYW/H
jqFGJuBw/N7xkbtqKUc0Mi7gpPRnGfQRrZVUjV0F64u+CFFGDe2RBE8jQ9aiifGp
sf4CyiohvqY7kPqbw2lW3bmt5ZqDjdMr8fjeACNN7PyGVz7EvVKjvZsM58+4WF0G
o9TInAJVOg4Jb+9KSbZxdu1J9HbGujgM1GiRmLU5zseCgMeiiSWPfabvr7JgeBF2
0Tl9HVS3GQP2lRt59MQz6TrgbhHoVU1kbWeNxfK+LBT3J2WjqMkiGM8cRQloUrOe
eQRVM8VCwWxZQ4LRZYsLh4AaHjEd7fvrF4ZJRePBAXOI0yBe75Q4eiSNE1gQ+mz6
CBQzFJgLj2Ii+pZ5iq+P7bVfD4tg9ufOicvhxP8bWko+wmqoer3bov+oKwzi9lpg
AC92B//wMH1Co+pAt1/VENvS0+cPWJgfm+DZwXgU/ckBKyy6Z6OM3Ze0r3spOo4S
3COLxKCPzhFyi7WgIpE0rWtTDymVvyh2vk1rgUmK6ysCvfRpZBJUaqNcMxVvJyxF
QWliIdgTEkb+rz2z+XIwDuDh08vJTjwHV4vljZTpjAO7ORzIv1MEbSTuNvmEA7iQ
cI5E/8PPwxypsXA5vmGd
=1vGn
-----END PGP SIGNATURE-----

--DmXt234IVMqhtOUBQUQcErbagKJxeI4FF--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

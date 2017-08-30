From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] IB/cm: Fix sleeping in atomic when RoCE is used
Date: Wed, 30 Aug 2017 10:23:42 -0400
Message-ID: <a7c4b18a-3b19-74f4-b9b8-35f31e65a2bb@redhat.com>
References: <20170829173444.4289-1-roland@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="6aGdQxwXARp7HtSXaxpr08mu6lRBguKfo"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170829173444.4289-1-roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--6aGdQxwXARp7HtSXaxpr08mu6lRBguKfo
Content-Type: multipart/mixed; boundary="cqP4FMqAUb3bBCt9Dpu5HsOno8SRL0pG2";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <a7c4b18a-3b19-74f4-b9b8-35f31e65a2bb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] IB/cm: Fix sleeping in atomic when RoCE is used
References: <20170829173444.4289-1-roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
In-Reply-To: <20170829173444.4289-1-roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

--cqP4FMqAUb3bBCt9Dpu5HsOno8SRL0pG2
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 8/29/2017 1:34 PM, Roland Dreier wrote:
> From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
>=20
> A couple of places in the CM do
>=20
>     spin_lock_irq(&cm_id_priv->lock);
>     ...
>     if (cm_alloc_response_msg(work->port, work->mad_recv_wc, &msg))
>=20
> However when the underlying transport is RoCE, this leads to a sleeping=
 function
> being called with the lock held - the callchain is
>=20
>     cm_alloc_response_msg() ->
>       ib_create_ah_from_wc() ->
>         ib_init_ah_from_wc() ->
>           rdma_addr_find_l2_eth_by_grh() ->
>             rdma_resolve_ip()
>=20
> and rdma_resolve_ip() starts out by doing
>=20
>     req =3D kzalloc(sizeof *req, GFP_KERNEL);
>=20
> not to mention rdma_addr_find_l2_eth_by_grh() doing
>=20
>     wait_for_completion(&ctx.comp);
>=20
> to wait for the task that rdma_resolve_ip() queues up.
>=20
> Fix this by moving the AH creation out of the lock.
>=20
> Signed-off-by: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>

This looks good Roland, thanks for that.  Will apply today.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--cqP4FMqAUb3bBCt9Dpu5HsOno8SRL0pG2--

--6aGdQxwXARp7HtSXaxpr08mu6lRBguKfo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJZpspuAAoJELgmozMOVy/dZD0P+gLQaJwGqlt/x+iaEguKZmrk
cSu3VkpsYJMxSjVqFaOHL0nWf/png1nGSESrCzb+AnRpWpEY4tAnGNk+yf0ksFzA
c55iVNxCJZySbZhs4dQ4/wfP5Kw7nolnepOdeFM7EZslvGL6l+CCdZDgwuEt+ZeA
nkGjX3Ea7l/q0/IxNAWdm8Hbz/X8z7yvl7Aut+v/jxZiC8DCMpOGPdDmh2KQO/GS
FSBpOFACup6gu0yTouLlCD4B5ZVTJA8rbKuMT7AdlClQT7zce12MZQh/HFV1l/XZ
xZ4jPuG+KosSZ+Oov1gLZcwTiXaVbQg9njiQe6gvcWVz7SYIu/rBaS5yAkutSL/f
NowZMIXZ8rt8SmqM9t0hfjXqyRTMi4Z0QGg6z8twKwMnPXGAZ4/HyNw/SipU0OFo
ZubXIy4uNUFa6wA6SHCeuf0tku3vb/uyMM0bGlAs/FcaSDuRCJBT2LpT/RJHkzoY
5LTqzO9GJw3oLa4LzLK8g9yd1cuZ0pTRx52rHWfm+9K+/Pe3PUiUIjdb2igoxgud
xYrP0kMZVzHMRjZLKmTNeCjqgdDWskjKw/wKOw2R+XywoIHsaw6w3uqLuqxIiQRE
L9EpjlJ1HJQiAh/6MO4jDsX4PX8zVIV2L7rqpLzGM6CjW0xC+BhKd27B+k2WzoTX
Bce9rtoEOmAZpwvxXW/W
=Tdpj
-----END PGP SIGNATURE-----

--6aGdQxwXARp7HtSXaxpr08mu6lRBguKfo--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

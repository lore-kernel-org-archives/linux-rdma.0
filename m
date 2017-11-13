From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] IB/ocrdma_hw: remove unnecessary code in
 ocrdma_mbx_dealloc_lkey
Date: Mon, 13 Nov 2017 16:19:01 -0500
Message-ID: <1510607941.3735.38.camel@redhat.com>
References: <20171107144517.GA25631@embeddedor.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-J6L62PEodYHWNeMun/HL"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171107144517.GA25631-L1vi/lXTdts+Va1GwOuvDg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Gustavo A. R. Silva" <garsilva-L1vi/lXTdts+Va1GwOuvDg@public.gmane.org>, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-J6L62PEodYHWNeMun/HL
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2017-11-07 at 08:45 -0600, Gustavo A. R. Silva wrote:
> Check on return value and goto label mbx_err are unnecessary.
>=20
> Addresses-Coverity-ID: 1268780
> Signed-off-by: Gustavo A. R. Silva <garsilva-L1vi/lXTdts+Va1GwOuvDg@public.gmane.org>
> Reviewed-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-J6L62PEodYHWNeMun/HL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAloKDEUACgkQuCajMw5X
L90Bvw/+O7CBHKVOCIha/VDwoQChgTrj9hAsQn4RpecVpvgERnkqeHAn0tLfanMD
2dq7TEJb2v5zBD0G/r2nfyYFe8VMC4XKY2Dm/CEq8wm+5qc3vaKy1Snvj6slLVN4
XuVM3lfslEQDycON58pXfoymg6fj/+F5+iWK7aFaopW3aLM20smWBgBoMCmlXji6
1fXl8TYEKVKHfPLv7ay7WmM9zRr+JzIzpXGRy+0HXspaYGZPvos+dEB66dGOvFjf
CeNhTyPEKwZtnHPTHe85yMitECzycMD05PxGDZIhR/qxrOIzHCF8u+pHEf3RmHcW
BHV2n3Eenkw/e8wvfNHHpgrR8RpQGmesMvTlWArhBEKv/GZls0rDA11XwE80eNvy
iUSyg2bex/U0s6y8ekm4ju6HHA7JlInf1e7Q/XDjk137sI9sh4A6lA9L8q+li59r
qgAw8SG/LrLi6HAzlewMrk86NDzeDaABQCyUrLaXGCqkJOmJ0IRFm5nW7xS6PI+k
92wOHCblILjFQ037n5DmKTQCw1MZJZsda1v5mHvfeQ0B/y5ztIbFYRBdggtE4CeS
VWlabsaDMw4yen/mbBb4CikJWv/kpNpsF4/zqy4/q+MjzGj6rE64aj0Vy4vVoOHs
ZNTlq3hG79aqdANrTrENsXfptxOOrcRwgeRh2AUKHIO/YHLyTuw=
=1gHp
-----END PGP SIGNATURE-----

--=-J6L62PEodYHWNeMun/HL--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] infiniband/hfil: drop pci_link_reset()
Date: Thu, 12 Jan 2017 12:08:11 -0500
Message-ID: <1484240891.123135.7.camel@redhat.com>
References: <1482129996-19255-1-git-send-email-caoj.fnst@cn.fujitsu.com>
         <1482129996-19255-2-git-send-email-caoj.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-0ftC7bEvotfwRu4NNUKl"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1482129996-19255-2-git-send-email-caoj.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Cao jin <caoj.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-0ftC7bEvotfwRu4NNUKl
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2016-12-19 at 14:46 +0800, Cao jin wrote:
> In AER recovery, pci_error_handlers.link_reset() is never called,
> drop it now.
>=20
> Signed-off-by: Cao jin <caoj.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-0ftC7bEvotfwRu4NNUKl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYd7f7AAoJELgmozMOVy/dhCIP/1VsXd4sKnjbGSKRhHEsyaVt
Ewo4ZX5d2F1KHTKZE6RYha+6UDLsnaU9DGZEyKSfChFR7rpUm8ClCXOAGyTLSzBH
0LV1zHhbOs3UkhEocKa0aQfKr3R9+s2qVPgBjMHQdHpWf7Vy+jSYKcE42Ky64ik8
YJobIkfTtYxBJ4KWAKEKbzaXtsWbzY3OVo5Rp08N6CFXvEk5HFk92lf2/6ydJqLd
l1PCHR9NLhYQlmV+/5s2B03yV5GykKkNnoRbMbU7/R91RE6C9VzukaQtMl32WLCa
r3fthd3e3iBxPPltXFUjuDiZfhAvrOdnZoEoST+GF1xCjbQEX0dXI/iwKkQQFWlh
d15/sybEM0IsKcmSd1a+pWG6WSG97SolODXInaNAVoBRct2rx+JJKdjsEBlgH1Kw
BsWFLBocc6K9a/ZkKKkHZBapIZ/M/wTH0NOdOfvjLhsFwROOJO2jaC0Cl6F7FG2B
/IueCkffrm9VZAmRxSQRPxy783A2mqCNMwGXgRhmYNJ87twDTQeyuFYKNUMAA7in
Q3Mc6XQyfJ1ZDnAW1tb4ybmsB6wVa0Vec9slmPbxBZ77UWT5ZEdg6pGm1lh18oHb
WnBWfzTzLBi6Up5wshTpS36erUAXpZrTtSTx7JXUf0qahBKeh7Q3ptERKquIarvz
t58SwBkr0OeClxkceQgo
=qF0L
-----END PGP SIGNATURE-----

--=-0ftC7bEvotfwRu4NNUKl--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

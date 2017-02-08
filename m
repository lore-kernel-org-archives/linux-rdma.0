From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-rc v1] RDMA: Remove kernel private defines and
 reference to header from UAPI
Date: Wed, 08 Feb 2017 12:42:49 -0500
Message-ID: <1486575769.86943.17.camel@redhat.com>
References: <20170208150409.29537-1-leon@kernel.org>
         <8c2f6c58-f622-95cf-e146-ed7a5747fd9a@mellanox.com>
         <20170208172544.GF6005@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-a6ZyHTxtuNYNP0qXcUrY"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170208172544.GF6005-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Matan Barak (External)" <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-a6ZyHTxtuNYNP0qXcUrY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2017-02-08 at 19:25 +0200, Leon Romanovsky wrote:
> > I tried to write this earlier, but for some reason my mailer didn't
> really
> > send it.
> > IMHO, since these enum values are actually passed between user-
> space and
> > kernel (attr_mask), it's acceptable to expose all enum values.
> > Otherwise, user-space should define all these symbols by by itself
> (as done
> > today), so why bother introduce only this explicit symbol?
>=20
> Mainly because it is -rc7 fix and it is MUST be applied as soon
> as possible, currently IB stack is broken.

Indeed, which is why I took the V1 of the patch. =C2=A0We can fix it up
nicer in -next if people prefer.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-a6ZyHTxtuNYNP0qXcUrY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYm1iZAAoJELgmozMOVy/drbUP/0u6lqqdzcErF7htiKvlx07W
qT2pZxIDFhi3jYes8wJ6NWWdBJ8RXpc6nTy5xewZVCm+X6hhzr6DgptvzInbD0UB
zZC4rZQlHSnzRBZwh5vkgWfmhO7A12vj76Dgcpy/jUj8E4+5/ve4PYhrM75pxvwu
DnaWQfUYuVKhH/1C0CjkY9pdyBa4XSVlId10cekhD9eHKQNe6QULm8m9FfQ9abeJ
OvYeqa2tESqwQ+manbdK2yGhXJ3ccKaYWnTb5vZCCGOP0lUGp2P0C49cpzTnTx/h
HY2bHSIRprGgoBsJoN3rL26IM1IzHL8xU6vMRnZwrv26IHj+wci9SBzqhUdgXG/z
vB6Jab68Q6xx818ldHviABMNndK8p7eqe7ccqYo9wyMp3e1wrplsyCemoP2gBANe
ybgMju8RZrXTMdAtR5VFD/5SY50xAJXLIU1u8kEgxd7WARAi1uUar0OQVFS1+PiU
XYUpErwucy3aBElGZsZxKzQbb+VydrnJiEF8Sq4ONHVY3MfSM6JeNnZCS2ib99GC
m+JYloyym3OMNjtT2RqXb07AaCxegBvNo1s13pUUqjONIi0gqq/y+N2nrioCF40L
M4DQSjHpyw3C4Uk/8M75pTiIQ2zqHCMU4XYj81xvG82kSIRzh8F3kYjaNrE2dLpD
lm7S5OsL5JZsLMnTotQ/
=x/yA
-----END PGP SIGNATURE-----

--=-a6ZyHTxtuNYNP0qXcUrY--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

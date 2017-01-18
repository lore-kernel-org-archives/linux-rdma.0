From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/3] IB/vmw_pvrdma: Defer activating device until
 vmxnet3 link is up
Date: Wed, 18 Jan 2017 15:25:31 -0500
Message-ID: <1484771131.2406.48.camel@redhat.com>
References: <cover.1484075557.git.aditr@vmware.com>
         <4b515ded56300f12cedc67253d42ab8fbc52134e.1484075557.git.aditr@vmware.com>
         <20170116073858.GA25853@mtr-leonro.local>
         <35f6cce2-00c8-16b6-e3e0-481f234bd9c9@vmware.com>
         <VI1PR0502MB30081629AE674E7F24337835D17F0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
         <ad2f92cd-f120-b04a-0e94-b49915cadf02@vmware.com>
         <20170118184236.GA4864@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-/YAZ08IH2N3ao4Gf0OlT"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170118184236.GA4864-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org" <pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-/YAZ08IH2N3ao4Gf0OlT
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2017-01-18 at 11:42 -0700, Jason Gunthorpe wrote:
> On Wed, Jan 18, 2017 at 10:30:20AM -0800, Adit Ranadive wrote:
>=20
> >=20
> > We do register for netdev events so we get callbacks for the
> > link state. The problem happens when we call ib_register before the
> > vmxnet3
> > link is up. At this point the ib_core stack already has created the
> > QP1, etc.
> > Once the vmxnet3 link is up we would have to call
> > ib_unregister/ib_register
> > to recreate QP1. This might fail/stuck if the there is a user app
> > thats created
> > QPs and we're just waiting to free those resources.
>=20
> Having to register/unregister on every link transition sounds like a
> horrible design, you should fix that :)

Indeed.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-/YAZ08IH2N3ao4Gf0OlT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYf887AAoJELgmozMOVy/dd40QAITmKTkD0ancUFe2K4lHFRAs
w/6+54kWqdXmPohzxOAf8LLAJD5BMehNOartttUn4FMVWYSMkxK8gkz2iR2ekAuz
KJhTqicDHVveAmjIxJHGCQpPQMvkh5H/lr8O0gDPEPOmVkO8zu4Gx9tuEInQOStq
C6j79LvPeHgBwJPiyWvk/FqyifMIQUSzC5Rxxj0/IjfkqJTUHy8hzHBNrB4L5c+c
Ce4YKcUkhNUYjRudnysRUE7QtPQ5GLIbVRS/70BfTiLzjVjFzFRs6328JIe2/d0k
nnMZfhsDVOt7jsbNshuNt8LixrkVnHsUklMzvomyfW/5XxdK9S5d5FLv8JkfkHeq
ZdSuj3U1OgAsevsEhZKqW2AzET+pdGUPLwAEm/SGR/Wnp5QsRu8u1E7elyjAd1Fm
eRcggWGFiHYZPkbhU6AwnNK0Dxw+jd5ZQ+AddB8rcWJrTR+UE5tJui5Z7dldHDn5
dWSfx3UxQi6wQzr/h9LEQsz4QZDgS1P7K4sXCnvmFYK/2htXouVfTMH2O6jE0UoO
h0XlC0UB34eyGdZevQU0AOrSkwY1q+WBK73PgahBPKlEq1rzVZrXlMnIdsdQbySu
XsXAff/9ZjAH3u3uZogPTkJQ0KpC8GFt98o0ZkNBzeqpvP8iY9a025bzvh70Rz7D
c3vvN7gHPxM8h8Dqq+Cn
=hqqX
-----END PGP SIGNATURE-----

--=-/YAZ08IH2N3ao4Gf0OlT--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

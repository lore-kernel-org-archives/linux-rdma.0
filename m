From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] iser-target: Fix possible use-after-free in connection
 establishment error
Date: Wed, 10 Jan 2018 16:54:46 -0500
Message-ID: <1515621286.3403.172.camel@redhat.com>
References: <20171126133104.22710-1-sagi@grimberg.me>
         <3676820c-544e-8ced-859a-ade8e6a0ef53@grimberg.me>
         <BN3PR07MB25782C93E50A7A0C55A110B4F83B0@BN3PR07MB2578.namprd07.prod.outlook.com>
         <eda02d71-cf33-2333-223a-0d6eeabb8185@grimberg.me>
         <e11259b7-5add-bf87-73d4-49483c90bf73@mellanox.com>
         <20180109171718.GC4518@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-tg98VyR7LdXDpawgcXMj"
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20180109171718.GC4518@ziepe.ca>
Sender: target-devel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>, Max Gurtovoy <maxg@mellanox.com>
Cc: Sagi Grimberg <sagi@grimberg.me>, "Amrani, Ram" <Ram.Amrani@cavium.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
List-Id: linux-rdma@vger.kernel.org


--=-tg98VyR7LdXDpawgcXMj
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2018-01-09 at 10:17 -0700, Jason Gunthorpe wrote:
> On Tue, Jan 09, 2018 at 07:04:16PM +0200, Max Gurtovoy wrote:
> > hi Guys,
> > did we forget taking this fix to mainline/stable or we found another
> > solution ?
>=20
> I thought it was going to NAB's tree.. My mistake, I put it back into
> patchworks and it will get into for-next

In fairness, the email thread said exactly that.  But, it never got
picked up by NAB.  And being that it's in our tree and calling an rdma-
core function, it can easily enough go through our tree, so I applied it
to for-rc.

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-tg98VyR7LdXDpawgcXMj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlpWi6YACgkQuCajMw5X
L93cSQ//Y3y6fa/asbr2MY0A5JiFEkPuUXuYYnFUUqKRA4UiYsUbyD/7l/Nwtk4H
l/SLi/oRGQUKtw3o1VTTNfCrXLOb1jQb8Z0iGnqiSayk26xpqoXGws1i+O1z4JYY
NksB/ODA1tsANcOxySsBmTLTtmV4lqJFEnGjxVE95CsbXo6zOr9kUEDuBTk4br4e
A5UtYvwEswWJgRAzlC266+6IKs4fi54zR3NpYpaHS7XX2cb5PiSx/sjY9wuLXD03
EgHy9yFwQNjWW/otGxh+EDzxaPA/OgojUQKEbyhEr1YKBDEqCJaqGJE9F8AbltjH
wp+B9ZmmzNwd+FA+HzzHXter8syfET37bPUeD2peXdf8qTq7ZGNIPoMpwkJGUUsl
PaYUh0i6R7j0kwJIxM3Q6p3Z++GvgxqVe2MgS9NkVSwJOMRokKM+95lAaJiwydPA
MYsiYcaZU5OUMSLkcwnuBiBJf+omobCUtDtfCXf37lC+qkYU/beR4+e1VIUIwQy+
ZChEwcuFtv229XeqpefE6xzEM6NBDce94EQ3CNwGiyMYci5oY3nOaXBhy9ruVLCr
13qtm7XMghT8ZzxTQDQ+TQs6x9WkX6RAJtVRGYrZbe1fpxKkiLq2eZqqoaStp1lZ
8PrbZA8w6AqqzQDMZAwI7lG5YtRuD1+9rUnyOR/aRT2HhUq3W2Q=
=Rdwh
-----END PGP SIGNATURE-----

--=-tg98VyR7LdXDpawgcXMj--

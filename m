From: David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [PATCH] PCI: Add no-D3 quirk for Mellanox ConnectX-[45]
Date: Wed, 9 Jan 2019 16:30:45 +1100
Message-ID: <20190109053045.GE6682@umbus.fritz.box>
References: <20181206041951.22413-1-david@gibson.dropbear.id.au>
 <20181206064509.GM15544@mtr-leonro.mtl.com>
 <20190104034401.GA2801@umbus.fritz.box>
 <20190105175116.GB14238@ziepe.ca>
 <c1296ee9120a6a04dc75d0fdb2a641c722cb65d6.camel@kernel.crashing.org>
 <20190108040129.GE5336@ziepe.ca>
 <012d24d58a542ed44c8af9f517f1bd61ab912037.camel@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="wTWi5aaYRw9ix9vO"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <012d24d58a542ed44c8af9f517f1bd61ab912037.camel@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, davem@davemloft.net, saeedm@mellanox.com, ogerlitz@mellanox.com, tariqt@mellanox.com, bhelgaas@google.com, linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org, alex.williamson@redhat.com, linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org, sbest@redhat.com, paulus@samba.org, Alexey Kardashevskiy <aik@au1.ibm.com>
List-Id: linux-rdma@vger.kernel.org


--wTWi5aaYRw9ix9vO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 09, 2019 at 04:09:02PM +1100, Benjamin Herrenschmidt wrote:
> On Mon, 2019-01-07 at 21:01 -0700, Jason Gunthorpe wrote:
> >=20
> > > In a very cryptic way that requires manual parsing using non-public
> > > docs sadly but yes. From the look of it, it's a completion timeout.
> > >=20
> > > Looks to me like we don't get a response to a config space access
> > > during the change of D state. I don't know if it's the write of the D3
> > > state itself or the read back though (it's probably detected on the
> > > read back or a subsequent read, but that doesn't tell me which specif=
ic
> > > one failed).
> >=20
> > If it is just one card doing it (again, check you have latest
> > firmware) I wonder if it is a sketchy PCI-E electrical link that is
> > causing a long re-training cycle? Can you tell if the PCI-E link is
> > permanently gone or does it eventually return?
>=20
> No, it's 100% reproducable on systems with that specific card model,
> not card instance, and maybe different systems/cards as well, I'll let
> David & Alexey comment further on that.

Well, it's 100% reproducable on a particular model of system
(garrison) with a particular model of card.  I've had some suggestions
that it fails with some other systems card card models, but nothing
confirmed - the one other system model I've been able to try, which
also had a newer card model didn't reproduce the problem.

> > Does the card work in Gen 3 when it starts? Is there any indication of
> > PCI-E link errors?
>=20
> Nope.
>=20
> > Everytime or sometimes?
> >=20
> > POWER 8 firmware is good? If the link does eventually come back, is
> > the POWER8's D3 resumption timeout long enough?
> >=20
> > If this doesn't lead to an obvious conclusion you'll probably need to
> > connect to IBM's Mellanox support team to get more information from
> > the card side.
>=20
> We are IBM :-) So far, it seems to be that the card is doing something
> not quite right, but we don't know what. We might need to engage
> Mellanox themselves.

Possibly.  On the other hand, I've had it reported that this is a
software regression at least with downstream red hat kernels.  I
haven't yet been able to eliminate factors that might be confusing
that, or try to find a working version upstream.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--wTWi5aaYRw9ix9vO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAlw1hwMACgkQbDjKyiDZ
s5IDKw//XIQZh971MfpcSENald4kWBTfSHHlOD5+4Kl8H6zUpmr8Yo2nc97DnGdk
oRzpnprxrbEZgCg43CSA/W4JYwczn1SIq4nEdXUW+byu1imVvI4Abwh2IpzUERy8
L+anK4lQllJNrBZ66UPcAY7KUUec08STrBlwH61mFZp67ywsw2oQLkPdpwcz9HDj
dPU1EoaMa+Cg+A7MRlzxofZ3bhZtOeIQJCMYdvBVVjJ/uU7iYZtemmUUjNJdag5F
/cgQ2k8KmXg+ENWii2kx1Hj9jb2wmoRXfYmPh5k7bw9EApH9YGnaIQMKkHnqWJay
oLJIxStqc/mn6Pu2QNrUbvKQuAy2mljMajR2IY9j2G9YUsMeRaeHyKUBG6ojSJ3h
BbB0mj8Zb34Aj0R4HWM9yRdCv4muKywF/ddwSZKFRK9PXEJ0mMNqtq/HZ7Ztwvcm
lRVrCc4UMFglYKxK6w5gz3gY3SPY3fKOeVBJXjtmL5nEP51QuMYicaK8APSnj8EN
tsFy7BT7GR8uQtR6s6CMdId7YgZWiiM0nP7ji2Rr5xwtt7MDCQkgSgtv5f1g+5Oy
6ikWNG1TRk88qozePzpooKUnoMaNTqcA7RZbOgrJOQ0m64lOyQ3jMQJPv8c4RJOD
k+/QeDln5GduSMkIJEFyv8BIImVTm4u57d45DfCKZWRraeXBkXg=
=jw4v
-----END PGP SIGNATURE-----

--wTWi5aaYRw9ix9vO--

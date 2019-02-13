From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: Re: [RFC 03/19] net/ice: Add support for ice peer devices and
 drivers
Date: Wed, 13 Feb 2019 07:40:15 -0800
Message-ID: <8612b6c404633f930de5ceb090647ae0910644b2.camel@intel.com>
References: <20190212214402.23284-1-shiraz.saleem@intel.com>
         <20190212214402.23284-4-shiraz.saleem@intel.com>
         <20190213034104.GA8751@ziepe.ca>
Reply-To: jeffrey.t.kirsher@intel.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-gywrvZWrBrW6eIhRnBov"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190213034104.GA8751@ziepe.ca>
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>, Shiraz Saleem <shiraz.saleem@intel.com>
Cc: dledford@redhat.com, davem@davemloft.net, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, mustafa.ismail@intel.com, Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
List-Id: linux-rdma@vger.kernel.org


--=-gywrvZWrBrW6eIhRnBov
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2019-02-12 at 20:41 -0700, Jason Gunthorpe wrote:
> On Tue, Feb 12, 2019 at 03:43:46PM -0600, Shiraz Saleem wrote:
> > From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
> >=20
> > The E800 series of Ethernet devices has multiple hardware blocks,
> > of
> > which RDMA is one. The RDMA block isn't interfaced directly to PCI
> > or any other bus. The RDMA driver (irdma) thus depends on the ice
> > driver to provide access to the RDMA hardware block.
> >=20
> > The ice driver first creates a pseudo bus and then creates and
> > attaches
> > a new device to the pseudo bus using device_register(). This new
> > device
> > is referred to as a "peer device" and the associated driver (i.e.
> > irdma)
> > is a "peer driver" to ice. Once the peer driver loads, it can call
> > ice driver functions exposed to it via struct ice_ops. Similarly,
> > ice can
> > call peer driver functions exposed to it via struct ice_peer_ops.
>=20
> This seems quite big for this straightforward description..
> =20
> I was going to say I like the idea of using the driver model to
> connect the drivers, but if it takes so much code ...

Part of the reason why the ice driver patches are much larger than the
i40e patch is because currently there is zero RDMA support for our ice
driver.  The ice developers wanted to wait for the new RDMA interface
implementation before adding the RDMA support to the ice driver.

>=20
> > +     /* check for reset in progress before proceeding */
> > +     pf =3D pci_get_drvdata(peer_dev->pdev);
> > +     for (i =3D 0; i < ICE_MAX_RESET_WAIT; i++) {
> > +             if (!ice_is_reset_in_progress(pf->state))
> > +                     break;
> > +             msleep(100);
> > +     }
>=20
> Use proper locking, not loops with sleeps.


--=-gywrvZWrBrW6eIhRnBov
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiTyZWz+nnTrOJ1LZ5W/vlVpL7c4FAlxkOl8ACgkQ5W/vlVpL
7c6w5Q//ZO+C7Ns4jwHTBW+xJQdT3BHMtGZZTNPZh6u94wWS+1+5kBlgkVvzsWCP
xMayPkqX2vjcFdsTKC5mQec2cve64wTyGIqpkFMP6LtrET16qer4zv8d6lFK0Dbu
i41GkMHvahSngIqQJgTzZ8mxbZlJQllilqv3tm2DoYODsnaLgqXJn3zH+osLGr/M
5thgItsvl4zg1YVhejWBnMiT51DfErhu2Yu5PgDCLugii+n0UhGdQacutpi40N0M
xiZrCzFE9cWX6t+DJlVAa1+K6Tr2CMWwDLMAnZBPgfnhHFmCEjpZXmuHkHuWmjit
BR37fB0IxicMMd9jyyk+r5GpXldfW7XhPKs4PNPTthQ0jyGz1tZ/y29L1Y4ilRh6
BlJmeSFYTKPOtZaklU/N3NgstLyl3JE+cJZlC4NFSID6+X6CHyWwTpxHKyAtvFa/
4LMzcqJy7JuPNhveKXrkGgeZCKuz2hKvODRNXmzzeQCvt+ssXFgbF3/AaQxFL+FT
UsSo5i8dgzPU3j2Pih5ytN+Q3iqczBKyo4rCr0a3ktVuY5BKf9yKTJQveqq/5TXi
tydqQXkT/3paSDeJXCe8Cz/45N4NdF7NaCqiVeesBauziKr4oZotVBEX1iHRj5X+
+j7ntjHAn/dlkSVwPjC0+/5XP/EEGamDCc+GmzWcBusfuU9hnY8=
=AlWg
-----END PGP SIGNATURE-----

--=-gywrvZWrBrW6eIhRnBov--

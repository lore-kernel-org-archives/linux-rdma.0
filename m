From: David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [PATCH] PCI: Add no-D3 quirk for Mellanox ConnectX-[45]
Date: Wed, 12 Dec 2018 11:22:34 +1100
Message-ID: <20181212002234.GC2719@umbus.fritz.box>
References: <20181206041951.22413-1-david@gibson.dropbear.id.au>
 <20181211140143.GD99796@google.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="qtZFehHsKgwS5rPz"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181211140143.GD99796@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: davem@davemloft.net, saeedm@mellanox.com, ogerlitz@mellanox.com, tariqt@mellanox.com, leon@kernel.org, linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org, alex.williamson@redhat.com, linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org, sbest@redhat.com, paulus@samba.org, benh@kernel.crashing.org
List-Id: linux-rdma@vger.kernel.org


--qtZFehHsKgwS5rPz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 11, 2018 at 08:01:43AM -0600, Bjorn Helgaas wrote:
> Hi David,
>=20
> I see you're still working on this, but if you do end up going this
> direction eventually, would you mind splitting this into two patches:
> 1) rename the quirk to make it more generic (but not changing any
> behavior), and 2) add the ConnectX devices to the quirk.  That way
> the ConnectX change is smaller and more easily
> understood/reverted/etc.

Sure.  Would it make sense to send (1) as an independent cleanup,
while I'm still working out exactly what (if anything) we need for
(2)?

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--qtZFehHsKgwS5rPz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAlwQVMoACgkQbDjKyiDZ
s5L+cw/+KM764cq7FAR/lTsfb87oC6lgM+U63FC2WIKnaxcJodoYFkg4eYhjc7B9
OfAliLU6kk4A/cowrU/TZRHtvW3LcaZU4qTlQBKuPoFq6ApOmCv8ftr4jbdcXD/U
2R/RS4QgRInfPg1g3de5DuveWiVI8gIzfcOKPh53yAkcdbsi937ZMFICwSYfln9X
hmONBWM0BfrVvx8AFxhyc2lczWNzXHpFTTBqcV+lZnGUlB51K/+WQOIx6BNVssQs
UfiJqHQixhdJA9pzkMEykEiS5A9hdOLJ4XyYO6jt1S9ZdB4dp1ckPrej8zgXt2l1
HRG11NfawSntxutiu4CLM4Ra0aykkRw6ws2n2joV0Tb7+jZMGTeCzJSACdIbZM48
RLKIS+b5PjAziH/QzZ4rSau6vRsaB7NY80fMPuvmM4/P3o5NrqmJm6trUX6LWOFZ
FnUjMvXlFmO/5E7pmclcUxqvG6n5alBbMg+vJRo5ljZbp2MeFAVR/BWnXA5iTARQ
JmjIIbUMQhie1ykQuWiZ0rqpCB/rEXDWfWDSyPvdYdXyNK2R/ZLi58G/PU/DQi3D
By4mlrRHhZCcRoxXK7RznAj/bR9nKI/NsGm+8eaqaTf5foVQ7jW+PQpz+Jiy3nrg
O/MBa8cWSsV9VH9xCbGAFHTjC6WtICnGk9xscxqcWlwnMWIr3sk=
=7iRq
-----END PGP SIGNATURE-----

--qtZFehHsKgwS5rPz--

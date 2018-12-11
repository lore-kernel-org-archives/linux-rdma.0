From: David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [PATCH] PCI: Add no-D3 quirk for Mellanox ConnectX-[45]
Date: Tue, 11 Dec 2018 13:31:51 +1100
Message-ID: <20181211023151.GH4261@umbus.fritz.box>
References: <20181206041951.22413-1-david@gibson.dropbear.id.au>
 <20181206064509.GM15544@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="mVonZaCXjkyW6e25"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181206064509.GM15544@mtr-leonro.mtl.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: davem@davemloft.net, saeedm@mellanox.com, ogerlitz@mellanox.com, tariqt@mellanox.com, bhelgaas@google.com, linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org, alex.williamson@redhat.com, linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org, sbest@redhat.com, paulus@samba.org, benh@kernel.crashing.org
List-Id: linux-rdma@vger.kernel.org


--mVonZaCXjkyW6e25
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 06, 2018 at 08:45:09AM +0200, Leon Romanovsky wrote:
> On Thu, Dec 06, 2018 at 03:19:51PM +1100, David Gibson wrote:
> > Mellanox ConnectX-5 IB cards (MT27800) seem to cause a call trace when
> > unbound from their regular driver and attached to vfio-pci in order to =
pass
> > them through to a guest.
> >
> > This goes away if the disable_idle_d3 option is used, so it looks like a
> > problem with the hardware handling D3 state.  To fix that more permanen=
tly,
> > use a device quirk to disable D3 state for these devices.
> >
> > We do this by renaming the existing quirk_no_ata_d3() more generally and
> > attaching it to the ConnectX-[45] devices (0x15b3:0x1013).
> >
> > Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> > ---
> >  drivers/pci/quirks.c | 17 +++++++++++------
> >  1 file changed, 11 insertions(+), 6 deletions(-)
> >
>=20
> Hi David,
>=20
> Thank for your patch,
>=20
> I would like to reproduce the calltrace before moving forward,
> but have trouble to reproduce the original issue.
>=20
> I'm working with vfio-pci and CX-4/5 cards on daily basis,
> tried manually enter into D3 state now, and it worked for me.
>=20
> Can you please post your full calltrace, and "lspci -s PCI_ID -vv"
> output?

Sorry, I may have jumped the gun on this.  Using disable_idle_d3 seems
to do _something_ for these cards, but there are some other things
going wrong which are confusing the issue.  This is on POWER, which
might affect the situation.  I'll get back to you once I have some
more information.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--mVonZaCXjkyW6e25
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAlwPIZQACgkQbDjKyiDZ
s5IBRRAA2MqVAFyjHwo1FjE4IFA/HwOxHbo9qSkEOrFE10oGylCi9LVKhKeZ0RV4
c6IrjliPYwy9Uy/B8fp+mCH1UeE73vSp+ieEqZ7TgMf1HqsO6vyYUcCO+JpcX1Ko
9fiyQMCuEfvF3Z6A+XXzZ6Jp5MuGTF496Xv5n8j9672DAo6I1iFf75ayhORZcUVh
ZrLGtGa7k88Mhizbk2ZV9TFUPWcYV1ekfWY/Wvdq59E2b7fNhyPQiNop2cbEIt4K
BxD6MxGig0C+puFptKwdDNPMQB/nRNc843FtQ4JKUsKcSt3N0Wk7SHdINn6Kxjub
fINnCEUAjTNOxyOU3lWgBc2BrI6xRpyYodMDlIzWQwM4/Kss40Qzg2zUWcpEkxIi
KPpehbo/gMcj1SGZNJYV7NE1tuF+Z+kdfcN+ZM/D8sFTwWtMjKyiziDHXBgsc8WD
wpH0wLZkqnPnluipNRaq2foShsiDTX5OLWR4tjmmcrIcF7BppMKz7/HIlaUXAqZ7
6ViQMDhThPBU0CetZx9esXVW/PI+XPclAgFj6fRrKnVtDYQIkUO8NolTeYQjCWZA
4wsPm9PX1a4/XxEVYn15PU2wADgdsRgkRRXtddl8/nmWsrY/0U2igsTWLuKF9ugW
0V8raqIYkzdiHenfBMlsIod3G/xTBx+rMKbktPvefCIMlKNTcGE=
=i2A1
-----END PGP SIGNATURE-----

--mVonZaCXjkyW6e25--

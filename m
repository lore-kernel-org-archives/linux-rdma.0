From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: Re: [net-next] i40iw/i40e: Remove link dependency on i40e
Date: Tue, 22 May 2018 14:04:06 -0700
Message-ID: <079ceee3bc8cd0ea50dd7ddc12b27512ca5ac49e.camel@intel.com>
References: <20180522203831.20624-1-jeffrey.t.kirsher@intel.com>
         <20180522205612.GD7502@mellanox.com>
Reply-To: jeffrey.t.kirsher@intel.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-jRGuwlHOEVsD4yYvgjUu"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180522205612.GD7502@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@mellanox.com>
Cc: davem@davemloft.net, dledford@redhat.com, Sindhu Devale <sindhu.devale@intel.com>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com, jogreene@redhat.com, Shiraz Saleem <shiraz.saleem@intel.com>
List-Id: linux-rdma@vger.kernel.org


--=-jRGuwlHOEVsD4yYvgjUu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2018-05-22 at 14:56 -0600, Jason Gunthorpe wrote:
> On Tue, May 22, 2018 at 01:38:31PM -0700, Jeff Kirsher wrote:
> > From: Sindhu Devale <sindhu.devale@intel.com>
> >=20
> > Currently i40iw is dependent on i40e symbols
> > i40e_register_client and i40e_unregister_client due to
> > which i40iw cannot be loaded without i40e being loaded.
> >=20
> > This patch allows RDMA driver to build and load without
> > linking to LAN driver and without LAN driver being loaded
> > first. Once the LAN driver is loaded, the RDMA driver
> > is notified through the netdevice notifiers to register
> > as client to the LAN driver. Add function pointers to IDC
> > register/unregister in the private VSI structure. This
> > allows a RDMA driver to build without linking to i40e.
>=20
> Why would you want to do this? The rdma driver is non-functional
> without the ethernet driver, so why on earth would we want to defeat
> the module dependency mechanism?

This change is driven by the OSV's like Red Hat, where customer's were
updating the i40e driver, which in turn broke i40iw.
--=-jRGuwlHOEVsD4yYvgjUu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiTyZWz+nnTrOJ1LZ5W/vlVpL7c4FAlsEhcYACgkQ5W/vlVpL
7c5qbw/8CEg/96PSBZ4LN+29P7b+vXgc+2qhqA8XrM2KKkvbcNDQDVI7mClCbkJl
zuPybpzP01cUXbijP+Vco38oIXgZV0DoyqIVjVpP1arHEF41OYzoFPnGi4wRHdBv
xm2gT4p6bVn8zoSftlMSVgk6ShhqQxPZWwrq+Q3hgqhG07DWW88M9MJQBOTiYmmT
B5xKsxFo7/f2JiR2GQ/RU1w76bA64IMKFsibenPLvQUnz2O2fqGmhi+1FXqCCQr0
+SezMXw3du2ImsLk/L+gDZSR5FtsgFdpmeVd1b8RLFmPj3iVp8rDi1e7IQpzlFLG
hR0VgHm/H3Iyhm2qn0T86ZzpJZBiIDmksgkauZOW1lHeowfqrZwg8n+S5CwpOX0g
pgF19YPdiJykIlDtgWCZp4ktSW8EtkT0vaUidJNdWtlV4gpY5DvD7EMQPFhZG9qx
tGhptxJOVsTeKx88AskHUgS4n0U4qWi7Wxy64f1igT4hEsAmKkux3nMmeEL5Yyz7
G04MPzxo4XYKw4Mn9fc+6fT9sW6NL8YNLa4I/ksvdYkphKoKH1lXeNqRbxPLu5h3
dyexRJsj0ZlranD6AKZ6YsSFfVh2VaxKMRoalpgz1MXWVi3cBG2RQULxFgc5aPml
PW3Aefno7OR6Hheu1/XXZlT4vzxg13GLUZSemWIlehTVco+0R8g=
=Kkq+
-----END PGP SIGNATURE-----

--=-jRGuwlHOEVsD4yYvgjUu--

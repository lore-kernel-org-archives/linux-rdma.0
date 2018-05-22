From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: Re: [net-next] i40iw/i40e: Remove link dependency on i40e
Date: Tue, 22 May 2018 14:50:32 -0700
Message-ID: <2fcc22b088fd04dafbdc1582d03c4bca21eefade.camel@intel.com>
References: <20180522203831.20624-1-jeffrey.t.kirsher@intel.com>
         <20180522205612.GD7502@mellanox.com>
         <079ceee3bc8cd0ea50dd7ddc12b27512ca5ac49e.camel@intel.com>
         <20180522213334.GE7502@mellanox.com>
Reply-To: jeffrey.t.kirsher@intel.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-bCuDNMC3k1fJYiXihWey"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180522213334.GE7502@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@mellanox.com>
Cc: davem@davemloft.net, dledford@redhat.com, Sindhu Devale <sindhu.devale@intel.com>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com, jogreene@redhat.com, Shiraz Saleem <shiraz.saleem@intel.com>
List-Id: linux-rdma@vger.kernel.org


--=-bCuDNMC3k1fJYiXihWey
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2018-05-22 at 15:33 -0600, Jason Gunthorpe wrote:
> On Tue, May 22, 2018 at 02:04:06PM -0700, Jeff Kirsher wrote:
> > On Tue, 2018-05-22 at 14:56 -0600, Jason Gunthorpe wrote:
> > > On Tue, May 22, 2018 at 01:38:31PM -0700, Jeff Kirsher wrote:
> > > > From: Sindhu Devale <sindhu.devale@intel.com>
> > > >=20
> > > > Currently i40iw is dependent on i40e symbols
> > > > i40e_register_client and i40e_unregister_client due to
> > > > which i40iw cannot be loaded without i40e being loaded.
> > > >=20
> > > > This patch allows RDMA driver to build and load without
> > > > linking to LAN driver and without LAN driver being loaded
> > > > first. Once the LAN driver is loaded, the RDMA driver
> > > > is notified through the netdevice notifiers to register
> > > > as client to the LAN driver. Add function pointers to IDC
> > > > register/unregister in the private VSI structure. This
> > > > allows a RDMA driver to build without linking to i40e.
> > >=20
> > > Why would you want to do this? The rdma driver is non-functional
> > > without the ethernet driver, so why on earth would we want to
> > > defeat
> > > the module dependency mechanism?
> >=20
> > This change is driven by the OSV's like Red Hat, where customer's
> > were
> > updating the i40e driver, which in turn broke i40iw.
>=20
> So that isn't a reason to put something into the main line kernel,
> and
> I'm deeply skeptical this change is even sane.
>=20
> It has been a while since I've looked at RH's kernel, but AFAIK,
> breakage should only happen if the ABIs around
> i40e_unregister_client/etc change..
>=20
> So if the i40e module updates breaks the ABI, then stuffing that same
> broken ABI through a function pointer is *totally* wrong.
>=20
> Looks like a NAK for the RDMA side.

The ABI rarely changes, if at all.  The issue OSV's are seeing is that
upgrading i40e, requires that i40iw be recompiled even though there
were no updates/changes to the ABI.
--=-bCuDNMC3k1fJYiXihWey
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiTyZWz+nnTrOJ1LZ5W/vlVpL7c4FAlsEkKkACgkQ5W/vlVpL
7c4E8Q/8Cj31zfgaMUsB+OYY4BRLgnD1CgtaxZihw6iIozUuTd5I+bEhe89B4bLB
620piSSLfcXLhTMwav9YMV2YDZVmwZ7WS2OKK0/tHH2kaV6f3yfLfugcEjGtRTTf
G8hWYo87ozPeDXWusQbm1VVN+66B55tThKvaCuq5IzVGGPhghkOOhVq4vkGQvVac
Cn1Sk8IQpeygXTtd+dyyUCup7KVgHaynz1hAxQSulmw7PUpAj+HkW9nN11sUB4PQ
mEBckWZoYUmLq/fhvLFc9GEgpJEgT8/r7wmswG+ihgJUr1yUrNDG1HzGW6EUCrKs
joJ7zqSsup+RrpqRQas96HdG8M50fajRD4afMuNxYmtOR1o2I3anEthrGeojb1CR
95wqXT4RYPdf3kO+B8e9zLkWqpFaVu2iG9dder2N1H5u7YHITo27kyLuBLJHVxk1
hs/JysROaGY5rB3MwCSQ5sNKCmfeGgKvn0vcYSAga6eudTSu/Tzn/bYdPgsC1dI+
4XItPvDv3YwDVs7E0xaeEj6M9zX8T6gZw3YZICxPmVqGyfoa7q/h82vNZkv8ilvJ
fHiEWAKzPJSOhNZKRRbXTjrtuF5uLEJbuTDTnSakYdKHJdcXnOkmWFB+uFvcWbH1
bvQNxxqE1nfe2xCpMhv0GTCNA3POMmcXHK+FyrDdv622MUSk8nU=
=8EI2
-----END PGP SIGNATURE-----

--=-bCuDNMC3k1fJYiXihWey--

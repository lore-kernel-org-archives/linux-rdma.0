From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: Re: [RFC v1 01/19] net/i40e: Add peer register/unregister to struct
 i40e_netdev_priv
Date: Tue, 12 Mar 2019 19:11:08 -0700
Message-ID: <c53c117d58b8bbe325b3b32d6681b84cf422b773.camel@intel.com>
References: <20190215171107.6464-1-shiraz.saleem@intel.com>
         <20190215171107.6464-2-shiraz.saleem@intel.com>
         <20190215172233.GC30706@ziepe.ca>
         <9DD61F30A802C4429A01CA4200E302A7A5A471B8@fmsmsx124.amr.corp.intel.com>
         <20190221193523.GO17500@ziepe.ca>
         <2B0E3F215D1AB84DA946C8BEE234CCC97B11DF23@ORSMSX101.amr.corp.intel.com>
         <20190222202340.GY17500@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-ZMWkNEW/UCgG4w48kCmR"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190222202340.GY17500@ziepe.ca>
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>, "Ertman, David M" <david.m.ertman@intel.com>
Cc: "Saleem, Shiraz" <shiraz.saleem@intel.com>, "dledford@redhat.com" <dledford@redhat.com>, "davem@davemloft.net" <davem@davemloft.net>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "Ismail, Mustafa" <mustafa.ismail@intel.com>, "Patil, Kiran" <kiran.patil@intel.com>
List-Id: linux-rdma@vger.kernel.org


--=-ZMWkNEW/UCgG4w48kCmR
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2019-02-22 at 13:23 -0700, Jason Gunthorpe wrote:
> On Fri, Feb 22, 2019 at 08:13:58PM +0000, Ertman, David M wrote:
> > > From: Jason Gunthorpe [mailto:jgg@ziepe.ca]
> > > Sent: Thursday, February 21, 2019 11:35 AM
> > > To: Saleem, Shiraz <shiraz.saleem@intel.com>
> > > Cc: dledford@redhat.com; davem@davemloft.net; linux-
> > > rdma@vger.kernel.org; netdev@vger.kernel.org; Ismail, Mustafa
> > > <mustafa.ismail@intel.com>; Kirsher, Jeffrey T <
> > > jeffrey.t.kirsher@intel.com>;
> > > Patil, Kiran <kiran.patil@intel.com>; Ertman, David M
> > > <david.m.ertman@intel.com>
> > > Subject: Re: [RFC v1 01/19] net/i40e: Add peer register/unregister to
> > > struct
> > > i40e_netdev_priv
> > >=20
> > > On Thu, Feb 21, 2019 at 02:19:33AM +0000, Saleem, Shiraz wrote:
> > > > > Subject: Re: [RFC v1 01/19] net/i40e: Add peer
> > > > > register/unregister to
> > > > > struct i40e_netdev_priv
> > > > >=20
> > > > > On Fri, Feb 15, 2019 at 11:10:48AM -0600, Shiraz Saleem wrote:
> > > > > > Expose the register/unregister function pointers in the struct
> > > > > > i40e_netdev_priv which is accesible via the netdev_priv()
> > > > > > interface
> > > > > > in the RDMA driver. On a netdev notification in the RDMA
> > > > > > driver,
> > > > > > the appropriate LAN driver register/unregister functions are
> > > > > > invoked from the struct i40e_netdev_priv structure,
> > > > >=20
> > > > > Why? In later patches we get an entire device_add() based thing.
> > > > > Why
> > > > > do you need two things?
> > > > >=20
> > > > > The RDMA driver should bind to the thing that device_add created
> > > > > and
> > > > > from there reliably get the netdev. It should not listen to
> > > > > netdev notifiers for
> > > attachment.
> > > > In the new IDC mechanism between ice<->irdma, the LAN driver setups
> > > > up
> > > > the device for us and attaches it to a software bus via
> > > > device_add() based
> > > mechanism.
> > > > However, RDMA driver binds to the device only when the LAN
> > > > 'register'
> > > > function is called in irdma.
> > >=20
> > > That doesn't make sense. The PCI driver should always create the
> > > required
> > > struct device attachment point when attachment is becomes possible.
> > >=20
> > > > There is no ordering guarantee in which irdma, i40e and ice modules
> > > > load.
> > > > The netdev notifier is for the case where the irdma loads before
> > > > i40e
> > > > or ice.
> > >=20
> > > You are supposed to use the driver core to handle this ordering.
> > >=20
> > > The pci driver creates the attachment points in the correct order,
> > > when they
> > > are ready for use, and the driver core will automatically attach
> > > registered
> > > device drivers to the attachement points, no matter the module load
> > > loader.
> > >=20
> > > You will have a netdev and a rdma attachment point, sounds like the
> > > RDMA one
> > > is created once the netdev is happy.
> > >=20
> > > Maybe what you are missing is a struct device_driver?
> > >=20
> > > Jason
> >=20
> > I am assuming that the term PCI driver is being used to mean the PCI
> > subsystem in the kernel.  If this assumption is wrong, please disregard
> > the next
> > paragraph, but the following points will still apply.
>=20
> No, I mean the driver that has the struct pci_driver for the PCI
> function. Maybe that is the LAN driver for this case.

Sorry for the delayed response, I was dealing with a death in the family.

I want to make sure we are on the same page, so please correct me if I am
wrong.  The Intel RDMA driver is not a stand-alone PCI function driver
because there is no separate PCI function for RDMA, so the RDMA driver does
not call pci_register_driver(), that is done with the LAN driver.  The
Intel RDMA driver still needs to access to HW resources which is accessible
only through the LAN PF driver (e.g. i40e/ice) and does not have its own
netdev, so it uses the netdev exposed by the LAN PF driver.  The access to
the netdev is needed so that it can listen to RT netlink messages and other
reasons.

We refer to "software bus" because out hardware doe not expose the hardware
bus, so our APIs to bus_register/unregister are actually using a software
bus, which is exposed and managed by the LAN driver.

> > bus, and has no ability to perform the described functions.  The
> > irdma driver cannot register with the software bus unless it
> > registers with the LAN driver that controls the bus.  The LAN
> > driver's register function will call "driver_register(&drv->driver)"
> > for the registering irdma driver.
>=20
> That isn't how to use the driver core.

Software bus exposing and managing in other kernel drivers, like Many
Integrated Core (MIC) software driver and virtio subsystem.

> > Since the irdma driver is a consolidated driver (supports both ice and
> > i40e LAN
> > drivers), we cannot guarantee that a given LAN driver will load before
> > the irdma
> > driver.  Even if we use module dependencies to make irdma depend on
> > (ice ||
> > i40e), we have to consider the situation where a machine will have both
> > an ice
> > supported LAN device and an i40e supported LAN device in it.  In this
> > case, the
> > load order could be (e.g.) i40e -> irdma -> ice.  The irdma driver can
> > check all
> > present netdevs when it loads to find the one that has the correct
> > function
> > pointers in it, but it will have no way of knowing that a new software
> > bus was
> > created by the second LAN driver to load.
>=20
> This is why you use the driver core to manage driver binding.
>=20
> > This is why irdma is listening for netdev notifiers, so that whenever a
> > new netdev
> > appears from a LAN driver loading after irdma, the irdma driver can
> > evaluate
> > whether the new netdev was created by a LAN driver supported by irdma
> > driver.
>=20
> Register a device driver to the driver core and wait for the driver
> core to call that driver's probe method.

Yes, the LAN PF driver is the software component exposing and managing the
bus, so it is the one who will call probe/remove of the peer driver (RDMA
driver).  Although netdev notifiers based approach is needed if the RDMA
driver was loaded first before the LAN PF driver (i40e or ice) is loaded.

>=20
> Jason


--=-ZMWkNEW/UCgG4w48kCmR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEiTyZWz+nnTrOJ1LZ5W/vlVpL7c4FAlyIZrwACgkQ5W/vlVpL
7c60Yg/+KOhpOOWSWQsvXvdNOSTICEX3v+8J60mJcH9hTsT1BxzR0pYx2IIlAHun
WBog96/nY0eyGW14NsyQUIsQb5aoCQheTIHPQjYQQm9Mw6PwdfNT6YOmA6xejHR+
Q7O57emtVCM/ckJDmd/GoBnszDZowaiNCYrWKvPPIr4WoE7PLvRNsivRTzbl7PZd
AIHIItM8Uzp8h2Eljrt74xmslD+xAV9qWvZ43QrEVDzJ2ZCF7kZLMk0NicX2UaPt
ndntdwUR74aexZWhnoSIbV3YJlxyWyN8+kvTDdM8ZEZztqd5dHhj7lgGX1R89ZRY
1h7DW23M3/Mm9jcMACgta60iZ9Z/ncRITKdNyTxC4DAOgtsfKM+Hheg98LGVdAg3
mkdw8znMvTDfneXnjhWVVsZrZ0FwqpnYZnJvOydqQciytqvL7cp26IeoLCCyi9uQ
FkJoZYjmZ+PCwXMN4tuusvSWATM5DbL4foptotM9H+GUclumKiUQksJ4b5mTcsVP
YOhCoqKubT0tkvz3TjP4WZYdBi6T41tHtcSRY3qBDI5/EZU7Hs2sq02PdlGIV/0C
zWa2fHFb5ryj7uaHmJyTz3rycIgyXkU8wjtrYPzqaA4xcOXUtGeRLRGlOrNCuQPM
ClYXACszSIVU7eedXb3JtUpOeuTJGoGjaSuWHdrgBU+M5jwfAMA=
=iOI6
-----END PGP SIGNATURE-----

--=-ZMWkNEW/UCgG4w48kCmR--

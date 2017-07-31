From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: RDMA miniconf: Persistent device naming
Date: Mon, 31 Jul 2017 19:54:53 +0300
Message-ID: <20170731165453.GD13672@mtr-leonro.local>
References: <20170731113633.GU13672@mtr-leonro.local>
 <1501513246.2466.1.camel@wdc.com>
 <20170731164705.GB28204@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="avNtfD0ffNO6L/9g"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170731164705.GB28204-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--avNtfD0ffNO6L/9g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 31, 2017 at 10:47:05AM -0600, Jason Gunthorpe wrote:
> On Mon, Jul 31, 2017 at 03:00:47PM +0000, Bart Van Assche wrote:
> > On Mon, 2017-07-31 at 14:36 +0300, Leon Romanovsky wrote:
> > > I would like to propose the discussion about ability to add
> > > persistent device naming to RDMA subsystem.
> > >
> > > Right now, the devices receive their names by simple addition of new free
> > > index to the name (mlx5_0, mlx5_1 ...). Such naming scheme depends on the
> > > PCI probing and in case of device reset can rename device.
> > >
> > > Such situation doesn't help to provide constant udev rules, reliable
> > > ibverbs hotplug and advanced "set command" of RDMAtool which at some
> > > point of time will require reinit of ib_device.
> > >
> > > In this discussion, I want to present netdev implementation of such
> > > feature, talk about implications on libibverbs and suggest possible
> > > device name convention.
> >
> > Hello Leon,
> >
> > Does this mean that there is user space software that depends on these names?
> > Shouldn't all user space software be independent of the device names assigned
> > by the kernel? For e.g. SCSI disks this was solved a long time ago by making
> > /dev/disk/by-id/${name derived from persistent ID} soft links available. An
> > example:
> >
> > $ ls -l /dev/disk/by-id/scsi-35001b44c698c2947
> > lrwxrwxrwx 1 root root 9 Jul 31 07:53 /dev/disk/by-id/scsi-35001b44c698c2947 -> ../../sda
>
> The problem with RDMA is it relies heavily on sysfs, and the sysfs
> path name is what is being proposed to be changable.
>
> The best fix is going to be to consistently use the new stable index
> to access all information, which means effectively obsoleting sysfs.
>

I want to take RDMA one step more,
https://www.freedesktop.org/wiki/Software/systemd/PredictableNetworkInterfaceNames/

I called the topic name "persistent", but the right name is "predictable".

Thanks

> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--avNtfD0ffNO6L/9g
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAll/YN0ACgkQ5GN7iDZy
WKdHLw/+KWuhFoQdQqpJQAFCS9Z5I3jJViJoPmXhNBTRSGyFyf88vw+2hWJesSUb
IWrs8pBFh2XP00I2MguTBqdNU5eez46h4vhAWkc80MZR4RK9/fieHWa9BWqQkyQa
OHjsRpEX/XmL6/i2mmtDSwPFQusLWBgDEPwDjbIs06Z5NCLSITzrqIJ5Bee42RDD
U/nDXRz5SVqTof3G7Ir4rZs3tQJQBryB4FRw5YM5bVj4n6aD4tOGhphUz8t4PStF
eW68HKZsckmmxLLyhPKocYrA9WBA20EWDi9V7Ze5/qpqgPfg9jl3aGsBDh7SmBOl
iHN/nPxrj7w9DCdtazc74y8dWMZU6i+Dop/MvzQ0akEJOm0eneIqks4ELuPcNP9o
GcHyn/pxKXNwiPdKLA1QqC0+Os+L2Dt7LqXVbkk3NGCgOO9IEmnC0eOsWTZkaHWX
bKnsZO39C7zFEEQYaUBbIC6Kczk9dj7jT0ZvxI3/pFxZgyIxhAfQVr9b+fLjt5ct
PWFJlmiJSFwSIYG21isi9x/zp+SJAk1DFbgN9s9gjRuI70OwM9YHHyhvmgQxjrRW
0bRbnXC6jTFHDirVJqY5gxhS6wiudQpPsi+3ajOUlj3j9VkKcRZ81MXtTjgCGa0H
MN+2ygn6b6TZukjNzVNgs45lXrXa80PDUOw2iUuVC95TWDlKfEU=
=il22
-----END PGP SIGNATURE-----

--avNtfD0ffNO6L/9g--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

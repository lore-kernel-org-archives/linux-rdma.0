From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: RDMA miniconf: Persistent device naming
Date: Mon, 31 Jul 2017 19:00:29 +0300
Message-ID: <20170731160029.GZ13672@mtr-leonro.local>
References: <20170731113633.GU13672@mtr-leonro.local>
 <1501513246.2466.1.camel@wdc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="mlvFMpb4NrD3AMcD"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1501513246.2466.1.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--mlvFMpb4NrD3AMcD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 31, 2017 at 03:00:47PM +0000, Bart Van Assche wrote:
> On Mon, 2017-07-31 at 14:36 +0300, Leon Romanovsky wrote:
> > I would like to propose the discussion about ability to add
> > persistent device naming to RDMA subsystem.
> >
> > Right now, the devices receive their names by simple addition of new free
> > index to the name (mlx5_0, mlx5_1 ...). Such naming scheme depends on the
> > PCI probing and in case of device reset can rename device.
> >
> > Such situation doesn't help to provide constant udev rules, reliable
> > ibverbs hotplug and advanced "set command" of RDMAtool which at some
> > point of time will require reinit of ib_device.
> >
> > In this discussion, I want to present netdev implementation of such
> > feature, talk about implications on libibverbs and suggest possible
> > device name convention.
>
> Hello Leon,
>
> Does this mean that there is user space software that depends on these names?

Yes, during initialization phase libibverbs reads sysfs entry [1] and
the ibverbs hotplug relies on this information for every
ibv_get_device_list call.

In the RDMA netlink patches, I added notion of device index and the
RDMAtool operates on it, instead of the device name.

> Shouldn't all user space software be independent of the device names assigned
> by the kernel? For e.g. SCSI disks this was solved a long time ago by making
> /dev/disk/by-id/${name derived from persistent ID} soft links available. An
> example:

Yes, it should, and I don't have enough knowledge to say why RDMA is "special"
in this specific case.

>
> $ ls -l /dev/disk/by-id/scsi-35001b44c698c2947
> lrwxrwxrwx 1 root root 9 Jul 31 07:53 /dev/disk/by-id/scsi-35001b44c698c2947 -> ../../sda
>

[1] https://github.com/linux-rdma/rdma-core/blob/master/libibverbs/init.c#L138

> Bart.

--mlvFMpb4NrD3AMcD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAll/VBwACgkQ5GN7iDZy
WKd3vg//V+kEervYVg90Iad5Cr5bXTARaOCHR3UdmAAhgqkiPeamGtQ3UJ5RBXQh
9plBG45Jd1HJUBEo4dxztt8ZglR1zCu1fDZNEUPEe/CXit9GpSADZkmmaYxURT1A
eQewWiR8UyPM6lKPnQq8HH3qVKiDmAgBff/xgb2WeBUVrJYptVo++THVHZKqtDXI
iReAO5FvUi7sgVhEsE64ouAiN6RnD9sfqcRq/t5YPKl2XgfcOo9VJhswMyuzGzWN
BCXW06we5IKa6mcyzKOJMueDYMSp8uBYPvzB76Ic9MUb2J8K/gRUZrazcGq/2CcI
begDBnNf/vl0fISfyMTiMVRmZ/OLSM/riLxAuqbTNc2+Ozf/M2e/xHL1lq1SK2Tn
ft1FgzMDHdDEbU+thsgOEfcJLw7ypVkG6Lj7TySdX14ajvdHcJo9d/Zq9oZkY5zA
7D+UimMxDDA/4MZcVFUIYpHCCxAlGw6+rjj1+KInHJWm4/6SAU9OsYDPr8mMe0bs
2p+SNlPdfInO8Bv08XQH88jlAvcT+ECDcwElMnuwl64j0ojdBuktJKxht7/+EYUY
6BHG0W2h4VrRi7j0idVHuOYjWMw5PfIFaTW3/Jd1fNHD9AJbLN02RY3RztQCMFUD
8+yBU2VZt7bzwjYkVc/edVPOM9k08FYvIXHdVIb+zQIfmjehiPw=
=JCir
-----END PGP SIGNATURE-----

--mlvFMpb4NrD3AMcD--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

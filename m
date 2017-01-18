From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] [RFC] IB/hfi1: Fix port ordering issue in a multiport
 device
Date: Wed, 18 Jan 2017 16:01:00 -0500
Message-ID: <1484773260.2406.58.camel@redhat.com>
References: <148409267200.13402.16060755922068447437.stgit@tstruk-mobl1.ra.intel.com>
         <20170111181042.GC22783@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-fFVYHJP4g9dqu3U5jx+y"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170111181042.GC22783-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-fFVYHJP4g9dqu3U5jx+y
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2017-01-11 at 11:10 -0700, Jason Gunthorpe wrote:
> On Tue, Jan 10, 2017 at 03:57:52PM -0800, Tadeusz Struk wrote:
> >=20
> > We can fix this by enforcing the correct port order at module load
> > time.
> > To reorder the ports to match the numbering labels on the back of
> > the
> > device we need to delay registering devices with the ib_core until
> > we
>=20
> Sorry, no way - this is horrifying.

Agree.

> If you need stable names for RDMA devices then you need to add proper
> infrastructure to the kernel to rename RDMA devices from user space
> via udev. ala netdev.

This has its own problems in this particular case, namely having to
ship files that know which parts are effected and then modify the
names. =C2=A0Or requiring that users create all of the rename rules when
they really shouldn't be bothered with anything. =C2=A0Although, the module
option to turn this fix off for existing clusters that have been wired
up wrong is just as bad as creating persistent naming rules...

> or change the ib_core to allow your driver to specify the full name
> and manage things in your driver.
>=20
> No way on this insane block probe approach.

Isn't there already code in the code device layer to handle this kind
of thing? =C2=A0I seem to recall backporting it from upstream to a rhel
kernel many years ago. =C2=A0Lemme go look...

OK, sure, as far as the reordering stuff is concerned, all you need to
do is to make use of the EPROBE_DEFER return option to your PCI probe
routine. =C2=A0That way, when you get the probe for the out of order port,
the first time you pass EPROBE_DEFER as your return, then you get the
second port, your register it with the IB layer which will make it
appear as the first port (optionally, and as I haven't tried this I
don't know if it will work or if it's necessary, you can save the
pointer to the first port's device struct off, and when you get the
second one, you can tell the driver layer to splice the second port in
front of the first port in the device child list on the parent device,
but I think this is optional and really has no lasting effect on the
outcome), then later the first port gets retried and ends up being the
second port.

So, scrap all of this hand done junk and use the provided
infrastructure as it was intended to be used. =C2=A0I *really* don't want t=
o
do a kernel module option for this either. =C2=A0Do you know for a fact tha=
t
this is wired up wrong in the field and the people can't just swap
hfi1_0<->hfi1_1 in their config files and have it all work without
being recabled?

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-fFVYHJP4g9dqu3U5jx+y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYf9eMAAoJELgmozMOVy/dy+EQAJF8flPmpj6wF+aOIEU5gEf+
jbrfD45+3o55fEKSnW8yNbHJKhDBbLQOP/7A5TzeTTY64kjjV8q6jb/vaDJrIOml
8ClobWyYONE46YUTaepIJW7mFb0iuwZRwZbHd3L6fTgPxwll7zFf3nBBmr32kgxx
jkLhEH87OCG4XtH9EVB8b9Y4TJXvVYbNN+9rd40s5WtbOpK8TiWshMcOGu5SI1J0
eChzYDbPWJzp9fa3Mbz+3WGtr47nsxuhNwViP7V84bbdABeqZJMDXdiazO7hWurO
uV7N7aSX5+HRIh6ORbi7fbgpI7xUklrAUCTnpc2ATsS5xJWfYA9v+0LrhF3QoCqN
Cp8lAHAn7caW4lXITgXUC6AaG+kLtzUowRN98MGiQaOz/pQHoO+xR9d3oZnUw8u3
zUsnFt0uTb7VJiMxj20ygiLYu/tSzEWijGUg/qdfmPJFuf6cPLBmTEGbe0O+A+IN
ZEvaqqPhw8YNJK+0fWkPpwEdhQKg5UasbcBuk0IQQRcPvp4Hbw0/sBG6LTryfLpF
VIMg9l/AipyLPOASTmMaRFG67/W9rwa/6aLeaciCGqT29QNkpHgax6FyZDU2JBcj
4ucfi0boVP0Mzck7XCUstqXEuO6scQD10H5e2spzQXKIJ340bZ2EBzEIY55B2li7
naPRHjJyRTul5VNr0ZKt
=dwjE
-----END PGP SIGNATURE-----

--=-fFVYHJP4g9dqu3U5jx+y--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC 0/3] Support standard SRIOV configuration for IB VFs
Date: Tue, 26 May 2015 16:32:58 -0400
Message-ID: <1432672378.28905.178.camel@redhat.com>
References: <1432225447-6536-1-git-send-email-ogerlitz@mellanox.com>
	 <1432226406.28905.22.camel@redhat.com>
	 <CAJ3xEMjzpqnQuA=0HQaN8noVq04d9BkVvEWGY7Lq5ZntVTKm4w@mail.gmail.com>
	 <1432242708.28905.73.camel@redhat.com>
	 <CAJ3xEMh3BaxJzCu9mV9m6ZMwgrDaO2UvTyS1i=DEPq9nuLX3oA@mail.gmail.com>
	 <20150525211433.GA9186@obsidianresearch.com>
	 <CAJ3xEMhG2W6WzxC4Kc2CFmdMwTRUF5ppBgcDZ6SMA=kgJowUpQ@mail.gmail.com>
	 <20150525223235.GA9858@obsidianresearch.com>
	 <1432659226.28905.151.camel@redhat.com>
	 <20150526181336.GD11800@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-EsPf1re67aRvp9thK72w"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150526181336.GD11800-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-EsPf1re67aRvp9thK72w
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2015-05-26 at 12:13 -0600, Jason Gunthorpe wrote:
> On Tue, May 26, 2015 at 12:53:46PM -0400, Doug Ledford wrote:
> >=20
> Yes, it is ugly that we are using a IPoIB netdev to configure the RDMA
> device.
>=20
> If you want to suggest that we use the RDMA Netlink interface to do
> this,

I had thought of exactly that...

>  that would make sense to me too. But I thought the whole point
> was to provide something somewhat software compatible with the
> ethernet world..

Not so much ethernet world as netdevice world.  The iproute2 program is
used to configure any and all netdevices, ethernet or otherwise.  Right
now, we can abuse it to do the same here, but it uses the netdevice ndo_
ops, not rtnetlink to accomplish what it does, so we are limited in how
we do thing if we want to maintain tool usage.

> > The fact that the 20 byte LLADDR of IPoIB is problematic is born out by
> > multiple facts:  we only use 8 bytes in DHCP requests and responses,
> > only use 8 bytes in matching IPoIB netdevices against HWADDR entries in
> > the sysconfig/ifcfg-* files, only use 8 bytes for matching the udev
> > rules to rename IPoIB devices, etc.
>=20
> The LLADDR for IPoIB *is* 20 bytes.
>=20
> Truncating it down is *broken userspace*:
>  - DHCP: Not sending the full 20 bytes in the client request means the
>    server cannot unicast the reply. This causes all sorts of problems
>    and is discouraged in the RFCs these days.

Reference?  The RFCs I've read (4390 -> 4361 -> 3315) list a number of
options (three at the moment), but the LLADDR options all call for using
a LLADDR from a device that is a permanent part of the machine (not
common with add in cards), so the option most commonly used in IB is
option 2, DUID Assigned by Vendor, aka GUID.  According to that,
truncating to 8 bytes is precisely what you are supposed to do.  And, at
least in all current Red Hat products, that's exactly how dhcp client
creates the client-id.

>  - ifcfg/udev/networkmanager: So what happens when I do
>     ip link add link ib0 name ib0.1 type ipoib
>    And get two IPoIB interfaces with the same GUID? I doubt any sane
>    user would want to apply the same config to those two interfaces.

No, they probably don't want to apply the same rules to both interfaces.
I'm not entirely sure I agree with the argument though.  I fully
expected this to fail without a pkey argument on the ip command line.
The net stack doesn't allow users to do the same thing with Ethernet
devices, so I'm not sure we shouldn't be disallowing this as opposed to
creating duplicate devices that are identical in all ways except name.

> As I've already said, this is not possible. The person who designed
> this netlink extension screwed it up and 'mac_len' is fixed to 32
> bytes.

You're right.  We don't have a way of passing in the length we wish to
set versus the size of the message.

> Even if they didn't, the netlink common code should validate the input
> length for the drivers and confirm it is dev->addr_len, as is done for
> all other cases.
>=20
> Unbreaking it is a UAPI change, not impossible, but do we really care
> enough about 8 or 20 to push for that?

In truth, at least right now, it's all moot.  Since we can't set the
subnet prefix, the qpn, or the flags, anything above 8 bytes is
immutable regardless of how many bytes we pass in.  So even if we say we
aren't going to change the UAPI and for everything to 20, the real world
result is that 8 works exactly the same and has no functional
difference.

> What does get return? If we accept 8 or 20, then get must return 20.

The get has to return 20 regardless.  It's the only accepted means of
getting all 20 bytes of the LLADDR.  There was a hack long ago (that
might even still work, but I haven't checked) where you could call the
ioctl to get the lladdr, which was supposed to be limited to 6 bytes,
but if the caller of the ioctl passed in an oversized buffer, the kernel
would write the full 20 bytes as long as the buffer could hold it.  But
that hack may have long since been closed up.

> Should get response to a set of 8 return 8 or 20?=20

20.

> The kernel UAPI is much cleaner if there is one case: 20 byte LLADDR.

As I mentioned above, due to the constraints of what we can set and the
fact that we don't actually *tell* the kernel what size we've filled out
in the 32byte struct, it's really all moot at this point.

> The kernel internal API is much cleaner if drivers don't have the
> option to use two sizes for their LLADDR.
>=20
> Just checking that the 20 byte address is sane (right GID prefix, 0
> QPN, right flags) should be enough for the app to denote it knows what
> it is doing.

Yes, checking the subnet prefix and flags would work.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-EsPf1re67aRvp9thK72w
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVZNh6AAoJELgmozMOVy/d4y4P/ijN3jv4u2TWpw04XZ+sU1TT
d8wE5WkuOojMMcI3AZASofoApWcunao86qgYnGXUNU295hYZ6DKPpOYy473IGoSS
Oqjk2/zaAStlJzkCw7Al+BdgBaKg+7wHjoufKuHzy8zw+kl2muUjNXQUA6iQ6P0m
LAmtYx097m4u0MYq1C2TLbHCXkgCPwuUEYoc54pOI+rT9sx214yBMSPpc/Hdzty0
dooiIzO8Y/cvag2liSHTbs62egkY3xY7j+nGwxz4ESCWpLtJYnovNAEAvfLI+BOJ
HuQTGRZ8/4ycGYzj6YVkTFjcq8s4P4atYgeDDET+zLcroSpvpLHCNao6bqaYafPp
d2MV+RKUngx+hey6BHV1mXL07SX4/FmJmFYJlUUHqjtTyfY6X+WQMuspbHBNF4E6
a9dYmWOY56W36+ivpj39dekrDDzcpsdvcKFd0okTMmJCQ+Zxqp7FtsQe+7Vzef9b
h5q2HLiOh/Pn6yqZ8Q7guiGa37I2UYFS23n6VxH0Q2YWLiAiqmmHQV8ZR07YnwSk
WpPg3QhuI5OkbhIwn2gSl7fE7S8FaiYHCfc4NS/HdUQthirk8j7UOm+HhCMOXOML
hlIS6/VMNMiivW1ufBtUgVyJCovG1VY2J2MbmpR8tpQ2yH0kDxFldiWDCwYpWdfR
LTcYNENgESt8ZtVZZDCT
=mCGM
-----END PGP SIGNATURE-----

--=-EsPf1re67aRvp9thK72w--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

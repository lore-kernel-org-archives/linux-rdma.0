From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: device attr cleanup (was: Handle mlx4 max_sge_rd correctly)
Date: Thu, 10 Dec 2015 23:56:50 -0500
Message-ID: <566A5792.9080102@redhat.com>
References: <CAJ3xEMj2EOxX1CiA93MPOsM-FdU9ijcWCYm9tObbkLqqja0PoA@mail.gmail.com>
 <566753E3.9060301@redhat.com>
 <CAJ3xEMhaEnv9He7N5q8fFsRzy_j27wdE6KWSFF39UzA680udwA@mail.gmail.com>
 <20151208225940.GB27609@obsidianresearch.com>
 <CAJ3xEMiEYgsxiL6zR-Dia3Rxwriye1WHcadTmUjU7zV=ide1LA@mail.gmail.com>
 <20151209184448.GC4522@infradead.org> <5669BA8E.30200@redhat.com>
 <20151210232956.GA26009@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="E3A0ImMLcR4hDPT6CaM59kD0wxkqnoGuT"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151210232956.GA26009-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--E3A0ImMLcR4hDPT6CaM59kD0wxkqnoGuT
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/10/2015 06:29 PM, Christoph Hellwig wrote:
> On Thu, Dec 10, 2015 at 12:46:54PM -0500, Doug Ledford wrote:
>> Organization.  Let's be fair, the totally flat namespace you are
>> preferring is the equivalent of a teenager that is completely incapabl=
e
>> of picking thier dirty laundry up off the floor.  It is sloppy,
>> disorganized, often full of old cruft that you don't know if you can g=
et
>> rid of or not, often so disorganized you might have three similarly
>> named items that you can't figure out which one should be used in whic=
h
>> circumstances, etc.
>=20
> The most cruft I've found in major subsystems in years has been
> in the RDMA code, so I'm not sure where that argument comes from.

=46rom reading struct netdevice and trying to work out what all of the
items do.  The portion I didn't like before is gone now, so it doesn't
do any good for me to reference it (it was related to the address lists
for the device).

> We're pretty good at garbage collecting cruft in Linux, and the
> typical counter examples are arbitrarily split structures where it's
> easy to hide things.
>=20
>>>  And looking at the existing members of
>>> struct ib_device what determines if it goes straight into the device
>>> or the attribute?
>>
>> Organization.  What goes where depends on what makes sense according t=
o
>> the organization you are doing.
>=20
> So what makes num_comp_vectors or phys_port_cnt fit into ib_device,
> while max_qp or max_cq are in struct ib_device_attr?

Historically, the latter two were part of the device query and
represented device maximums (and almost all of ib_device_attr is this
sort of thing).  The first depends on the initialization results for the
PCI dev and is not a device limit that can be queried.  The second is a
high level device property that allows you to know how many devices need
queried.  If you were to ever have per-port struct for device
capabilities, the port count would necessarily need to be outside of
that area.

So, from a logical perspective, ib_device_attr contents can be thought
of as those things you get when you query the card, and only things you
get by querying the card (although not all cards have all items in this
struct), while the others in ib_device are part of other initialization
steps.

> I really like clean data structures, but keeping structures that
> have 1:1 relationships and sit in the same module separate never
> has been a good idea.

Looking at struct netdevice, it has the sort of organization I would
call reasonable.  Things like struct tx_stats is a struct, even though
it's embedded in the parent struct and not a pointer and there is
exactly and only one copy, so it could be flat.

>>>  There is a reason why we don't do this weird
>>> attr split in other Linux subsystems, and making IB follow this patte=
rn
>>> makes everyone feel right at home instead of wondering about the
>>> weird attribute.
>>
>> Being organized is not "weird".  Let's not wax poetic about sloppy,
>> disorganized structures.  Let's be honest about what they are so we
>> don't feel like we need to take a shower every time we talk about them=

>> to purge us of the sins of our lies.
>=20
> I call that utter BS.  Being organized is exactly not having multiple
> structures that have the same scope or life time, it's actually what
> I call disorganzied.

While I didn't make a huge search for anything, at least the tx stats in
struct netdevice are a direct contradiction to this statement.  They are
something I would call well organized.  And speaking of that, in struct
netdevice, all of the various ops elements are handled as structs,
including the base netdevice ops, whereas struct ib_device puts the base
ops flat in the struct.  So if we wanted to be more like struct
netdevice, we would move the base ops out of struct ib_device.

>  There is a lot to be said about grouping the
> fields in the structure, and that's how sensible subsystems handle it:
>=20
> stuct foo_bar {
> 	/* read/write in the hot path, keep together and tightly packed: */
> 	...
>=20
> 	/* read-only in the hot path */
> 	...
>=20
> 	/* random members: */
> 	...
>=20
> 	/* properties here, immutable after setup: */
> 	...
> };
>=20
> but that's completely inverse to what we're having with ib_device
> currently.

Well, the current struct ib_device is not well laid out.  That I'll
grant.  But it's not because ib_device_attr is a struct.  It simply
isn't well laid out.  Among other things, for the example you give
above, struct ib_device is the wrong layer to be trying to lay things
out like this.  An ib_device can be multi-port, and each port can be a
different RDMA device type.  I would argue then that the hotpath items
need to be done at the port level, not the parent device level.  We
started this with the port_immutable array.  I would argue that
continuing with that work and moving further down that path is the right
way to go.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--E3A0ImMLcR4hDPT6CaM59kD0wxkqnoGuT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWaleSAAoJELgmozMOVy/dyzQP/REEW/y5MPJGgklUthVlF2f0
/QETo5A4xUeCKiaI+lqmbHDtKtGV7z+YqClkldL2thPmWdUtrbADEydHUWCmj9V+
GvxoUSloL638fP3ppiC5UH6e3zTMrVRZSgfO3lQzZjUtGC/vmVniUwlv4VbofJ1n
zI2iBVcAbezUFJAgMcQ1dkndyuyDjlBz7BP7YMaU14B4jHJD7ut/PtXhy9DXScfN
2TqjWFJE4+5ngesHJCwLtZ3rGlAhdL8b/XAzbvcLzwH+qcingvzj9bEBh6g6lo2n
ofdAVgHH5l5HN9pX2EbvGMZVHw1A7PZzo3P5SOWZgsVRzS1VVX3DTMqDF3f18s8T
GAUPKyN8qGXBN0VE1s2z72fq41fi87ZBhCY3+TRBb1JmXs3Iuanj7KBmiNsyZqH0
qR5OVnSW7bF0Sk7jEzvlC8tjMGx7oAxahhqfh1uBRIWkwV8PDqd+wOMdHBaHyIoE
tv+tOjlbYh/caLjwSQNHESqt9lxECb5j2CqpvrfdDq4uy8hJIBto7eBxND5V+d6S
Pd6oBsm6BkfgzfXXaC89vvKoT5oQ5MUIMUC2f45aqxE0VncBQl4On9HFEbo6sMIr
Ili58ysiRPAJTy8iUY9vz9dFkNbMohmc9LrYJ7/pNqPiLNbv47zfFizog10AHRzW
xDzKFJfA4ZehiFeZJVth
=9N8l
-----END PGP SIGNATURE-----

--E3A0ImMLcR4hDPT6CaM59kD0wxkqnoGuT--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

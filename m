From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: device attr cleanup (was: Handle mlx4 max_sge_rd correctly)
Date: Thu, 10 Dec 2015 12:46:54 -0500
Message-ID: <5669BA8E.30200@redhat.com>
References: <CAJ3xEMj2EOxX1CiA93MPOsM-FdU9ijcWCYm9tObbkLqqja0PoA@mail.gmail.com>
 <566753E3.9060301@redhat.com>
 <CAJ3xEMhaEnv9He7N5q8fFsRzy_j27wdE6KWSFF39UzA680udwA@mail.gmail.com>
 <20151208225940.GB27609@obsidianresearch.com>
 <CAJ3xEMiEYgsxiL6zR-Dia3Rxwriye1WHcadTmUjU7zV=ide1LA@mail.gmail.com>
 <20151209184448.GC4522@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="mBhr0sG90h7jVetWxpPP8xbkON8eqbi5v"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151209184448.GC4522-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--mBhr0sG90h7jVetWxpPP8xbkON8eqbi5v
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/09/2015 01:44 PM, Christoph Hellwig wrote:
> On Wed, Dec 09, 2015 at 01:13:29AM +0200, Or Gerlitz wrote:
>>
>> Christoph patch is here indeed, it does two things
>>
>> 1. remove all the ULP device attr alloc, device query, attr free hassl=
e
>> 2. adds tons of new fields to struct ib_device
>>
>> I think it just goes too much and needlessly adds tons of these new
>> fields directly to struct ib_device where we can have them all well
>> scoped into ib_device_attr member or pointer from struct ib_device
>=20
> What's the benefit of that?

Organization.  Let's be fair, the totally flat namespace you are
preferring is the equivalent of a teenager that is completely incapable
of picking thier dirty laundry up off the floor.  It is sloppy,
disorganized, often full of old cruft that you don't know if you can get
rid of or not, often so disorganized you might have three similarly
named items that you can't figure out which one should be used in which
circumstances, etc.

The downside of a more organized approach is often longer/more complex
variable names.  It also means that if you want to micro-optimize for
which variables are in the hot path and you need one and only one of the
variables from the attr struct, then you either have to make a copy
somewhere else that is in a frequently hot cache line (along with making
sure the copy and the original stay in sync) or you have to take it out
of the attr struct, or other bad things.

>  And looking at the existing members of
> struct ib_device what determines if it goes straight into the device
> or the attribute?

Organization.  What goes where depends on what makes sense according to
the organization you are doing.

>  There is a reason why we don't do this weird
> attr split in other Linux subsystems, and making IB follow this pattern=

> makes everyone feel right at home instead of wondering about the
> weird attribute.

Being organized is not "weird".  Let's not wax poetic about sloppy,
disorganized structures.  Let's be honest about what they are so we
don't feel like we need to take a shower every time we talk about them
to purge us of the sins of our lies.

That said, though, the kernel frequently has hot spots that require we
have the freedom to rearrange structures to suit memory placement
constraints.  It's really for that reason more than anything else that
we tolerate these horribly disorganized structures with a totally flat
namespace.  And to be fair, any super high speed core code like the IB
code is more susceptible than most to issues of cache line delays and
hot path slow downs.

For that reason, and *only* that reason, I'm inclined to take your
patch.  Otherwise, I wouldn't touch it.  The rest of the kernel may
think a disorganized, flat namespace is fruit punch kool-aid...I happen
to prefer things differently.  But I'm willing to acquiesce to the needs
of a high performance kernel subsystem as appropriate regardless of my
personal taste on the issue.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--mBhr0sG90h7jVetWxpPP8xbkON8eqbi5v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWabqOAAoJELgmozMOVy/d070QALQwWgq+xQ+aYP02K8YDzgR8
DFRwVsWNVCwhDX17p4s6PO3BqkCFF1g4NAXa0uKT1tmdRzrJV/jNhIowoeC7y0+s
lghS60oSrclf2wKRkqnbrarCiCCbxKrTi/f3oqY6bjdSYbiUdYr1AgVcLOPg8wsc
vA6fhK4PibcDQUAmCylS/YLaUo13jdW+VC8U+mbSNesqQ1jill5lYpIsb3Q+bsKz
SzjwC0SuEgKERiqHUcTJ1dFTRlJ5rUwWQTJIIDlST/hnE5WSP6wHy9NtnvKasaTm
eJ+utsUG7O3ndRj29BVrXmB/oRZkfuhCrUHQnTlL+oNGlf6ICpRe1UHU8G7A7K+X
vY+2xYwglnQrHvieH8bJ61nxngs4W5rycm8NsFXPHHvxalO3YiS75mhc1fGR8v0K
zI9dXYEXzJ223HCT4go29T7kiM84UsVfDJY6g86ia5V0VDpbzFZTs6PP4ITrmHlZ
f+zr2MrQIG4CSW7gzKyAVccHOlC5brZgQelFhGzQAg9oYgVXB8FoQxuHwX7hqVtb
gMwirGr6BB0ZFi2YXRmwAJen0jFqhm3pNOjtaaDmb1w+dJWvipMKZc0IGU/2kulw
dIBwLC225PgbigQg63RarSJVBiIYMuNVxwaTBON9BnvcMvbwqRzCY/PRgQRj+QvS
ty13h9ZNNEl2ugEVpVK3
=8umi
-----END PGP SIGNATURE-----

--mBhr0sG90h7jVetWxpPP8xbkON8eqbi5v--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

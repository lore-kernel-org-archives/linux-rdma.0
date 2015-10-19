From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-cm] IB/core: Fix use after free of ifa
Date: Mon, 19 Oct 2015 11:27:18 -0400
Message-ID: <56250BD6.2050503@redhat.com>
References: <1444910463-5688-1-git-send-email-matanb@mellanox.com>
 <1444910463-5688-2-git-send-email-matanb@mellanox.com>
 <561FE452.3050304@redhat.com>
 <CAAKD3BBEfKTHPKyoTzMW3YESKJmGkcUkui=hjhsbyFRY+xDDEw@mail.gmail.com>
 <5624E0AE.8050702@redhat.com> <5624FC13.1090200@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Lg7Mh0BLHSLa2DavJRcWO3kkBdI9iOIuL"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5624FC13.1090200-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Lg7Mh0BLHSLa2DavJRcWO3kkBdI9iOIuL
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 10/19/2015 10:20 AM, Matan Barak wrote:
> On 10/19/2015 3:23 PM, Doug Ledford wrote:

>> This is a major cause of the slowness.  Unless you have a specific nee=
d
>> of them, per-entry rwlocks are *NOT* a good idea.  I was going to brin=
g
>> this up separately, so I'll just mention it here.  Per entry locks hel=
p
>> reduce contention when you have lots of multiple accessors.  Using
>> rwlocks help reduce contention when you have a read-mostly entry that =
is
>> only occasionally changed.  But every lock and every unlock (just like=

>> every atomic access) still requires a locked memory cycle.  That means=

>> every lock acquire and every lock release requires a synchronization
>> event between all CPUs.  Using per-entry locks means that every entry
>> triggers two of those synchronization events.  On modern Intel CPUs,
>> they cost about 32 cycles per event.  If you are going to do something=
,
>> and it can't be done without a lock, then grab a single lock and do it=

>> as fast as you can.  Only in rare cases would you want per-entry locks=
=2E
>>
>=20
> I agree that every rwlock costs us locked access. However, lets look at=

> the common scenario here.

No, let's not.  Especially if your "common scenario" causes you to
ignore pathological bad behavior.  Optimizing for the common case is not
an excuse to enable pathological behavior.

> I think that in production stable systems, the
> IPs our rdma-cm stack uses (and thus GIDs) should be pretty stable.

Probably true.

> Thus, most accesses should be read calls.

Probably true.

> That's why IMHO read-write
> access makes sense here.

Probably true.

> Regarding single-lock vs per entry lock, it really depends on common an=

> entry could be updated while another entry is being used by an
> application.

No, it depends on more than that.  In addition to the frequency of
updates versus lookups, there is also the issue of lookup cost and
update cost.  Using per entry locks makes both the lookup cost and the
update cost of anything other than the first gid in the table grow
exponentially.  A good way to demonstrate this would be to create 100
vlans on a RoCE device, then run the cmtime test between two hosts using
the 100th vlan IP at each end.  Using per-entry locks, the performance
of this test relative to using the first IP on the device will be
pathologically bad.

> In a (future) dynamic system, you might want to create
> containers dynamically, which will add a net device and change the
> hardware GID table while other application (maybe in another container)=

> uses other GIDs, but this might be rare scenario.

This is a non-issue.  Creating a container and an application inside
that container to use an RDMA interface is already a heavy weight
operation (minimum fork/exec/program startup).  Table lookups can be
needed thousands of times per second under certain conditions and must
be fast.  Per-entry locks are only fast for the first item in the list.
 After that, they progressively get slower and slower than usage with a
single lock.

> Ok, refactoring this code for a single lock shouldn't be problematic.
> Regarding performance, I think the results here are vastly impacted by
> the rate we'll add/remove IPs or upper net-devices in the background.

Not really.  You will never add/remove IPs fast enough to justify
per-entry locks, especially when you consider that ib_cache_gid_add
calls find_gid twice, once going over the entire table if the gid isn't
found, before ever calling add_gid.  The ocrdma table isn't bad because
it's only 16 entries.  But the mlx4 table is going to be 128 I suspect,
so you can do the test I mentioned above and use 100 vlans.  In that
scenario, the 101st gid will require that you take and release 128 locks
to scan for the entry in the list, it will come back empty, then you
will take and release 101 locks until you find an empty entry, and then
you will take a write lock as you write the gid.  That's 230 total
locks, for 460 total locked memory operations at 32 cycles each, so a
total of 14,720 cycles spent doing nothing but locking the memory bus.
And each of those operations slows down all of the CPUs in the system.

Where I've seen this sort of behavior totally wreck a production system
is when the GID you need to look up is on port 2.  Even if it is the
firstmost GID on port 2, if you have to search all of port 1's table
first, then by the time you get to port 2's table, you've already lost.

So, here's some suggestions:

1)  Use a single lock on the table per port.
2)  Change find_gid so that it will take an additional element, int
*empty_idx, and as it is scanning the gid table, when it runs across an
empty entry, if empty_idx !=3D NULL, *empty_idx =3D idx;.  This prevents
needing to scan the array twice.
3)  Consider optimizing the code by requiring that any time a GID is
added, it must take the first empty spot, and any time one is deleted,
any valid entries after it must be moved up to fill the empty spot, then
optimize find_gid to quit once it finds an empty slot because it knows
the rest of the table is empty.  Given that mlx4 keeps a huge 128 table
array, this can be very helpful.
4)  Does the table port struct have to use a mutex?  Could it be changed
to a rwlock instead?  If so, you could changing write_gid so that it
assumes it is called with the read lock on the port already held and it
merely updates itself to a write lock when it is ready to write the
entry to the array and update the card.  It would then downgrade back to
a read lock on return and the calling function would hold the single
read lock from the time it is ready to call find_gid until write_gid has
returned.
5)  I noticed that ib_cache_gid_find_by_port calls find_gid without even
taking the read lock, that needs fixed.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--Lg7Mh0BLHSLa2DavJRcWO3kkBdI9iOIuL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWJQvWAAoJELgmozMOVy/dLcQQAMLlXZmN1B9EVNqP8eyQXzWH
PUk24TGdleiWy7aSdTzmadCONFyOGGxYkt4ElQtTXe/HDALIsvbNrbbwj0f68n0/
wtUGJdCM+gsRJTmExwVQbJwISkXN/ALG5MzrOslZfwCriPEwkDgfpW4/LRTauxz1
xdcaz3MMFpmicNF4ztUyYa6MUdIXnVgk+hvzSBTZRpE+FmrPt62Vn9KOfiLq2Ss7
HzY5W2piZTLTSaI2t3H1mm2BjsaNBJO25w1RyWP3llEIX6NRM4iEncKmLXLsYH62
Ix/sGwhWsBKo7OnxP8Que4Ca91cDt6uOQbqIP4XBD+ZVJtRngPOh8QYjPrIuIalX
5sn70Ss3m44Mu2guPut8uC6p2Yn/uSRXY4kp6sQXy4nXBw5X0A9P+oDvvgfAABSb
XWCYbrDkYrnCY2lupJ3WWppZo0ykPnUKhmr3BGmfgfTpzRkeHHALhjIg3OwqV1wB
pSGrBlNP9ohmMSlKTn2pXxv6xxA+2e5IwAHRMAMGmdKT5UMFiBiLOZufIsKEmFUa
fpkllESsHADlCQTOs6qEYU+BVfy4sfCQtV4kDfbPqzafj5IWekkJguWrvryPXtdU
vHD7tyOIH38hy3U61Jo2TaMQV4G+yIFthxq6tz4srkiaHFgsXtmCJjAd++lo7kNa
FuD2Tr9i8aqJly5CwjtX
=q+Xh
-----END PGP SIGNATURE-----

--Lg7Mh0BLHSLa2DavJRcWO3kkBdI9iOIuL--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-cm] IB/core: Fix use after free of ifa
Date: Tue, 20 Oct 2015 12:52:24 -0400
Message-ID: <56267148.5090408@redhat.com>
References: <1444910463-5688-1-git-send-email-matanb@mellanox.com>
 <1444910463-5688-2-git-send-email-matanb@mellanox.com>
 <561FE452.3050304@redhat.com>
 <CAAKD3BBEfKTHPKyoTzMW3YESKJmGkcUkui=hjhsbyFRY+xDDEw@mail.gmail.com>
 <5624E0AE.8050702@redhat.com> <5624FC13.1090200@mellanox.com>
 <56250BD6.2050503@redhat.com> <562654B6.8090501@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="oOELehWDiwjcoaSfnNDk1qRON753Boebf"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <562654B6.8090501-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--oOELehWDiwjcoaSfnNDk1qRON753Boebf
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 10/20/2015 10:50 AM, Matan Barak wrote:
>=20
>=20
> On 10/19/2015 6:27 PM, Doug Ledford wrote:
>> On 10/19/2015 10:20 AM, Matan Barak wrote:
>>> On 10/19/2015 3:23 PM, Doug Ledford wrote:
>>
>>>> This is a major cause of the slowness.  Unless you have a specific n=
eed
>>>> of them, per-entry rwlocks are *NOT* a good idea.  I was going to br=
ing
>>>> this up separately, so I'll just mention it here.  Per entry locks h=
elp
>>>> reduce contention when you have lots of multiple accessors.  Using
>>>> rwlocks help reduce contention when you have a read-mostly entry
>>>> that is
>>>> only occasionally changed.  But every lock and every unlock (just li=
ke
>>>> every atomic access) still requires a locked memory cycle.  That mea=
ns
>>>> every lock acquire and every lock release requires a synchronization=

>>>> event between all CPUs.  Using per-entry locks means that every entr=
y
>>>> triggers two of those synchronization events.  On modern Intel CPUs,=

>>>> they cost about 32 cycles per event.  If you are going to do somethi=
ng,
>>>> and it can't be done without a lock, then grab a single lock and do =
it
>>>> as fast as you can.  Only in rare cases would you want per-entry loc=
ks.
>>>>
>>>
>>> I agree that every rwlock costs us locked access. However, lets look =
at
>>> the common scenario here.
>>
>> No, let's not.  Especially if your "common scenario" causes you to
>> ignore pathological bad behavior.  Optimizing for the common case is n=
ot
>> an excuse to enable pathological behavior.
>>
>>> I think that in production stable systems, the
>>> IPs our rdma-cm stack uses (and thus GIDs) should be pretty stable.
>>
>> Probably true.
>>
>>> Thus, most accesses should be read calls.
>>
>> Probably true.
>>
>>> That's why IMHO read-write
>>> access makes sense here.
>>
>> Probably true.
>>
>>> Regarding single-lock vs per entry lock, it really depends on common =
an
>>> entry could be updated while another entry is being used by an
>>> application.
>>
>> No, it depends on more than that.  In addition to the frequency of
>> updates versus lookups, there is also the issue of lookup cost and
>> update cost.  Using per entry locks makes both the lookup cost and the=

>> update cost of anything other than the first gid in the table grow
>> exponentially.  A good way to demonstrate this would be to create 100
>> vlans on a RoCE device, then run the cmtime test between two hosts usi=
ng
>> the 100th vlan IP at each end.  Using per-entry locks, the performance=

>> of this test relative to using the first IP on the device will be
>> pathologically bad.
>>
>=20
> That's correct, we"waste" #entries * <time of lock and unlock>. But we
> have to note this is mainly during the connecting part.

Yes, and I spent a *month* of my life tracking down why a customer's
real world application was failing in production (but not in their
staging environment) and it all boiled down to the fact that when their
app had to start up more than about 700-900 connections at app startup
and their setup included dual port controllers with both ports in use,
and some of those connections had to look up GIDs on the second port,
the abysmal per-gid lookup rate meant that the kernel had a hard ceiling
of how many GIDs it could look up per second.  Once that was hit, the
app went into a permanent cycle of dropping failed connections and
re-opening new ones and it would simply never catch up.

So it concerns me greatly to hear you say "But we have to note this is
mainly during the connecting part", implying that some wasted cycles on
connection startup are OK.  They aren't.  Not ever.  Production systems
fall over dead precisely because of things like this.

>> 3)  Consider optimizing the code by requiring that any time a GID is
>> added, it must take the first empty spot, and any time one is deleted,=

>> any valid entries after it must be moved up to fill the empty spot, th=
en
>> optimize find_gid to quit once it finds an empty slot because it knows=

>> the rest of the table is empty.  Given that mlx4 keeps a huge 128 tabl=
e
>> array, this can be very helpful.
>=20
> I don't think we want to change existing GID entries. Entities sometime=
s
> want to refer to GIDs via GID indices. Changing the GIDs order under
> their feet could be problematic.

I had a feeling this one might be an issue.  There is, however, a
solution that would resolve the problem.  The issue here is that you
have an array of GIDs that you want to be able to both scan efficiently
and access directly.  The array is great for direct access, but the scan
efficiently part is a total looser because you scan so many empty
entries most of the time.  You could change it so that a gid port table
is actually a combination of 1) an array of gid_port_table_element
pointers and 2) a linked list of gid_port_table_element structs.  Then
you only allocate a struct when needed, link it into the list, assign it
an index, set the pointer in the array at point index to point to your
struct, and that way you can still direct access the elements, but can
also scan efficiently.  It's more complex, but would speed up the
scanning considerably.

>> 4)  Does the table port struct have to use a mutex?  Could it be chang=
ed
>> to a rwlock instead?  If so, you could changing write_gid so that it
>> assumes it is called with the read lock on the port already held and i=
t
>> merely updates itself to a write lock when it is ready to write the
>> entry to the array and update the card.  It would then downgrade back =
to
>> a read lock on return and the calling function would hold the single
>> read lock from the time it is ready to call find_gid until write_gid h=
as
>> returned.
>=20
> AFAIK, read_locks can't be "upgraded" to write_locks. In addition, the
> cost of the locks here is negligible (assuming it's a per-table rwlock
> and not per entry lock). In all code paths that uses the table mutex, w=
e
> call the vendor's command to write the GID table. Updating the GID tabl=
e
> usually cost a lot more than the mutex locks.

I thought the kernel allowed upgrades, but I admit I didn't check.
Anyway, it was merely to prevent the case where you drop the read lock
and try to take the write lock and other readers rush in.  You could
also take the write lock from the beginning, but that might hurt
concurrency.

>> 5)  I noticed that ib_cache_gid_find_by_port calls find_gid without ev=
en
>> taking the read lock, that needs fixed.
>=20
> find_gid takes a per-entry read_lock. Which lock do you think is missin=
g
> here?

The other places hold the table mutex.

> Although it's mostly used in the connection part,

Please don't say that as though it makes the inefficiencies in this code
OK.  It doesn't.  Being on the connection startup or teardown path is
not an excuse.

> I think the locking
> refactoring here is a good performance enhancement.
> Because it is an enhancement, do you agree we could work here by gradua=
l
> changes and change the locking schema later?

I never intended it to be during the rc phase.  But it would be good to
tackle soon.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--oOELehWDiwjcoaSfnNDk1qRON753Boebf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWJnFIAAoJELgmozMOVy/dWLYP/AiNVe2zz7PRI3WsQM7DmfDj
8xFQWkJ3XmaZ3oAG4Yr4BQc2RVSeBAIQm4pXaq7S7xVEAeC92h8hwczMSmnA5h+9
r9rqa+7NLQKc8E2PNO7w8CVHXdnilGqbGQMiiNJh+NOUAnuYnDnS23ifoPZd3PBW
7/wmveM+qNKa7VqNrnQoPrHBfvbkVjtqYHY3F3II/9z/mZhSHnCtfliMhDzzrygj
+oJx2hl2+bShH41iIV065Yfn1UtajzUKQG+GCSXQ1T62dCNf4Tedh5QWc3gcaNje
HJ+Vcwjt7Nm9wMlTPUL4gNBwtRDChLt3oroqbqd1e0KWMIwLgi9I42vkGu/i1+zI
c1x7nO/QId5e79AsH4kh8Sfvfdn0RZSiG6ksumMHkPCbD9OSjo+yES6oBUpHsKJp
/ZWb3iNbTVlvgRYW88X1GuYsR3Qy5lrnt1KQLb/Tk8740q/EVZkdtbaapCdUzRjo
b9RZlRdrq5wZi+/eWT9R6Id5LaKkhVw0/IfVgu4oGW/1NinkxvkW4i9wrrmIqu6Z
ZbYo2io5zeEZHIMIDnvx5nAiO2DHrIPv/VmWRBkNtcm37ACNlhP7I2HT8LMIAOFX
zo1n5lHdhVsDYHYH49hSvrRIkLcAXVwuBgMItAUyEEmrkK22w41zmOzDGLGgg+gd
K/vc0D8414IlZFyWXZ5W
=rHZV
-----END PGP SIGNATURE-----

--oOELehWDiwjcoaSfnNDk1qRON753Boebf--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: device attr cleanup
Date: Tue, 22 Dec 2015 14:19:48 -0500
Message-ID: <5679A254.2040809@redhat.com>
References: <CAJ3xEMj2EOxX1CiA93MPOsM-FdU9ijcWCYm9tObbkLqqja0PoA@mail.gmail.com>
 <566753E3.9060301@redhat.com>
 <CAJ3xEMhaEnv9He7N5q8fFsRzy_j27wdE6KWSFF39UzA680udwA@mail.gmail.com>
 <20151208225940.GB27609@obsidianresearch.com>
 <CAJ3xEMiEYgsxiL6zR-Dia3Rxwriye1WHcadTmUjU7zV=ide1LA@mail.gmail.com>
 <CAJ3xEMgQNMtxgTKC0zaKgy-WGugf6KwT7Ys5h3_RbN_7qd2=tg@mail.gmail.com>
 <56706414.8010807@redhat.com> <5670FC5E.8070405@mellanox.com>
 <CAJ3xEMiGOF79o1OSgxgk2tN+kY91uiNY5Aq+xu2U0Sur-htxpQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="6unfUBlt3C6jPr8lu2Vx8Srph5KAuw91a"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMiGOF79o1OSgxgk2tN+kY91uiNY5Aq+xu2U0Sur-htxpQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--6unfUBlt3C6jPr8lu2Vx8Srph5KAuw91a
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 12/22/2015 02:56 AM, Or Gerlitz wrote:
> On Wed, Dec 16, 2015 at 7:53 AM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wro=
te:
>> On 12/15/2015 9:03 PM, Doug Ledford wrote:
>=20
>>> Or, you specifically asked me to wait until this week.  I made my
>>> initial impressions clear (I don't necessarily like the removal of th=
e
>>> attr struct, but I like the removal of all of the query calls, and I'=
m
>>> inclined to take the patch in spite of not liking the removal of the
>>> struct).  Do you have anything to add or have we beat this horse to d=
eath?
>=20
>> Hi Doug,
>> Lets stop beating, both horses and people.
>> I do understand that
>> 1. you don't link the removal of the attr
>> 2. you do like the removal of all the query calls
>>
>> I am proposing to take the path of a patch that
>> does exactly #2 while avoiding #1.
>=20
> Doug,
>=20
> Did you look on my v1 post and the related discussion there w.r.t udata=
?

Yes, I did.

> You didn't make any comment on my response here nor on the proposed pat=
ches.

I'm trying to find all of the emails, they aren't in a single thread in
my mailbox (I had to do some reconstruction of my mailbox due to a
problem in a mail filter late last week...missing that the rule was set
to "match any" when I intended "match all" and the action of the rule
was "delete" when I expected delete to be the same as "move to trash"
and it wasn't, it was delete immediately, has caused me some problems).

> Since we are really short in time w.r.t EOY holidays and we have the
> udata matter
> open (see [1]), could we move finalizing this discussion to the 4.6 tim=
e-frame?
>=20
> If you do have the time, I think it would be fair to see a response
> from you on the
> discussion before you pick any of the two patch sets - so??

I'm not inclined to take either patch set as they stand.  Your's is
closer to what I'm leaning towards though.  I think I can add a single
patch to yours to make it into what I want.  I'm going to go work on
that right now...

> Or.
>=20
> [1] Christoph's patch doesn't remove the query_device callback from
> mlx4 since we
> report there values to libmlx4 through the udata mechanism. The
> query_device callback
> will need to be present in future/current drivers if they decide to
> use udata as well
>=20
>=20
>> What's wrong with that? I haven't heard any reasoning for why its
>> so good to stash ~50 new fields on the IB device structure except
>> for the author saying that other subsystems do that and other people
>> saying they are in favor of this approach while not providing any
>> reasoning, except for maybe something on bikes.
>>
>> Why you or anyone else has to be from now and ever the cache line poli=
ce
>> making sure that people don't add new attributes in random locations
>> over the IB device structure?
>>
>> What's wrong with putting fifty attributesin a structure which is a fi=
eld
>> of the device struct and have people go there to see what are the d
>> ifferentattrs and add news ones there?
>>
>> This will make the 4.5 merge window extremely complex or even totally
>> threatened  w.r.t to the RDMA subsystem and related drivers by 3.3K LO=
C
>> patch.
>>
>> Sorry, but, I still don't get it.
>>
>> Or.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--6unfUBlt3C6jPr8lu2Vx8Srph5KAuw91a
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWeaJUAAoJELgmozMOVy/dTiwP/25YN7mok8NRCcqMFlpJnJsT
T+ICWSl1KYyaley9f0vkoXTBq7Os+qIxQV3QIBvR2mpqz6A21s+M6+7k6P92wgsu
8uimZF3OIK0Cls4W46gfIf24XHYq9C19zCBfPHoCOUm47MySZAWGaADuyPk3n7Ly
NWmz//a0Yw2zdYkqgyouIbuvd71WiORruMinndiv+kjHQGvULd80fOH8kfGTCSfH
Z72guNy2gSkqJe1PPLEPKze3npI++me488R4ZBrJulzT1XT1igCf5a3sr3YiO4AT
FqfzmZ0fd9CgCPFDD93mQNFAsC0IvG8iKfrmRSorURxCZ+HaBtceawfX1r04SK49
V1cOncx03ETyxK18yDu7FAkz6mM63U3q6b5USBalQPizXoco1spdz/vFvsnGUMLE
75b3RSO2LEpKainXT/w+84Vi7FeHzBWCxFGzaAYCNvVIETg4ZAYUNZRnguC/Lmoa
pdu1WTt932xFJiSqHgkSSqWywETJS/qbB7o3ar+wKBH5f/B1MJdVD7O0vr5Xu8wG
zxt2ry+KOzDziK+R1S2kyhmb8DEZc5DQ7ZauoUV7Mr5PCRgtSuQjGJVc2/S1Dson
j73TjpkM5OYn3dEOHUGiFmYR5g3Kj1TjqS40goDhVcRCJpI841Tz6yZL+4gOQsCn
bDgaBmU1AqQ/cdjnpaac
=ZpQy
-----END PGP SIGNATURE-----

--6unfUBlt3C6jPr8lu2Vx8Srph5KAuw91a--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

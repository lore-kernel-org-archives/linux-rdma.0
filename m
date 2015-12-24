From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: device attr cleanup
Date: Wed, 23 Dec 2015 22:19:15 -0500
Message-ID: <567B6433.4050907@redhat.com>
References: <20151208225940.GB27609@obsidianresearch.com>
 <20151208230244.GA10701@infradead.org>
 <20151209005203.GD16976@phlsvsds.ph.intel.com>
 <20151209184235.GB4522@infradead.org>
 <20151210014556.GA32059@phlsvsds.ph.intel.com>
 <56693758.90808@dev.mellanox.co.il>
 <93E3DE8A-0589-436D-A9A1-7EAC66B12739@oracle.com>
 <20151210180703.GC21482@obsidianresearch.com>
 <20151210233047.GB26009@infradead.org>
 <09F96E8A-5E1E-4345-9069-C07108AF0BC7@oracle.com>
 <20151223213116.GB29650@fieldses.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="WHPPdEKS5pw9NbAeKrj4gPgMHA8r9v6ao"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151223213116.GB29650-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Anna Schumaker <schumakeranna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--WHPPdEKS5pw9NbAeKrj4gPgMHA8r9v6ao
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/23/2015 04:31 PM, J. Bruce Fields wrote:
> On Thu, Dec 10, 2015 at 07:49:59PM -0500, Chuck Lever wrote:
>>
>>> On Dec 10, 2015, at 6:30 PM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wr=
ote:
>>>
>>> On Thu, Dec 10, 2015 at 11:07:03AM -0700, Jason Gunthorpe wrote:
>>>> The ARM folks do this sort of stuff on a regular basis.. Very early =
on
>>>> Doug prepares a topic branch with only the big change, NFS folks pul=
l
>>>> it and then pull your work. Then Doug would send the topic branch to=

>>>> Linus as soon as the merge window opens, then NFS would send theirs.=

>>>>
>>>> This is alot less work overall than trying to sequence multiple
>>>> patches over multiple releases..
>>>
>>> Agreed.  Staging has alaways been a giant pain and things tend to nev=
er
>>> finish moving over that way if they are non-trivial enough.
>>
>> In that case:
>>
>> You need to make sure you have all the right Acks. I've added
>> Anna and Bruce to Ack the NFS-related portions. Santosh should
>> Ack the RDS part.
>>
>> http://git.infradead.org/users/hch/rdma.git/shortlog/refs/heads/ib_dev=
ice_attr
>=20
> Fine by me.
>=20
>> Given the proximity to the holidays and the next merge window,
>> Doug will need to get a properly-acked topic branch published
>> in the next day or two so the rest of us can rebase and start
>> testing before the relevant parties disappear for the holiday.
>=20
> What branch should I be working from?

That patch was very intrusive (and I didn't like the change to the
structure organization).  An alternative patch was proposed and I took
it instead.  The patch I took is much less intrusive, but you might
still need to adjust things slightly.  I've pushed my current WIP
for-next branch to my github repo:

git://github.com/dledford/linux.git for-next

This branch might get rebased still yet before it gets pushed to my
official repo at k.o, but it is perfectly fine to check that your
patches will merge with my for-next branch without conflicts.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--WHPPdEKS5pw9NbAeKrj4gPgMHA8r9v6ao
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWe2QzAAoJELgmozMOVy/dCeMP/jY6a3NcpSwA6U7ykIkUNkbG
iHHmRmtTnBHgW5A/od/V586mkDX/NnRQV57S9P0JpTr6HZVgQQtY2Nzhz7ufgI5L
m9yCpYixc3FjT7WJKfjezBX2AX4A8AQL/icRVt3aRIsDuCZaYRwlJcp6uzMRuSQt
vyjbD7ndlm56+3I03WmxC9kp5P6KWxPgZEgO62GoHV/+eH29aHjR9qOFfPK40djR
4XTufESnshw78f2fIt01iNqS8lbtPBrOmRIMjt/POMkYMpwPRwffOTdUY5s9+4nD
HyDIDeQOOx6sMuBKWuTkNuFycBhkwBGjsDztYiWK6cDiUQccnyTkPBVMglGMDQuy
UdKSZ5GOaEC4KPmWMPL8Nb8pMBaZ3fiB6j/Wm43LdhioUbFK7Ogr5oFf/G6E+JRZ
Kj04wvZmptkDak0ulqW0yfq8KHtc4KlK8YQTe0Z89PnKzL46wQxCw/dIUWUhmT2z
vq48AsBfI5A6XzqICDGTdG2+S0CVp8ChvULs7PzP1V3LOiknb4jZMdX41vmH0cao
KNvj3G5d6/FLwRXX4/n30WrYFZT9867cFWEsdgbZbnn7r2B2CIjfYdHsCqoj3nIE
2tw95DU0wbxoEW+TV9GXEmrB/wBMAe/j0o73H624ojaa3JlFn7jvyFuzvEvyMvYw
UI39Vaask6KlfRrIdEF7
=fk/E
-----END PGP SIGNATURE-----

--WHPPdEKS5pw9NbAeKrj4gPgMHA8r9v6ao--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

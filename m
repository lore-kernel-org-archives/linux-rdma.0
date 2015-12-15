From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: device attr cleanup
Date: Tue, 15 Dec 2015 14:03:48 -0500
Message-ID: <56706414.8010807@redhat.com>
References: <CAJ3xEMj2EOxX1CiA93MPOsM-FdU9ijcWCYm9tObbkLqqja0PoA@mail.gmail.com>
 <566753E3.9060301@redhat.com>
 <CAJ3xEMhaEnv9He7N5q8fFsRzy_j27wdE6KWSFF39UzA680udwA@mail.gmail.com>
 <20151208225940.GB27609@obsidianresearch.com>
 <CAJ3xEMiEYgsxiL6zR-Dia3Rxwriye1WHcadTmUjU7zV=ide1LA@mail.gmail.com>
 <CAJ3xEMgQNMtxgTKC0zaKgy-WGugf6KwT7Ys5h3_RbN_7qd2=tg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="B9SW5reK0lJqAWt1xDAs4PevIwWu6GTtK"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMgQNMtxgTKC0zaKgy-WGugf6KwT7Ys5h3_RbN_7qd2=tg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--B9SW5reK0lJqAWt1xDAs4PevIwWu6GTtK
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 12/08/2015 06:15 PM, Or Gerlitz wrote:
> On Wed, Dec 9, 2015 at 1:13 AM, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote=
:
>> On Wed, Dec 9, 2015 at 12:59 AM, Jason Gunthorpe
>> <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
>>> On Wed, Dec 09, 2015 at 12:47:55AM +0200, Or Gerlitz wrote:
>>
>>>> The patch is three liner to add the cached attrs --
>>>> http://marc.info/?l=3Dlinux-rdma&m=3D142309296813985&w=3D2 -- if you=
 are OK
>>>> with that, I will add a 2nd patch that ports all ULPs to use the
>>>> cached copy instead of their code which does the query.
>>
>>>> Actually, why not start with this approach and later decide if we ne=
ed
>>>> to go further of this is enough?
>>
>>> Or, can we please stop this bikeshedding. Christoph's patch is done,
>>> well tested and does a lot more clean up that this hacky three liner.=

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
>>
>>> It is a good patch,
>>
>> I didn't say it's bad, I said I think we can achieve #1 above with way=

>> less drastic patch, and I'd like to hear the maintainer option, and
>> have the chance to argu with the maintainer if needed, yours I heard,
>> you like it, I know.
>=20
> and I will be OOO for the rest of this week, since this is in the air
> for ***months***, it would be fair enough to ask the maintainer not to
> cut it this way or another before next week, Doug, agree?

Or, you specifically asked me to wait until this week.  I made my
initial impressions clear (I don't necessarily like the removal of the
attr struct, but I like the removal of all of the query calls, and I'm
inclined to take the patch in spite of not liking the removal of the
struct).  Do you have anything to add or have we beat this horse to death=
?


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--B9SW5reK0lJqAWt1xDAs4PevIwWu6GTtK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWcGQUAAoJELgmozMOVy/dfDkQAKVQE/CE8e+7BnD8rnT4CphR
jbfouKMBkz/eIT3lbeNJFaL6VN6xpYuYv36I2gLy6HviTcsSBp12Gmo/pKBUcUI9
ua93mE8frNovEi04Ys9k3Rv6JuPAi2AA32ZZYdH3jq9EeRH3QbvIxZUq505FKinY
Mnbi3lbS7UstmNOFDChThr81+xXkOj0Z7hJ5CkWvb9mdVPCTcga0eGxF8P1KhozG
SOgKtqqRO7vgBJmODpc4YaWoY6rrnuCXSEtpFvTNJ1HlAcC6vq2SP5ybTHm1swmu
k+1UsCpxgu4NUSYgUfHyiFbW6PvBNonclPzdnDh9dHQwyg2EJpF9ARFvk4VyXckh
DzIIlGKLAp1wpHuOFx/5Oe5wCYRIjfDi1dNR5q7EWeurxVUCzSpSuwHTN27jbspL
w0hhc7CDRIARZwuolwUAVU9IS7bYCWpy+fJ5iHRkyqsIq9URA2RFcitT7N1lG2GA
7BmD2/SWSgic6L8TApLOZRYK3P5KohfWb10CqfYnYXhH3hd3qqAA0qRd9Ft4UNq8
h4EmhKsFJxTdUkd0UexZt+buMGIn4R8siqiNnIDpteFGO1AJqVSpzjO577CWVBf7
T/+XqsYUbTggbcCbDofADV/Uj2hF/TYTp6DO1PtA3LqasteBSmLSOjW64k6qDPYi
oKn+WvWAiRtJ5qqA9O1M
=YygI
-----END PGP SIGNATURE-----

--B9SW5reK0lJqAWt1xDAs4PevIwWu6GTtK--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

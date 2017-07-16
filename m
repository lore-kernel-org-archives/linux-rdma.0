From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: This merge window...
Date: Sun, 16 Jul 2017 08:46:43 -0400
Message-ID: <d285c27b-bcd2-9585-f513-d7e96fb28e34@redhat.com>
References: <824b3771-78a6-7c80-50d9-a34383169185@redhat.com>
 <CAJ3xEMh-YcUgydmc96UumX3cfgr7P+0rRenOvBe_6m_bo+K3mg@mail.gmail.com>
 <1499875106.2924.26.camel@redhat.com> <20170712160432.GA24552@infradead.org>
 <20170712171044.GE1528@mtr-leonro.local>
 <e3a1c07f-8a52-351e-312c-6e374ec7d136@grimberg.me>
 <alpine.DEB.2.20.1707140926080.27726@nuc-kabylake>
 <11752e09-6ac3-6362-0aac-8e735b80033b@redhat.com>
 <20170716035749.GB14674@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="33qFTLVELdlCKRVNtJffdTrdVLVBixoTF"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170716035749.GB14674-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Christopher Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--33qFTLVELdlCKRVNtJffdTrdVLVBixoTF
Content-Type: multipart/mixed; boundary="jFWib3nIKdI4Oq089mCsfFaXcPiHwXe2A";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Christopher Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>,
 Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
 "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <d285c27b-bcd2-9585-f513-d7e96fb28e34-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: This merge window...
References: <824b3771-78a6-7c80-50d9-a34383169185-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <CAJ3xEMh-YcUgydmc96UumX3cfgr7P+0rRenOvBe_6m_bo+K3mg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
 <1499875106.2924.26.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> <20170712160432.GA24552-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
 <20170712171044.GE1528-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
 <e3a1c07f-8a52-351e-312c-6e374ec7d136-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
 <alpine.DEB.2.20.1707140926080.27726@nuc-kabylake>
 <11752e09-6ac3-6362-0aac-8e735b80033b-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <20170716035749.GB14674-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
In-Reply-To: <20170716035749.GB14674-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>

--jFWib3nIKdI4Oq089mCsfFaXcPiHwXe2A
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 7/15/2017 11:57 PM, Leon Romanovsky wrote:
> On Sat, Jul 15, 2017 at 02:12:42PM -0400, Doug Ledford wrote:
>> On 7/14/2017 10:28 AM, Christopher Lameter wrote:
>>> On Thu, 13 Jul 2017, Sagi Grimberg wrote:
>>>
>>>> Join on the awesomeness.
>>>
>>> It would even be more awesome if we had multiple people that can work=
 the
>>> release process so that we do not have a single person bottleneck.
>>>
>>> Doug: Would you please do some more detailed planning and delegate th=
ings
>>> as possible? A couple of developers should be able to review the curr=
ent
>>> state of things and help to move things forward if there is a bottlen=
eck
>>> currently or coming up.
>>>
>>
>> I am, without a doubt, reworking my process.  I will not be syncing up=

>> against Dave Miller's tree any more.  When I take patches, they should=

>> apply cleanly to my tree and work without dependencies.  If there are
>> dependencies, then people need to send the dependencies through Dave's=

>> tree (assuming that's where they go) in release X, and then send the
>> dependent code to my tree in release X + 1.
>=20
> There are two parts in this proposal, while second part (dependency) is=

> fair enough and possible to meet, it is unclear to me the first part
> (apply cleanly).
>=20
> 1. On which branch should we send our topics?

You can always use -rc1 as a safe starting point.  I'm going to try to
open things up around then anyway.

> 2. Are you acknowledge that this branch is going to be updated +/- on d=
aily basis?

Not necessarily daily, but certainly every 2-3 days.

> 3. How do you see us submitting multiple topics? Sequential submission =
- like DaveM,
> and it should be applied close to submissions (if no objections and so =
on ..).
> Or parallel submissions - like it is now and the conflicts are unavoida=
ble.

Not the parallel submissions we are using now.  It generates far too
many conflicts and such.  What I would prefer to see is one submission,
then two or three days (so the first submission has had some bake time),
then the next one and it should assume the first is applied and apply
cleanly on top of that.

> 4. If 2 and 3 are not going to change, should we wait till late rc and =
submit all (100+)
> patches at one or two shots to avoid merge conflicts?
>=20
> I would be glad to get the whole picture of submission process, before
> we are moving forward.

Is what I wrote above clear enough?


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--jFWib3nIKdI4Oq089mCsfFaXcPiHwXe2A--

--33qFTLVELdlCKRVNtJffdTrdVLVBixoTF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJZa2A4AAoJELgmozMOVy/dzqMQAMEso773jt51EPljIPIlkzdb
2TZ/AxneH+1gEraNFtfEDwrFnBHMJjmQzxIlBsD2PpqVJdocjvIyP/FhdGTBbmBq
KIGW2xEj1TxuvNAOz0eNwA8q0chahq3OC+EZrF7YEFz9DcAuwtPmS8FyBInUJI04
G2NG1ahTT3DEYF8v/ha6FwUwZ0i1PqRgXNimqRHgPFGjIR7oh4eclIqQ3uZeWyMA
r3utlSt41W0P8pTyH/bW6cUayLaXQl9BCzK2m2e0alrrqEtVcx5xhdaBW9uH4Q3x
ryx6gZKfjD/9ObQOrKv3vCtus1Q+aJGXfh/qr+rnrC0wdeemFQ+zGL627ZqyMRev
343RNo4V3yxVFvEtlrm1oownQDBXjIgJAw4AkcVhLb6pDx7GwqUDS/hH9NVyDojb
X/Ej/1uvCpz6NgfhEd9jz2V9QmFLsaJKNFi+3XnZjNV0MkQPkvyky1WVdF7nookd
Uo/NcoCmuYY8qWYmZOOZNP9uXiLryavqX/v6KwxGv8MLU4Vd28W91A8xzdzAPJ1O
AUblNpOAEQfbVlUYXDPtC9EfsifxCzj2vzUQqNntRmD722JBIL0vRcv7QnjNTyOU
ehSP6yeH0pCvxWWHnj/QEa29hbP3IQ99enX//VJfUNQ3Ce7WW/+ycivNOlxrppCW
0mUS1JzNUx9ADKVAziOg
=hGSZ
-----END PGP SIGNATURE-----

--33qFTLVELdlCKRVNtJffdTrdVLVBixoTF--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

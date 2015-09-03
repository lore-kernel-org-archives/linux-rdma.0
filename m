From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] IB/ipoib: Clean up send-only multicast joins
Date: Thu, 3 Sep 2015 17:25:42 -0400
Message-ID: <55E8BAD6.9070309@redhat.com>
References: <1440200053-18890-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <55DCAACD.3000307@redhat.com> <20150825182233.GA20744@obsidianresearch.com>
 <55DCB56F.5000001@redhat.com> <20150825194945.GA22335@obsidianresearch.com>
 <55DDC12E.6030705@redhat.com> <20150826161829.GA27407@obsidianresearch.com>
 <55DDECA3.4010207@redhat.com> <20150827233322.GA29724@obsidianresearch.com>
 <55E8B8EB.7000009@redhat.com> <20150903212307.GA8026@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="dvqBf4QoVklxEsKtnpjxVGhHJxpdeWrMp"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150903212307.GA8026-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--dvqBf4QoVklxEsKtnpjxVGhHJxpdeWrMp
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 09/03/2015 05:23 PM, Jason Gunthorpe wrote:
> On Thu, Sep 03, 2015 at 05:17:31PM -0400, Doug Ledford wrote:
>> On 08/27/2015 07:33 PM, Jason Gunthorpe wrote:
>>> On Wed, Aug 26, 2015 at 12:43:15PM -0400, Doug Ledford wrote:
>>>
>>>> That still takes us back to the fact that the locking changes are
>>>> unneeded.  I'm not opposed to them, but as you mentioned in your fir=
st
>>>> email, they should go with the changes that require them, and none o=
f
>>>> the changes in the first patch require them.  Which means that if we=

>>>> want to keep them, it might be worth splitting them out and giving t=
hem
>>>> their own patch with an explanation of why they are a benefit (light=
ly
>>>> contended code, saves a release/reacquire on the failure path).
>>>
>>> Lets just drop them, the cost for restructing was an added empty lock=

>>> grab on a non-error path.
>>
>> I've reworked the patch to not perform any locking changes and applied=

>> the result.
>=20
> Thanks Doug, I've been too busy to look at this..

You're welcome ;-)

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--dvqBf4QoVklxEsKtnpjxVGhHJxpdeWrMp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJV6LrWAAoJELgmozMOVy/do7oP/0fK8Dx1fuaFvlivydq6+BQ2
WWYvkk8ju3UcYkFK/tM3VRebjvJmQatz3o21C52/Mb8pFzQYDqytMu3T6n9NmX6g
qZnezwTE3Q7+d2Kr14hoS9hz+b8/vjDBuT7efoKx7xdOuHFGHZ9c4DcBy9nGBnUV
KsauXWhU0LEBqIqN2++ZaK/cZ3r1d4Lh5yYWm8xZvuixCUClHbC8f6Cx/MgiGrKY
/eZRJZNbsztvZWb5VdO/pY27MXxAp1YOOW7S8li4FxldL1YrkBxSjVmOhv9k6HFN
TGIOY0wYWkUgDMOlvVD5Oj3azZAe5Tqe38ZrycsqN0NaRbBHGGeoHM0OAtyNipjo
pE0v8ZN5yy32jXjR8txrNp7a7/yEouylfVqOr39/jkSGm8nsmUvzbHdUGx7hLbPD
HR0GJ6BXDiSoUkWnoz2dQO3Jeo1SS67899b5I67QvcrDmkEnYmK+bh7xGCQspnRV
pF3lAREYRabvDU8MbsD2azBpvoe7ht9ORgGPT++9/aDKJgWileKDczhf1rBP95M4
FryiTqcHjp9JT39dUzxMUudm+FCQJ58lfV5nL5Q71OUYwg5kdr4c+HiwuHs/JY23
/hmg+FVDnBWzDKemiMFWP3oxrjZ3JCIfUbXytEb5g6JvS1oaDWTkFZZX1uXVIHj1
HnDNHvlPj5cFcl/5/ZB/
=WrWz
-----END PGP SIGNATURE-----

--dvqBf4QoVklxEsKtnpjxVGhHJxpdeWrMp--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

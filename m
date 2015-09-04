From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH libibverbs] Fix create/destroy flow API
Date: Fri, 4 Sep 2015 17:59:24 -0400
Message-ID: <55EA143C.60907@redhat.com>
References: <9665e46a71940f2721b30fdb4aaa0853161babc9.1441401379.git.dledford@redhat.com>
 <20150904213226.GB20758@obsidianresearch.com> <55EA124F.2070305@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="rMfipVl0DfGvsj3FObwt6fisQmAT0rIi6"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55EA124F.2070305-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--rMfipVl0DfGvsj3FObwt6fisQmAT0rIi6
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 09/04/2015 05:51 PM, Doug Ledford wrote:
> On 09/04/2015 05:32 PM, Jason Gunthorpe wrote:
>> On Fri, Sep 04, 2015 at 05:17:38PM -0400, Doug Ledford wrote:
>>> +		/*
>>> +		 * In order to maintain backward/forward binary compatibility
>>> +		 * with libmlx4-1.0.6, which has the original version of the
>>> +		 * flow steering patches, we need to set the two
>>> +		 * ABI_compat_placeholder entries to match the driver
>>> +		 * set flow entries.  This is because, in the specific instance
>>> +		 * of using libmlx4-1.0.6 with the fixed version of
>>> +		 * libibvberbs, the ibv_create_flow inline function already
>>> +		 * compiled into libmlx4-1.0.6 will be loooking in the
>>> +		 * ABI_placeholder spots for the function pointer to the
>>> +		 * create and destroy flow verbs.
>>>  		 */
>>
>> This isn't quite the right comment, it has very little to do with mlx,=

>> ibv_create_flow is the user entry point, the above applies to
>> everything linked to ibverbs.
>=20
> You're right.  I'll correct that.

The new cokment:

                /*
                 * In order to maintain backward/forward binary
compatibility
                 * with apps compiled against libibverbs-1.1.8 that use t=
he
                 * flow steering addition, we need to set the two
                 * ABI_placeholder entries to match the driver set flow
                 * entries.  This is because apps compiled against
                 * libibverbs-1.1.8 use an inline ibv_create_flow and
                 * ibv_destroy_flow function that looks in the placeholde=
r
                 * spots for the proper entry points.  For apps compiled
                 * against libibverbs-1.1.9 and later, the inline functio=
ns
                 * will be looking in the right place.
                 */


>> My suggestion was to not change the ibverbs->user ABI at all and just
>> mangle the driver side, ie move the ABI_placeholder to what was drv_
>> instead of lib_.
>=20
> As you pointed out, this doesn't make the entire matrix of old/new
> driver/libibverbs/app work.  I can think of two things that would be
> ugly about doing it this way if we wanted to make that matrix fully
> operational.  With the way I did it, things are clean in the new driver=

> and mostly clean in the new libibverbs, and the full matrix works.
>=20
>> Can't see anything wrong with it this way, off hand, other than the
>> comment.
>=20
> Thanks for looking at it ;-)
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--rMfipVl0DfGvsj3FObwt6fisQmAT0rIi6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJV6hQ8AAoJELgmozMOVy/dcLwP+wWEpppk9y4/8AOG3/4c6LBC
01fd+/L3bq6GZ6C+BNu3ewWR35EC/aYWW/w1xPHsueKNn7smiIcXrMmSgIdzRZSM
IiY8fw69jdhGqPoezWEGQfgOeAnVG5rnNPvmn2UsoWFHvbutpiI0Ls9ng4+qlhpz
F1zkjYtue6tO+/OWBndt3XDwDG3Rpxsy868wLn3IvtIyePuVt5dCUsPKZcrZ06Xr
ghpuYuS5Mvjqu3bT9wgRMSKQCrzmaOyO0cek20csw+qdQDL8m27nI5O99HBKhyLd
Z38jwuIKSXIceqHLEKSMovZAwXjmBt2RHpbFwRLkccj/pz+BhUcVRCvLHH7ZpQ4G
n8XjQeiXGaDc99mi/s562FeCatEHpbOpQmsOGfKlRVg3g44dGq4V8YqY+oLe7b3C
QiaxpJpaSYWeczsK2idzY/lpeGAzKiDvWFuB3dTJp8ILC+PE6zwebo4G0sItLemu
OR46uskcmdBcpp+iMA+0AGf9ZoWRplxKvrRxKWD13K9mq6glgBTDrHTqvua4TGlj
WUnwUm1CfFpRjOzJcF8oZAXkOxpECW6kwL4SYt2xCuZ/f9jWg+SoGyZaLL26rLi4
qqd34tByCaH9051Ew3ifD+yYYyrvadgY91P6rM9oexqPy2h01U1caQsTqqD7pWzA
qSoDuv/rTroD4R4BKbBA
=07Ja
-----END PGP SIGNATURE-----

--rMfipVl0DfGvsj3FObwt6fisQmAT0rIi6--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

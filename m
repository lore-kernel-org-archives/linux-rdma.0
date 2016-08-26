From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] IB/hfi1: Fix a parameter of find_first_bit.
Date: Fri, 26 Aug 2016 15:34:48 -0400
Message-ID: <e86e76dc-811b-7002-a35d-1e515c833d46@redhat.com>
References: <1472186949-9025-1-git-send-email-christophe.jaillet@wanadoo.fr>
 <cf61e699-9e2d-a594-64e6-43ea33b239d9@redhat.com>
 <2c923344-04c8-cdbd-ac06-047027f7a23a@redhat.com>
 <20160826192957.GG594@leon.nu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="XFnopNOkb0uofv8R6E1s45fjIuWGXMbwr"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160826192957.GG594-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Christophe JAILLET <christophe.jaillet-39ZsbGIQGT5GWvitb5QawA@public.gmane.org>, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--XFnopNOkb0uofv8R6E1s45fjIuWGXMbwr
Content-Type: multipart/mixed; boundary="DsMnoPLAjdNekc0COxj61oE4qsrRXOrHW"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Christophe JAILLET <christophe.jaillet-39ZsbGIQGT5GWvitb5QawA@public.gmane.org>,
 mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org,
 sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <e86e76dc-811b-7002-a35d-1e515c833d46-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] IB/hfi1: Fix a parameter of find_first_bit.
References: <1472186949-9025-1-git-send-email-christophe.jaillet-39ZsbGIQGT5GWvitb5QawA@public.gmane.org>
 <cf61e699-9e2d-a594-64e6-43ea33b239d9-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <2c923344-04c8-cdbd-ac06-047027f7a23a-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <20160826192957.GG594-2ukJVAZIZ/Y@public.gmane.org>
In-Reply-To: <20160826192957.GG594-2ukJVAZIZ/Y@public.gmane.org>

--DsMnoPLAjdNekc0COxj61oE4qsrRXOrHW
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 8/26/2016 3:29 PM, Leon Romanovsky wrote:
> On Fri, Aug 26, 2016 at 02:01:55PM -0400, Doug Ledford wrote:
>> On 8/26/2016 9:35 AM, Doug Ledford wrote:
>>> On 8/26/2016 12:49 AM, Christophe JAILLET wrote:
>>>> The 2nd parameter of 'find_first_bit' is the number of bits to searc=
h.
>>>> In this case, we are passing 'sizeof(unsigned long)' which is likely=
 to
>>>> be 4 or 8.
>>>
>>> If the size can be 4 or 8, then using 64 universally is not correct.
>>> Why not use sizeof() * 8 (or << 3)?
>>
>> Better yet, why not put this patch in the kernel first:
>>
>> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
>> index d96a6118d26a..a8838c87668e 100644
>> --- a/include/linux/kernel.h
>> +++ b/include/linux/kernel.h
>> @@ -52,6 +52,8 @@
>>
>>  #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) +
>> __must_be_array(arr))
>>
>> +#define bitsizeof(x)   (sizeof((x)) << 3)
>> +
>>  #define u64_to_user_ptr(x) (           \
>>  {                                      \
>>         typecheck(u64, x);              \
>>
>> then start going around replacing all these hard coded numbers with th=
e
>> use of bitsizeof().  It can be applied not just to the find_first*bit(=
)
>> routines, but to a bunch of other routines too.  Just look at
>> include/linux/bitmap.h and any that have nbits as an argument are
>> candidates.
>=20
> There is BITS_PER_LONG define for that. There is actual use of it in ml=
x5 for
> the similar code pieces.

BITS_PER_LONG only works if your bitfield is a single long.  It doesn't
work for other bitfields.  What I posted above will work for anything.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--DsMnoPLAjdNekc0COxj61oE4qsrRXOrHW--

--XFnopNOkb0uofv8R6E1s45fjIuWGXMbwr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXwJnYAAoJELgmozMOVy/dnWsQALfrcOME4GXBsWkEONu1kJOh
aqFj3l0SYoK+DaxwuUIlVWDn6jquWEkVSW9BBiQrw7q8LQwZB/Ma8QTm6xKVoruy
YBYBckQRloAYhOwoqRAJs4TBTSqb0V3664Ey67IqRYXJrP8H+T73tqVaogr5XOaP
1Oufn3MnJnR4wNtX8SLPH7fRMTb7ijElkRgmm6UH7lk05cQijN2c4xlqw2ancndz
QWupbQNcrXQY74ZAOOr+hN3SW5zxYv9pOyP6vjfWQHa7YEXNqqXvb3X2v9mV9Yk7
wV45m9blzuyyFnL056Nijeme5hiGgH8v+S6X0zxxi4/CQzIYxbq95kG+Ug/4/H9T
rtymopIegTlxcLBCOCjPoOTuMoxBEs/d5juf4CkeeeB6H5bSqCi+53WHTbV4WyTM
MtcTU/5i6tRtEveRUjUt3oKH/5MxZRUIBReaXcfVT5sT4YAinZ31MrxaCr10TAMI
mNIqT1poxG+KQG9P0ZS1E2QfOZzno/4qgQ9EXa8WdiMjvePmhlQRS+YCfzL7UHXv
tC7cyFxQhK5K4gPNEpArdgeTdIxnXuWQkNI7UAPRdZK5o8DPVTLHXwZBNxbz1lzU
aLYbtl8SjF3TYhUL7LXN+byABQnFwaQbAWSufkUWWii5EBK1Owtf9NnKjQ9HY0v8
KvHRnZVSfbaEhbaKHQfy
=Xwqf
-----END PGP SIGNATURE-----

--XFnopNOkb0uofv8R6E1s45fjIuWGXMbwr--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] IB/hfi1: Fix a parameter of find_first_bit.
Date: Fri, 2 Sep 2016 10:39:11 -0400
Message-ID: <3afab67c-919b-b9ad-c558-55046a277aab@redhat.com>
References: <1472186949-9025-1-git-send-email-christophe.jaillet@wanadoo.fr>
 <cf61e699-9e2d-a594-64e6-43ea33b239d9@redhat.com>
 <2c923344-04c8-cdbd-ac06-047027f7a23a@redhat.com>
 <20160826192957.GG594@leon.nu>
 <e86e76dc-811b-7002-a35d-1e515c833d46@redhat.com>
 <20160828060640.GI594@leon.nu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="xhksEBRpRlx2u7mwxAo9B8KteQvHxFsl7"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160828060640.GI594-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Christophe JAILLET <christophe.jaillet-39ZsbGIQGT5GWvitb5QawA@public.gmane.org>, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--xhksEBRpRlx2u7mwxAo9B8KteQvHxFsl7
Content-Type: multipart/mixed; boundary="A3EH1tCxuuEeilcCiMnDeCq4QRE0PXhqd";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Christophe JAILLET <christophe.jaillet-39ZsbGIQGT5GWvitb5QawA@public.gmane.org>,
 mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org,
 sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <3afab67c-919b-b9ad-c558-55046a277aab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] IB/hfi1: Fix a parameter of find_first_bit.
References: <1472186949-9025-1-git-send-email-christophe.jaillet-39ZsbGIQGT5GWvitb5QawA@public.gmane.org>
 <cf61e699-9e2d-a594-64e6-43ea33b239d9-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <2c923344-04c8-cdbd-ac06-047027f7a23a-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <20160826192957.GG594-2ukJVAZIZ/Y@public.gmane.org>
 <e86e76dc-811b-7002-a35d-1e515c833d46-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <20160828060640.GI594-2ukJVAZIZ/Y@public.gmane.org>
In-Reply-To: <20160828060640.GI594-2ukJVAZIZ/Y@public.gmane.org>

--A3EH1tCxuuEeilcCiMnDeCq4QRE0PXhqd
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 8/28/2016 2:06 AM, Leon Romanovsky wrote:
> On Fri, Aug 26, 2016 at 03:34:48PM -0400, Doug Ledford wrote:
>> On 8/26/2016 3:29 PM, Leon Romanovsky wrote:
>>> On Fri, Aug 26, 2016 at 02:01:55PM -0400, Doug Ledford wrote:
>>>> On 8/26/2016 9:35 AM, Doug Ledford wrote:
>>>>> On 8/26/2016 12:49 AM, Christophe JAILLET wrote:
>>>>>> The 2nd parameter of 'find_first_bit' is the number of bits to sea=
rch.
>>>>>> In this case, we are passing 'sizeof(unsigned long)' which is like=
ly to
>>>>>> be 4 or 8.
>>>>>
>>>>> If the size can be 4 or 8, then using 64 universally is not correct=
=2E
>>>>> Why not use sizeof() * 8 (or << 3)?
>>>>
>>>> Better yet, why not put this patch in the kernel first:
>>>>
>>>> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
>>>> index d96a6118d26a..a8838c87668e 100644
>>>> --- a/include/linux/kernel.h
>>>> +++ b/include/linux/kernel.h
>>>> @@ -52,6 +52,8 @@
>>>>
>>>>  #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) +
>>>> __must_be_array(arr))
>>>>
>>>> +#define bitsizeof(x)   (sizeof((x)) << 3)
>>>> +
>>>>  #define u64_to_user_ptr(x) (           \
>>>>  {                                      \
>>>>         typecheck(u64, x);              \
>>>>
>>>> then start going around replacing all these hard coded numbers with =
the
>>>> use of bitsizeof().  It can be applied not just to the find_first*bi=
t()
>>>> routines, but to a bunch of other routines too.  Just look at
>>>> include/linux/bitmap.h and any that have nbits as an argument are
>>>> candidates.
>>>
>>> There is BITS_PER_LONG define for that. There is actual use of it in =
mlx5 for
>>> the similar code pieces.
>>
>> BITS_PER_LONG only works if your bitfield is a single long.  It doesn'=
t
>> work for other bitfields.  What I posted above will work for anything.=

>=20
> Yes, the question to ask if it is really needed.

A quick review of the usage of find_first_bit in the kernel shows that
the majority of uses that use large, complex bit arrays (things larger
than a single long, where bitsizeof(complex_object) might be helpful),
also tend to have limits to their bitmap sizes that do not directly
equal the size of the bitmap.  For example, the bitmap for an md raid
array is allocated as a chunk of memory, where the chunk of memory is
larger than the bitmap size as a general rule, so
bitsizeof(chunk_of_memory) would run off the end of the real bitmap.
Likewise for a number of other complex bitmaps (block layer tag in use
bitmap for instance).

So, is it useful?  I think so.  But it's not needed for original patch
in this thread.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--A3EH1tCxuuEeilcCiMnDeCq4QRE0PXhqd--

--xhksEBRpRlx2u7mwxAo9B8KteQvHxFsl7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXyY8PAAoJELgmozMOVy/dXcIQAIphS9TY+7dKIYjDDJTPi63R
rfpeIGadMOuc5VQb6FmmTD3mhECw62aRFQKuvu89I3lj2UOr2PpJ3rflsMA112cl
9W4lfXGZscaNJUKBxAv8fhkwhxdA8a2mCMf9ySttVOZ9RHQA9drGSh+T4NuXrAta
bWFZ/YtL9SK0w8r5nbGaDlN89UIPNDXToY3xHSf7hqnPYfmNopPt+LFGp/jLs0gS
ldZHAIRgOQpHE8siNxDaBBHXGPzwPDOHuPy400bBYYVuwUsUnmB4vJTvGJeUierZ
9gJL0lfDU2ShhvzHMuhC/5i6i9z8zO6FK4ShX/QYd0JRHcWrb2VTUJW7dsnhhs+i
sVqbkTkhbiC7GAp4mDJiSlV3rcsbDbQb7cC7FBoBJuteuvYK9+6p4FBvVIqPiFap
dqi5WrF8BbbsjRLadcKp3gSQRHAK+4GSfNyblJmSXwuXrn18t0BxFvgcK+sa+RNm
q+1CTsFZFLVQl0H7WC+JLrXlZrZOsrdAVEk4fHqAKS/hzBL36XkmuSZLsGP2ER7l
WJKRtdDVQU8wmIOHG9bL8rnc/KcOf4FXUZcKSoGYv/2+d6ailV7g4t0kxo3t9AWW
3mkpYX/0/HUZkbUuMPD4UcXeSXhxeF8+49LahXDv7ThG9PV79ojT/IX62n3/VR4t
ofkKiOPSzeXR2um36XYC
=EZrd
-----END PGP SIGNATURE-----

--xhksEBRpRlx2u7mwxAo9B8KteQvHxFsl7--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

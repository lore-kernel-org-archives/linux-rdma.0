From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH 1/2] IB/hfi1: Fix a parameter of find_first_bit.
Date: Sun, 4 Sep 2016 12:04:52 +0300
Message-ID: <20160904090452.GP21847@leon.nu>
References: <1472186949-9025-1-git-send-email-christophe.jaillet@wanadoo.fr>
 <cf61e699-9e2d-a594-64e6-43ea33b239d9@redhat.com>
 <2c923344-04c8-cdbd-ac06-047027f7a23a@redhat.com>
 <20160826192957.GG594@leon.nu>
 <e86e76dc-811b-7002-a35d-1e515c833d46@redhat.com>
 <20160828060640.GI594@leon.nu>
 <3afab67c-919b-b9ad-c558-55046a277aab@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="h5TCuzcqTWZxfGfk"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3afab67c-919b-b9ad-c558-55046a277aab@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>, mike.marciniszyn@intel.com, dennis.dalessandro@intel.com, sean.hefty@intel.com, hal.rosenstock@gmail.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--h5TCuzcqTWZxfGfk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 02, 2016 at 10:39:11AM -0400, Doug Ledford wrote:
> On 8/28/2016 2:06 AM, Leon Romanovsky wrote:
> > On Fri, Aug 26, 2016 at 03:34:48PM -0400, Doug Ledford wrote:
> >> On 8/26/2016 3:29 PM, Leon Romanovsky wrote:
> >>> On Fri, Aug 26, 2016 at 02:01:55PM -0400, Doug Ledford wrote:
> >>>> On 8/26/2016 9:35 AM, Doug Ledford wrote:
> >>>>> On 8/26/2016 12:49 AM, Christophe JAILLET wrote:
> >>>>>> The 2nd parameter of 'find_first_bit' is the number of bits to search.
> >>>>>> In this case, we are passing 'sizeof(unsigned long)' which is likely to
> >>>>>> be 4 or 8.
> >>>>>
> >>>>> If the size can be 4 or 8, then using 64 universally is not correct.
> >>>>> Why not use sizeof() * 8 (or << 3)?
> >>>>
> >>>> Better yet, why not put this patch in the kernel first:
> >>>>
> >>>> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> >>>> index d96a6118d26a..a8838c87668e 100644
> >>>> --- a/include/linux/kernel.h
> >>>> +++ b/include/linux/kernel.h
> >>>> @@ -52,6 +52,8 @@
> >>>>
> >>>>  #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) +
> >>>> __must_be_array(arr))
> >>>>
> >>>> +#define bitsizeof(x)   (sizeof((x)) << 3)
> >>>> +
> >>>>  #define u64_to_user_ptr(x) (           \
> >>>>  {                                      \
> >>>>         typecheck(u64, x);              \
> >>>>
> >>>> then start going around replacing all these hard coded numbers with the
> >>>> use of bitsizeof().  It can be applied not just to the find_first*bit()
> >>>> routines, but to a bunch of other routines too.  Just look at
> >>>> include/linux/bitmap.h and any that have nbits as an argument are
> >>>> candidates.
> >>>
> >>> There is BITS_PER_LONG define for that. There is actual use of it in mlx5 for
> >>> the similar code pieces.
> >>
> >> BITS_PER_LONG only works if your bitfield is a single long.  It doesn't
> >> work for other bitfields.  What I posted above will work for anything.
> >
> > Yes, the question to ask if it is really needed.
>
> A quick review of the usage of find_first_bit in the kernel shows that
> the majority of uses that use large, complex bit arrays (things larger
> than a single long, where bitsizeof(complex_object) might be helpful),
> also tend to have limits to their bitmap sizes that do not directly
> equal the size of the bitmap.  For example, the bitmap for an md raid
> array is allocated as a chunk of memory, where the chunk of memory is
> larger than the bitmap size as a general rule, so
> bitsizeof(chunk_of_memory) would run off the end of the real bitmap.
> Likewise for a number of other complex bitmaps (block layer tag in use
> bitmap for instance).
>
> So, is it useful?  I think so.  But it's not needed for original patch
> in this thread.

Honestly, I wasn't convinced at all, but you are right,
it is theoretical discussion.

Thanks

>
>
> --
> Doug Ledford <dledford@redhat.com>
>     GPG Key ID: 0E572FDD
>




--h5TCuzcqTWZxfGfk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXy+O0AAoJEORje4g2clinoYUP/3RKhFGjsJEZf79Z9Qaruvad
vmYJBMzYHp8Rtw/Qi0vX3CBTGIHctqw28TS9mTFw6Bnwp3l2ExR1K6RkRyFHHa2k
2wEoozxT8uLNvQF2LoXRcz2e4fg9k3HEJUaePwcdyRA6uwq7wwHAhAXEhcIlQaB+
zhOJcF4jqDP6prhHf6qzqzgu2T6vThXRMABEFaqjVh3nrMNRnKSabYhnok1bw1b8
mF9ch3K8THYGBqivnZvNrTw2xTkPTHZW3Y5ElN8dP3WFK2oIs3LXntnUxS5RAfIB
ddIWo1NcI1J3GF6WeEbcIOZY+aPSFidowh8PnzOLzxYZflooJvFkGEZTX56bls+p
wtvYtLUPlNPFLO6kjdixP3/gAG+jIyK52yygVPnzrLOx713opAfCdQcuSw1ov3ZK
FfK9YzP3S6Xd2CBAQwTs0UBybIQk3XmnJbdkrmDilQdMi0lkOoranN+0eY8dXLzg
a1SRlQGy0fi6xvbHTnknyGVBgBamM6EPbt54JDAf5gZ7KFA1hXabcu+eEIqfK1e8
v88dfnX/RbnycPkKzwxPwwtOuw06CtvNJHyprfLAu6DUvdhM2rdLMfMGSXcMjTZM
ARgkxWxtcAmFXdHEJ6Z6azbtpGmGTFuiqhbZOsdPVcKZ4n6qPTJwqOOp/wtBTs4/
lI23Kgmtnhbtm4IQDamZ
=pmvU
-----END PGP SIGNATURE-----

--h5TCuzcqTWZxfGfk--

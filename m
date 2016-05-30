From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 libibverbs 2/7] Add member functions to poll an
 extended CQ
Date: Mon, 30 May 2016 09:50:07 -0400
Message-ID: <8708a378-4c48-df98-86a4-d210bbe690b5@redhat.com>
References: <1464533475-18949-1-git-send-email-yishaih@mellanox.com>
 <1464533475-18949-3-git-send-email-yishaih@mellanox.com>
 <574B6F71.9060808@redhat.com> <20160529233009.GA12420@obsidianresearch.com>
 <8F7BC9E2-75EC-413B-BEBE-11450225AF06@redhat.com>
 <4958edf4-7296-26c9-4cbe-8fab45be11a3@mellanox.com>
 <4e8befc4-aec5-a17d-24ce-40ff97d345da@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="lsUCREgJUPPcwoGjPiAW3HweBO8CT3uhj"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4e8befc4-aec5-a17d-24ce-40ff97d345da-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--lsUCREgJUPPcwoGjPiAW3HweBO8CT3uhj
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

Resend because of my mailer...

On 05/30/2016 09:46 AM, Doug Ledford wrote:
> On 05/30/2016 03:47 AM, Matan Barak wrote:
>> On 30/05/2016 02:47, Doug Ledford wrote:
>=20
>>> Today's version has a data copy. What I'm suggesting here eliminates
>>> that entirely and all of the branches can be optimized away at compil=
e
>>> time, leaving a load from a hot cache line of an offset value and the=
n
>>> a direct load from that offset in the hcqe. I would think that becaus=
e
>>> of the elimination of the data copy and the compile time elimination
>>> of branches, this has the potential to meet or exceed today's
>>> implementation. I would certainly like to see the numbers.
>>>
>>
>> Not necessarily, smart compiler could fetch the data straight from the=

>> hardware's CQE and pass it through a register.
>=20
> Not while still maintaining multi-device capability.  What I laid out
> works without having to compile for a specific piece of hardware.
>=20
>>>> This is a whole picture optimization and the user side is only one
>>>> part of the equation - the function pointer scheme is also optimizin=
g
>>>> the driver path quite heavily, which is why it is showing positively=

>>>> in benchmarks.
>>>
>>> Passing an opaque hcqe pointer to the user and then only getting the
>>> data they want out of it should similarly help optimize the driver's
>>> path I would think.
>>>
>>
>> What if the driver's CQE format has a field which is split between two=

>> different offsets?
>=20
> I have an idea for that as well.
>=20
>> We looked at storing offsets and masks before implementing this and
>> supplying inline functions to get the various fields, but IMHO, that's=
 a
>> no go as it's not generic enough.
>>
>> Anyway, if you really want to tie yourself to one vendor, maybe we cou=
ld
>> allow static linking with the user-space driver and by using lto you
>> could get inline-like function behavior.
>=20
> No, what I'm outlining works with multi-vendor support.  It's opaque to=

> the user application.
>=20
> Now, as to how to handle complex fields.
>=20
> I was thinking of making the wc_elements enum encode some complex
> information.  Right now, it's just the offset number.  It would be
> possible to set each particular element as either A) simple offset, B)
> possibly complex (which means some vendors can do a simple offset and
> others need a complex function), or C) all complex.  Then the #define
> can be made smart enough to know the difference and on simple items
> return the data, on possibly complex items you have an if statement and=

> branch so we avoid this when possible but allows different hardware
> types to be handled, and on always complex items we are able to optimiz=
e
> down to just the call in the compiler.  Although, I freely admit that i=
f
> you have more than just a handful of these complex items then it likely=

> becomes cleaner to just do the "function call per wc element" way of
> doing things like your patch has.  But I doubt there are that many
> complex items in your CQE.  Do you have a count?
>=20
>=20
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--lsUCREgJUPPcwoGjPiAW3HweBO8CT3uhj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXTEUPAAoJELgmozMOVy/doIIQAI1q0bhK4v2VjnOTNRBGvioL
p9RfnCgYg50KNTrxtcstL1cKns8jc1m8HM1fE8LuKOA3M7SE8rdnRKOYSRTNznBH
HfFf0GK8hYhCBH8jdlAK/Lc+hoAHSN/9ULP//SMt/mEJfJ73mIixY/OOALz7giHC
hHTHHzfqPJtNCCuvAqkO3puIU6HOLKgvn/BaUXfddZL33+bLroFXz4WjHKQoIv1Q
7VOCfSGmVy0yYCIl/wLVCB7tt2tcCPfjWgdoxEIuD9qaIbIUIER3QfAZL5fVZEvk
tkmFhO/YtFFIKNgc029+bDp8oJzK4hfivkHIHQT9KO+m0YMYUwX2Mi6Vk/NtkpNQ
Jcu7wcomm332KduDmHTbiVcZRjMIZCbsWhmt6MAfI/thWuJ9ge3NolcGiDI/hVPH
sQhWq9u0B0414THW7bHEYa2n5vooJhvDb5+7dd9mojL+GPrwpQ5PsUCZzx72/fJJ
AQupzKRtD+JlNt0si1YA9ko3EvPBEMbGx3B0DhCTZFxcQMkoIYFIfnVhByzSzTAO
iAt/x9yrQVvYoTyCh4/AAqprNKgZWhtHpgqBEEO9G9AuLL1xC2Alwd/UU96pBVpF
vWX1FBSlGOysCfGHHT8z/aaIcC9RiRd80fND/4n/cQMfUKrZY0PlSdElGQmyuYYw
vySPcX7RUbrMQwHRnRRX
=4uH3
-----END PGP SIGNATURE-----

--lsUCREgJUPPcwoGjPiAW3HweBO8CT3uhj--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 0/2] IB/mlx5: Use tasklet to decrease completions
 processing time in interrupts
Date: Wed, 18 May 2016 10:48:25 -0400
Message-ID: <a6c058cd-929c-9f35-16fc-101467013572@redhat.com>
References: <1460902121-5567-1-git-send-email-matanb@mellanox.com>
 <20160418130456.GA11508@infradead.org> <5714DF68.6040509@mellanox.com>
 <a93b20ca-42bf-ca2b-2995-aa2837a1bafe@redhat.com>
 <868e5bcf-18c5-30f4-fe3f-b361c0ce43ec@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="4FjSXh0mpsRq3kAMmafPPlwCLWgMLiLVf"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <868e5bcf-18c5-30f4-fe3f-b361c0ce43ec-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--4FjSXh0mpsRq3kAMmafPPlwCLWgMLiLVf
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 05/15/2016 03:31 AM, Matan Barak wrote:
> On 13/05/2016 23:16, Doug Ledford wrote:
>> On 04/18/2016 09:21 AM, Matan Barak (External) wrote:
>>> On 18/04/2016 16:04, Christoph Hellwig wrote:
>>>> On Sun, Apr 17, 2016 at 05:08:39PM +0300, Matan Barak wrote:
>>>>> Hi Doug,
>>>>>
>>>>> The mlx5 driver handles completion callbacks inside interrupts.
>>>>> These callbacks could be lengthy and thus cause hard lockups.
>>>>> In order to avoid these lockups, we introduce a tasklet mechanism.
>>>>> The mlx5_ib driver uses this mechanism in order to defer its
>>>>> completion callbacks processing to the tasklet.
>>>>>
>>>>> This follows the same mechanism we implemented for mlx4 that
>>>>> successfully decreased the processing time in interrupts.
>>>>
>>>> Just curious:  how much of this time is spent inside the mlx5 driver=
,
>>>> and how much is spent in the callbacks from the consumers?  We've no=
w
>>>> more than half done with switch the kernel ULPs to the new CQ API
>>>> which will always offload the callbacks to softirq or workqueue
>>>> context,
>>>> so if we can avoid a previous offload the completions would be a lot=

>>>> more efficient.
>>>>
>>>
>>> In short, you could hit a situation where processing the completions =
in
>>> the interrupt takes longer than the rate at which they arrive (lab ca=
ses
>>> that use one event queue, but still).
>>> I agree that going to softirqs/WQs (like the rest of the offloads) is=
 a
>>> good solution too - maybe even better than this one as the mechanism
>>> already exists, but why would it be a lot more efficient?
>>>
>>
>> Given the amount of the kernel converted to the new CQ API, are you gu=
ys
>> still looking to have this included?
>>
>=20
> Using irqpoll might be better, although - If I got things right it
> really polls the CQ instead of just notifying the user-space it has som=
e
> work to do (because it handles kernel usages probably). So, in order to=

> use the current approach for user-space, we might needs to change it a
> bit (unless I missed something).
>=20
> Saying that, because we're risking here at having a hard lockup and the=

> mlx4 driver already uses this proposed method successfully, I'll be ver=
y
> happy if we can merge this and look at migrating to the new CQ API late=
r
> if it makes sense here.

I've taken these, but I want you to look into whether or not the CQ API
is the next appropriate things to use here.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--4FjSXh0mpsRq3kAMmafPPlwCLWgMLiLVf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXPIC5AAoJELgmozMOVy/dOjkQAIq2z9fLO0Moq0OHiWOXmB0i
w+32LFI8Ad7EbmtTiTtSmBVo1yCKFzIFqh5j93hbOF2fhOqulSZxryY1qYiaSHof
d4s8K0Lsg3BkLAws7VU1b7KRRF9oRlO2flmOJiblmYiprdftj66KjByBhV3NBt3y
YLV8Q+5rxbEOOzDH5AOGP0FcxqV+bSPt6CR4bgS3UaXRjq7b+cbZnFdpZycHDUF9
U+zUL0sADJwI+7Hi9xrSzP2wHU1iyhebvapf2iQ0Na35Qds6TnjK/4ILMLtACJuf
XOF9MSamVKv3sV+FQwfiMu8T8Xaw+swotJ2Qz1NlAgmfXW1tifnDVP488PIZpT8F
VpcgY44Qo4x9J97PELZP08jynuRcDRbuk0iR3EJYASNrMV9Ce2f4T1LAEIcc9kCj
TzBfbdXUroPquav1lvVw8kMJX9BarmpUZxBiCAQeGvd/sWEfaVIz43bBBqL+WQnX
yDoAZ1gFsDd5oK4OYbv9wVcv4dm9CKM7f4v4aaeokVkNxbS7ZMhU5jXSPJwJt/97
EKUlsvhs1uNFxae2//xF+NAosbNCCj077/HovsUl/8QERNx9Pa+VnJCNtUgj1G3b
+JlQsXHux2CZAro6c5YfgoAi+q2pUshBX56T2soXoJIqdnkM91d0255JfKlOq+6w
iGROHFPJlLHIh6GPH39i
=dpw4
-----END PGP SIGNATURE-----

--4FjSXh0mpsRq3kAMmafPPlwCLWgMLiLVf--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

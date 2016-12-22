From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/3] IB/rxe: Three small fixes
Date: Thu, 22 Dec 2016 14:19:50 -0500
Message-ID: <2a4a2187-1ac8-e341-4ed9-257384ff2199@redhat.com>
References: <1482414878-6892-1-git-send-email-andrew.boyer@dell.com>
 <9f5e0225-c53e-43e7-13b5-ae715f74b198@redhat.com>
 <20161222171833.GD18935@mtr-leonro.local>
 <c8463d5a-f2ac-7474-93dd-42a2e263834d@redhat.com>
 <20161222190555.GE18935@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="EbROm9OALPmfVOsmLeT2s3kJwKR4AmN5X"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161222190555.GE18935-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--EbROm9OALPmfVOsmLeT2s3kJwKR4AmN5X
Content-Type: multipart/mixed; boundary="83xFm9HpbDM2kxUjfxHrQpR5r2mLFXHo4";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org,
 yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <2a4a2187-1ac8-e341-4ed9-257384ff2199-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/3] IB/rxe: Three small fixes
References: <1482414878-6892-1-git-send-email-andrew.boyer-8PEkshWhKlo@public.gmane.org>
 <9f5e0225-c53e-43e7-13b5-ae715f74b198-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <20161222171833.GD18935-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
 <c8463d5a-f2ac-7474-93dd-42a2e263834d-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <20161222190555.GE18935-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
In-Reply-To: <20161222190555.GE18935-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>

--83xFm9HpbDM2kxUjfxHrQpR5r2mLFXHo4
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/22/2016 2:05 PM, Leon Romanovsky wrote:
> On Thu, Dec 22, 2016 at 01:33:43PM -0500, Doug Ledford wrote:
>> On 12/22/2016 12:18 PM, Leon Romanovsky wrote:
>>> On Thu, Dec 22, 2016 at 11:41:24AM -0500, Doug Ledford wrote:
>>>> On 12/22/2016 8:54 AM, Andrew Boyer wrote:
>>>>> This patch series addresses two issues found during heavy traffic
>>>>> testing as well as a recently-reported Smatch issue.
>>>>>
>>>>> Andrew Boyer (3):
>>>>>   IB/rxe: Use BTH_PSN_MASK when ACKing duplicate sends
>>>>>   IB/rxe: Drop future atomic/read packets rather than retrying
>>>>>   IB/rxe: Don't check for null ptr in send()
>>>>>
>>>>>  drivers/infiniband/sw/rxe/rxe_comp.c | 2 +-
>>>>>  drivers/infiniband/sw/rxe/rxe_net.c  | 3 +--
>>>>>  drivers/infiniband/sw/rxe/rxe_resp.c | 3 ++-
>>>>>  3 files changed, 4 insertions(+), 4 deletions(-)
>>>>>
>>>>
>>>> Thanks, series applied.
>>>
>>> Hi Doug,
>>>
>>> Thank you for such fast response, but can you please give enough time=
 to
>>> other reviewers/relevant maintainers to take a look on them before
>>> applying?
>>
>> If the patches look like they need review, I wait for review.  These d=
id
>> not meet that criteria IMO.
>=20
> Two of three are trivial, and another one is worth to take an extra tim=
e
> to review.

Which one did you think was not trivial?


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--83xFm9HpbDM2kxUjfxHrQpR5r2mLFXHo4--

--EbROm9OALPmfVOsmLeT2s3kJwKR4AmN5X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYXCdWAAoJELgmozMOVy/d5WMQAKobuIDJnt2J4ZSXnnHmnlFn
qrS7Ay0PYGlo0ZpQWwRt9/pQ6Yh2qb/u51hsKE+FoxKvs2f3nsF4YSXvagxyDtOG
oH8k65loBNgtUZNSh3FxJ9NTONs5HpHuD2S1XXf7SEYCePlRm5V1os5osqhFYmrd
3E83Fsgg9HZxgdZ6C6bKR3w8MeeW4xTwQXaKlOSIe+PzfFf5d4oOhLpIRM2hj1A0
kqR85uENevSxO9fJBHGaGe2xOdniWUro14gSqMjn9/Lyij60Y7k0FwSoJOWGsDzc
PVm5YRku6QR1y4HhSS51nJ6vHpo7RxQ8SY/ghenIUZSYINIRieCeOFdA/fAAQrQP
o5QdrwT2gF7YsGWyq5nRfbdpL/OyBXkVF80qKhUGPnTzBuuohy7vHqe29xiGtzf2
Gd16r7CHiHsHhuDvYFWW0NDm4t2NT3m+ycIolP1WxBjDZ1at+5zbyhJPYsSKBA1G
i5NBq+5QXH9MDtg+6zPUsir38h75lwZY4iG0u5SLiIVlMObSDNd2/purpmCPclmo
RBwL6x00u5Tw/8aTfkmH+LKVBriQygK/mlXGVyUk9+nR5xcll/4ApBDQLlGzx+Gi
6FAMAu30eo5axQ5uf10Uml5YJXwqN79ewkRsJaK63pkLZ26YC5cUEZSs2ssx5bho
S46agKOAsVK4vrvLHRor
=ulyd
-----END PGP SIGNATURE-----

--EbROm9OALPmfVOsmLeT2s3kJwKR4AmN5X--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

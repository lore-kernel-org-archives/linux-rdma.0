From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/3] IB/rxe: Three small fixes
Date: Thu, 22 Dec 2016 16:39:52 -0500
Message-ID: <e67c2087-6e92-9618-a1ca-225f49176577@redhat.com>
References: <1482414878-6892-1-git-send-email-andrew.boyer@dell.com>
 <9f5e0225-c53e-43e7-13b5-ae715f74b198@redhat.com>
 <20161222171833.GD18935@mtr-leonro.local>
 <c8463d5a-f2ac-7474-93dd-42a2e263834d@redhat.com>
 <20161222190555.GE18935@mtr-leonro.local>
 <2a4a2187-1ac8-e341-4ed9-257384ff2199@redhat.com>
 <20161222202316.GA14178@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="4NNqEp7HTvSEQBjhXBuX4QcW8APxU46VT"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161222202316.GA14178-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--4NNqEp7HTvSEQBjhXBuX4QcW8APxU46VT
Content-Type: multipart/mixed; boundary="9CpO48S707o0jSPHhAH3IbGieusdppLjB";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org,
 yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <e67c2087-6e92-9618-a1ca-225f49176577-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/3] IB/rxe: Three small fixes
References: <1482414878-6892-1-git-send-email-andrew.boyer-8PEkshWhKlo@public.gmane.org>
 <9f5e0225-c53e-43e7-13b5-ae715f74b198-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <20161222171833.GD18935-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
 <c8463d5a-f2ac-7474-93dd-42a2e263834d-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <20161222190555.GE18935-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
 <2a4a2187-1ac8-e341-4ed9-257384ff2199-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <20161222202316.GA14178-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
In-Reply-To: <20161222202316.GA14178-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>

--9CpO48S707o0jSPHhAH3IbGieusdppLjB
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/22/2016 3:23 PM, Leon Romanovsky wrote:
> On Thu, Dec 22, 2016 at 02:19:50PM -0500, Doug Ledford wrote:
>> On 12/22/2016 2:05 PM, Leon Romanovsky wrote:
>>> On Thu, Dec 22, 2016 at 01:33:43PM -0500, Doug Ledford wrote:
>>>> On 12/22/2016 12:18 PM, Leon Romanovsky wrote:
>>>>> On Thu, Dec 22, 2016 at 11:41:24AM -0500, Doug Ledford wrote:
>>>>>> On 12/22/2016 8:54 AM, Andrew Boyer wrote:
>>>>>>> This patch series addresses two issues found during heavy traffic=

>>>>>>> testing as well as a recently-reported Smatch issue.
>>>>>>>
>>>>>>> Andrew Boyer (3):
>>>>>>>   IB/rxe: Use BTH_PSN_MASK when ACKing duplicate sends
>>>>>>>   IB/rxe: Drop future atomic/read packets rather than retrying
>>>>>>>   IB/rxe: Don't check for null ptr in send()
>>>>>>>
>>>>>>>  drivers/infiniband/sw/rxe/rxe_comp.c | 2 +-
>>>>>>>  drivers/infiniband/sw/rxe/rxe_net.c  | 3 +--
>>>>>>>  drivers/infiniband/sw/rxe/rxe_resp.c | 3 ++-
>>>>>>>  3 files changed, 4 insertions(+), 4 deletions(-)
>>>>>>>
>>>>>>
>>>>>> Thanks, series applied.
>>>>>
>>>>> Hi Doug,
>>>>>
>>>>> Thank you for such fast response, but can you please give enough ti=
me to
>>>>> other reviewers/relevant maintainers to take a look on them before
>>>>> applying?
>>>>
>>>> If the patches look like they need review, I wait for review.  These=
 did
>>>> not meet that criteria IMO.
>>>
>>> Two of three are trivial, and another one is worth to take an extra t=
ime
>>> to review.
>>
>> Which one did you think was not trivial?
>=20
> Personaly for me, it was second patch from the series.

That patch was found by experience.  Even if it isn't totally correct,
it improved the specific situation.  I'm fine taking that patch and if
the maintainer of rxe thinks there is a better way, I'm open to follow
on patches.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--9CpO48S707o0jSPHhAH3IbGieusdppLjB--

--4NNqEp7HTvSEQBjhXBuX4QcW8APxU46VT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYXEgoAAoJELgmozMOVy/d4xoQAKN4p3Ep8ZYNd/z5fQLTsnl8
7t592MM+PkCvf+EQSe5Ast9xbZ5cSe94VFFYZzAT5aC8LemZ6eaQdXMIRVtUDuHi
WiKInO8lvv5CVwSuPO2CiKxkEkXQl5QUPmX1QVE1nL1lXbiIX7mElxWWbXHSLOxw
8j/xyxfQ2ifWqwF3XqXaHta2L9yUNeWVVLQMWkBxOwiITuApWR2MHO8KQ82ICLwG
zTdsXjcIaEpifle8SJ/42MmDUJxOW4IYfbw8+/vGGPHpsBVe7M/1TVQjposOA6wF
nnbV+d2dfEB19mL1Z9DJzF6bgqwQfJpzAAOhvAxhaNKVdnSIOi2p5kT7cn7G/Ay3
YFG3UJqKGMH14hJgkceGRqW8+OjLrtoc2ExGRLFl8K38FHw5kTrzB5JVljOLvmbj
dTQbbMFWmPyt1MOEQXUH440n7BRwP6xuQmky/Y88szgy4l5hWKC769hNhfthEI9k
dWnNiWTkY727SYkC6198OO0CLa1UxVq2PfdPZ9IqVNoejoCzMep6OfbH8VMde4Kq
aytb/r894cqL0aLF1knrK0kQHmeh09itEjTQU1HPxMzR/GVctpksLI3pqW4W2xhO
qxhj/Tsp8JtdPsQtW5gdkPtFG0uorp9JP5FazjERABGZiJrWUR/il/f3WXhUHGT3
yN88iJ5HZwwyV0WFKq0j
=UbfI
-----END PGP SIGNATURE-----

--4NNqEp7HTvSEQBjhXBuX4QcW8APxU46VT--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

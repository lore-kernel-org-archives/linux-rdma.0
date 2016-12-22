From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/3] IB/rxe: Three small fixes
Date: Thu, 22 Dec 2016 13:33:43 -0500
Message-ID: <c8463d5a-f2ac-7474-93dd-42a2e263834d@redhat.com>
References: <1482414878-6892-1-git-send-email-andrew.boyer@dell.com>
 <9f5e0225-c53e-43e7-13b5-ae715f74b198@redhat.com>
 <20161222171833.GD18935@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="hsemUMLUdH4Vw7DEqiq5uLHcqe7QSeiV0"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161222171833.GD18935-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--hsemUMLUdH4Vw7DEqiq5uLHcqe7QSeiV0
Content-Type: multipart/mixed; boundary="xKdLac0b0vOW5drOdJPk3uTUB4Eb0jnOk";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org,
 yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <c8463d5a-f2ac-7474-93dd-42a2e263834d-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/3] IB/rxe: Three small fixes
References: <1482414878-6892-1-git-send-email-andrew.boyer-8PEkshWhKlo@public.gmane.org>
 <9f5e0225-c53e-43e7-13b5-ae715f74b198-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <20161222171833.GD18935-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
In-Reply-To: <20161222171833.GD18935-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>

--xKdLac0b0vOW5drOdJPk3uTUB4Eb0jnOk
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/22/2016 12:18 PM, Leon Romanovsky wrote:
> On Thu, Dec 22, 2016 at 11:41:24AM -0500, Doug Ledford wrote:
>> On 12/22/2016 8:54 AM, Andrew Boyer wrote:
>>> This patch series addresses two issues found during heavy traffic
>>> testing as well as a recently-reported Smatch issue.
>>>
>>> Andrew Boyer (3):
>>>   IB/rxe: Use BTH_PSN_MASK when ACKing duplicate sends
>>>   IB/rxe: Drop future atomic/read packets rather than retrying
>>>   IB/rxe: Don't check for null ptr in send()
>>>
>>>  drivers/infiniband/sw/rxe/rxe_comp.c | 2 +-
>>>  drivers/infiniband/sw/rxe/rxe_net.c  | 3 +--
>>>  drivers/infiniband/sw/rxe/rxe_resp.c | 3 ++-
>>>  3 files changed, 4 insertions(+), 4 deletions(-)
>>>
>>
>> Thanks, series applied.
>=20
> Hi Doug,
>=20
> Thank you for such fast response, but can you please give enough time t=
o
> other reviewers/relevant maintainers to take a look on them before
> applying?

If the patches look like they need review, I wait for review.  These did
not meet that criteria IMO.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--xKdLac0b0vOW5drOdJPk3uTUB4Eb0jnOk--

--hsemUMLUdH4Vw7DEqiq5uLHcqe7QSeiV0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYXByHAAoJELgmozMOVy/dBAwP/jAOvrZxgPcO8hyXHUBVGWi8
SDdvmSqNyN/0ST+CGoUgnJX3mZv8EX0wc4Lce+8X3cHGCLOVypsW3tauywYxexuT
vsgrfJiGRo7GEinbN99u6qKB+Exx+MlPTL/vKVbGKocJg+1UPiuBYJ+YBWPHA++q
oRscr95/I/9+FuCx19YmPEVtIbSPF87qsgiKobqTzrCGzf25HRt1BTSJUomFxE3+
pEpHWxm4T+Mh3QsdeEPXLgTe+dADKAFqZa2NS7qJ03Y0izNDmjeFvDrCYEwAxjlL
wzbpXncUsQsmuut/IScQ1WpU6rZFHUvoG0+fcCnElc2zvzkkWSdIgHyIuOYkHdh5
nmMD6dsyzlfiLCW+Rb3Awa5X28qI5PwupJDPfK3IrwaaQKyXGqKsWteuFHOl0cE6
er+vgnZv0fh80LOii2fzh3Gu7KF2eym2X4LrjUnXamjg4lwem5YlrPWCVR8P4Lup
LPCvuKo0F+0WBqffTnqF+R1JONVvxS3jRzgEOHN21gYapK3dv8THcCujidQsP8kP
dj7G/GhBqanu+Sdfi3rUMzk8tTQXLTLXFFyVLnrdw9mx5i88ZkVpQuzj0fd14CKu
gRtRddvf6sCX7yG8YjVbpzGh5EqEKWqMeBBuQabSa1tXMbhaJ+wp2lsPDV67aZdh
wsUVHdtqZJdajmfDjb5m
=zthl
-----END PGP SIGNATURE-----

--hsemUMLUdH4Vw7DEqiq5uLHcqe7QSeiV0--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next V3 6/6] RDMA/core: Unify style of IOCTL commands
Date: Fri, 23 Sep 2016 13:31:18 -0400
Message-ID: <42ecd9c2-aabd-c907-8518-a2254488494d@redhat.com>
References: <1472988635-31463-1-git-send-email-leon@kernel.org>
 <1472988635-31463-7-git-send-email-leon@kernel.org>
 <20160905053342.GW21847@leon.nu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="islSlmW2VLLBlonIL5SErcri8f1d4s1gO"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160905053342.GW21847-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--islSlmW2VLLBlonIL5SErcri8f1d4s1gO
Content-Type: multipart/mixed; boundary="oBVVautdOWAaPUIRlAUmEWdb9lNiLd6do";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
 Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Message-ID: <42ecd9c2-aabd-c907-8518-a2254488494d-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next V3 6/6] RDMA/core: Unify style of IOCTL commands
References: <1472988635-31463-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
 <1472988635-31463-7-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
 <20160905053342.GW21847-2ukJVAZIZ/Y@public.gmane.org>
In-Reply-To: <20160905053342.GW21847-2ukJVAZIZ/Y@public.gmane.org>

--oBVVautdOWAaPUIRlAUmEWdb9lNiLd6do
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 9/5/2016 1:33 AM, Leon Romanovsky wrote:
> On Sun, Sep 04, 2016 at 02:30:35PM +0300, Leon Romanovsky wrote:
>> From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>
>> MAD and HFI1 have different naming convention, this patch
>> simplifies and unifies their defines and names.
>>
>> As part of cleanup, the HFI1 _NUM() macro and command indexes
>> were removed. It has a potential to break applications which use
>> these defines directly, while shouldn't.
>>
>> Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> Reviewed-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
>> ---
>>  include/uapi/rdma/rdma_user_ioctl.h | 98 ++++++++++++++--------------=
---------
>>  1 file changed, 38 insertions(+), 60 deletions(-)
>>
>=20
> <....>
>=20
>>  /*
>> - * User IOCTLs can not go above 128 if they do then see common.h and =
change the
>> - * base for the snoop ioctl
>> + * General blocks assignments
>> + * It is closed on purpose do not expose it it user space
>=20
> Doug,
> Do you mind to change "it it" to be "it to" and save to everyone
> respin?

Fixed.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--oBVVautdOWAaPUIRlAUmEWdb9lNiLd6do--

--islSlmW2VLLBlonIL5SErcri8f1d4s1gO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJX5WbmAAoJELgmozMOVy/dqWwP/1nwlCZYqLCQeI6Qk178ZraY
77ZQHpUit3SlGTDI6+4pIFxLeSZ9fuWCqJkBnHCxbtAg0+uQ5yncmW2pz3lwd4LP
99vCwCbBNUHetYotAzkm+uKJR7kDPtnBZeWsGd7AK7ZWbIJzNDpZnnLxaMX0S45X
ckhZqicup52HSE/FWOFu5JqGUsEnfSq//JihQ6Rh8VtYYyZX9ILdiRKlD+Awctdm
cOajmOnCyMZvGCyVRwZAGzxxG9lWADUh0OKAVNBHyHbx1AOEEz+B3AsC4XE7uoZs
zIJCODf7WKGNBG5RW4O01m4CiFdV76WscrAEa/XnJn9dUvtQ1LGLsud6pyV2N9Wg
uJzizk+bko0qLeHMA4ER8x5N2qBipxKkYWM9RD7itD3WngkLdcWJ+jRvzG3bLHSy
ju7gDZ6FHok4O+BlejjbHSSsnxEV8mBiY0Hcx2+3r5R0liDphcR9tyBZpEf8iF+r
MyAl3KOqgVeYKuDkt7amkzyIijUzbh2Pki0BGxNQBRHHUEvAPCTI02Rd5UQXmFsX
Mbp681rrL9BtNSyJV9JK6Sdm2mhZ3apirQfkPlBNtkPjyhfu1FLOEQv9ClUHR3oX
iShUkEiSAJxQibV3/2KIyKzJetwURWtU/JR8J5T3oFaa4yuW3SmkOs9FosIHfsFI
ay9AwuPViWajCLDedrzv
=sc2J
-----END PGP SIGNATURE-----

--islSlmW2VLLBlonIL5SErcri8f1d4s1gO--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

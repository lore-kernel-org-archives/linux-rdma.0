From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/1] IB/isert: Properly release resources on
 RDMA_CM_EVENT_DEVICE_REMOVAL
Date: Fri, 2 Sep 2016 13:21:30 -0400
Message-ID: <32630698-d331-1b85-8939-819adae61dcd@redhat.com>
References: <20160829114549.6635-1-rajur@chelsio.com>
 <ae587bf0-3dd0-6e38-c589-565c6dcbcf2b@grimberg.me>
 <20160829130518.GE594@leon.nu>
 <aa94ae4d-c429-29c1-b04e-065274c17d9d@grimberg.me>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="10rAWB4QkckmAjOs2Ftkj989HHCXO5tJC"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <aa94ae4d-c429-29c1-b04e-065274c17d9d-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Raju Rangoju <rajur-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--10rAWB4QkckmAjOs2Ftkj989HHCXO5tJC
Content-Type: multipart/mixed; boundary="AGd5pHeQkpJhrORm46x9t4gK8V9wHC4DS";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Raju Rangoju <rajur-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org
Message-ID: <32630698-d331-1b85-8939-819adae61dcd-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/1] IB/isert: Properly release resources on
 RDMA_CM_EVENT_DEVICE_REMOVAL
References: <20160829114549.6635-1-rajur-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
 <ae587bf0-3dd0-6e38-c589-565c6dcbcf2b-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
 <20160829130518.GE594-2ukJVAZIZ/Y@public.gmane.org>
 <aa94ae4d-c429-29c1-b04e-065274c17d9d-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
In-Reply-To: <aa94ae4d-c429-29c1-b04e-065274c17d9d-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>

--AGd5pHeQkpJhrORm46x9t4gK8V9wHC4DS
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 8/29/2016 9:16 AM, Sagi Grimberg wrote:
>> Sagi,
>> Why 4.9? It looks like a good candidate (fix) to be in 4.8.
>=20
> Next round of 4.8-rc is good too.

I had been watching to see if Nick took this from the first submission
and if he didn't I had planned to.  It's now in my next -rc queue.  Thank=
s.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--AGd5pHeQkpJhrORm46x9t4gK8V9wHC4DS--

--10rAWB4QkckmAjOs2Ftkj989HHCXO5tJC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXybUaAAoJELgmozMOVy/dG/cQAJqiP7Cml0hMbbKlH0pZhSqW
tpNFsc5AW0WTfcI1XFwRq917ZuaMvhctPC2Zujn8YAHOq/v9s8dLw57HDjRN4pGS
ik/vwml6jRFJiPtvIg43DrW6UD50bscjUzziD0nJsqxA5a6KpoC+rkM6ODoXiA2Z
4mwy8BpnHZ93IFteQqwXy4NsXQKicurLPsPZmhTfUMcHFAZOYu/2dxaOn8Ejbwro
hERTAhdJKW1oZ+Z2rQtW5IMyJc5ZunAHiBe01Ls/80QTLbwBupEHYsxAyyNjkggF
Dd/sO/uoW5k5nvSKIAk9+dUyZl4+UHbdkSmcltYwYkOoBszVm8+YWmsdKFEMp+Zn
riXJ9irCI6JONaim5TUwVX8m1aevUqOPGjbPQm8QPPNZ0xqeW57hV+1M3D+R8HmK
gfhJq/p8/q0eSZHS8tgoAO0O8vfO6xnz3ZEhKiRePTQggSlV3Q9j9Hfep7nvyW6x
j4lUtUWZTJ7fvMMmOS8Ii1pEjqIuvKA7TZQXb4L7bft3998hNXrQvMYEZ5ivR7XJ
xamj6bPlhQxyxesDFfAh4mtbd9oYUXnI0NUHf9sIqh+8m8jBMwPxvEfPFYd5J4lO
7fRd+gQXEic75FegdYkJqfKBgHFAAdYELhCkDQO8SSl1w1GAy12mz4v6f0KuIenG
itjyQU0JoxTo1FfxZn3n
=0xSk
-----END PGP SIGNATURE-----

--10rAWB4QkckmAjOs2Ftkj989HHCXO5tJC--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

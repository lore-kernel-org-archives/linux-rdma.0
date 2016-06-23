From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/2] Add IPv6 support to flow steering
Date: Thu, 23 Jun 2016 09:59:49 -0400
Message-ID: <510472ec-da1f-d159-4e89-d3769a51b49b@redhat.com>
References: <1466165691-32538-1-git-send-email-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="H9oWk5GX9V5rF3hT6QB0DrOsJAbCr8Out"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1466165691-32538-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--H9oWk5GX9V5rF3hT6QB0DrOsJAbCr8Out
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 06/17/2016 08:14 AM, Leon Romanovsky wrote:
> The following two patches add and enable IPv6 support to flow
> steering.
>=20
> Maor Gottlieb (2):
>   IB/core: Add IPv6 support to flow steering
>   IB/mlx5: Enable flow steering for IPv6 traffic
>=20
>  drivers/infiniband/core/uverbs.h     |  1 +
>  drivers/infiniband/core/uverbs_cmd.c |  9 +++++++++
>  drivers/infiniband/hw/mlx5/main.c    | 26 ++++++++++++++++++++++++++
>  include/rdma/ib_verbs.h              | 14 ++++++++++++++
>  include/uapi/rdma/ib_user_verbs.h    | 18 ++++++++++++++++++
>  5 files changed, 68 insertions(+)
>=20

This series has been accepted for 4.8, thanks.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--H9oWk5GX9V5rF3hT6QB0DrOsJAbCr8Out
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXa+tWAAoJELgmozMOVy/dcAwQAIm62oRobdFkB9ZpgffK1aad
twcubbS4Om/b1fNajhrgjnCIgPPvxlBWtZlKJaRQ80aK5wWEzyVbhdO55t+hGotf
pr+F7DS+F86WIQtr49lHpPEKrEywwAesDkP2yMuWHLg9zbPApjhBc50EpQ82oIvj
xF/2U6BewLxZ5BazhC4ORi3WI7aT7IbB+ZnjxUBb3iRBYA7T21dvs92Vmm+EHl0c
GFFez3EbO2UZNz2jqcrt16o4j+p9MIUl0Fip3B7LqoscLQ+YbWCDGlJDcWDktm6I
N9WqWStdqr/6qifLrzR3NvhGSjHq2XTSvHPgBaiWUlbP7VsP5lRKHU5/ICJtfn/B
boy684YfnNQSaddNEo1hfaRyOLexo+6Vr2NtjuC0mcddzjEjsHFmN8H4btkqbtSg
94UxuTA7vZdwrxIFwDnF4tqkUBJwJTZswgas0U5fGi2Gxr+mawFNV8axYW2L5tlr
VWrQS6P3iy5GsBDuqk0tWnAZL5Lu/3Mr1fTDWk0LXqBVbQSiuonGOpeztXWnDrZS
smD3u/ihOYYSzU1V9m8rft7ocJRWrmbShJPbXF6CKvuUDjmJV0YFnX455ksghdaz
nuOmS/+lupHkWHQIE8J5xBTH5gShk2LQ1qLsk1URYROgUkzs0pAvmj65VdoEKDSa
v4uHidZ54A/nvlOmznAR
=XeDh
-----END PGP SIGNATURE-----

--H9oWk5GX9V5rF3hT6QB0DrOsJAbCr8Out--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V1 0/3] Add cross-channel support
Date: Wed, 23 Dec 2015 23:42:56 -0500
Message-ID: <567B77D0.9090400@redhat.com>
References: <1450606571-15877-1-git-send-email-leon@leon.nu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="3SJ1nGX3lLX6jgFE6uCJRt8ewWjua52gO"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450606571-15877-1-git-send-email-leon-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3SJ1nGX3lLX6jgFE6uCJRt8ewWjua52gO
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 12/20/2015 05:16 AM, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> This patchset adds cross-channel support.
>=20
> The cross-channel feature allows to execute WQEs that involve
> synchronization of I/O operations=E2=80=99 on different QPs.
>=20
> This capability enables to program complex flows with a single
> function call, hereby significantly reducing overhead associated
> with I/O processing.
>=20
> Changes from v0:
>   * Set UAR to be the same for QP and CQ.
>=20
> Leon Romanovsky (3):
>   IB/core: Align coding style of ib_device_cap_flags structure
>   IB/core: Add cross-channel support
>   IB/mlx5: Add driver cross-channel support
>=20
>  drivers/infiniband/core/uverbs_cmd.c |  5 ++-
>  drivers/infiniband/hw/mlx5/cq.c      |  7 +++-
>  drivers/infiniband/hw/mlx5/main.c    |  3 ++
>  drivers/infiniband/hw/mlx5/mlx5_ib.h | 16 ++++++++
>  drivers/infiniband/hw/mlx5/qp.c      | 54 ++++++++++++++++++++++-----
>  include/linux/mlx5/qp.h              |  3 ++
>  include/rdma/ib_verbs.h              | 71 +++++++++++++++++++++-------=
--------
>  7 files changed, 117 insertions(+), 42 deletions(-)
>=20

I took the series as is.  Please make sure to resubmit the libibverbs
portion of these changes with the requested man page updates.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--3SJ1nGX3lLX6jgFE6uCJRt8ewWjua52gO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWe3fQAAoJELgmozMOVy/dvr4P/iIaQxXloQljLzyTNA7aYQtt
wZVWmRcy08T18f3tcDhbdQebONkaHdIipIIZYdTG+learoWzQovOZcqvd+t70YRh
033FitovFfd8+1hQiU01vZx6nvvCYNYdZ50oc9C10ejwvYmUC0XvYq3Du2pOldpM
ZQQL4z/aZUlR+XJ8dObF6C4QnNgpcsRK/lALMES3BQGa1D1pvctYJ8XN34O0aBhu
SdnXucCPJPT8KhpBPOH4ZCnF3zRn3IH5j6AWvjgC/YilpOOiXIXFcSpT3/nH026w
kFbY/wR6wa3ccVrfcRQPFTZ1B2NVGI7VqYO9IwRhqMPg3x6P7O9ziUKUOJCGh4uQ
HNbQKb2YUEew+GIoPUBHZnn6KMiRh7+zcsxEDCMA2IMJhG2yijVBdGdTryl+FK34
+LXe2zKuUrsBJhSU+otIhlRU+vhsXE94B0tJE1HwnmgSSda34PdY9UEp27F4/aA5
y+jn8R67SNtMLM2JOt7aSMusAkCA4TT3RSsrNw45kz+xjQh+yqK2gIwTeZBmUKB+
YxALPoHpF/SLgmsslN653WOQq2Bwu3U19TzRwyADE0fMSI5mkp1O6mHy6E5xmtNN
n7nsaRFHQRsZK5VyL6NiH5Ibd6grTtxVXjZGHMCr4x3iJEX+GLDgM9aW9AakgDXg
x8h45PDV4sTLUa3YjRyq
=XruX
-----END PGP SIGNATURE-----

--3SJ1nGX3lLX6jgFE6uCJRt8ewWjua52gO--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

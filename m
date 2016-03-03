From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/core: trivial prink cleanup.
Date: Thu, 3 Mar 2016 10:21:29 -0500
Message-ID: <56D85679.1090007@redhat.com>
References: <1456860029-17533-1-git-send-email-pandit.parav@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="jDbWkuQ1bRfeo5mWdTo80UsXdc1n09F95"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456860029-17533-1-git-send-email-pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--jDbWkuQ1bRfeo5mWdTo80UsXdc1n09F95
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 03/01/2016 02:20 PM, Parav Pandit wrote:
> 1. Replaced printk with appropriate pr_warn, pr_err, pr_info.
> 2. Removed unnecessary prints around memory allocation failure
> which are not required, as reported by the checkpatch script.
>=20
> Signed-off-by: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/core/cache.c       | 15 +++++++-------
>  drivers/infiniband/core/cma.c         | 14 ++++++-------
>  drivers/infiniband/core/device.c      | 28 +++++++++++++-------------
>  drivers/infiniband/core/fmr_pool.c    | 37 ++++++++++++++-------------=
--------
>  drivers/infiniband/core/packer.c      | 14 ++++++-------
>  drivers/infiniband/core/sa_query.c    | 11 +++++------
>  drivers/infiniband/core/ucm.c         |  8 ++++----
>  drivers/infiniband/core/ucma.c        |  6 +++---
>  drivers/infiniband/core/ud_header.c   | 23 +++++++++++-----------
>  drivers/infiniband/core/uverbs_main.c | 10 +++++-----
>  10 files changed, 77 insertions(+), 89 deletions(-)

Thanks, applied.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--jDbWkuQ1bRfeo5mWdTo80UsXdc1n09F95
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJW2FZ5AAoJELgmozMOVy/d/FUP/RKcmartlROv8JTtZRpG+k1p
cgR8nmmNg4BF5+HvwnlyUeI9erafKsNADZ4xBXq1m6hrTJcL4uoszcRlmq45k5WT
pT1SNQ0nbC0/WV+RS2lOYGKNmlKf7ADqMHIivphZ5n7RVvWHCnjYHCZKRWPWrbJg
tTFSfIiMFLAGnmnZhAH73FSkWA4CPlseMoW+zHM3bjpLG0AfNbEpCOA7VlbQJd9J
cV2pqtlQ7GNtoQohdrowXj3E6YTA+b7HkVJcuT2ZuUEzWMUaaI1AECbEYk8jyebY
ljlpr0f3+QlkmBhu1SyHgWt5bJoqPKv7l/psui8wL7odcBtZ4GozmXtftgba3ENQ
rR5oVrahxlOG3t+nFLOrjm4J3fYNaVsnFcwgGe8G4BtW4yoejEW9xeT0X7EIDjLt
k9SZxKSx2aB2o6aM0NwB2ptkn+MTOrue4ZjqyNTVk524jh2DCC20s/xhpLoG1qM/
yWx5LKE17yzz+gbLXxFcRs/POWWWHmo7SBKRVPYmoWyWwNhEsoStkqieqUWudddn
9zMzOFzeWwPVvm9oClsohnYjfbzKufSXvl5rMiumfa8dbCKSawNdQ+f/erM6l0k9
gQ5k1dML4VmSqJxjrdYFNnelxpBtj5zuJz/lEjpeyeLVBYKCd/UKTOj3wazzaC8N
veVg1uh4Sv4AZn00uanZ
=sh69
-----END PGP SIGNATURE-----

--jDbWkuQ1bRfeo5mWdTo80UsXdc1n09F95--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

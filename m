From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/2][RESEND] General MAD clean up
Date: Tue, 12 May 2015 16:06:32 -0400
Message-ID: <1431461192.43876.79.camel@redhat.com>
References: <1431105004-23585-1-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-KvsjJn76EdLAZr4Df3zv"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431105004-23585-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-KvsjJn76EdLAZr4Df3zv
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2015-05-08 at 13:10 -0400, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>=20
> Resend due to Patchwork being reset.  Also added Jason's Reviewed-By and =
Sean's
> Acked-By lines.
>=20
> These 2 patches contain some clean ups to the MAD module.  One was review=
ed
> months ago by Sean and the other was suggested by Doug.
>=20
> These are based on Doug's for-4.2 branch
>=20
> Ira Weiny (2):
>   IB/mad: Rename is_data_mad to is_rmpp_data_mad
>   IB/mad: Clean up comments in smi.c
>=20
>  drivers/infiniband/core/mad.c | 7 ++++---
>  drivers/infiniband/core/smi.c | 4 ++--
>  2 files changed, 6 insertions(+), 5 deletions(-)
>=20

These have been picked up for 4.2.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-KvsjJn76EdLAZr4Df3zv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVUl1IAAoJELgmozMOVy/d+5YQAKntJUGVWDsPG1znb1AGG53B
/0UgA7xx5fQOzgtFtRfncAr7HB0lsjSEjp5BriAfFzpGFJTvmZMvlNHSs/wAVHoA
sSD3ScTWFUALONAc8gpWeD5h+PW6jIQEhp4OvvMLrg7u5/l2fQQsc2nDalNz+wiX
9VZ3c2pYkwkOYGGPKAOc2ElYyH2wU0ePkcefcaGTsE60ij60wNdR2BiUv+4V4isM
Qoqp/u6MERilC/RG96VzWnpG5KTcOYetUN40MbDgdsV2Vf4YBVHnm4xgZiOLunDQ
f2tZ1MOKidwM+CI70i65PF9QCdb/fNxRmQEfQ531C0UZ3L8DU4iWNJISNzufZgHO
O9Pqlhj4zXlmRyvI9zNXmvcKu9qgqC4ulElDNKIeey7RU7B+Ez73APgmjHQ3GzXa
mvt0euECoehx4v6gmAB30d+AEWSB5Ho9fBU6klt324M0fpd1xE73UyiBovPtHmCA
2oZRPMYxzeq+qNgnVF9WSQJDI9IxfxTH16PTPU8CnqUHSPaql7ss4qzYnDB9qIEt
/FiHKPj6l0zrfhO28hB/CmWAhBLnaTz/ZUOs71HUS4nMvbVnw0xWY/YIRxaX3tWj
2VYuzhapt77s7R5yt7wGKkr75YGVtoxdmmgR4lreNeOxIPxDcMzIctYRjBU5+fTN
7ii76GNZDF1TKO4M4eM2
=Ajw5
-----END PGP SIGNATURE-----

--=-KvsjJn76EdLAZr4Df3zv--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/{core,hw}: Add constant for node_desc
Date: Thu, 1 Sep 2016 16:22:54 -0400
Message-ID: <cbb0ddb4-b05b-28b1-468f-893915f2ccb5@redhat.com>
References: <1472115186-10718-1-git-send-email-yuval.shaia@oracle.com>
 <b366ef68-3f46-a245-2495-76107954219e@redhat.com>
 <20160828060926.GJ594@leon.nu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="f8JqvL8R0KN9Bcf3L833M3dNvRSepC4XB"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160828060926.GJ594-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--f8JqvL8R0KN9Bcf3L833M3dNvRSepC4XB
Content-Type: multipart/mixed; boundary="KPHQbK4avXjPFEP9UhmgwMnKFtdj85buP";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Message-ID: <cbb0ddb4-b05b-28b1-468f-893915f2ccb5-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/{core,hw}: Add constant for node_desc
References: <1472115186-10718-1-git-send-email-yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
 <b366ef68-3f46-a245-2495-76107954219e-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <20160828060926.GJ594-2ukJVAZIZ/Y@public.gmane.org>
In-Reply-To: <20160828060926.GJ594-2ukJVAZIZ/Y@public.gmane.org>

--KPHQbK4avXjPFEP9UhmgwMnKFtdj85buP
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 8/28/2016 2:09 AM, Leon Romanovsky wrote:
> On Thu, Aug 25, 2016 at 10:23:22AM -0400, Doug Ledford wrote:
>> On 8/25/2016 4:53 AM, Yuval Shaia wrote:
>>> Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>>> ---
>>>  drivers/infiniband/core/sysfs.c              |    2 +-
>>>  drivers/infiniband/hw/cxgb3/iwch_provider.c  |    2 +-
>>>  drivers/infiniband/hw/cxgb3/iwch_provider.h  |    1 +
>>>  drivers/infiniband/hw/cxgb4/iw_cxgb4.h       |    1 +
>>>  drivers/infiniband/hw/cxgb4/provider.c       |    2 +-
>>>  drivers/infiniband/hw/hfi1/verbs.c           |    3 ++-
>>>  drivers/infiniband/hw/mlx4/mad.c             |    3 ++-
>>>  drivers/infiniband/hw/mlx4/main.c            |    6 +++---
>>>  drivers/infiniband/hw/mlx5/mad.c             |    2 +-
>>>  drivers/infiniband/hw/mlx5/main.c            |    6 +++---
>>>  drivers/infiniband/hw/mthca/mthca_mad.c      |    3 ++-
>>>  drivers/infiniband/hw/mthca/mthca_provider.c |    5 +++--
>>>  drivers/infiniband/hw/ocrdma/ocrdma.h        |    1 +
>>>  drivers/infiniband/hw/ocrdma/ocrdma_main.c   |    2 +-
>>>  drivers/infiniband/hw/qib/qib_verbs.c        |    3 ++-
>>>  include/rdma/ib_verbs.h                      |    6 ++++--
>>>  16 files changed, 29 insertions(+), 19 deletions(-)
>>
>> Thanks, applied to for-next.
>=20
> Doug,
> Which version did you apply? This with error or v1?

I applied v2 with the added BUILD_BUG_ON checks.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--KPHQbK4avXjPFEP9UhmgwMnKFtdj85buP--

--f8JqvL8R0KN9Bcf3L833M3dNvRSepC4XB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXyI4eAAoJELgmozMOVy/druwP/icDjda9G4MuZVRPAC0GCBX7
oQu1iq2/021ca4SE/y5/f6TTBe30SStxBfwJd0HNp681UzgfNWuo9rhczvWWu0HD
yD4SaFlUGpWArkMd2QGoLZooGiZ7nLDCXj+sRij/CZMZZXdt8YN+XEt+vk9LWZB6
O3c02dLrm99F0gBagQhLK6Phpd3BADyv4xsea5F2QJik06nGDfdNaQkD0k1xG4/w
wsn1VQ58pN6Md7XuoSABFVziUwKHNPeQ8PpHOesbJt5YDsga/uWU9CgLiUmCWx4I
JNin3zPYb5huHNcfJ63PWbUxyga3z7CMeInWlQCFVXac/EcbXPWI0yBgNuGizmL2
Bvr+KKuMFH0UfAhjISsupuIqrQPRjB5m7CCoS6iH7mKTO+TxUYiX2NAHe+rLkeGx
JO9Cj7CyS/YwSy3r0oGAZQDDzTWyOeYbfo1E+koIMFO92B5rAwkt6QvOdZU3FHdw
4f2B18Jy4tad7+GVenw2D7OTsW+1ceCvg5lxImDRTxJuDf8/YNzTCModsXaulf5U
AD28ruJ31OFUWLYIb2r645NMv9pUzOVOndseym7n6ZS0KRArhtME1iJWDpAt699I
gzuCh5GqvdnQINmRKKjbaiH/6cB28YaYRTSlM/PRVsVKJ+W2sTqc7fzq89RMvPLT
NayjE1RdmC9rRYeNYdzG
=VqYb
-----END PGP SIGNATURE-----

--f8JqvL8R0KN9Bcf3L833M3dNvRSepC4XB--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core v2] libqedr: Add iWARP support for user-space
 lib
Date: Thu, 7 Sep 2017 20:57:07 +0300
Message-ID: <20170907175707.GC9912@mtr-leonro.local>
References: <1504689959-32494-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="+nBD6E3TurpgldQp"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1504689959-32494-1-git-send-email-Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--+nBD6E3TurpgldQp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 06, 2017 at 12:25:59PM +0300, Ram Amrani wrote:
> From: Michal Kalderon <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
>
> Introduce IS_IWARP / IS_ROCE macros for libqedr as there are no global
> macros for this in rdma-core.
> There is a second doorbell required for RQ.
> QP states in user lib are not updated, as they are updated implicitly by
> the driver and not driven by modify_qp as they are in ib / roce.
> For this reason, decisions based on states are encapsulated in IS_ROCE.
>
> Signed-off-by: Michal Kalderon <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
> ---
>  providers/qedr/qelr.h       |  2 ++
>  providers/qedr/qelr_verbs.c | 34 +++++++++++++++++++++++++++++-----
>  2 files changed, 31 insertions(+), 5 deletions(-)
>

Thanks, applied.

--+nBD6E3TurpgldQp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmxiHMACgkQ5GN7iDZy
WKfdjA/+OHJZRDLuEDIm2YmWHggH2EexNrfguST86qm3I6D8Hg4jeXEl6l1l5fNI
ODa7n/D0XrQhf1VF/4p5cJ11SoMNkpenAutsaZqiWjRHf9aRpy7yplXQGOVu6PTo
bedQzstBDEDNA7UQ8lRL/2zkfsFHitepPyFONU/ZhdjczBgAWrDdzk7FJhHs5Nxj
nGOP7MtiM1IxUDMAo0PSKB16oC8HNq7d1nY6UJjUV4shhT9iuOinE0ReWUR3wUOb
0vU/qMKe3QpyiJtzfFbnYilIM/54gPxLmdlous3TmDBtm8L+e9Apu52CCHhkoBj9
PnYP0LtQ84QIx2g9z/AFO5lwWjE7Efcor01UVGDOUnzNIoehIPN2mNqqHw3goTin
WGP97IqgX683acVrdlNtU8cpLUsMywlkjaEbMGJmNd/ofUmTsqD2SkUb9vHJutE1
heE/pGsN6OSNoif83qIfH6QNyxbsoEzV/zCRmK/KGJRxqq1Sl75UKpK4I+Y8MWGo
SnjNJYThSBPTVHe+trEnLOX4WCXb0d9uUu/lU0HrfzJkMsCci+wEW4RDBPvs8+mz
iCIClsBv3HnZke2EgHcOkPqR6yun5KZrrEWHnNNQyWLfvhC3c8QaDy91Uasibi0A
M6zet7fWjJ3tTeUOVdxT7AMDjAgS1Qq7IW96bMAacd9+xSuKiJw=
=5P5r
-----END PGP SIGNATURE-----

--+nBD6E3TurpgldQp--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

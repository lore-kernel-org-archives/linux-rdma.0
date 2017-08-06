From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [pull request][rdma-rc 00/11] IPoIB fixes for 4.13
Date: Sun, 6 Aug 2017 11:20:18 +0300
Message-ID: <20170806082018.GD3636@mtr-leonro.local>
References: <20170726181232.7363-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="bajzpZikUji1w+G9"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170726181232.7363-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--bajzpZikUji1w+G9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 26, 2017 at 09:12:21PM +0300, Leon Romanovsky wrote:
> The following changes since commit a62ab66b13a0f9bcb17b7b761f6670941ed5cd62:
>
>   RDMA/core: Initialize port_num in qp_attr (2017-07-20 11:24:13 -0400)
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git tags/rdma-rc-2017-07-26
>
> for you to fetch changes up to 5dc78ad1904db597bdb4427f3ead437aae86f54c:
>
>   IB/ipoib: Notify on modify QP failure only when relevant (2017-07-23 10:52:00 +0300)
>
> ----------------------------------------------------------------
> IPoIB fixes for 4.13
>
> The patchset provides various fixes for IPoIB. It is combination of
> fixes to various issues discovered during verification along with
> static checkers cleanup patches.
>
> Most of the patches are from pre-git era and hence lack of Fixes lines.
>
> There is one exception in this IPoIB group - addition of patch revert:
> Revert "IB/core: Allow QP state transition from reset to error", but
> it followed by proper fix to the annoying print, so I thought it is
> appropriate to include it.
>
> Thanks
> ----------------------------------------------------------------
> Alex Vesker (2):
>       IB/ipoib: Prevent setting negative values to max_nonsrq_conn_qp
>       IB/ipoib: Add multicast packets statistics
>
> Erez Shitrit (3):
>       IB/ipoib: Use cancel_delayed_work_sync when needed
>       IB/ipoib: Make sure no in-flight joins while leaving that mcast
>       IB/ipoib: Notify on modify QP failure only when relevant
>
> Feras Daoud (3):
>       IB/ipoib: Fix race between light events and interface restart
>       IB/ipoib: Set IPOIB_NEIGH_TBL_FLUSH after flushed completion initialization
>       IB/ipoib: Add get statistics support to SRIOV VF
>
> Leon Romanovsky (3):
>       IB/ipoib: Clean error paths in add port
>       IB/ipoib: Remove double pointer assigning
>       Revert "IB/core: Allow QP state transition from reset to error"
>
>  drivers/infiniband/core/verbs.c                |  1 -
>  drivers/infiniband/ulp/ipoib/ipoib.h           |  1 +
>  drivers/infiniband/ulp/ipoib/ipoib_cm.c        |  1 -
>  drivers/infiniband/ulp/ipoib/ipoib_ethtool.c   |  3 ++-
>  drivers/infiniband/ulp/ipoib/ipoib_ib.c        | 25 ++++++++++++++++++-
>  drivers/infiniband/ulp/ipoib/ipoib_main.c      | 19 +++++++++------
>  drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 33 +++++++++-----------------
>  7 files changed, 50 insertions(+), 33 deletions(-)


Reminder

--bajzpZikUji1w+G9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmG0UIACgkQ5GN7iDZy
WKfsAQ/+Nd9rd1OI4jNnBCEOePyKD8GX0aap7y9TV5bjnAp+TF9Mb2ruXa2kep+A
TUPietvBAydAoRDKh+r61hu2/DvqtBIfUjIo9301qzDogPGxBcTD/cP4XVWWrI8X
Fj3/O2ADPm0LMxdxvsetOB3728bkKuJYhWusD/txP4Rcl/oFfsOzUFpSnkU3fr8H
6MVCa/rZR3J2YwT1KOya5TK+wRXvqqehUE0kdRzYhqx4J9H8Rh6HfBsohj7SNPQ9
lp4e3R3avhcdFAKBHIrIbe+wAAiB8Z7Mig+qTHZxmJAT29lD1k6ujVV4e6D4qMDM
hyzr4xNf/7VUmgzvb6+xmi6UrdX6VMMdzUyMOBMCkU4o042vrEWmluIxteZeeYLL
a/V4xOyB1GPkwnSuKzqVxLJyNIMsFXgBjYLWWG4vmsb9OoCHvVRUicUQeW+yd9If
lrwgWvXjW0uf8bJQmhcghzCxDweE2CP+LxFcPTFz4JYAAOOEQZUFrQEez9NZyYDi
JC9ksxRaKQ7jvrqiYBiGjlNxQnJBlLI1skKSsds64dxN1A0ZjLDRVVh0UNsMNkZT
2UFurzxCTLPK4fOugxH8phfRzKdFZY0UFYbr/oFdSXOsKm3tMznK1b4VbnrzbAmN
BuN0Gboy6A//94AdkSH32fCWnbB2Zz1X4bU+xcrvGvqrgJZW08A=
=zI9u
-----END PGP SIGNATURE-----

--bajzpZikUji1w+G9--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

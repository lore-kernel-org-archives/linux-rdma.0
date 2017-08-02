From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH RFC 0/3] Proposal for exposing rdma_rw MR factor
Date: Wed, 2 Aug 2017 10:20:43 +0300
Message-ID: <20170802072043.GZ13672@mtr-leonro.local>
References: <20170801205334.15781.18761.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="4jz2RIiWkXBLiaBi"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170801205334.15781.18761.stgit-Hs+gFlyCn65vLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--4jz2RIiWkXBLiaBi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 01, 2017 at 05:06:51PM -0400, Chuck Lever wrote:
> Since I converted NFSD to use the new rdma_rw API, I've been
> struggling with how NFSD determines the size of its send CQ, and how
> it provisions its send queue limit (ie, when it waits for more send
> queue entries to become available).
>
> The problem arises because rdma_rw hides the exact number of send
> WQEs it has provisioned. It determines this number based on the MR
> registration mode (FRWR for iWARP devices, local DMA rkey for
> others), but the mode itself is no longer exposed to ULPs.
>
> Thus when FRWR is in use, rdma_rw adds more WQEs, but NFSD is no
> longer aware of this, does not provision a larger CQ, and does not
> raise its send queue accounting limit. That means the extra WQEs are
> never really used.
>
> At LSF this year, Christoph and Sagi proposed a simple API that
> expose information about how many CQ entries are needed so that ULPs
> can provision their CQs more accurately.

Indeed clean API. Does it make sense to get rid of sc_max_requests and
use this exported value directly?

>
> The first patch here is a pre-requisite for the third. The second
> patch adds the new API. The third patch changes NFSD to use the new
> API to provision its CQ and send queue accounting accurately.
>
> This approach was tested using the (fixed) force_mr core module
> parameter.

Good, I liked the word "tested" in the sentence :).

>
>
> ---
>
> Chuck Lever (3):
>       svcrdma: Limit RQ depth
>       rdma core: Add rdma_rw_mr_payload()
>       svcrdma: Estimate Send Queue depth properly
>
>
>  drivers/infiniband/core/rw.c             |   24 ++++++++++++++++++++
>  include/rdma/rw.h                        |    2 ++
>  net/sunrpc/xprtrdma/svc_rdma_transport.c |   36 +++++++++++++++++++++---------
>  3 files changed, 51 insertions(+), 11 deletions(-)
>
> --
> Chuck Lever
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--4jz2RIiWkXBLiaBi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmBfUsACgkQ5GN7iDZy
WKetkg/+J0KA/MQLA2e8nmYwOzyHCQr9c6eWc+UnQSvqnM7FdfUW8FA/4v62sPbG
FwzMJltGAYR9URStA9mAdhlfiDyngYVfKiW0Xvz9aU9hrZ8Lw0nY60xSk1w7TM3c
fADR4JnrptHcVleHJFDr+2ZGKyfUyE+zh5XJ6/irAiJ3tgD8/MUyVUvJO4wtEuLP
xPKNtAiTatsaEPTEM1GNWLXiWA/6eRKX4Qia7toXG82h4E5NZLZLpe8cC7beTe7o
NZ4vOe7klFaisheRYn+lMl2yXUumXeA+u6NFFAolxYBnW3ayJ9Hv2I9pPPAD/CGt
tDQXuOHTH5KCZR3nfpgXZ4eOZWdD8VWLXHjbZyqDEwZ7iUi3mc+ektZjCkpgnP3L
JFLsOcAajbP+p8HfM4+1JIks9wS3QvowtSWKiOaMBMNS3D9Y0L/mAeWz1hNNegTL
UTfbAQiW8r3KLKNG/2vgwQsM7nsdMB838oAaRG7JfeESVsHeWTsGamzDaPSMVw3x
4YP61PsulxQ5CUjbB3ZsvKFxGPZH3Z8IabWs4/PpOnCV9i1G52iboDWkGexJR6bw
Bt4py+PvuHZW3S250otzgP3LvMfkDRIJzxGU/0CGs8Q352ufP1B9AhxMgg/sv0yV
xxWtYpojZWhWskgbGppVxTj8RKuUMAaxNhclTmQqB7jwc8jU7m4=
=jNom
-----END PGP SIGNATURE-----

--4jz2RIiWkXBLiaBi--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

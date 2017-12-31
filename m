From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] IB/ocrdma: Use zeroing memory allocator than
 allocator/memset
Date: Sun, 31 Dec 2017 14:12:09 +0200
Message-ID: <20171231121209.GW3494@mtr-leonro.local>
References: <1514648396-6964-1-git-send-email-himanshujha199640@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="QGBKWVSgmlsIyJ+t"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1514648396-6964-1-git-send-email-himanshujha199640-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Himanshu Jha <himanshujha199640-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--QGBKWVSgmlsIyJ+t
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Dec 30, 2017 at 09:09:56PM +0530, Himanshu Jha wrote:
> Use dma_zalloc_coherent for allocating zeroed
> memory and remove unnecessary memset function.
>
> Done using Coccinelle.
> Generated-by: scripts/coccinelle/api/alloc/kzalloc-simple.cocci
> 0-day tested with no failures.
>
> Suggested-by: Luis R. Rodriguez <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Signed-off-by: Himanshu Jha <himanshujha199640-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/hw/ocrdma/ocrdma_hw.c    | 19 +++++++------------
>  drivers/infiniband/hw/ocrdma/ocrdma_stats.c |  6 ++----
>  drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |  8 +++-----
>  3 files changed, 12 insertions(+), 21 deletions(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--QGBKWVSgmlsIyJ+t
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpI1BkACgkQ5GN7iDZy
WKd1gRAAwAwrATdj/Vxiq4PvFFCGHE3xBMDHu8s3xZvwilez8G6KvnFatXyhP3Ra
nBiIPIilRAyBmbMvVf7SNucePqNDk15ID+ziBRa8mwaCCejM0/3d4rfgilBuGxa0
DY0RXLJ6iTQod8KJa2XOmMnJxFEPtRSCkwAgTetzHXcZWUbSHHExgMDb7SeBDKPr
24zvFEtoIMKtTsh3p4ANa8c/QOGK7REMN4PoCApgAvD8J2tufomwXvvBLP+SW+Sf
oirAsNTFtEFMlzuHWMSl/gK3qvjJEe683Te6jFun5V/qtCYpD/+VM/4yPf6iYRHx
M6GV1ruhvUKoHooe/XRHnuqEzNBVrwCieGaVFz7DCfx/WUtV0aTXemmcoTtk1+uQ
3tKMqiCNfpbXnzea9hIX1GKw68DUXFGUdqGBwEt+iWfrAl1fHkpKKjYArmYdpfUg
+YMMRasBCzaW/Hs4iVcTdPURyvG0kSUWjQMohKjv1QMz6/5SBVlzBDqECvP7cNe2
rcpUepCxEAP+3cjLrLJ+AQThVYxbAh5X3d4/M27OmfjWe4hYnV1OhyUJMutyUEsL
fZoF/ojT3KJ1XZ0EW5W0URdwVWsynizK6STtAHyKRIzzvpA0FKmtMAAgvCijxw/r
7I0tb4BaPpE96lCir0Fhiq4POs2j7sATjFRDdUcufhWfFlfUttE=
=m9wL
-----END PGP SIGNATURE-----

--QGBKWVSgmlsIyJ+t--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

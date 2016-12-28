From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/1] ib_srp mr allocation failure
Date: Wed, 28 Dec 2016 07:48:20 +0200
Message-ID: <20161228054820.GB26885@mtr-leonro.local>
References: <1482864552-27605-1-git-send-email-maxg@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="DKU6Jbt7q3WqK7+M"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1482864552-27605-1-git-send-email-maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: bvanassche-HInyCGIudOg@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Israel Rukshin <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--DKU6Jbt7q3WqK7+M
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 27, 2016 at 08:49:11PM +0200, Max Gurtovoy wrote:
> From: Israel Rukshin <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> Hi,
>
> While running traffic with multiple jobs I had those errors:
> scsi host8: ib_srp: Failed to map data (-12)
> scsi host8: ib_srp: Failed to map data (-12)
> ...
>
> The reason for the map failurs are SG gaps.
> This bug happens to me only with CX4 because it supports SG gaps registration.
> I fixed this issue by allocating the mr with IB_MR_TYPE_SG_GAPS.
>
> Should it be pushed also to stable kernel code ?

It looks so.

>
> Israel Rukshin (1):
>   IB/srp: fix mr allocation when the device supports sg gaps
>
>  drivers/infiniband/ulp/srp/ib_srp.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>
> --
> 1.8.4.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--DKU6Jbt7q3WqK7+M
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlhjUiQACgkQ5GN7iDZy
WKfwBA//VRFmzEgrWaz3y2hOP0BXLJbtiyCJzRp0XLIR9sZ5NZyLyagFvHCu9VRd
YohPblyBRXcjmAiue8bktr6UueB42YcQGwWAm0qHrS9PEhzLJHO6yrbGvX45WLpK
FBS/Jo1zpMvIx89C6X8wYBzMEYxDox6tKGqaYO2rc0919dodvsDpb9WuOEveKn4v
B7Y0fgagBcCCRMM4dyiDQkGCVarrUsHs3Ok8egOx/3+SBN91JQ78Hggnv6MrS1p6
/RCPhAErhvHYYAM1mJDPSJkahvJQQqcMfF56DgOZaf6yq97OQtQSAMxIu9VI9WZh
aylkq4mK/c/EEHsouLIKUXDpjf9kjXFgyQ4kUAR65k8OhjXTtRGyGRZ86h/kZ9Bm
BIRN/V1M08+FYLDrX89KQZGTOHwbRxCupFT8eqxjpbgzOx4jpgISq74TU031whWY
HMMid+xvRYSDAEGd9smzSK8E0J5ngPSmZFi7XtxjiGIIKafk9UMgsPv+WRW6devk
ul4AcSEhGKFucgEZesccuQdk33zD8Kgkx2DTS69O8vqx6At1MKabSTWnBat8xn6R
eYUa/1fT+XalVqfqXJATl0hxxKf7yA8YcWoIn6smU7PtuAhseEdsxoVJJoTwhexD
OI5dzUwc6/xqyYRQuUTe7MWuqLPh0BLrdFlqZZxXUgOwfY+TV+k=
=6jtS
-----END PGP SIGNATURE-----

--DKU6Jbt7q3WqK7+M--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

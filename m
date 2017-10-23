From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-core] providers/i40iw: Refactor queue depth
 calculation
Date: Mon, 23 Oct 2017 20:31:10 +0300
Message-ID: <20171023173110.GO2106@mtr-leonro.local>
References: <20171018211542.13056-1-tatyana.e.nikolova@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="8LS8R9T6g8Jk6Xk2"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171018211542.13056-1-tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--8LS8R9T6g8Jk6Xk2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 18, 2017 at 04:15:42PM -0500, Tatyana Nikolova wrote:
> From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
> Queue depth calculations use a mix of work requests
> and actual number of bytes.  Consolidate all calculations
> using minimum WQE size to avoid confusion.
>
> Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  providers/i40iw/i40iw_d.h      |  8 +++--
>  providers/i40iw/i40iw_uk.c     | 64 +++++++++++++++++++++++++--------
>  providers/i40iw/i40iw_user.h   |  4 ++-
>  providers/i40iw/i40iw_uverbs.c | 81 +++++++++++-------------------------------
>  4 files changed, 77 insertions(+), 80 deletions(-)
>

Thanks, applied.

--8LS8R9T6g8Jk6Xk2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnuJ14ACgkQ5GN7iDZy
WKe67hAAl01smomZXoWge/t9+MjnI6sewbXw304q8S4AU5yYArRixvSboatdlue/
48+qfUGI6YLXzLKmxu2kv0fg/4pHGAXkfK0v4W8ZUYPb6ZN51N+UzXIYEihEgFzT
dSvrvdiG3lxaMG2PBuRFgcsL8LL80bPnIUC78RVHRAxNeIn1acYgrSD7NCNASwKD
otSHSyImd6kpmwe+X8F7B0BOa0XZNWu4aXe+fhVtkJ7ZpIO8Qc2Rdd4R0E7hAWkD
KCXkNEe4SKAu6JDCZ3vD+n+GvY1jkwtHfGNr8ZqRgDH2OZyNcdtvVZiazUKtadD2
Mh+5rNQOu+/GH3JsHygtGD9gzXG1UAOw0+EGmWJvRf1CBJI65lknLaLa6aPrexR0
RN5f6X8LyBso+n3pg5GMa7yDDynjDyjW+ATmxMuemN7LKt8H/fGfUXH1ftXOv8JE
2/5EWAQt9Stz4ROoLQ6v15f+LdRv+VyQ5TX9Kg9rovab1y5ova4z//54+fT4fvmz
/gL4rBWFdwk+1qhsSvhzU9cLPcQihxXBwNKcjym17azW0yaQlSnb4OYrkOBWllia
dvW16GAOGP6JuPke/rIArq2UNcQ6nEoEjd1q9eAp2zGcJkt6cuO0W6N14w00dPJ8
J5SzROCS5CvZudSGBq2/bMGbOpbVa0kqTjcwxDTA0/SvdpcyQoU=
=NP3V
-----END PGP SIGNATURE-----

--8LS8R9T6g8Jk6Xk2--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

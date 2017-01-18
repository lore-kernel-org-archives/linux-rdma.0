From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-core] qedr: Fix a wrong field in struct rdma_rq_sge
Date: Wed, 18 Jan 2017 18:19:40 +0200
Message-ID: <20170118161940.GD32481@mtr-leonro.local>
References: <1484682252-32964-1-git-send-email-tatyana.e.nikolova@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="309evMHi/619oHyA"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1484682252-32964-1-git-send-email-tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

--309evMHi/619oHyA
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 17, 2017 at 01:44:12PM -0600, Tatyana Nikolova wrote:
> Fixes: 13b2b3cf148c ("libqedr: fix queue wrapping logic")
>
> After enabling FP_DP_VERBOSE macro, for example:
> #define FP_DP_VERBOSE(...)     DP_VERBOSE(__VA_ARGS__)
>
> libqedr compilation fails with the error below:
>
> In file included from ../providers/qedr/qelr_verbs.c:48:0:
> ../providers/qedr/qelr_verbs.c: In function =E2=80=98qelr_post_recv=E2=80=
=99:
> ../providers/qedr/qelr_verbs.c:1447:14: error: =E2=80=98struct rdma_rq_sg=
e=E2=80=99 has no member named =E2=80=98first_addr=E2=80=99
>            rqe->first_addr.hi, rqe->first_addr.lo);
>
> Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  providers/qedr/qelr_verbs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

This fix isn't relevant anymore, Ram deleted these macros.

Thanks

--309evMHi/619oHyA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlh/lZwACgkQ5GN7iDZy
WKfStRAAvsjhDQD6vgxB2MB1yU2it5yn3x2LZw4a0ZTHGHoJ19j+F5MzOfebwKTE
ym5o6kbT0wgXtAOWXhPmxlUO9qecmJ+jtpUcFKxe1Jd7ymammcmKkGn5MtF6Ar7f
nc2+JzMfJM7CHaR1rpqlL7CJTigjyyCa9onmVg6WpZ8UnbC3BbGQWabomEG1eXF1
uSSXK0Uwx9nduKqJG9hGXWeQjXSpLiwa2Zi7AeRn2wEs0oa0Kvg4Rr0EnlV5Dd+w
un5j3BVikwRFY8uZQ4XnsIeLYCo++8vcuVH9e3P0XnKFRaKuwP8r6yv0F0aKYpu1
comDkn8r79CmkHm1MkeKUR1ImSlS3UeCOB7a/zvHr2y7LnVzKEc0SxQBCgrie+Gi
p7zttxrNzO23VVCJuLhLwnjZRWfvXWgoWQZDSmzQ2+xQy4IMiQQoPf05tUoV+gr4
RpHd8rZkmsPiLq4zHXjV81y6F8VP83r/FhFmpAU+i/MMmOO7BkqUbvWNH3/rcOXm
NN47aZXRMW4yFJ6YNB6Gu0R6n6MLJ1zx10j3MmclKPhrkd9kOe+5+OLX1LMNCiHt
xX2DNQlUmbeEvoVVYbjc5TroAqrqCX3azVlTPnxo/6F4sHl7clOf4Iggo1jnA7p2
ThG8V3uhkrqvQhKwZscoCPlyWwwIZP6Y6pBbShF7b7I6eWO1MJ0=
=5jcM
-----END PGP SIGNATURE-----

--309evMHi/619oHyA--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

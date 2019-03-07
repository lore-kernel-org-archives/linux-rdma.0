From: Leon Romanovsky <leonro@mellanox.com>
Subject: Re: [PATCH] Avoid that check_shl_overflow() triggers a compiler
 warning when building with W=1
Date: Thu, 7 Mar 2019 07:24:32 +0000
Message-ID: <20190307072428.GJ1789@mtr-leonro.mtl.com>
References: <20190307010153.81157-1-bvanassche@acm.org>
 <20190307012417.GU1758@mellanox.com>
 <8a5bd9ae-ebfe-687c-2868-d0f2a610d1e0@acm.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="JbKQpFqZXJ2T76Sg"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <8a5bd9ae-ebfe-687c-2868-d0f2a610d1e0@acm.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Jason Gunthorpe <jgg@mellanox.com>, Kees Cook <keescook@chromium.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>
List-Id: linux-rdma@vger.kernel.org

--JbKQpFqZXJ2T76Sg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 06, 2019 at 06:14:09PM -0800, Bart Van Assche wrote:
> On 3/6/19 5:24 PM, Jason Gunthorpe wrote:
> > On Wed, Mar 06, 2019 at 05:01:53PM -0800, Bart Van Assche wrote:
> > > This patch avoids that the following warning is reported when building
> > > the mlx5 driver with W=1:
> > >
> > > drivers/infiniband/hw/mlx5/qp.c: In function set_user_rq_size:
> > > ./include/linux/overflow.h:230:6: warning: comparison of unsigned expression >= 0 is always true [-Wtype-limits]
> > >     _s >= 0 && _s < 8 * sizeof(*d) ? _s : 0;  \
> > >        ^
> > > drivers/infiniband/hw/mlx5/qp.c:5820:6: note: in expansion of macro check_shl_overflow
> > >    if (check_shl_overflow(rwq->wqe_count, rwq->wqe_shift, &rwq->buf_size))
> > >        ^~~~~~~~~~~~~~~~~~
> > >
> > > Cc: Jason Gunthorpe <jgg@mellanox.com>
> > > Cc: Leon Romanovsky <leonro@mellanox.com>
> > > Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> > > Fixes: 0c66847793d1 ("overflow.h: Add arithmetic shift helper") # v4.19
> > > Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> > >   include/linux/overflow.h | 22 ++++++++++++++++++++--
> > >   1 file changed, 20 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/include/linux/overflow.h b/include/linux/overflow.h
> > > index 40b48e2133cb..8afe0c0ada6f 100644
> > > +++ b/include/linux/overflow.h
> > > @@ -202,6 +202,24 @@
> > >   #endif /* COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW */
> > > +/*
> > > + * Evaluate a >= 0 without triggering a compiler warning if the type of a
> > > + * is an unsigned type.
> > > + */
> > > +#define is_positive(a) ({					\
> > > +	typeof(a) _minus_one = -1LL;				\
> > > +	typeof((a) + 0U) _sign_mask = _minus_one > 0 ? 0 :	\
> >
> > This is probably just is_signed_type(a)
>
> Hi Jason,
>
> I don't think that gcc accepts something like is_signed_type(typeof(a)) so
> I'm not sure that the is_signed_type() macro is useful in this context.
>
> > > +				1ULL << (8 * sizeof(a) - 1);	\
> > > +								\
> > > +	((a) & _sign_mask) == 0;				\
> > This is the same sort of obfuscation that Leon was building, do you
> > think the & is better than his ==, >  version?
> >
> > Will gcc shortcircuit the warning if we write it as
> >
> > (is_signed_type(a) && a < 0)
> >
> > ?
>
> I have tested this patch. With this patch applied no warnings are reported
> while building the mlx5 driver and the tests in lib/test_overflow.c pass.

Bart,

My simple patch passes too :).

>
> Thanks,
>
> Bart.

--JbKQpFqZXJ2T76Sg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJcgMcsAAoJEORje4g2clinN7wP/RCNy6kC+EsmjSjuH1eRgAS/
6MX3F0bdMG/G97BeY+gDOlfjQEMKLMmMZAvodKphcxnSkpPX1IZ6qxf8MtysuYxb
fZlihUBQv/yJI3EOO9Up2oF7q0l5uiT96iuEYKDYcP9dgcUn8Kd/gyORjRvWRC4o
pjpLSnRwdXy0h6diibfjbqN/uaXEoEPnC+Ft2QaYYaQl2/V9WtQcJeIY7gYFjYyF
1ZMLlM3IIXr1rHZUl7T7SAYfI76Hv/pUJQQxmut7t8Jz12ThHd6M4+GeDeM0c6F/
UH4969dWytz5mqFILfW43bY1VTivSkwq9YdnqA5PqYBxsrDasdN3UZyePEho8NYt
PYerMfZNL8f7oTL3tpBUr50rlFF/7xEDkm6/0mFHIvvclznwK6Yb4kBwkQptzRLa
D9Fy+Sew+1GKzsakgBcyiN9Vd/tTaMf8gkExXF9GUIo2Ga2gftNoTCdXPoWK+Ajf
pWUKAcwl0LdXsmebcb7xZJsdvYwWgTw33gEYm9Wph/qhZ6KBozvYAQsgnWj5bUIN
8N/qfOIg4/BhVGCPW7jjLn1GdZLub691lm4r1kHHebEmeM1kCH8kagz7ii8tsfwR
Xelr0MWx52aNGzBUQSbStJBto4TvEHCOG2b23VV2tVaoD4f+WE7c6ckAN4aBBcr9
pTOtoYlyIVgELsDZBoIT
=k04u
-----END PGP SIGNATURE-----

--JbKQpFqZXJ2T76Sg--

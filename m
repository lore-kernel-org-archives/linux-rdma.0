From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH RFC rdma-core 1/3] util: Add common code for provider
 debug
Date: Wed, 18 Jan 2017 20:31:04 +0200
Message-ID: <20170118183104.GH32481@mtr-leonro.local>
References: <1484682413-56580-1-git-send-email-tatyana.e.nikolova@intel.com>
 <20170118053130.GS32481@mtr-leonro.local>
 <20170118164444.GA14198@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="N6OI5UwltL9FF6Nb"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170118164444.GA14198-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

--N6OI5UwltL9FF6Nb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 18, 2017 at 09:44:44AM -0700, Jason Gunthorpe wrote:
> On Wed, Jan 18, 2017 at 07:31:30AM +0200, Leon Romanovsky wrote:
> > > +#define PRINT_ERR(fmt, ...)								\
> > > +do {											\
> > > +	fprintf(stderr, "[%s:%d]" fmt, __func__, __LINE__, ##__VA_ARGS__);		\
> > > +} while (0)
> > > +
> > > +#define PRINT_DBG(dbg_mask, dbg_level, fmt, ...)					\
> > > +do {											\
> > > +	if ((rdma_dbg_mask & dbg_mask) && (rdma_dbg_level >= dbg_level))		\
> > > +		fprintf(stderr, "[%s:%d]" fmt, __func__, __LINE__, ##__VA_ARGS__);	\
> > > +} while (0)
> > > +
> > > +#define LOG_DBG(dbg_fp, dbg_mask, dbg_level, fmt, ...)					\
> > > +do {											\
> > > +	if ((rdma_dbg_mask & dbg_mask) && (rdma_dbg_level >= dbg_level))		\
> > > +		fprintf(dbg_fp, "[%s:%d]" fmt, __func__, __LINE__, ##__VA_ARGS__);	\
> > > +} while (0)
> > > +
> > > +#define LOG_DBG_FLUSH(dbg_fp, dbg_mask, dbg_level, fmt, ...)				\
> > > +do {											\
> > > +		LOG_DBG(dbg_fp, dbg_mask, dbg_level, fmt, ##__VA_ARGS__);		\
> > > +		if (dbg_fp != stderr)							\
> > > +			fflush(dbg_fp);							\
> > > +} while (0)
> >
> > IMHO, these macros should be inline functions, and better to avoid global variables.
>
> It is more expensive at the call site to inline something that calls
> via va_args than via ..., so these should remain as macros.

These macros/functions need to be compiled in for DEBUG mode only, in
such case you can pay extra CPU cycles.

>
> When doing this people generally like the 'if' test to be outside, for
> performance.
>
> I'm still not sure about these.. Why do we need print & log? I think
> there should only be one. Providers should not print to stderr unless
> the user asks for debugging.
>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--N6OI5UwltL9FF6Nb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlh/tGgACgkQ5GN7iDZy
WKekVxAArSLNJARW/LtzxBIDPitFu+KPd31iKMNoS4GQd7/E4PrhetjkvAiwphlY
KGK9RsORTwgcQRXUBkwU4Fc0JadAAPwuOzNnS8fAo2wdZYcN2BnD3dI1jQpp3Buh
kG3crvobUYnYR/PRjJ61WXdhIgaXoga5IakjnEoSha0oE5Ua0GbirR77+xQ/M5tM
gJvF9ZhSnhd1W+0XoGgP8x54vSvG62djvj0pmsJ5zFqYmiYafz+t/YQDgfGqqzik
dv4HrXAPWpRx8avq7UiBay4Avr7/zUMZV5Wv1lO4eMuHLQe39mRApybduVKMP6L7
u9Sk3vN/jE9pL9gWJu0C0QzGZKsPwD7yySkItWVNnJiEMHr5+9O2z6rSNwmElaul
FOd6px0/ha/cnngLLQ7FAnOAKYdD8WHHyD2FOsfkOjM1zSiFikHjd+7/S3tMM35S
R7kMP1vU+RB35IJ2riW6o9QB4vMyGg/ouQRQvuQQli7LPyPnUeMMYENsxZfKbXWW
5y85CV1nnXnuUkPDnq23rajFupKS5xP5oFCgJfggPGFKOY/rZQADg0bB4kLHzKUl
jzL7NZgNy0hYFG/amhLiKOEnj4hJlNGtJg05jCHu2S6U29PzUSs/9Nf2xPO9gKYh
tbSMS7fvATjhqb8aRYwPI2xtaC1OE9B8W51c0cZutbb7oeYJLfQ=
=dEm2
-----END PGP SIGNATURE-----

--N6OI5UwltL9FF6Nb--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

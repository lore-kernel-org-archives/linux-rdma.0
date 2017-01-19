From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH RFC rdma-core 1/3] util: Add common code for provider
 debug
Date: Thu, 19 Jan 2017 10:09:24 +0200
Message-ID: <20170119080924.GM32481@mtr-leonro.local>
References: <1484682413-56580-1-git-send-email-tatyana.e.nikolova@intel.com>
 <20170118053130.GS32481@mtr-leonro.local>
 <20170118164444.GA14198@obsidianresearch.com>
 <20170118183104.GH32481@mtr-leonro.local>
 <20170118184411.GA5020@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="4YfhVOqjnG2FJTMT"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170118184411.GA5020-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--4YfhVOqjnG2FJTMT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 18, 2017 at 11:44:11AM -0700, Jason Gunthorpe wrote:
> On Wed, Jan 18, 2017 at 08:31:04PM +0200, Leon Romanovsky wrote:
> > On Wed, Jan 18, 2017 at 09:44:44AM -0700, Jason Gunthorpe wrote:
> > > On Wed, Jan 18, 2017 at 07:31:30AM +0200, Leon Romanovsky wrote:
> > > > > +#define PRINT_ERR(fmt, ...)								\
> > > > > +do {											\
> > > > > +	fprintf(stderr, "[%s:%d]" fmt, __func__, __LINE__, ##__VA_ARGS__);		\
> > > > > +} while (0)
> > > > > +
> > > > > +#define PRINT_DBG(dbg_mask, dbg_level, fmt, ...)					\
> > > > > +do {											\
> > > > > +	if ((rdma_dbg_mask & dbg_mask) && (rdma_dbg_level >= dbg_level))		\
> > > > > +		fprintf(stderr, "[%s:%d]" fmt, __func__, __LINE__, ##__VA_ARGS__);	\
> > > > > +} while (0)
> > > > > +
> > > > > +#define LOG_DBG(dbg_fp, dbg_mask, dbg_level, fmt, ...)					\
> > > > > +do {											\
> > > > > +	if ((rdma_dbg_mask & dbg_mask) && (rdma_dbg_level >= dbg_level))		\
> > > > > +		fprintf(dbg_fp, "[%s:%d]" fmt, __func__, __LINE__, ##__VA_ARGS__);	\
> > > > > +} while (0)
> > > > > +
> > > > > +#define LOG_DBG_FLUSH(dbg_fp, dbg_mask, dbg_level, fmt, ...)				\
> > > > > +do {											\
> > > > > +		LOG_DBG(dbg_fp, dbg_mask, dbg_level, fmt, ##__VA_ARGS__);		\
> > > > > +		if (dbg_fp != stderr)							\
> > > > > +			fflush(dbg_fp);							\
> > > > > +} while (0)
> > > >
> > > > IMHO, these macros should be inline functions, and better to avoid global variables.
> > >
> > > It is more expensive at the call site to inline something that calls
> > > via va_args than via ..., so these should remain as macros.
> >
> > These macros/functions need to be compiled in for DEBUG mode only, in
> > such case you can pay extra CPU cycles.
>
> One of the reasonable ways to use this is to always compile in *error
> case* debug prints, as these are intrinsically on the slow error path
> already - however for that use we certainly want to minimize icache
> consumption at the call site.

There are debug prints in data path too.
https://patchwork.kernel.org/patch/9521817/
See mlx5_get_next_cqe and mlx5_cq_read_wc_opcode functions.

>
> If we don't want to micro-optimize the DEBUG enabled case then I
> recommend this approach for the macro:
>
> #define LOG_DBG(dbg_fp, dbg_mask, dbg_level, fmt, ...)
>     ({
>       static const struct verbs_log_loc loc = {
>        .dbg_mask = dbg_mask,
>        .dbg_level = dbg_level,
>        .fmt = fmt,
>        .line = __LINE__,
>        .func = __func__ };
>     __check_fmt_args(fmt, ## __VA_ARGS__);
>     verbs_log_dbg(dbg_fp, &loc, ## __VA_ARGS__);
>    })
>
> verbs_log_dbg would be implemented out of line.
>
> That has the lowest call-site icache overhead as most of the required
> data is pushed into the .rodata pointer (instead of in .text) and we
> can continue to use the register calling convention for the va_args.
>
> We can probably also eliminate dbg_fp as an argument, there is no
> reason to have the providers store that, IHMO.
>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--4YfhVOqjnG2FJTMT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAliAdDQACgkQ5GN7iDZy
WKdCbw/6A9RVmteq7qZDK08j+bHbu7k1E6/7JURoKF3T9+JfDepLW0A3BDhUcGLE
9/J6UfwNv820aNiJyodqvyyLgfiasp75IKDyW/jvOsxJSXlwK0Rz2ZWeiBFKsWQn
N9qGKAopK1hT7XYTWAGUd32OdnpJ6bVJOUu/KuLC54t7Uym2JvG+c+TzlX5guJOA
cweLINcoR5WNe91rrcToIMf5XV2Ma8ROUkDvl2XHc1ta2BW0EeCJKIanaU8UG1d/
wsCpnYhwG+J03utwRaX/pAFlneMylvYUcNoZyu/ObUT1DX98SQ2hPaNC3T2ZfreX
Zhq/1ZePdcd1Ca3lHGMk1t9M0BQgMkw2oGAVrNK2zT3FOhhYrkZUYFa/bWYn9/3Q
cIvOLiV+v+6LeilyFX2QIyxk6vYvwymNQendJpeUR9pXk4F4w5C7wvI3+mamGqno
jiVyJOuWFWm5+18aU+oKDtqmLuqI6r4e3X+2KTOfN96qO5Zzj79kpGKGxqwL4V+t
HA3IBXlUUO9X6EVeJ8dUoLEuRH3iqr9sHJt3YzqesZJqACn3DiVHoM97wzbiepyo
188uE2kPD3BFZclaqGZtNerrB2QBl0zh9zHPGGMho1bdntib3rT15csU0cHd8/wj
i7r1Uu8rqRtZAX1chffTyprTe0O76Ao0gGhtraGnCmZNC4u9FGU=
=jR7E
-----END PGP SIGNATURE-----

--4YfhVOqjnG2FJTMT--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

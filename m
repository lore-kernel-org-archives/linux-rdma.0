From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: libmlx4: Pass the argument "foreign" to AM_INIT_AUTOMAKE()
Date: Mon, 10 Oct 2011 11:12:47 -0700
Message-ID: <CAL1RGDX7queuQdb=G=D-VUZUC0KgJHDO_g9QOfQtdgiFVhiFvg@mail.gmail.com>
References: <201110101941.37440.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201110101941.37440.bvanassche-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Thanks... I already have this locally (waiting to get my kernel.org tre=
e back up
and/or have time to set up a github mirror before I push this out)

 - R.

On Mon, Oct 10, 2011 at 10:41 AM, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> =
wrote:
> Tell automake explicitly that the libmlx4 package is not a GNU packag=
e. This
> change makes it possible to regenerate the configure script via autor=
econf
> instead of only via autogen.sh.
>
> Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
>
> ---
> =A0configure.in | =A0 =A02 +-
> =A01 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/configure.in b/configure.in
> index 49dc1b0..111f0b0 100644
> --- a/configure.in
> +++ b/configure.in
> @@ -5,7 +5,7 @@ AC_INIT(libmlx4, 1.0.2, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)
> =A0AC_CONFIG_SRCDIR([src/mlx4.h])
> =A0AC_CONFIG_AUX_DIR(config)
> =A0AC_CONFIG_HEADER(config.h)
> -AM_INIT_AUTOMAKE(libmlx4, 1.0.2)
> +AM_INIT_AUTOMAKE([foreign])
> =A0m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])
>
> =A0AC_PROG_LIBTOOL
> --
> 1.7.3.4
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

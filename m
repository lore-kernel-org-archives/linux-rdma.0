From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [infiniband-diags PATCH 2/2] build-sys: avoid overlinking to libudev
Date: Tue, 14 Jul 2015 11:44:28 -0400
Message-ID: <20150714154427.GB27566@phlsvsds.ph.intel.com>
References: <1435241522-7721-1-git-send-email-mschmidt@redhat.com> <1435241522-7721-3-git-send-email-mschmidt@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1435241522-7721-3-git-send-email-mschmidt-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michal Schmidt <mschmidt-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 25, 2015 at 04:12:02PM +0200, Michal Schmidt wrote:
> Not all built binaries need to link to udev, only rdma-ndd.
> Use pkg-config to detect udev in configure.ac.
> 
> Signed-off-by: Michal Schmidt <mschmidt-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Thanks applied,
Ira

> ---
>  Makefile.am  | 6 ++++++
>  configure.ac | 9 +++++----
>  2 files changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/Makefile.am b/Makefile.am
> index 057508b18d..93af707ad6 100644
> --- a/Makefile.am
> +++ b/Makefile.am
> @@ -130,6 +130,12 @@ src_ibcacheedit_LDFLAGS = -L$(top_builddir)/libibnetdisc -libnetdisc
>  src_dump_fts_SOURCES = src/dump_fts.c
>  src_dump_fts_LDFLAGS = -L$(top_builddir)/libibnetdisc -libnetdisc
>  
> +if ENABLE_RDMA_NDD
> +src_rdma_ndd_SOURCES = src/rdma-ndd.c
> +src_rdma_ndd_CFLAGS = $(AM_CFLAGS) $(UDEV_CFLAGS)
> +src_rdma_ndd_LDADD = libcommon.a $(UDEV_LIBS)
> +endif
> +
>  BUILT_SOURCES = ibdiag_version
>  ibdiag_version:
>  	if [ -x $(top_srcdir)/gen_ver.sh ] ; then \
> diff --git a/configure.ac b/configure.ac
> index ece1d530a7..090b6ecf76 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -210,11 +210,12 @@ default_start="null"
>  AC_SUBST(DEFAULT_START, $default_start)
>  AC_SUBST(DEFAULT_STOP, $default_stop)
>  
> -if test x$rdmandd = xyes; then
> -    AC_CHECK_HEADER(libudev.h, with_udev="yes", with_udev="no")
> -    AC_CHECK_LIB(udev, udev_monitor_ref, [], AC_MSG_ERROR(libudev is required for rdma-ndd...))
> +AS_IF([test x$rdmandd = xyes], [
> +    PKG_CHECK_MODULES([UDEV], [libudev])
>      AC_CONFIG_FILES([doc/man/rdma-ndd.8 etc/rdma-ndd.init])
> -fi
> +    AC_SUBST([UDEV_CFLAGS])
> +    AC_SUBST([UDEV_LIBS])
> +])
>  
>  dnl Generate doc/man/*.in files if possible
>  DOC_DATE="`date +%Y-%m-%d`"
> -- 
> 2.4.3
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH management.git] Fix autotools to include the necessary
 M4 files
Date: Mon, 25 Oct 2010 20:05:56 +0200
Message-ID: <20101025180556.GD14919@me>
References: <20101007223301.GA30829@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20101007223301.GA30829-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Jason,

On 16:33 Thu 07 Oct     , Jason Gunthorpe wrote:
> Otherwise running autogen.sh with a new version of autotools and then
> building on a system with an older version tends to explode.
> Unfortunately this is sometimes necessary since the new version is
> required by the package.
> 
> This is how GNU envisions this mess works at least..
> 
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> ---
>  infiniband-diags/Makefile.am  |    1 +
>  infiniband-diags/configure.in |    1 +
>  libibmad/Makefile.am          |    2 +-
>  libibmad/configure.in         |    1 +
>  libibumad/Makefile.am         |    2 +-
>  libibumad/configure.in        |    1 +
>  opensm/configure.in           |    1 +
>  7 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/infiniband-diags/Makefile.am b/infiniband-diags/Makefile.am
> index af90b05..e4d3d90 100644
> --- a/infiniband-diags/Makefile.am
> +++ b/infiniband-diags/Makefile.am
> @@ -1,3 +1,4 @@
> +ACLOCAL_AMFLAGS = -I config
>  SUBDIRS = libibnetdisc
>  
>  INCLUDES = -I$(top_builddir)/include/ -I$(srcdir)/include -I$(includedir) \
> diff --git a/infiniband-diags/configure.in b/infiniband-diags/configure.in
> index b9326c0..3c16aec 100644
> --- a/infiniband-diags/configure.in
> +++ b/infiniband-diags/configure.in
> @@ -3,6 +3,7 @@ dnl Process this file with autoconf to produce a configure script.
>  AC_PREREQ(2.57)
>  AC_INIT(infiniband-diags, 1.5.7, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)
>  AC_CONFIG_AUX_DIR(config)
> +AC_CONFIG_MACRO_DIR(config)
>  AM_CONFIG_HEADER(config.h)
>  AM_INIT_AUTOMAKE

infiniband-diags directory does have any custom m4 macros (libibmad and
libibumad too). Could you explain why should it fail without the change?
Is this for potential future use?

Sasha

>  
> diff --git a/libibmad/Makefile.am b/libibmad/Makefile.am
> index 6881453..f732c6c 100644
> --- a/libibmad/Makefile.am
> +++ b/libibmad/Makefile.am
> @@ -1,4 +1,4 @@
> -
> +ACLOCAL_AMFLAGS = -I config
>  SUBDIRS = .
>  
>  INCLUDES = -I$(srcdir)/include -I$(includedir)
> diff --git a/libibmad/configure.in b/libibmad/configure.in
> index 23ec914..97e8cb3 100644
> --- a/libibmad/configure.in
> +++ b/libibmad/configure.in
> @@ -4,6 +4,7 @@ AC_PREREQ(2.57)
>  AC_INIT(libibmad, 1.3.6, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)
>  AC_CONFIG_SRCDIR([src/sa.c])
>  AC_CONFIG_AUX_DIR(config)
> +AC_CONFIG_MACRO_DIR(config)
>  AM_CONFIG_HEADER(config.h)
>  AM_INIT_AUTOMAKE
>  
> diff --git a/libibumad/Makefile.am b/libibumad/Makefile.am
> index 6e3f518..28bf69c 100644
> --- a/libibumad/Makefile.am
> +++ b/libibumad/Makefile.am
> @@ -1,4 +1,4 @@
> -
> +ACLOCAL_AMFLAGS = -I config
>  SUBDIRS = .
>  
>  INCLUDES = -I$(srcdir)/include/infiniband -I$(includedir)
> diff --git a/libibumad/configure.in b/libibumad/configure.in
> index 9fcd609..04ecb0e 100644
> --- a/libibumad/configure.in
> +++ b/libibumad/configure.in
> @@ -4,6 +4,7 @@ AC_PREREQ(2.57)
>  AC_INIT(libibumad, 1.3.6, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)
>  AC_CONFIG_SRCDIR([src/umad.c])
>  AC_CONFIG_AUX_DIR(config)
> +AC_CONFIG_MACRO_DIR(config)
>  AM_CONFIG_HEADER(config.h)
>  AM_INIT_AUTOMAKE
>  
> diff --git a/opensm/configure.in b/opensm/configure.in
> index 8695965..057724a 100644
> --- a/opensm/configure.in
> +++ b/opensm/configure.in
> @@ -4,6 +4,7 @@ AC_PREREQ(2.57)
>  AC_INIT(opensm, 3.3.7, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)
>  AC_CONFIG_SRCDIR([opensm/osm_opensm.c])
>  AC_CONFIG_AUX_DIR(config)
> +AC_CONFIG_MACRO_DIR(config)
>  AC_CONFIG_HEADERS(include/config.h include/opensm/osm_config.h)
>  AM_INIT_AUTOMAKE
>  
> -- 
> 1.6.0.4
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

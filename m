From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [infiniband-diags PATCH 1/4] Update AM_INIT_AUTOMAKE to use
 subdir-objects
Date: Fri, 16 Sep 2016 07:02:01 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E24EE4623@CRSMSX101.amr.corp.intel.com>
References: <20160905214844.GA9613@pryan.ekaia.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160905214844.GA9613-2v28OwtJ5VXkvb5ro2YpKQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?iso-8859-1?Q?Ana_Guerrero_L=F3pez?= <ana-kLLpUjk7vcnYtjvyW6yDsg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Ana,

I just wanted to let you know that I have these in my Queue and will get to them soon.

Ira

> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Ana Guerrero López
> Sent: Monday, September 05, 2016 2:49 PM
> To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: [infiniband-diags PATCH 1/4] Update AM_INIT_AUTOMAKE to use
> subdir-objects
> 
> With this option, the objects are placed into the subdirectory of the build
> directory corresponding to the subdirectory of the source file.
> Fixes the following warning:
> 
> Makefile.am:103: warning: source file 'src/ibdiag_common.c' is in a
> subdirectory,
> Makefile.am:103: but option 'subdir-objects' is disabled
> automake: warning: possible forward-incompatibility.
> automake: At least a source file is in a subdirectory, but the 'subdir-objects'
> automake: automake option hasn't been enabled.  For now, the
> corresponding output
> automake: object file(s) will be placed in the top-level directory.  However,
> automake: this behaviour will change in future Automake versions: they will
> automake: unconditionally cause object files to be placed in the same
> subdirectory
> automake: of the corresponding sources.
> automake: You are advised to start using 'subdir-objects' option throughout
> your
> automake: project, to avoid future incompatibilities.
> 
> Signed-off-by: Ana Guerrero López <ana-kLLpUjk7vcnYtjvyW6yDsg@public.gmane.org>
> ---
>  configure.ac | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/configure.ac b/configure.ac index 623bc4f..75dbb8d 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -5,7 +5,7 @@ AC_INIT(infiniband-diags, 1.6.7, linux-
> rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)
>  AC_CONFIG_AUX_DIR(config)
>  AC_CONFIG_MACRO_DIR(config)
>  AM_CONFIG_HEADER(config.h)
> -AM_INIT_AUTOMAKE([foreign])
> +AM_INIT_AUTOMAKE([subdir-objects])
> 
>  AC_SUBST(RELEASE, ${RELEASE:-unknown})
>  AC_SUBST(TARBALL, ${TARBALL:-${PACKAGE}-${VERSION}.tar.gz})
> --
> 2.9.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the
> body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

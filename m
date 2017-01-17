From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH RFC rdma-core 1/3] util: Add common code for provider
 debug
Date: Tue, 17 Jan 2017 13:47:41 -0700
Message-ID: <20170117204741.GG27528@obsidianresearch.com>
References: <1484682413-56580-1-git-send-email-tatyana.e.nikolova@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1484682413-56580-1-git-send-email-tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> +++ b/buildlib/rdma_functions.cmake
> @@ -6,7 +6,7 @@
>  # Global list of pairs of (SHARED STATIC) libary target names
>  set(RDMA_STATIC_LIBS "" CACHE INTERNAL "Doc" FORCE)
>  
> -set(COMMON_LIBS_PIC ccan_pic)
> +set(COMMON_LIBS_PIC ccan_pic util_pic)
>  set(COMMON_LIBS ccan)

Also change COMMON_LIBS to have util

>  # Install a symlink during 'make install'
> diff --git a/util/CMakeLists.txt b/util/CMakeLists.txt
> index 1cda890..fb36103 100644
> +++ b/util/CMakeLists.txt
> @@ -1,3 +1,11 @@
>  publish_internal_headers(util
>    compiler.h
> +  dbg.h
>    )
> +
> +set(C_FILES
> +  dbg.c
> +  )
> +
> +add_library(util_pic ${C_FILES})

Use these two lines instead:

add_library(util STATIC ${C_FILES})
add_library(util_pic STATIC ${C_FILES})

> +#define VERBS_PROVIDER_DBG_MASK  "VERBS_PROVIDER_DBG_MASK"
> +#define VERBS_PROVIDER_DBG_LEVEL "VERBS_PROVIDER_DBG_LEVEL"
> +#define VERBS_PROVIDER_DBG_FILE  "VERBS_PROVIDER_DBG_FILE"

Probably don't need these as #defines

> +#define PRINT_ERR(fmt, ...)								\
> +do {											\
> +	fprintf(stderr, "[%s:%d]" fmt, __func__, __LINE__, ##__VA_ARGS__);		\
> +} while (0)
> +
> +#define PRINT_DBG(dbg_mask, dbg_level, fmt, ...)					\
> +do {											\
> +	if ((rdma_dbg_mask & dbg_mask) && (rdma_dbg_level >= dbg_level))		\
> +		fprintf(stderr, "[%s:%d]" fmt, __func__, __LINE__, ##__VA_ARGS__);	\
> +} while (0)

This could just be LOG_DBG(stderr, ....)

> +
> +#define LOG_DBG(dbg_fp, dbg_mask, dbg_level, fmt, ...)					\
> +do {											\
> +	if ((rdma_dbg_mask & dbg_mask) && (rdma_dbg_level >= dbg_level))		\
> +		fprintf(dbg_fp, "[%s:%d]" fmt, __func__, __LINE__, ##__VA_ARGS__);	\
> +} while (0)
> +
> +#define LOG_DBG_FLUSH(dbg_fp, dbg_mask, dbg_level, fmt, ...)				\
> +do {											\
> +		LOG_DBG(dbg_fp, dbg_mask, dbg_level, fmt, ##__VA_ARGS__);		\
> +		if (dbg_fp != stderr)							\
> +			fflush(dbg_fp);							\
> +} while (0)

Hum, wondering if it is worth retaining this FLUSH behavior or if we
should just have a way to open the log file with line buffering?

This patch should also include man page content please.

I think people will ask for the 'MLX5_DEBUG' style total compile out.
Should we have a --with-debug-log cmake option and disable it by
default?

'setup_debug' should probably happen someplace in verbs, not be in
every driver.

Otherwise looks essentially reasonable to me.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

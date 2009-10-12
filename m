From: Sasha Khapyorsky <sashak@voltaire.com>
Subject: Re: [PATCH] osmtest - code cleanup
Date: Mon, 12 Oct 2009 23:40:54 +0200
Message-ID: <20091012214054.GH13830@me>
References: <4BFF1A3398A74B2AABB948EF2843BF68@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <ofw-bounces@lists.openfabrics.org>
Content-Disposition: inline
In-Reply-To: <4BFF1A3398A74B2AABB948EF2843BF68@amr.corp.intel.com>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ofw>
List-Post: <mailto:ofw@lists.openfabrics.org>
List-Help: <mailto:ofw-request@lists.openfabrics.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=subscribe>
Sender: ofw-bounces@lists.openfabrics.org
Errors-To: ofw-bounces@lists.openfabrics.org
To: "Stan C. Smith" <stan.smith@intel.com>
Cc: ofw@lists.openfabrics.org, 'linux-rdma' <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On 11:57 Mon 12 Oct     , Stan C. Smith wrote:
> 
> Remove unused ifdef __WIN__ & redundant include.
> 
> Signed-off-by: stan smith <stan.smith@intel.com>

Applied. Thanks. The question is below.

> 
> diff --git a/opensm/osmtest/osmtest.c b/opensm/osmtest/osmtest.c
> index c6ec955..82a814e 100644
> --- a/opensm/osmtest/osmtest.c
> +++ b/opensm/osmtest/osmtest.c
> @@ -43,19 +43,13 @@
>   *
>   */
>  
> -#ifdef __WIN__
> -#pragma warning(disable : 4996)
> -#endif
> -
>  #include <stdio.h>
>  #include <stdlib.h>
>  #include <string.h>
> -#ifdef __WIN__
> -#include <complib/cl_timer.h>
> -#else
> +#ifndef __WIN__
>  #include <strings.h>
> -#include <sys/time.h>
>  #endif

I suppose that windows should have string.h, right? Assuming so could we
remove '#ifndef __WIN__' completely here?

Sasha

> +#include <sys/time.h>
>  #include <complib/cl_debug.h>
>  #include "osmtest.h"
>  
> 

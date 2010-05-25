From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm/complib use portable macro syntax
Date: Tue, 25 May 2010 13:54:57 +0300
Message-ID: <20100525105457.GN28549@me>
References: <3F6F638B8D880340AB536D29CD4C1E192562EBBAE9@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <3F6F638B8D880340AB536D29CD4C1E192562EBBAE9-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Stan,

On 09:45 Fri 21 May     , Smith, Stan wrote:
> 
> Use portable macro argument syntax.
> 
> signed-of-by: stan smith <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
  ^^^^^^^^^^^^
  Signed-off-by:

> 

The patch below is malformed - whitespaces are mangled (please check
your mailer).

Applied by hands. Thanks.

Sasha

> diff --git a/opensm/complib/cl_event_wheel.c b/opensm/complib/cl_event_wheel.c
> index ef6d598..eb894a6 100644
> --- a/opensm/complib/cl_event_wheel.c
> +++ b/opensm/complib/cl_event_wheel.c
> @@ -42,7 +42,7 @@
>  #include <complib/cl_event_wheel.h>
>  #include <complib/cl_debug.h>
> 
> -#define CL_DBG(fmt, arg...)
> +#define CL_DBG(fmt, ...)
> 
>  static cl_status_t __event_will_age_before(IN const cl_list_item_t *
>                                            const p_list_item, IN void *context)
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

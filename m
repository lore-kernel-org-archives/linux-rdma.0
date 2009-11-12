From: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] opensm - use C99 transportable data type for pointer
 storage
Date: Thu, 12 Nov 2009 09:32:28 -0800
Message-ID: <3F6F638B8D880340AB536D29CD4C1E1912CC482F85@orsmsx501.amr.corp.intel.com>
References: <086F8B40ADA84EE7B6398F4761937836@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <086F8B40ADA84EE7B6398F4761937836-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Sasha Khapyorsky' <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello,
  Can you help me understand why this patch always seems to fall into a black hole with no feedback?

Thank you,

Stan.


Stan C. Smith wrote:
> In order to skip the #ifndef __WIN__ around #include <stdint.h>,
> inttypes.h was used. 'inttypes.h' includes stdint.h and exists in the
> WinOF svn tree.
> OFED opensm builds without problems on EL 5.3.
>
> Signed-off-by: stan smith <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
> diff --git a/opensm/include/opensm/st.h b/opensm/include/opensm/st.h
> index 30cc308..ad6c289 100644
> --- a/opensm/include/opensm/st.h
> +++ b/opensm/include/opensm/st.h
> @@ -39,6 +39,7 @@
>  #define ST_INCLUDED
>
>  #include <stdlib.h>
> +#include <inttypes.h>
>
>  #ifdef __cplusplus
>  #  define BEGIN_C_DECLS extern "C" {
> @@ -49,7 +50,7 @@
>  #endif                               /* __cplusplus */
>
>  BEGIN_C_DECLS
> -#define st_ptr_t unsigned long
> +#define st_ptr_t uintptr_t
>  typedef st_ptr_t st_data_t;
>
>  #define ST_DATA_T_DEFINED

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

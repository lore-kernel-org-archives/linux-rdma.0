From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH 3/5] infiniband-diags/mcm_rereg_test.c: Include
 ib_types.h
Date: Fri, 13 Apr 2012 18:41:19 -0700
Message-ID: <20120413184119.0f725e89.weiny2@llnl.gov>
References: <1334279385-10792-1-git-send-email-foraker1@llnl.gov>
	<1334279385-10792-3-git-send-email-foraker1@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1334279385-10792-3-git-send-email-foraker1-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, 12 Apr 2012 18:09:43 -0700
Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org> wrote:

> Remove IB_MCM_COMPMASK defines, which should be pulled from
> ib_types.h instead.  This is necessary in order to allow future
> inclusion of ibdiag_common.h.
> 
> Signed-off-by: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>

Thanks applied,
Ira

> ---
>  src/mcm_rereg_test.c |   21 +--------------------
>  1 file changed, 1 insertion(+), 20 deletions(-)
> 
> diff --git a/src/mcm_rereg_test.c b/src/mcm_rereg_test.c
> index 55b8add..60ec421 100644
> --- a/src/mcm_rereg_test.c
> +++ b/src/mcm_rereg_test.c
> @@ -42,6 +42,7 @@
>  
>  #include <infiniband/umad.h>
>  #include <infiniband/mad.h>
> +#include <infiniband/iba/ib_types.h>
>  
>  #define info(fmt, ...) fprintf(stderr, "INFO: " fmt, ## __VA_ARGS__ )
>  #define err(fmt, ...) fprintf(stderr, "ERR: " fmt, ## __VA_ARGS__ )
> @@ -53,26 +54,6 @@
>  
>  #define TMO 100
>  
> -/* Multicast Member Record Component Masks */
> -#define IB_MCR_COMPMASK_MGID        (1ULL<<0)
> -#define IB_MCR_COMPMASK_PORT_GID    (1ULL<<1)
> -#define IB_MCR_COMPMASK_QKEY        (1ULL<<2)
> -#define IB_MCR_COMPMASK_MLID        (1ULL<<3)
> -#define IB_MCR_COMPMASK_MTU_SEL     (1ULL<<4)
> -#define IB_MCR_COMPMASK_MTU         (1ULL<<5)
> -#define IB_MCR_COMPMASK_TCLASS      (1ULL<<6)
> -#define IB_MCR_COMPMASK_PKEY        (1ULL<<7)
> -#define IB_MCR_COMPMASK_RATE_SEL    (1ULL<<8)
> -#define IB_MCR_COMPMASK_RATE        (1ULL<<9)
> -#define IB_MCR_COMPMASK_LIFE_SEL    (1ULL<<10)
> -#define IB_MCR_COMPMASK_LIFE        (1ULL<<11)
> -#define IB_MCR_COMPMASK_SL          (1ULL<<12)
> -#define IB_MCR_COMPMASK_FLOW        (1ULL<<13)
> -#define IB_MCR_COMPMASK_HOP         (1ULL<<14)
> -#define IB_MCR_COMPMASK_SCOPE       (1ULL<<15)
> -#define IB_MCR_COMPMASK_JOIN_STATE  (1ULL<<16)
> -#define IB_MCR_COMPMASK_PROXY       (1ULL<<17)
> -
>  static ibmad_gid_t mgid_ipoib = {
>  	0xff, 0x12, 0x40, 0x1b, 0xff, 0xff, 0x00, 0x00,
>  	0x00, 0x00, 0x00, 0x00, 0xff, 0xff, 0xff, 0xff
> -- 
> 1.7.9.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ira Weiny
Member of Technical Staff
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

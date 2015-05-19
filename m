From: "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 3/3] IB/sa: route SA pathrecord query through netlink
Date: Tue, 19 May 2015 12:57:43 +0000
Message-ID: <3F128C9216C9B84BB6ED23EF16290AFB0CAB2467@CRSMSX101.amr.corp.intel.com>
References: <1431975616-23529-1-git-send-email-kaike.wan@intel.com>
 <1431975616-23529-4-git-send-email-kaike.wan@intel.com>
 <555ADCE3.5080301@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <555ADCE3.5080301-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ilya Nelkenbaum <ilyan-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Fleck, John" <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> On 5/18/2015 10:00 PM, kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> > diff --git a/drivers/infiniband/core/sa_query.c
> b/drivers/infiniband/core/sa_query.c
> > index c38f030..69fcd28 100644
> > --- a/drivers/infiniband/core/sa_query.c
> > +++ b/drivers/infiniband/core/sa_query.c
> > @@ -45,12 +45,22 @@
> >  #include <uapi/linux/if_ether.h>
> >  #include <rdma/ib_pack.h>
> >  #include <rdma/ib_cache.h>
> > +#include <rdma/rdma_netlink.h>
> > +#include <net/netlink.h>
> > +#include <rdma/rdma_netlink.h>
> Redundant include

Will be removed.

Thank you,

Kaike
> 
> >  #include "sa.h"

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

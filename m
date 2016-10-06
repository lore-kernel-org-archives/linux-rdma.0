From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] MAINTAINERS: Update Intel RDMA RNIC driver maintainers
Date: Thu, 6 Oct 2016 15:36:59 -0600
Message-ID: <20161006213659.GA14459@obsidianresearch.com>
References: <20161005143054.4844-1-henry.orosco@intel.com>
 <20161005153530.GA11148@flatif-MOBL1>
 <20161005191229.GI18636@obsidianresearch.com>
 <13AA599688F47243B14FCFCCC2C803BB10A8C79D@fmsmsx104.amr.corp.intel.com>
 <02e701d22018$5d7ca740$1875f5c0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <02e701d22018$5d7ca740$1875f5c0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: "'Nikolova, Tatyana E'" <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "'Latif, Faisal'" <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "'Orosco, Henry'" <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 06, 2016 at 04:26:56PM -0500, Steve Wise wrote:
> > 
> > Hi Jason,
> > 
> > I will continue to maintain libnes, libi40iw and libiwpm in rdma-core.  Steve
> Wise
> > has significantly contributed to libiwpm which is iWarp related service and he
> may
> > be interested in co-maintaining it.
> 
> Sure.

Great, added to my pull request:

>From d8aca8da1cb51bb9ec43284a3060145ccddca69a Mon Sep 17 00:00:00 2001
From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Date: Thu, 6 Oct 2016 15:35:22 -0600
Subject: [PATCH] iwpmd: Add Steve Wise as a MAINTAINER

Acked-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Acked-by: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index e4f3554ea46a..49413a6544df 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -76,6 +76,7 @@ F:	providers/ipathverbs/
 
 IWARP PORT MAPPER DAEMON (for iwarp kernel providers)
 M:	Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
+M:	Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
 H:	Robert Sharp <robert.o.sharp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
 S:	Supported
 F:	iwpmd/
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

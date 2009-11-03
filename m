From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] RDMA CM: Correct detection of SA Created MGID
Date: Tue, 3 Nov 2009 10:35:39 -0800
Message-ID: <A10A4165EAE64FECAA5D33EF3D79BC9A@amr.corp.intel.com>
References: <20091103183308.GS7768@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091103183308.GS7768-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>RDMA CM treats AF_INET6 addresses that are either 0 or prefixed with
>FF1x:A01B::/32 as MGIDs, but the detection for the prefix was buggy,
>fix it up.
>
>Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

Acked-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

>---
> drivers/infiniband/core/cma.c |    2 +-
> 1 files changed, 1 insertions(+), 1 deletions(-)
>
>Sean: Sounded like you agree?

yes - thanks

>
>diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
>index 1e9a78a..a1041b2 100644
>--- a/drivers/infiniband/core/cma.c
>+++ b/drivers/infiniband/core/cma.c
>@@ -2720,7 +2720,7 @@ static void cma_set_mgid(struct rdma_id_private *id_priv,
> 	if (cma_any_addr(addr)) {
> 		memset(mgid, 0, sizeof *mgid);
> 	} else if ((addr->sa_family == AF_INET6) &&
>-		   ((be32_to_cpu(sin6->sin6_addr.s6_addr32[0]) & 0xFF10A01B) ==
>+		   ((be32_to_cpu(sin6->sin6_addr.s6_addr32[0]) & 0xFFF0FFFF) ==
> 								 0xFF10A01B)) {
> 		/* IPv6 address is an SA assigned MGID. */
> 		memcpy(mgid, &sin6->sin6_addr, sizeof *mgid);
>--
>1.5.4.2


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

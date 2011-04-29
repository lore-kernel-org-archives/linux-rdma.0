From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH 1/2] RDMA/cxgb4: Reset wait condition atomically.
Date: Fri, 29 Apr 2011 11:22:38 -0500
Message-ID: <4DBAE5CE.1080702@opengridcomputing.com>
References: <20110422175607.8004.14295.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110422175607.8004.14295.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On 04/22/2011 12:56 PM, Steve Wise wrote:
> The driver was never really waiting for RDMA_WR/FINI completions because
> the condition variable used to determine if the completion happened was
> never reset, and this condition variable is reused for both connection
> setup and teardown.  This causes various driver crashes under heavy
> loads due to releasing resources too early.
>
> The fix is to use atomic bits to correctly reset the condition immediately
> after the completion is detected.
>
> Signed-off-by: Steve Wise<swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

Hey Roland, are these 2 patches ok to merge?

Thanks,

Steve.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

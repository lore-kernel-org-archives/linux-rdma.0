From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH 2.6.36] RDMA/cxgb3: Don't exceed the max HW CQ depth.
Date: Sat, 28 Aug 2010 08:40:04 -0500
Message-ID: <4C7911B4.9070904@opengridcomputing.com>
References: <20100828133505.14439.81049.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100828133505.14439.81049.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

  On 8/28/2010 8:35 AM, Steve Wise wrote:
> The max depth supported by T3 is 64K entries.
>
> This bug will cause stalls and possibly crashes in large MPI clusters.
>
> Signed-off-by: Steve Wise<swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> ---

I would also like to get this into 2.6.35 stable.  What's the process 
for that?

Steve.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

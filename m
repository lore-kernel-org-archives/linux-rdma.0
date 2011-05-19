From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH] RDMA/core: Optimized path for kernel post_send/post_recv
Date: Thu, 19 May 2011 15:51:53 -0500
Message-ID: <4DD582E9.6020509@opengridcomputing.com>
References: <20110324123937.19461.56781.stgit@gkslx010.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110324123937.19461.56781.stgit-dAdtdUp2yJRU7keBU/FxOFDQ4js95KgL@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: miroslaw.walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 03/24/2011 07:43 AM, miroslaw.walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> The patch introduces a new path of posting buffers from user-space to kernel
> post_send/post_recv using shared page.
>
> The shared page is allocated and defined by vendor driver.
> The vendor driver during create QP decides when the new path will be used
> setting a field use_shpage_for_rxtx field in connection context.
>
> When the connection context indicates that the shared page  should be used
> the uverbs_post_send()/uverbs_post_recv() calls directly the vendor driver
> private post_send()/post_recv() functions improving the kernel path.
>
> Signed-off-by: Mirek Walukiewicz<miroslaw.walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---

Hey Roland,

Do you plan to merge this?

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

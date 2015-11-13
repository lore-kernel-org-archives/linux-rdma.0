From: "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v2 1/1] IB/sa: Put netlink request into the request list
 before sending
Date: Fri, 13 Nov 2015 13:57:43 +0000
Message-ID: <3F128C9216C9B84BB6ED23EF16290AFB1857DA25@CRSMSX101.amr.corp.intel.com>
References: <1446207825-17664-1-git-send-email-kaike.wan@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1446207825-17664-1-git-send-email-kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
> Sent: Friday, October 30, 2015 8:24 AM
> To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: Wan, Kaike
> Subject: [PATCH v2 1/1] IB/sa: Put netlink request into the request list before
> sending
> 
> From: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> It was found by Saurabh Sengar that the netlink code tried to allocate
> memory with GFP_KERNEL while holding a spinlock. While it is possible to fix
> the issue by replacing GFP_KERNEL with GFP_ATOMIC, it is better to get rid
> of the spinlock while sending the packet. However, in order to protect
> against a race condition that a quick response may be received before the
> request is put on the request list, we need to put the request on the list first.
> 
> Signed-off-by: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---

Reported-by: Saurabh Sengar <saurabh.truth-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Kaike
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

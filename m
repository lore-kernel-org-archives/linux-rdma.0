From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH 0/2] NFS/RDMA server patches for 3.17
Date: Thu, 10 Jul 2014 14:00:48 -0500
Message-ID: <53BEE2E0.2080908@opengridcomputing.com>
References: <20140710174225.3734.44692.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140710174225.3734.44692.stgit-Hs+gFlyCn65vLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, swise-UeZzRo20aYc@public.gmane.org
Cc: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Done!

(my email is swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org)

Steve.

On 7/10/2014 12:44 PM, Chuck Lever wrote:
> Hi Steve-
>
> Can you include these two potential 3.17 candidate patches in
> your testing branch?
>
> ---
>
> Chuck Lever (2):
>        svcrdma: Remove extra writeargs sanity check for NFSv2/3
>        svcrdma: Increase credit limit to 32
>
>
>   fs/nfsd/nfs3xdr.c               |   15 +--------------
>   fs/nfsd/nfsxdr.c                |   16 +---------------
>   include/linux/sunrpc/svc_rdma.h |    3 +--
>   3 files changed, 3 insertions(+), 31 deletions(-)
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

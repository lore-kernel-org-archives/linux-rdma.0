From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 13/15] IB/srpt: Detect session shutdown reliably
Date: Wed, 6 Jan 2016 16:39:03 +0200
Message-ID: <568D2707.9020309@dev.mellanox.co.il>
References: <568BD0FC.70207@sandisk.com> <568BD2A9.6070600@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <568BD2A9.6070600-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 05/01/2016 16:26, Bart Van Assche wrote:
> The Last WQE Reached event is only generated after one or more work
> requests have been queued on the QP associated with a session. Since
> session shutdown can start before any work requests have been queued,
> use a zero-length RDMA write to wait until a QP has been drained.

Is it just me or is there (a lot) more going on here other than
this patch description?

Would it be possible to either:
- break the patch to smaller pieces (preferable), or
- document all the changes in this patch

It's hard to understand the reason for each change.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

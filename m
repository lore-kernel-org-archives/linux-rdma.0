From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 0/2] Don't allocate ib/iw cm workqueues with
 WQ_MEM_RECLAIM
Date: Fri, 18 Aug 2017 10:48:53 -0400
Message-ID: <1503067733.2598.8.camel@redhat.com>
References: <1502824838-21745-1-git-send-email-sagi@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1502824838-21745-1-git-send-email-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2017-08-15 at 22:20 +0300, Sagi Grimberg wrote:
> It's not correct due to the fact that such workqueues cannot allocate
> memory in their work execution by definition, which is definitly not
> the case for cm workqueues.
> 
> Changes from v1:
> - fixed spelling glitch
> 
> Sagi Grimberg (2):
>   cm: Don't allocate ib_cm workqueue with WQ_MEM_RECLAIM
>   iwcm: Don't allocate iwcm workqueue with WQ_MEM_RECLAIM
> 
>  drivers/infiniband/core/cm.c   | 2 +-
>  drivers/infiniband/core/iwcm.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

Thanks Sagi, series applied.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

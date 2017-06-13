From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 0/2] RDMA/qedr: A couple of patches
Date: Tue, 13 Jun 2017 16:42:15 -0400
Message-ID: <1497386535.7171.242.camel@redhat.com>
References: <1496064191-11442-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1496064191-11442-1-git-send-email-Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, 2017-05-29 at 16:23 +0300, Ram Amrani wrote:
> Michal Kalderon (1):
>   RDMA/qedr: Initialize byte_len in WC of READ and SEND commands
> 
> Ram Amrani (1):
>   RDMA/qedr: Add 64KB PAGE_SIZE support to user-space queues
> 
>  drivers/infiniband/hw/qedr/qedr.h  |  4 ++-
>  drivers/infiniband/hw/qedr/verbs.c | 69 +++++++++++++++++++++++-----
> ----------
>  2 files changed, 45 insertions(+), 28 deletions(-)

This series dropped because you resubmitted it for rc instead of next.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

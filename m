From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 rdma for-rc 0/2] RDMA/qedr: A couple of patches
Date: Tue, 13 Jun 2017 16:41:24 -0400
Message-ID: <1497386484.7171.241.camel@redhat.com>
References: <1496669547-22503-1-git-send-email-Ram.Amrani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1496669547-22503-1-git-send-email-Ram.Amrani-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ram Amrani <Ram.Amrani-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 2017-06-05 at 16:32 +0300, Ram Amrani wrote:
> From: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
> 
> Changes from v1:
> I've rebased the patches agains 4.12-rc and request them to be added
> to
> the rc and not for-next.
> As a result I've used umem->shift instead of the now obsolete umem-
> >page_size.
> 
> Michal Kalderon (1):
>   RDMA/qedr: Initialize byte_len in WC of READ and SEND commands
> 
> Ram Amrani (1):
>   RDMA/qedr: Add 64KB PAGE_SIZE support to user-space queues
> 
>  drivers/infiniband/hw/qedr/qedr.h  |  5 ++-
>  drivers/infiniband/hw/qedr/verbs.c | 68 +++++++++++++++++++++++-----
> ----------
>  2 files changed, 45 insertions(+), 28 deletions(-)

Series applied, thanks.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

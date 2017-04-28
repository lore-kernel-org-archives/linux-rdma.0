From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma 0/5] RDMA/qedr: four fixes and an enhancment
Date: Fri, 28 Apr 2017 12:49:34 -0400
Message-ID: <1493398174.3041.153.camel@redhat.com>
References: <1493289335-29350-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1493289335-29350-1-git-send-email-Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, 2017-04-27 at 13:35 +0300, Ram Amrani wrote:
> Three bug fixes:
>   RDMA/qedr: reset access control when registering a MR
>   RDMA/qedr: properly check atomic capabilities
>   RDMA/qedr: destroy CQ only after HW releases it
> 
> Missing functionality bug:
>   RDMA/qedr: add support for send+invalidate in poll CQ
> 
> Enhancment:
>   RDMA/qedr: enhance destroy flow for GSI QP
> 
> Ram Amrani (5):
>   RDMA/qedr: reset access control when registering a MR
>   RDMA/qedr: properly check atomic capabilities
>   RDMA/qedr: enhance destroy flow for GSI QP
>   RDMA/qedr: destroy CQ only after HW releases it
>   RDMA/qedr: add support for send+invalidate in poll CQ
> 
>  drivers/infiniband/hw/qedr/main.c  |  88 +++++++++++-------
>  drivers/infiniband/hw/qedr/qedr.h  |   5 +-
>  drivers/infiniband/hw/qedr/verbs.c | 185
> +++++++++++++++++++++++++++----------
>  include/uapi/linux/pci_regs.h      |   1 +
>  4 files changed, 198 insertions(+), 81 deletions(-)

Thanks, series applied.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

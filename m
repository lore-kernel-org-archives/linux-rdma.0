From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-rc 0/2] RDMA/qedr: two important fixes for RDMA CM
 with VLAN
Date: Wed, 04 Oct 2017 15:20:01 -0400
Message-ID: <1507144801.46071.3.camel@redhat.com>
References: <1507031247-7972-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1507031247-7972-1-git-send-email-Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, 2017-10-03 at 14:47 +0300, Ram Amrani wrote:
> This series contains two important fixes for RDMA CM with VLAN.
> 
> Ram Amrani (2):
>   RDMA/qedr: Parse VLAN ID correctly and ignore the value of zero
>   RDMA/qedr: Parse vlan priority as sl
> 
>  drivers/infiniband/hw/qedr/qedr.h    |  2 +-
>  drivers/infiniband/hw/qedr/qedr_cm.c | 12 +++++++++---
>  2 files changed, 10 insertions(+), 4 deletions(-)

Thanks, applied.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

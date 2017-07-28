From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma 0/3] RDMA/qedr: User-to-kernel space patches
Date: Fri, 28 Jul 2017 14:06:10 -0400
Message-ID: <1501265170.2593.32.camel@redhat.com>
References: <1498493106-28604-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1498493106-28604-1-git-send-email-Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, 2017-06-26 at 19:05 +0300, Ram Amrani wrote:
> The first patch is a fix that prevents memory overrun.
> Thanks Jason.
> 
> The other two add new parameters that are passed to rdma-core.
> 
> Ram Amrani (3):
>   RDMA/qedr: Prevent memory overrun in verbs' user responses
>   RDMA/qedr: notify user application if DPM is supported
>   RDMA/qedr: notify user application of supported WIDs
> 
>  drivers/infiniband/hw/qedr/main.c  |  1 +
>  drivers/infiniband/hw/qedr/qedr.h  |  2 ++
>  drivers/infiniband/hw/qedr/verbs.c | 19 +++++++++++++++----
>  include/uapi/rdma/qedr-abi.h       |  3 +++
>  4 files changed, 21 insertions(+), 4 deletions(-)

The first patch was a fix and made it into -rc.  The other two were not
really fixes, but have been applied to -next.  Thanks.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

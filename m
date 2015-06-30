From: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Subject: Re: [PATCH 0/2] update ocrdma to dual license
Date: Tue, 30 Jun 2015 11:33:58 +0530
Message-ID: <CANjDDBiB_CDnGsuF5Lkif+wD_ZPNkiHB-joeSaYHev9Tt=s0Bg@mail.gmail.com>
References: <1434127505-17739-1-git-send-email-devesh.sharma@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1434127505-17739-1-git-send-email-devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

a gentle reminder to pull this simple patch-set to your tree.

-Regards
Devesh

On Fri, Jun 12, 2015 at 10:15 PM, Devesh Sharma
<devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org> wrote:
> A series to update the license from GPL to GPL/Dual-BSD licensing
> for ocrdma source.
>
> Devesh Sharma (2):
>   RDMA/ocrdma: update license from gpl to dual license
>   RDMA/ocrdma: update module license to dual license
>
>  drivers/infiniband/hw/ocrdma/ocrdma.h       |   53 ++++++++++++++++---------
>  drivers/infiniband/hw/ocrdma/ocrdma_abi.h   |   53 ++++++++++++++++---------
>  drivers/infiniband/hw/ocrdma/ocrdma_ah.c    |   53 ++++++++++++++++---------
>  drivers/infiniband/hw/ocrdma/ocrdma_ah.h    |   53 ++++++++++++++++---------
>  drivers/infiniband/hw/ocrdma/ocrdma_hw.c    |   53 ++++++++++++++++---------
>  drivers/infiniband/hw/ocrdma/ocrdma_hw.h    |   53 ++++++++++++++++---------
>  drivers/infiniband/hw/ocrdma/ocrdma_main.c  |   55 +++++++++++++++++----------
>  drivers/infiniband/hw/ocrdma/ocrdma_sli.h   |   53 ++++++++++++++++---------
>  drivers/infiniband/hw/ocrdma/ocrdma_stats.c |   53 ++++++++++++++++---------
>  drivers/infiniband/hw/ocrdma/ocrdma_stats.h |   53 ++++++++++++++++---------
>  drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |   53 ++++++++++++++++---------
>  drivers/infiniband/hw/ocrdma/ocrdma_verbs.h |   53 ++++++++++++++++---------
>  12 files changed, 409 insertions(+), 229 deletions(-)
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 0/4] RDMA/ocrdma: Add RoCE-v2 support
Date: Mon, 8 Feb 2016 16:18:33 +0530
Message-ID: <CANjDDBgVeADqgDTtC1L7QMOLmuH6UE5L3+wXTTetWzKA6+nMnw@mail.gmail.com>
References: <1453989599-21307-1-git-send-email-devesh.sharma@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1453989599-21307-1-git-send-email-devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Dough,

This is a gentle reminder to pull this patch series into upstream.
Please let me know if you are targeting a specific kernel version.

-Regards
Devesh

On Thu, Jan 28, 2016 at 7:29 PM, Devesh Sharma
<devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org> wrote:
> This patch series adds support for RoCE-v2 protocol
> on Avago's RoCE enabled adapters.
>
> Devesh Sharma (3):
>   RDMA/ocrdma: Support RoCE-v2 in the UD path
>   RDMA/ocrdma: Support RoCE-v2 in the RC path
>   RDMA/ocrdma: Support user AH creation for RoCE-v2
>
> Somnath Kotur (1):
>   RDMA/ocrdma: Export udp encapsulation capability
>
>  drivers/infiniband/hw/ocrdma/ocrdma.h       |  8 +++
>  drivers/infiniband/hw/ocrdma/ocrdma_ah.c    | 75 ++++++++++++++++++++++++-----
>  drivers/infiniband/hw/ocrdma/ocrdma_ah.h    |  5 +-
>  drivers/infiniband/hw/ocrdma/ocrdma_hw.c    | 26 +++++++++-
>  drivers/infiniband/hw/ocrdma/ocrdma_main.c  |  4 ++
>  drivers/infiniband/hw/ocrdma/ocrdma_sli.h   | 16 ++++--
>  drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 22 +++++++--
>  7 files changed, 134 insertions(+), 22 deletions(-)
>
> --
> 1.8.3.1
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

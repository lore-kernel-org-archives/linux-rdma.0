From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-rc 0/3] RDMA fixes for 4.13
Date: Thu, 24 Aug 2017 15:41:03 -0400
Message-ID: <1503603663.78641.37.camel@redhat.com>
References: <20170823053542.17754-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170823053542.17754-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, 2017-08-23 at 08:35 +0300, Leon Romanovsky wrote:
> Hi Doug,
> 
> Those patches were found after you asked me if I have new patches
> for the rdma-rc and at that time I really didn't have.
> 
> There are three patches in this series, two from Majd and one from
> Noa.
> 
> The patch from Noa was the one which pushed me to send it now.
> Latest changes to support LID started to use port number to determine
> port type, and it is not always safe. This allows access to non-
> allocated
> memory, despite the fact that the scope of this attack is limited by
> the size
> of port (u8), but it is better to fix it now and don't bother
> ourselves
> with stable@ e.t.c.
> 
> The patches from Majd are fixing one panic and one as a followup to
> latest discussion with Selvin about common modify_port function.
> 
> Thanks
> ----------------------------------------------------------------
> Majd Dibbiny (2):
>       IB/mlx5: Fix Raw Packet QP event handler assignment
>       IB/mlx5: Always return success for RoCE modify port
> 
> Noa Osherovich (1):
>       IB/core: Avoid accessing non-allocated memory when inferring
> port type
> 
>  drivers/infiniband/core/uverbs_cmd.c | 11 +++++++----
>  drivers/infiniband/core/verbs.c      |  7 ++++++-
>  drivers/infiniband/hw/mlx5/main.c    |  6 ++++++
>  drivers/infiniband/hw/mlx5/qp.c      |  1 +
>  include/rdma/ib_verbs.h              |  1 +
>  5 files changed, 21 insertions(+), 5 deletions(-)

Thanks, applied for -rc.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

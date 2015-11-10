From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v2 0/2] Handle mlx4 max_sge_rd correctly
Date: Tue, 10 Nov 2015 12:36:44 +0200
Message-ID: <5641C8BC.40507@dev.mellanox.co.il>
References: <1446031696-19022-1-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1446031696-19022-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 28/10/2015 13:28, Sagi Grimberg wrote:
> This addresses a specific mlx4 issue where the max_sge_rd
> is actually smaller than max_sge (rdma reads with max_sge
> entries completes with error).
>
> The second patch removes the explicit work-around from the
> iser target code.
>
> Changes from v1:
> - Fixed driver rdma segment size to be 16 bytes
>
> Changes from v0:
> - Used a dedicated enumeration MLX4_MAX_SGE_RD and added
>    a root cause analysis to patch change log.
>
> - Fixed isert qp creation to be max_sge but construct rdma
>    work request with the minimum of max_sge and max_sge_rd
>    as non-rdma sends (login rsp) take 2 sges (and some devices
>    have max_sge_rd = 1.
>
> Sagi Grimberg (2):
>    mlx4: Expose correct max_sge_rd limit
>    iser-target: Remove explicit mlx4 work-around
>
>   drivers/infiniband/hw/mlx4/main.c       |    2 +-
>   drivers/infiniband/ulp/isert/ib_isert.c |   13 +++----------
>   include/linux/mlx4/device.h             |   11 +++++++++++
>   3 files changed, 15 insertions(+), 11 deletions(-)
>

Doug,

Any reply on this patchset?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

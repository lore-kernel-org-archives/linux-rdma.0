From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 for-next 0/2] RDMA/bnxt_Re: Patches for for-next
Date: Fri, 18 Aug 2017 15:09:17 -0400
Message-ID: <1503083357.2598.46.camel@redhat.com>
References: <1501663579-24707-1-git-send-email-selvin.xavier@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1501663579-24707-1-git-send-email-selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, 2017-08-02 at 01:46 -0700, Selvin Xavier wrote:
> Hi Doug,
> 
> This patch series include two feature additions for bnxt_re.
> Patch 1 adds support for multiple interrupt vectors in data path
> and patch 2 adds the support for exporting some of the hw statistics.
> 
> Please consider them for the for-next branch.
> 
> Thanks,
> Selvin Xavier
> 
> v1->v2:
> 	Fix kbuild test warnings for xtensa architecture
> 
> Selvin Xavier (1):
>   RDMA/bnxt_re: Allocate multiple notification queues
> 
> Somnath Kotur (1):
>   RDMA/bnxt_re: Implement the alloc/get_hw_stats callback
> 
>  drivers/infiniband/hw/bnxt_re/Makefile      |   2 +-
>  drivers/infiniband/hw/bnxt_re/bnxt_re.h     |   5 +-
>  drivers/infiniband/hw/bnxt_re/hw_counters.c | 114
> ++++++++++++++++++++++++++++
>  drivers/infiniband/hw/bnxt_re/hw_counters.h |  62 +++++++++++++++
>  drivers/infiniband/hw/bnxt_re/ib_verbs.c    |  17 ++++-
>  drivers/infiniband/hw/bnxt_re/main.c        | 110 +++++++++++++++++-
> ---------
>  drivers/infiniband/hw/bnxt_re/qplib_fp.c    |  21 ++++-
>  drivers/infiniband/hw/bnxt_re/qplib_fp.h    |   4 +-
>  8 files changed, 285 insertions(+), 50 deletions(-)
>  create mode 100644 drivers/infiniband/hw/bnxt_re/hw_counters.c
>  create mode 100644 drivers/infiniband/hw/bnxt_re/hw_counters.h

Thanks, series applied.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

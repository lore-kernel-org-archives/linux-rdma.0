From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH v6 for-4.13 0/7] Automatic affinity settings for nvme
        over rdma
Date: Mon, 19 Jun 2017 14:28:06 +0200
Message-ID: <20170619122806.GA29061@lst.de>
References: <1497796677-15794-1-git-send-email-sagi@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1497796677-15794-1-git-send-email-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Saeed Mahameed <saeedm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Thanks Sagi,

the whole series looks great to me.

It would be even nicer if the maintainers of the various HCA drivers
could look into adding support..

On Sun, Jun 18, 2017 at 05:37:50PM +0300, Sagi Grimberg wrote:
> Doug, please consider this patch set for 4.13.
> Saeed, care to get this into your testing environment?
> 
> This patch set is aiming to automatically find the optimal
> queue <-> irq multi-queue assignments in storage ULPs (demonstrated
> on nvme-rdma) based on the underlying rdma device irq affinity
> settings.
> 
> Changes from v5:
> - updated change log for patch #2
> - removed nit indentation changes
> 
> Changes from v4:
> - removed mlx5e assumptions on device home node irq affinity mappings
> - rebased to 4.12-rc5
> 
> Changes from v3:
> - Renamed mlx5_disable_msix -> mlx5_free_pci_vectors for symmetry reasons
> 
> Changes from v2:
> - rebased to 4.12
> - added review tags
> 
> Changes from v1:
> - Removed mlx5e_get_cpu as Christoph suggested
> - Fixed up nvme-rdma queue comp_vector selection to get a better match
> - Added a comment on why we limit on @dev->num_comp_vectors
> - rebased to Jens's for-4.12/block
> - Collected review tags
> 
> Sagi Grimberg (7):
>   mlx5: convert to generic pci_alloc_irq_vectors
>   mlx5e: don't assume anything on the irq affinity mappings of the
>     device
>   mlx5: move affinity hints assignments to generic code
>   RDMA/core: expose affinity mappings per completion vector
>   mlx5: support ->get_vector_affinity
>   block: Add rdma affinity based queue mapping helper
>   nvme-rdma: use intelligent affinity based queue mappings
> 
>  block/Kconfig                                      |   5 +
>  block/Makefile                                     |   1 +
>  block/blk-mq-rdma.c                                |  54 +++++++++++
>  drivers/infiniband/hw/mlx5/main.c                  |   9 ++
>  drivers/net/ethernet/mellanox/mlx5/core/en.h       |   1 -
>  drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  54 +++++------
>  drivers/net/ethernet/mellanox/mlx5/core/eq.c       |   9 +-
>  drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |   2 +-
>  drivers/net/ethernet/mellanox/mlx5/core/health.c   |   2 +-
>  drivers/net/ethernet/mellanox/mlx5/core/main.c     | 106 ++++-----------------
>  .../net/ethernet/mellanox/mlx5/core/mlx5_core.h    |   1 -
>  drivers/nvme/host/rdma.c                           |  29 ++++--
>  include/linux/blk-mq-rdma.h                        |  10 ++
>  include/linux/mlx5/driver.h                        |   8 +-
>  include/rdma/ib_verbs.h                            |  25 ++++-
>  15 files changed, 174 insertions(+), 142 deletions(-)
>  create mode 100644 block/blk-mq-rdma.c
>  create mode 100644 include/linux/blk-mq-rdma.h
> 
> -- 
> 2.7.4
---end quoted text---
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

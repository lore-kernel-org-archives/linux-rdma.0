From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH for-next 00/10] mlx4: Add Memory Windows support
Date: Sun, 24 Feb 2013 07:31:04 +0000
Message-ID: <14E57612D748984B982C350F6A78109E67F78CEB@MTRDAG01.mtl.com>
References: <1360167556-20756-1-git-send-email-ogerlitz@mellanox.com>
 <CAJZOPZJwcLyhc88WCjmnrBRDLo9qp6snSLxQGEZUfYOTyuVMCg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZJwcLyhc88WCjmnrBRDLo9qp6snSLxQGEZUfYOTyuVMCg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shani Michaeli <shanim-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

+ Shani@Mellanox

-----Original Message-----
From: Or Gerlitz [mailto:or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org] 
Sent: Monday, February 18, 2013 6:48 PM
To: Roland Dreier
Cc: linux-rdma; Haggai Eran; Moni Shoua; shanim-xlywION9k29BDgjK7y7TUQ@public.gmane.org
Subject: Re: [PATCH for-next 00/10] mlx4: Add Memory Windows support

On Wed, Feb 6, 2013 at 6:19 PM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:

> Here's a series from Shani Michaeli and Haggai Eran adds mlx4 driver 
> support for Memory Windows.

Hi Roland,

So things are warming up for the 3.9 merge window, I see that this series is marked as "new" in your patchwork - any comments? is it be condisred in for 3.9?

Or.


> The first entries in this set are "pre patches" preparing the grounds 
> for the actual implementation of MWs. Later there're two core patches, 
> one to ib_verbs.h adding support for type 2 MWs and another one to 
> uverbs that exposes MW commands to user space. And finally the actual 
> mlx4 driver MWs patches.

> Shani Michaeli (10):
>   IB/mlx4_ib: Remove local invalidate segment unused fields
>   net/mlx4_core: Rename MPT related service routines to have mpt_ prefix
>   net/mlx4_core: Propogate MR deregistration failure
>   net/mlx4_core: Disable memory windows for VFs
>   net/mlx4_core: Enable memory windows in {INIT,QUERY}_HCA
>   IB/core: Enhance memory windows support
>   IB/uverbs: Implement memory windows support in uverbs
>   mlx4: Implement memory windows allocation and deallocation
>   IB/mlx4_ib: Support memory window binding
>   IB/mlx4_ib: Advertize MW support
>
>  drivers/infiniband/core/uverbs.h                   |    2 +
>  drivers/infiniband/core/uverbs_cmd.c               |  121 +++++++++++++
>  drivers/infiniband/core/uverbs_main.c              |   13 ++-
>  drivers/infiniband/core/verbs.c                    |    5 +-
>  drivers/infiniband/hw/cxgb3/iwch_provider.c        |    5 +-
>  drivers/infiniband/hw/cxgb3/iwch_qp.c              |   15 +-
>  drivers/infiniband/hw/cxgb4/iw_cxgb4.h             |    2 +-
>  drivers/infiniband/hw/cxgb4/mem.c                  |    5 +-
>  drivers/infiniband/hw/ehca/ehca_iverbs.h           |    2 +-
>  drivers/infiniband/hw/ehca/ehca_mrmw.c             |    5 +-
>  drivers/infiniband/hw/mlx4/main.c                  |   19 ++
>  drivers/infiniband/hw/mlx4/mlx4_ib.h               |   14 ++
>  drivers/infiniband/hw/mlx4/mr.c                    |   87 +++++++++-
>  drivers/infiniband/hw/mlx4/qp.c                    |   41 ++++-
>  drivers/infiniband/hw/nes/nes_verbs.c              |   19 ++-
>  drivers/net/ethernet/mellanox/mlx4/en_main.c       |    4 +-
>  drivers/net/ethernet/mellanox/mlx4/fw.c            |   14 ++-
>  drivers/net/ethernet/mellanox/mlx4/fw.h            |    1 +
>  drivers/net/ethernet/mellanox/mlx4/main.c          |    4 +
>  drivers/net/ethernet/mellanox/mlx4/mlx4.h          |   34 +++-
>  drivers/net/ethernet/mellanox/mlx4/mr.c            |  186
> +++++++++++++++-----
>  .../net/ethernet/mellanox/mlx4/resource_tracker.c  |   63 ++++++-
>  include/linux/mlx4/device.h                        |   22 ++-
>  include/linux/mlx4/qp.h                            |   19 ++-
>  include/rdma/ib_verbs.h                            |   73 +++++++-
>  include/uapi/rdma/ib_user_verbs.h                  |   16 ++
>  net/sunrpc/xprtrdma/verbs.c                        |   20 +-
>  27 files changed, 683 insertions(+), 128 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

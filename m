From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH rdma-next] IB/core: Simplify rdma cgroup registration
Date: Fri, 18 Jan 2019 13:44:16 -0700
Message-ID: <20190118204416.GA7101@ziepe.ca>
References: <20190117181415.28566-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190117181415.28566-1-leon@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Parav Pandit <parav@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>, Leon Romanovsky <leonro@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jan 17, 2019 at 08:14:15PM +0200, Leon Romanovsky wrote:
> From: Parav Pandit <parav@mellanox.com>
> 
> RDMA cgroup registration routine always returns success,
> so simplify function to be void and run clang formatter
> over whole CONFIG_CGROUP_RDMA art of core_priv.h.
> 
> This reduces unwinding error path for regular registration and
> future net namespace change functionality for rdma device.
> 
> Signed-off-by: Parav Pandit <parav@mellanox.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> Acked-by: Tejun Heo <tj@kernel.org>
> ---
>  drivers/infiniband/core/cgroup.c    |  5 ++---
>  drivers/infiniband/core/core_priv.h | 17 +++++++++++------
>  drivers/infiniband/core/device.c    |  8 +-------
>  include/linux/cgroup_rdma.h         |  2 +-
>  kernel/cgroup/rdma.c                |  5 +----
>  5 files changed, 16 insertions(+), 21 deletions(-)

Applied to for-next

Thanks,
Jason

From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] RDMA: fix dependencies for rdma_user_mmap_io
Date: Wed, 26 Sep 2018 13:51:10 -0600
Message-ID: <20180926195110.GA27233@ziepe.ca>
References: <20180926193706.2447532-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180926193706.2447532-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Lijun Ou <oulijun@huawei.com>, "Wei Hu(Xavier)" <xavier.huwei@huawei.com>, Doug Ledford <dledford@redhat.com>, Yishai Hadas <yishaih@mellanox.com>, Shaobo Xu <xushaobo2@huawei.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Sep 26, 2018 at 09:36:52PM +0200, Arnd Bergmann wrote:
> The mlx4 driver produces a link error when it is configured
> as built-in while CONFIG_INFINIBAND_USER_ACCESS is set to =m:
> 
> drivers/infiniband/hw/mlx4/main.o: In function `mlx4_ib_mmap':
> main.c:(.text+0x1af4): undefined reference to `rdma_user_mmap_io'
> 
> The same function is called from mlx5, which already has a
> dependency to ensure we can call it, and from hns, which
> appears to suffer from the same problem.
> 
> This adds the same dependency that mlx5 uses to the other two.
> 
> Fixes: 6745d356ab39 ("RDMA/hns: Use rdma_user_mmap_io")
> Fixes: c282da4109e4 ("RDMA/mlx4: Use rdma_user_mmap_io")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/infiniband/hw/hns/Kconfig  | 1 +
>  drivers/infiniband/hw/mlx4/Kconfig | 1 +
>  2 files changed, 2 insertions(+)

Woops, thanks Arnd, applied to for-next

Jason

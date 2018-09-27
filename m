From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] RDMA/ucontext: fix building with CONFIG_MMU=n
Date: Thu, 27 Sep 2018 10:26:05 -0600
Message-ID: <20180927162605.GB28301@ziepe.ca>
References: <20180927101017.990471-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180927101017.990471-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leon@kernel.org>, Matan Barak <matanb@mellanox.com>, Parav Pandit <parav@mellanox.com>, "Wei Hu(Xavier)" <xavier.huwei@huawei.com>, Huy Nguyen <huyn@mellanox.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 27, 2018 at 12:10:03PM +0200, Arnd Bergmann wrote:
> The zap_vma_ptes() is declared but not defined on NOMMU kernels,
> causing a link error for the newly added uverbs code:
> 
> drivers/infiniband/core/uverbs_main.o: In function `uverbs_user_mmap_disassociate':
> uverbs_main.c:(.text+0x114c): undefined reference to `zap_vma_ptes'
> drivers/infiniband/core/uverbs_main.o: In function `rdma_umap_open':
> uverbs_main.c:(.text+0x53c): undefined reference to `zap_vma_ptes'

I'm a bit surprised by this - the code is not new, it just got moved
out of the drivers, and I don't see any protections there against
CONFIG_MMU ??
 
> To fix this, we can either make uverbs depend on CONFIG_MMU, or try
> to build it anyway. Since this is the only compile-time dependency,
> I decided to allow building it with an extra compile-time check for
> CONFIG_MMU before calling the one function.

Hrm. So this code doesn't work at all on NOMMU, it relies on
remap_pfn_range, which always fails on those kernels, 

Due to this of this the entirety of INFINIBAND_USER_ACCESS is broken.

I think a kconfig change is the better way to go?

Jason

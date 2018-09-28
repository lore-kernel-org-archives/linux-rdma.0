From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] RDMA/ucontext: fix building with CONFIG_MMU=n
Date: Fri, 28 Sep 2018 11:15:16 +0200
Message-ID: <CAK8P3a0m2WhWKZgMnJuarh5Y3uF-A3Ou228in-0wLg=9bTpMKA@mail.gmail.com>
References: <20180927101017.990471-1-arnd@arndb.de> <20180927162605.GB28301@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180927162605.GB28301@ziepe.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leon@kernel.org>, Matan Barak <matanb@mellanox.com>, Parav Pandit <parav@mellanox.com>, xavier.huwei@huawei.com, huyn@mellanox.com, linux-rdma <linux-rdma@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 27, 2018 at 6:26 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
>
> On Thu, Sep 27, 2018 at 12:10:03PM +0200, Arnd Bergmann wrote:
> > The zap_vma_ptes() is declared but not defined on NOMMU kernels,
> > causing a link error for the newly added uverbs code:
> >
> > drivers/infiniband/core/uverbs_main.o: In function `uverbs_user_mmap_disassociate':
> > uverbs_main.c:(.text+0x114c): undefined reference to `zap_vma_ptes'
> > drivers/infiniband/core/uverbs_main.o: In function `rdma_umap_open':
> > uverbs_main.c:(.text+0x53c): undefined reference to `zap_vma_ptes'
>
> I'm a bit surprised by this - the code is not new, it just got moved
> out of the drivers, and I don't see any protections there against
> CONFIG_MMU ??

I think I just never hit those in my randconfig builds. Out of the three
drivers, one is 64-bit only, and the others depend on PCI. The nommu
configurations I'm testing in randconfig are all 32-bit without PCI.

> > To fix this, we can either make uverbs depend on CONFIG_MMU, or try
> > to build it anyway. Since this is the only compile-time dependency,
> > I decided to allow building it with an extra compile-time check for
> > CONFIG_MMU before calling the one function.
>
> Hrm. So this code doesn't work at all on NOMMU, it relies on
> remap_pfn_range, which always fails on those kernels,
>
> Due to this of this the entirety of INFINIBAND_USER_ACCESS is broken.
>
> I think a kconfig change is the better way to go?

Works for me. Can you just commit that yourself with 'Reported-by:
Arnd Bergmann <arnd@arndb.de>' then?

      Arnd

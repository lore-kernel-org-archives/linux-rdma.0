From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] IB/hns: Use zeroing memory allocator instead of
 allocator/memset
Date: Mon, 4 Jun 2018 10:50:37 -0600
Message-ID: <20180604165037.GA3403@ziepe.ca>
References: <20180603093222.24308-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180603093222.24308-1-yuehaibing@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: YueHaibing <yuehaibing@huawei.com>
Cc: oulijun@huawei.com, xavier.huwei@huawei.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, dledford@redhat.com
List-Id: linux-rdma@vger.kernel.org

On Sun, Jun 03, 2018 at 05:32:22PM +0800, YueHaibing wrote:
> Use dma_zalloc_coherent for allocating zeroed memory and
> remove unnecessary memset function.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/infiniband/hw/hns/hns_roce_alloc.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)

Applied to for-next, thanks.

Jason

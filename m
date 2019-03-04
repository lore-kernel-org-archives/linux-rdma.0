From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH -next] RDMA/hns: Use GFP_ATOMIC in hns_roce_v2_modify_qp
Date: Mon, 4 Mar 2019 16:25:22 -0400
Message-ID: <20190304202522.GA14163@ziepe.ca>
References: <20190304025620.27224-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190304025620.27224-1-yuehaibing@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Yue Haibing <yuehaibing@huawei.com>
Cc: oulijun@huawei.com, xavier.huwei@huawei.com, dledford@redhat.com, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Mar 04, 2019 at 10:56:20AM +0800, Yue Haibing wrote:
> From: YueHaibing <yuehaibing@huawei.com>
> 
> In commit 0425e3e6e0c7, hns_roce_v2_modify_qp called inside
> spinlock which using GFP_KERNEL, it may sleep with holding
> the spinlock, so we should use GFP_ATOMIC instead.
> 
> Fixes: 0425e3e6e0c7 ("RDMA/hns: Support flush cqe for hip08 in kernel space")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
>  drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied to for-next, thanks

Jason

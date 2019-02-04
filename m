From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH -next] RDMA/hns: Make some function static
Date: Mon, 4 Feb 2019 15:34:20 -0700
Message-ID: <20190204223420.GA23292@ziepe.ca>
References: <20190201031104.15064-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190201031104.15064-1-yuehaibing@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: YueHaibing <yuehaibing@huawei.com>
Cc: oulijun@huawei.com, xavier.huwei@huawei.com, dledford@redhat.com, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Feb 01, 2019 at 11:11:04AM +0800, YueHaibing wrote:
> Fixes the following sparse warnings:
> 
> drivers/infiniband/hw/hns/hns_roce_hw_v2.c:5822:5: warning:
>  symbol 'hns_roce_v2_query_srq' was not declared. Should it be static?
> drivers/infiniband/hw/hns/hns_roce_srq.c:158:6: warning:
>  symbol 'hns_roce_srq_free' was not declared. Should it be static?
> drivers/infiniband/hw/hns/hns_roce_srq.c:81:5: warning:
>  symbol 'hns_roce_srq_alloc' was not declared. Should it be static?
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 2 +-
>  drivers/infiniband/hw/hns/hns_roce_srq.c   | 9 +++++----
>  2 files changed, 6 insertions(+), 5 deletions(-)

Applied to for-next

Thanks,
Jason

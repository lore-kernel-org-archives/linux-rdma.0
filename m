From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] RDMA/hns: Use 64-bit arithmetic instead of 32-bit
Date: Mon, 22 Oct 2018 12:15:23 -0600
Message-ID: <20181022181523.GB30059@ziepe.ca>
References: <20181018080258.GA1720@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181018080258.GA1720@embeddedor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Lijun Ou <oulijun@huawei.com>, "Wei Hu(Xavier)" <xavier.huwei@huawei.com>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 18, 2018 at 10:02:58AM +0200, Gustavo A. R. Silva wrote:
> Cast *max_num_sg* to u64 in order to give the compiler complete
> information about the proper arithmetic to use.
> 
> Notice that such variable is used in a context that expects an
> expression of type u64 (64 bits, unsigned) and the following
> expression is currently being evaluated using 32-bit
> arithmetic:
> 
> length = max_num_sg * page_size;
> 
> Addresses-Coverity-ID: 1474517 ("Unintentional integer overflow")
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
>  drivers/infiniband/hw/hns/hns_roce_mr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/hw/hns/hns_roce_mr.c b/drivers/infiniband/hw/hns/hns_roce_mr.c
> index 521ad2a..d479d5e 100644
> +++ b/drivers/infiniband/hw/hns/hns_roce_mr.c
> @@ -1219,7 +1219,7 @@ struct ib_mr *hns_roce_alloc_mr(struct ib_pd *pd, enum ib_mr_type mr_type,
>  	int ret;
>  
>  	page_size = 1 << (hr_dev->caps.pbl_buf_pg_sz + PAGE_SHIFT);
> -	length = max_num_sg * page_size;
> +	length = (u64)max_num_sg * page_size;

This should be done with check_mul_overflow() which will also force
the input types to the correct thing.

alloc_mr is callable from userspace so the potential overflow here
should not be ignored.

Jason

From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH -next] IB/hfi1: remove set but not used variables
 'offset' and 'fspsn'
Date: Mon, 27 May 2019 20:10:08 -0300
Message-ID: <20190527231008.GA19493@ziepe.ca>
References: <20190525125737.15648-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190525125737.15648-1-yuehaibing@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: YueHaibing <yuehaibing@huawei.com>
Cc: mike.marciniszyn@intel.com, dennis.dalessandro@intel.com, dledford@redhat.com, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Sat, May 25, 2019 at 08:57:37PM +0800, YueHaibing wrote:
> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/infiniband/hw/hfi1/tid_rdma.c: In function tid_rdma_rcv_error:
> drivers/infiniband/hw/hfi1/tid_rdma.c:2029:7: warning: variable offset set but not used [-Wunused-but-set-variable]
> drivers/infiniband/hw/hfi1/tid_rdma.c: In function hfi1_rc_rcv_tid_rdma_ack:
> drivers/infiniband/hw/hfi1/tid_rdma.c:4555:35: warning: variable fspsn set but not used [-Wunused-but-set-variable]
> 
> 'offset' is never used since introduction in
> commit d0d564a1caac ("IB/hfi1: Add functions to receive TID RDMA READ request")
> 
> 'fspsn' is never used since introduciotn in
> commit 9e93e967f7b4 ("IB/hfi1: Add a function to receive TID RDMA ACK packet")
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/infiniband/hw/hfi1/tid_rdma.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)

Applied to for-next

Thanks,
Jason

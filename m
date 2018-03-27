From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] RDMA/hns: ensure for-loop actually iterates and free's
 buffers
Date: Tue, 27 Mar 2018 15:08:03 -0600
Message-ID: <20180327210803.GA26189@ziepe.ca>
References: <20180326151018.21066-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180326151018.21066-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin Ian King <colin.king@canonical.com>
Cc: Lijun Ou <oulijun@huawei.com>, Wei Hu <xavier.huwei@huawei.com>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Mar 26, 2018 at 04:10:18PM +0100, Colin Ian King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The current for-loop zeros variable i and only loops once, hence
> not all the buffers are free'd.  Fix this by setting i correctly.
> 
> Detected by CoverityScan, CID#1463415 ("Operands don't affect result")
> 
> Fixes: a5073d6054f7 ("RDMA/hns: Add eq support of hip08")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> Reviewed-by: Yixian Liu <liuyixian@huawei.com>
> ---
>  drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied to for-rc, thanks

Jason

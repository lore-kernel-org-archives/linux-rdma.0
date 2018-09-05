From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] infiniband: hw: hns: Fix a sleep-in-atomic-context bug
 in hns_roce_set_hem()
Date: Wed, 5 Sep 2018 15:54:50 -0600
Message-ID: <20180905215450.GA27596@ziepe.ca>
References: <20180901113948.28967-1-baijiaju1990@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180901113948.28967-1-baijiaju1990@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jia-Ju Bai <baijiaju1990@gmail.com>
Cc: oulijun@huawei.com, xavier.huwei@huawei.com, dledford@redhat.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Sat, Sep 01, 2018 at 07:39:48PM +0800, Jia-Ju Bai wrote:
> The driver may sleep with holding a spinlock.
> 
> The function call paths (from bottom to top) in Linux-4.16 are:
> 
> drivers/infiniband/hw/hns/hns_roce_hem.c, 345: 
> 	msleep in hns_roce_set_hem
> drivers/infiniband/hw/hns/hns_roce_hem.c, 330: 
> 	_raw_spin_lock_irqsave in hns_roce_set_hem
> 
> To fix this bug, msleep() is replaced with mdelay().
> 
> This bug is found by my static analysis tool DSAC.
> 
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
> ---
>  drivers/infiniband/hw/hns/hns_roce_hem.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

This was already fixed here:

commit 73b4e1f4c04e76b19fca296d09b97555bfb35202
Author: Lijun Ou <oulijun@huawei.com>
Date:   Wed Jul 25 15:29:38 2018 +0800

    RDMA/hns: Use delay instead of usleep
    
    In order to avoid using usleep function in lock function, we use delay
    function instead of it.  Besides, it also use brackets for standardized
    the computed order.
    
    Signed-off-by: Lijun Ou <oulijun@huawei.com>
    Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>

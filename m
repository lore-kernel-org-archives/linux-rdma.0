From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH 1/2][next] RDMA/hns: fix comparison of unsigned long
 variable 'end' with less than zero
Date: Fri, 7 Jun 2019 14:57:49 -0300
Message-ID: <20190607175749.GB25014@ziepe.ca>
References: <20190531092101.28772-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190531092101.28772-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: Lijun Ou <oulijun@huawei.com>, Wei Hu <xavier.huwei@huawei.com>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Fri, May 31, 2019 at 10:21:00AM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Currently the comparison of end with less than zero is always false
> because end is an unsigned long.  Also, replace checks of end with
> non-zero with end > 0 as it is possible that the #defined decrement
> may be changed in the future causing end to step over zero and go
> negative.
> 
> The initialization of end with 0 is also redundant as this value is
> never read and is later set to HW_SYNC_TIMEOUT_MSECS, so fix this by
> initializing it with this value to begin with.
> 
> Addresses-Coverity: ("Unsigned compared against 0")
> Fixes: 669cefb654cb ("RDMA/hns: Remove jiffies operation in disable interrupt context")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/infiniband/hw/hns/hns_roce_hem.c   |  4 ++--
>  drivers/infiniband/hw/hns/hns_roce_hw_v1.c | 12 ++++++------
>  2 files changed, 8 insertions(+), 8 deletions(-)

hns team: Can you please comment on this patch

Jason

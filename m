From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH 2/2][next] RDMA/hns: fix inverted logic of readl read and
 shift
Date: Fri, 7 Jun 2019 14:57:29 -0300
Message-ID: <20190607175729.GA25014@ziepe.ca>
References: <20190531092101.28772-1-colin.king@canonical.com>
 <20190531092101.28772-2-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190531092101.28772-2-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: Lijun Ou <oulijun@huawei.com>, Wei Hu <xavier.huwei@huawei.com>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Fri, May 31, 2019 at 10:21:01AM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> A previous change incorrectly changed the inverted logic and logically
> negated the readl rather than the shifted readl result. Fix this by
> adding in missing parentheses around the expression that needs to be
> logically negated.
> 
> Addresses-Coverity: ("Logically dead code")
> Fixes: 669cefb654cb ("RDMA/hns: Remove jiffies operation in disable interrupt context")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/infiniband/hw/hns/hns_roce_hem.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied to for-next, thanks

Jason

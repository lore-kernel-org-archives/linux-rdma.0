From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH rdma-next] RDMA/qedr: remove set but not used variable
 'ctx'
Date: Wed, 5 Sep 2018 15:56:18 -0600
Message-ID: <20180905215618.GA30370@ziepe.ca>
References: <1535774026-160694-1-git-send-email-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1535774026-160694-1-git-send-email-yuehaibing@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: YueHaibing <yuehaibing@huawei.com>
Cc: Michal Kalderon <Michal.Kalderon@cavium.com>, Ariel Elior <Ariel.Elior@cavium.com>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Sat, Sep 01, 2018 at 03:53:46AM +0000, YueHaibing wrote:
> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/infiniband/hw/qedr/verbs.c: In function 'qedr_create_srq':
> drivers/infiniband/hw/qedr/verbs.c:1450:24: warning:
>  variable 'ctx' set but not used [-Wunused-but-set-variable]
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> Acked-by: Rahul Verma <rahul.verma@cavium.com>
> ---
>  drivers/infiniband/hw/qedr/verbs.c | 2 --
>  1 file changed, 2 deletions(-)

Applied to for-next, thanks

Jason

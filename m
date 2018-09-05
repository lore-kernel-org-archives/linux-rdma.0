From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] infiniband: scsi: remove unnecessary unlikely()
Date: Wed, 5 Sep 2018 15:52:59 -0600
Message-ID: <20180905215259.GA27512@ziepe.ca>
References: <20180831201645.15611-1-igor.stoppa@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180831201645.15611-1-igor.stoppa@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Igor Stoppa <igor.stoppa@gmail.com>
Cc: Bart Van Assche <bvanassche@acm.org>, Igor Stoppa <igor.stoppa@huawei.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Aug 31, 2018 at 11:16:45PM +0300, Igor Stoppa wrote:
> WARN_ON() already contains an unlikely(), so it's not necessary to
> wrap it into another.
> 
> Signed-off-by: Igor Stoppa <igor.stoppa@huawei.com>
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> Cc: linux-rdma@vger.kernel.org (open list:SCSI RDMA PROTOCOL (SRP) TARGET)
> Cc: linux-kernel@vger.kernel.org (open list)
> ---
>  drivers/infiniband/ulp/srpt/ib_srpt.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied to for-next, thanks

Jason

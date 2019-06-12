From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] RDMA/odp: Fix missed unlock in non-blocking
 invalidate_start
Date: Wed, 12 Jun 2019 19:15:36 +0300
Message-ID: <20190612161536.GS6369@mtr-leonro.mtl.com>
References: <20190611160951.23135-1-jgg@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190611160951.23135-1-jgg@ziepe.ca>
Sender: stable-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-rdma@vger.kernel.org, Moni Shoua <monis@mellanox.com>, Jason Gunthorpe <jgg@mellanox.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Jun 11, 2019 at 01:09:51PM -0300, Jason Gunthorpe wrote:
> From: Jason Gunthorpe <jgg@mellanox.com>
>
> If invalidate_start returns with EAGAIN then the umem_rwsem needs to be
> unlocked as no invalidate_end will be called.
>
> Cc: <stable@vger.kernel.org>
> Fixes: ca748c39ea3f ("RDMA/umem: Get rid of per_mm->notifier_count")
> Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
> ---
>  drivers/infiniband/core/umem_odp.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>

From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] RDMA/nldev: missing error code in nldev_res_get_doit()
Date: Thu, 1 Feb 2018 15:50:15 -0700
Message-ID: <20180201225015.GC8590@ziepe.ca>
References: <20180201100148.GA8959@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180201100148.GA8959@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leonro@mellanox.com>, Steve Wise <swise@opengridcomputing.com>, Mark Bloch <markb@mellanox.com>, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Feb 01, 2018 at 01:01:48PM +0300, Dan Carpenter wrote:
> We should return -ENOMEM if the allocation fails.  The current code
> accidentally returns success.
> 
> Fixes: bf3c5a93c523 ("RDMA/nldev: Provide global resource utilization")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> Reviewed-by: Leon Romanovsky <leonro@mellanox.com>

Applied to for-next, thanks

Jason

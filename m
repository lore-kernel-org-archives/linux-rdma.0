From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] IB/mlx4: Fix an error handling path in
 'mlx4_ib_rereg_user_mr()'
Date: Mon, 11 Jun 2018 12:45:04 -0600
Message-ID: <20180611184504.GA15889@ziepe.ca>
References: <20180611181511.28025-1-christophe.jaillet@wanadoo.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180611181511.28025-1-christophe.jaillet@wanadoo.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: Christophe Jaillet <christophe.jaillet@wanadoo.fr>
Cc: yishaih@mellanox.com, dledford@redhat.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 11, 2018 at 08:15:11PM +0200, Christophe Jaillet wrote:
> Before returning -EPERM we should release some resources, as already done
> in the other error handling path of the function.
> 
> Fixes: d8f9cc328c88 ("IB/mlx4: Mark user MR as writable if actual virtual memory is writable")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  drivers/infiniband/hw/mlx4/mr.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)

Applied to for-rc, thanks

Jason

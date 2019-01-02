From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH 06/20] IB/ipoib: drop useless LIST_HEAD
Date: Wed, 2 Jan 2019 15:48:37 -0700
Message-ID: <20190102224837.GA28029@ziepe.ca>
References: <1545555435-24576-1-git-send-email-Julia.Lawall@lip6.fr>
 <1545555435-24576-7-git-send-email-Julia.Lawall@lip6.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1545555435-24576-7-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Doug Ledford <dledford@redhat.com>, kernel-janitors@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Dec 23, 2018 at 09:57:01AM +0100, Julia Lawall wrote:
> Drop LIST_HEAD where the variable it declares is never used.
> 
> Commit 31c02e215700 ("IPoIB: Avoid using stale last_send counter
> when reaping AHs") removed the uses, but not the declaration.
> 
> The semantic patch that fixes this problem is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> identifier x;
> @@
> - LIST_HEAD(x);
>   ... when != x
> // </smpl>
> 
> Fixes: 31c02e215700 ("IPoIB: Avoid using stale last_send counter when reaping AHs")
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
> ---
> Successfully 0-day tested on 151 configurations.
> 
>  drivers/infiniband/ulp/ipoib/ipoib_ib.c |    1 -
>  1 file changed, 1 deletion(-)

Applied to rdma for-next thanks

Jason

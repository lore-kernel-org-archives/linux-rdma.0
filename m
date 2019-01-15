From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] RDMA/mlx5: Replace kzalloc with kcalloc
Date: Tue, 15 Jan 2019 15:54:03 -0700
Message-ID: <20190115225403.GA18581@ziepe.ca>
References: <20190115060048.GA9911@embeddedor>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190115060048.GA9911@embeddedor>
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Leon Romanovsky <leon@kernel.org>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 15, 2019 at 12:00:48AM -0600, Gustavo A. R. Silva wrote:
> Replace kzalloc() function with its 2-factor argument form, kcalloc().
> 
> This patch replaces cases of:
> 
> 	kzalloc(a * b, gfp)
> 
> with:
> 	kcalloc(a, b, gfp)
> 
> This code was detected with the help of Coccinelle.
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> Acked-by: Leon Romanovsky <leonro@mellanox.com>
> ---
>  drivers/infiniband/hw/mlx5/main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied to for-next

Thanks,
Jason

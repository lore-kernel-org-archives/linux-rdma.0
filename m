From: Michal Kubecek <mkubecek@suse.cz>
Subject: Re: [PATCH] mlx5: avoid 64-bit division
Date: Mon, 27 May 2019 22:47:27 +0200
Message-ID: <20190527204727.GH30439@unicorn.suse.cz>
References: <20190520111902.7104DE0184@unicorn.suse.cz>
 <20190527181534.GA10029@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190527181534.GA10029@ziepe.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>, Doug Ledford <dledford@redhat.com>, Ariel Levkovich <lariel@mellanox.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Mon, May 27, 2019 at 03:15:34PM -0300, Jason Gunthorpe wrote:
> On Mon, May 20, 2019 at 01:19:02PM +0200, Michal Kubecek wrote:
> > diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
> > index abac70ad5c7c..340290b883fe 100644
> > +++ b/drivers/infiniband/hw/mlx5/main.c
> > @@ -2344,7 +2344,7 @@ static int handle_alloc_dm_sw_icm(struct ib_ucontext *ctx,
> >  	/* Allocation size must a multiple of the basic block size
> >  	 * and a power of 2.
> >  	 */
> > -	act_size = roundup(attr->length, MLX5_SW_ICM_BLOCK_SIZE(dm_db->dev));
> > +	act_size = round_up(attr->length, MLX5_SW_ICM_BLOCK_SIZE(dm_db->dev));
> >  	act_size = roundup_pow_of_two(act_size);
> 
> It is kind of weird that we have round_up and the bitshift
> version.. None of this is performance critical so why not just use
> round_up everywhere?
> 
> Ariel, it is true MLX5_SW_ICM_BLOCK_SIZE will always be a power of
> two?

If it weren't, the requirements from the comment above could never be
satisfied as a power of two can only be a multiple of another power of
two. Which also means that what the code above does is in fact
equivalent to

	act_size = max_t(u64, roundup_pow_of_two(attr->length),
			 MLX5_SW_ICM_BLOCK_SIZE(dm_db->dev));

or

	act_size = roundup_pow_of_two(max_t(u64, attr->length,
					    MLX5_SW_ICM_BLOCK_SIZE(dm_db->dev));

Michal Kubecek

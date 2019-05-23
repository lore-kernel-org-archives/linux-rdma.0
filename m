From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] RDMA/mlx5: Use DIV_ROUND_UP_ULL macro to allow 32 bit
 to build
Date: Thu, 23 May 2019 08:48:12 -0400
Message-ID: <20190523084812.325454f6@gandalf.local.home>
References: <20190522145450.25ff483d@gandalf.local.home>
        <20190523065803.GB30439@unicorn.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190523065803.GB30439@unicorn.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Michal Kubecek <mkubecek@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, Leon Romanovsky <leon@kernel.org>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 23 May 2019 08:58:03 +0200
Michal Kubecek <mkubecek@suse.cz> wrote:

> > diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
> > index abac70ad5c7c..40d4c5f7ea43 100644
> > --- a/drivers/infiniband/hw/mlx5/main.c
> > +++ b/drivers/infiniband/hw/mlx5/main.c
> > @@ -2344,7 +2344,7 @@ static int handle_alloc_dm_sw_icm(struct ib_ucontext *ctx,
> >  	/* Allocation size must a multiple of the basic block size
> >  	 * and a power of 2.
> >  	 */
> > -	act_size = roundup(attr->length, MLX5_SW_ICM_BLOCK_SIZE(dm_db->dev));
> > +	act_size = DIV_ROUND_UP_ULL(attr->length, MLX5_SW_ICM_BLOCK_SIZE(dm_db->dev));
> >  	act_size = roundup_pow_of_two(act_size);
> >  
> >  	dm->size = act_size;  
> 
> This seems wrong: roundup() rounds up to a multiple of second argument
> but DIV_ROUND_UP_ULL() would divide with rounding up.

Yeah, the macros are a bit confusing. There's unfortunately no
roundup_64() (perhaps we should make one?)

#define roundup(x, y) (					\
{							\
	typeof(y) __y = y;				\
	(((x) + (__y - 1)) / __y) * __y;		\
}							\
)


#define DIV_ROUND_DOWN_ULL(ll, d) \
	({ unsigned long long _tmp = (ll); do_div(_tmp, d); _tmp; })

#define DIV_ROUND_UP_ULL(ll, d)		DIV_ROUND_DOWN_ULL((ll) + (d) - 1, (d))


roundup(a, b) == ((a + b - 1) / b) * b

DIV_ROUND_UP_ULL(a, b) DIV_ROUND_DOWN_ULL(a + b - 1, b)
 = (a + b - 1) / b

Hmm, looks like you are right (damn, I thought I did this before
posting the patch, but I must have miscalculated something). It does
look like we are missing a "* b" in there.

I think I'll go and just add a roundup_64()!

Thanks for pointing this out.

-- Steve

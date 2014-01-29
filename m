From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] IB/mlx5: Fix binary compatibility with libmlx5
Date: Thu, 30 Jan 2014 01:33:35 +0200
Message-ID: <20140129233335.GA20224@mtldesk30>
References: <1391005649-17932-1-git-send-email-eli@mellanox.com>
 <1391028523.23180.63.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1391028523.23180.63.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 29, 2014 at 09:48:43PM +0100, Yann Droneaud wrote:
Yann,
thanks for reviewing, your comments are helpful :-)

> 
> 12 digits identifier are the norm for kernel. Please update your git
> configuration:
> 
>  git config --global core.abbrev 12
> 
> See http://lwn.net/Articles/571980/
>     http://blog.cuviper.com/2013/11/10/how-short-can-git-abbreviate/
> 
> > libmlx5 and mlx5_ib since it defines a different value to the number of micro
> > UARs per page, leading to wrong calculation in libmlx5. This patch defines
> > struct mlx5_ib_alloc_ucontext_req_v2 as an extension to struct
> > mlx5_ib_alloc_ucontext_req.  The extended size is determined in
> > mlx5_ib_alloc_ucontext() and in case of old library we use uuarn 0 which works
> > fine. For new libraries we use the more sophisticated allocation algorithm.
> > 
> > Fixes: c1be523 ('Fix micro UAR allocator')
>         ^^^^^^^
> Likewise

Will fix.
> 
> I'm not sure how this could work without subtracting sizeof(struct
> ib_uverbs_cmd_hdr).

struct ib_uverbs_get_context happens to have the same size as struct
ib_uverbs_cmd_hdr so it passed all my sanity tests. Correct, will fix
that too.
> 
> As I explained in "Re: [PATCHv4 for-3.13 00/10] create_flow/destroy_flow
> fixes for v3.13" [1] ib_uverbs_write() does not decrement input length:
> it gives hdr.in_words * 4 to the uverbs function, here 
> ib_uverbs_get_context(). Then, the function built struct ib_udata 
> without taking care of the extra bytes count in in_len:
> 
>     struct ib_uverbs_get_context cmd;
>     ...
>     INIT_UDATA(&udata, buf + sizeof cmd,
>                (unsigned long) cmd.response + sizeof resp,
>                in_len - sizeof cmd, out_len - sizeof resp);

So this just seems broken and the fix is to do the subtraction here so
the hardware driver gets the correct size without needing to subtract
the extra bytes, like this:
        INIT_UDATA(&udata, buf + sizeof cmd,
                   (unsigned long) cmd.response + sizeof resp,
                   in_len - sizeof cmd - sizeof (struct ib_uverbs_cmd_hdr),
                   out_len - sizeof resp);

And the hardware driver gets the correct size for its struct.
> 
> Driver mthca does some handling which look like to what's proposed in
> your patch, but takes care of subtracting the header size from the input
> length, see mthca_reg_user_mr()[2].
> 
> [1]
> <http://marc.info/?i=1387493822.11925.217.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
> 
> [2]
> <http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/drivers/infiniband/hw/mthca/mthca_provider.c?id=0e47c969c65e213421450c31043353ebe3c67e0c#n988>
> 
> > +	if (reqlen == sizeof(struct mlx5_ib_alloc_ucontext_req))
> > +		ver = 0;
> > +	else if (reqlen == sizeof(struct mlx5_ib_alloc_ucontext_req_v2))
> > +		ver = 2;
> > +	else
> > +		return ERR_PTR(-EINVAL);
> > +
> 
> Doing so introduce a subtle regression: there was no check on the length
> before, so it was legal to pass a input buffer far larger than needed,
> aka. trailing garbage. 
> 
> With such new test in place, it's no more allowed, and this is a
> regression. It's not a big issue, but a little departure from current
> behavor.
Well it's a regression if there was out there another library for mlx5
out there which misbehaves and there is any as far as I know. So I
think it's safe to add this strict check.
> 
> BTW, this is the correct way to handle the request, every other uverbs
> functions should behave like this, eg. being strict on its accepted
> input.
> 
> > +	err = ib_copy_from_udata(&req, udata, reqlen);
> >  	if (err)
> >  		return ERR_PTR(err);
> >  
> > +	if (req.flags || req.reserved)
> > +		return ERR_PTR(-EINVAL);
> > +
> 
> Just like this :)
> 
> >  	if (req.total_num_uuars > MLX5_MAX_UUARS)
> >  		return ERR_PTR(-ENOMEM);
> >  
> > @@ -626,6 +640,7 @@ static struct ib_ucontext *mlx5_ib_alloc_ucontext(struct ib_device *ibdev,
> >  	if (err)
> >  		goto out_uars;
> >  
> > +	uuari->ver = ver;
> >  	uuari->num_low_latency_uuars = req.num_low_latency_uuars;
> >  	uuari->uars = uars;
> >  	uuari->num_uars = num_uars;
> > diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
> > index 492dc33..300475c 100644
> > --- a/drivers/infiniband/hw/mlx5/qp.c
> > +++ b/drivers/infiniband/hw/mlx5/qp.c
> > @@ -430,11 +430,17 @@ static int alloc_uuar(struct mlx5_uuar_info *uuari,
> >  		break;
> >  
> >  	case MLX5_IB_LATENCY_CLASS_MEDIUM:
> > -		uuarn = alloc_med_class_uuar(uuari);
> > +		if (uuari->ver < 2)
> > +			uuarn = -ENOMEM;
> 
> In the commit message, you specified that uuarn is set to 0 when v1 is
> used. But here it's set to -ENOMEM.
> 
If you look at qp.c you can see that the code falls back from high to
medium to low class. Low class always succeeds and gives 0.

> > +		else
> > +			uuarn = alloc_med_class_uuar(uuari);
> >  		break;
> >  
> >  	case MLX5_IB_LATENCY_CLASS_HIGH:
> > -		uuarn = alloc_high_class_uuar(uuari);
> > +		if (uuari->ver < 2)
> > +			uuarn = -ENOMEM;
> 
> Likewise.
> 
> > +		else
> > +			uuarn = alloc_high_class_uuar(uuari);
> >  		break;
> >  
> >  	case MLX5_IB_LATENCY_CLASS_FAST_PATH:
> > @@ -559,6 +565,7 @@ static int create_user_qp(struct mlx5_ib_dev *dev, struct ib_pd *pd,
> >  		}
> >  	}
> >  
> > +
> 
> Remove this white space.
> 
> >  	uar_index = uuarn_to_uar_index(&context->uuari, uuarn);
> >  	mlx5_ib_dbg(dev, "uuarn 0x%x, uar_index 0x%x\n", uuarn, uar_index);
> >  
> > diff --git a/drivers/infiniband/hw/mlx5/user.h b/drivers/infiniband/hw/mlx5/user.h
> > index 32a2a5d..0f4f8e4 100644
> > --- a/drivers/infiniband/hw/mlx5/user.h
> > +++ b/drivers/infiniband/hw/mlx5/user.h
> > @@ -62,6 +62,13 @@ struct mlx5_ib_alloc_ucontext_req {
> >  	__u32	num_low_latency_uuars;
> >  };
> >  
> > +struct mlx5_ib_alloc_ucontext_req_v2 {
> > +	__u32	total_num_uuars;
> > +	__u32	num_low_latency_uuars;
> > +	__u32	flags;
> > +	__u32	reserved;
> > +};
> > +
> 
> >  struct mlx5_ib_alloc_ucontext_resp {
> >  	__u32	qp_tab_size;
> >  	__u32	bf_reg_size;
> > diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
> > index 554548c..32cb18c 100644
> > --- a/include/linux/mlx5/driver.h
> > +++ b/include/linux/mlx5/driver.h
> > @@ -227,6 +227,7 @@ struct mlx5_uuar_info {
> >  	 * protect uuar allocation data structs
> >  	 */
> >  	struct mutex		lock;
> > +	u32			ver;
> >  };
> >  
> >  struct mlx5_bf {
> 
> Regards.
> 
> -- 
> Yann Droneaud
> OPTEYA
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [patch] IB/mlx5: stack info leak in mlx5_ib_alloc_ucontext()
Date: Sun, 28 Jul 2013 23:24:43 +0300
Message-ID: <20130728202323.GA5053@mwanda>
References: <20130725170436.GC7026@elgon.mountain>
 <20130728072336.GB29427@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130728072336.GB29427@mtldesk30>
Sender: kernel-janitors-owner@vger.kernel.org
To: Eli Cohen <eli@dev.mellanox.co.il>
Cc: Eli Cohen <eli@mellanox.com>, Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Jul 28, 2013 at 10:23:36AM +0300, Eli Cohen wrote:
> On Thu, Jul 25, 2013 at 08:04:36PM +0300, Dan Carpenter wrote:
> > We don't set "resp.reserved".  Since it's at the end of the struct that
> > means we don't have to copy it to the user.
> > 
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > 
> > diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
> > index 8000fff..43dfb84 100644
> > --- a/drivers/infiniband/hw/mlx5/main.c
> > +++ b/drivers/infiniband/hw/mlx5/main.c
> > @@ -619,7 +619,8 @@ static struct ib_ucontext *mlx5_ib_alloc_ucontext(struct ib_device *ibdev,
> >  
> >  	resp.tot_uuars = req.total_num_uuars;
> >  	resp.num_ports = dev->mdev.caps.num_ports;
> > -	err = ib_copy_to_udata(udata, &resp, sizeof(resp));
> > +	err = ib_copy_to_udata(udata, &resp,
> > +			       sizeof(resp) - sizeof(resp.reserved));
> >  	if (err)
> >  		goto out_uars;
> >
> 
> I don't have strong opinion on this one. The title of the patch is
> stack info leak but the only leak of a reserved field. Other opinions?

First let me say that I don't know how this code is called, it may
be root only, but even in that case I think it's still worth
applying my patch.

These info leak problems are a well known security problem so I
didn't put a long explanation.  What you do is you fill the stack
with function pointers, then you call the function that leaks.  Then
you have a potentially useful pointer which was supposed to be
secret.  Something like that anyway.

There are probably lots of other easier ways to defeat address space
randomization.  There may be other ways you can use info leaks as
well...

Anyway, regardless, static checkers and code auditors look for these
leaks so applying the patch makes sense just to silence a warning.

regards,
dan carpenter

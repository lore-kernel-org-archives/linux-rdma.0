From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/mlx5: Fix a warning message
Date: Wed, 14 Jun 2017 12:52:28 +0300
Message-ID: <20170614095228.z27m247t5k2si6fz@mwanda>
References: <20170614091556.GF29394@elgon.mountain>
 <CAAKD3BDG9aOcLU9vEL1u8Yn23QpsZCjjN-y5DbKq5zBrvYJK=A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAAKD3BDG9aOcLU9vEL1u8Yn23QpsZCjjN-y5DbKq5zBrvYJK=A@mail.gmail.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 14, 2017 at 12:19:57PM +0300, Matan Barak wrote:
> On Wed, Jun 14, 2017 at 12:15 PM, Dan Carpenter
> <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> > "umem" is a valid pointer.  We intended to print "*umem" instead.
> >
> > Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> >
> > diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
> > index 763bb5b36144..86af54b0e414 100644
> > --- a/drivers/infiniband/hw/mlx5/mr.c
> > +++ b/drivers/infiniband/hw/mlx5/mr.c
> > @@ -825,7 +825,7 @@ static int mr_umem_get(struct ib_pd *pd, u64 start, u64 length,
> >                             access_flags, 0);
> >         err = PTR_ERR_OR_ZERO(*umem);
> >         if (err < 0) {
> > -               mlx5_ib_err(dev, "umem get failed (%ld)\n", PTR_ERR(umem));
> > +               mlx5_ib_err(dev, "umem get failed (%ld)\n", PTR_ERR(*umem));
> 
> I think it's better just to print err :)
> 

I don't understand what you're saying.

regards,
dan carpenter

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

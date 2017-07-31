From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [rdma-rc 08/14] RDMA/mlx4: Avoid potential derefence warning
Date: Mon, 31 Jul 2017 22:02:08 +0300
Message-ID: <20170731190208.evfjlejsp6xce3m2@mwanda>
References: <20170731070924.7193-1-leon@kernel.org>
 <20170731070924.7193-9-leon@kernel.org>
 <20170731162133.GB13672@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170731162133.GB13672-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jul 31, 2017 at 07:21:33PM +0300, Leon Romanovsky wrote:
> On Mon, Jul 31, 2017 at 10:09:18AM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > The smatch complains about possible dereference, it is unclear from
> > source how it can occur, since in case of failure to find/allocate
> > group, the acquire_group() will return error.
> >
> > Avoid the following error, by changing IS_ERR() to be IS_ERR_OR_NULL().
> >
> > drivers/infiniband/hw/mlx4/mcg.c:964 mlx4_ib_mcg_multiplex_handler() error:
> > 	potential null dereference 'group'.  (acquire_group returns null)
> >
> > Fixes: b9c5d6a64358 ("IB/mlx4: Add multicast group (MCG) paravirtualization for SR-IOV")
> > Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > ---
> >  drivers/infiniband/hw/mlx4/mcg.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> 
> Hi Dan,
> 
> Bart [1] and me both believe that smatch tool is incorrectly reported error.
> Do you think that the tool should be fixed?
> 

Yeah.  There are two functions called acquire_group() and one returns
NULL and one returns error pointers.  It's getting them mixed up.
It's simple enough to silence the warning.  I'll push that tomorrow.

I normally run with the cross function database so I don't see this
warning on my builds.  The cross function DB doesn't get confused when
there are two functions with the same name.

regards,
dan carpenter
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

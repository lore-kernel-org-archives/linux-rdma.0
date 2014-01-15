From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH for-next 09/14] IB/mlx5: Add support for resize CQ
Date: Wed, 15 Jan 2014 09:33:16 +0200
Message-ID: <20140115073316.GB31664@mtldesk30>
References: <1389714323-20130-1-git-send-email-eli@mellanox.com>
 <1389714323-20130-10-git-send-email-eli@mellanox.com>
 <1389717410.1585.67.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1389717410.1585.67.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 14, 2014 at 05:36:50PM +0100, Yann Droneaud wrote:
> > +	if (ib_copy_from_udata(&ucmd, udata, sizeof(ucmd)))
> > +		return -EFAULT;
> > +
> 
> You might also write
> 
>          err = ib_copy_from_udata(&ucmd, udata, sizeof(ucmd));
>          if (err)
>                  return err;
> 
> Then you should check reserved fields being set to the default value:
> As noted by Daniel Vetter in its article "Botching up ioctls"[1]
>   "Check *all* unused fields and flags and all the padding for whether 
>    it's 0, and reject the ioctl if that's not the case. Otherwise your 
>    nice plan for future extensions is going right down the gutters 
>    since someone *will* submit an ioctl struct with random stack 
>    garbage in the yet unused parts. Which then bakes in the ABI that 
>    those fields can never be used for anything else but garbage."
> It's  important to ensure that reserved fields are set to known value,
> so that it will be possible to use them latter to extend the ABI.
> 
> [1] http://blog.ffwll.ch/2013/11/botching-up-ioctls.html
> 
>          if (ucmd.reserved0 || ucmd.reserved1)
>                  return -EINVAL;
> 
It is not likely that someone will pass non-zero values here since
libmlx5 clears and most apps will use it. But I agree with your
comment - thanks for pointing this out. Probably there are other
places that need to be checked.


> > +	}
> > +	mutex_unlock(&cq->resize_mutex);
>          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> Is everything in this section really critical.
> For example, allocating and setting 'in' structure or releasing the
> ressources could probably move outside the mutex protected section ?
> 

Well, you could move things around to shorten the overall time the
lock is held but that might require structural changes in the code
that will not necessairily fit nice. Resizing a CQ is not a frequent
operation and this lock is used to avoid concurrent attempts of
resizing of the same CQ so I would not invest more effort here.

> >  
> > 
> >  int mlx5_core_modify_cq(struct mlx5_core_dev *dev, struct mlx5_core_cq *cq,
> > -			struct mlx5_modify_cq_mbox_in *in)
> > +			struct mlx5_modify_cq_mbox_in *in, int in_sz)
>                                                             ^^^^^^^^^^
> 
> Should probably be 'unsigned' ? size_t ?
> 
> same here.
> 

The resized value is defined int at the ib core layer so I chose to
follow the same type to avoid need for casting. Maybe a future patch
could change the type all over.

> diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
> > index dbb03ca..87e2371 100644
> > --- a/include/linux/mlx5/device.h
> > +++ b/include/linux/mlx5/device.h
> > @@ -710,6 +711,7 @@ struct mlx5_modify_cq_mbox_in {
> >  
> >  struct mlx5_modify_cq_mbox_out {
> >  	struct mlx5_outbox_hdr	hdr;
> > +	u8			rsvd[8];
> >  };
> >  
> >  struct mlx5_enable_hca_mbox_in {
> > 
> 
> It not clear why 8 bytes are needed here ?
> 
This is a requirement of the driver/firmware interface.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

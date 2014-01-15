From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 09/14] IB/mlx5: Add support for resize CQ
Date: Wed, 15 Jan 2014 11:02:55 +0100
Message-ID: <1389780175.572.10.camel@localhost.localdomain>
References: <1389714323-20130-1-git-send-email-eli@mellanox.com>
	 <1389714323-20130-10-git-send-email-eli@mellanox.com>
	 <1389717410.1585.67.camel@localhost.localdomain>
	 <20140115073316.GB31664@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140115073316.GB31664@mtldesk30>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Eli,=20

Le mercredi 15 janvier 2014 =C3=A0 09:33 +0200, Eli Cohen a =C3=A9crit =
:
> On Tue, Jan 14, 2014 at 05:36:50PM +0100, Yann Droneaud wrote:
> > > +	if (ib_copy_from_udata(&ucmd, udata, sizeof(ucmd)))
> > > +		return -EFAULT;
> > > +
> >=20
> > You might also write
> >=20
> >          err =3D ib_copy_from_udata(&ucmd, udata, sizeof(ucmd));
> >          if (err)
> >                  return err;

I'd like to have your opinion on this change.

I'm going to patch every call to ib_copy_from_udata() to follow my
proposed scheme (eg. returned error code from ib_copy_from_udata()
instead of hard coded error value).

> >=20
> > Then you should check reserved fields being set to the default valu=
e:
> > As noted by Daniel Vetter in its article "Botching up ioctls"[1]
> >   "Check *all* unused fields and flags and all the padding for whet=
her=20
> >    it's 0, and reject the ioctl if that's not the case. Otherwise y=
our=20
> >    nice plan for future extensions is going right down the gutters=20
> >    since someone *will* submit an ioctl struct with random stack=20
> >    garbage in the yet unused parts. Which then bakes in the ABI tha=
t=20
> >    those fields can never be used for anything else but garbage."
> > It's  important to ensure that reserved fields are set to known val=
ue,
> > so that it will be possible to use them latter to extend the ABI.
> >=20
> > [1] http://blog.ffwll.ch/2013/11/botching-up-ioctls.html
> >=20
> >          if (ucmd.reserved0 || ucmd.reserved1)
> >                  return -EINVAL;
> >=20
> It is not likely that someone will pass non-zero values here since
> libmlx5 clears and most apps will use it.

Is libmlx5/libibverbs the ABI ?

Unfortunately, anybody is allowed to access the kernel uverbs API
directly, so we must take care of the kernel ABI, just in case.

> But I agree with your
> comment - thanks for pointing this out. Probably there are other
> places that need to be checked.
>=20

=46or code not yet part of a released kernel version, we can fix that.
But for all other, it would require proper checking/thinking before
rejecting reserved field not set to 0 since it might theoterically brea=
k
existing userspace program: it will be a departure from previous ABI.

>=20
> > > +	}
> > > +	mutex_unlock(&cq->resize_mutex);
> >          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> >=20
> > Is everything in this section really critical.
> > For example, allocating and setting 'in' structure or releasing the
> > ressources could probably move outside the mutex protected section =
?
> >=20
>=20
> Well, you could move things around to shorten the overall time the
> lock is held but that might require structural changes in the code
> that will not necessairily fit nice. Resizing a CQ is not a frequent
> operation and this lock is used to avoid concurrent attempts of
> resizing of the same CQ so I would not invest more effort here.
>=20

I agree.

I would found more readable to have the two locks held next each other.
YMMV.


> > > =20
> > >=20
> > >  int mlx5_core_modify_cq(struct mlx5_core_dev *dev, struct mlx5_c=
ore_cq *cq,
> > > -			struct mlx5_modify_cq_mbox_in *in)
> > > +			struct mlx5_modify_cq_mbox_in *in, int in_sz)
> >                                                             ^^^^^^^=
^^^
> >=20
> > Should probably be 'unsigned' ? size_t ?
> >=20
> > same here.
> >=20
>=20
> The resized value is defined int at the ib core layer so I chose to
> follow the same type to avoid need for casting. Maybe a future patch
> could change the type all over.
>=20

But it's the size of struct mlx5_modify_cq_mbox_in, not the number of
'cqe' to resize the cq to.

> > diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/devic=
e.h
> > > index dbb03ca..87e2371 100644
> > > --- a/include/linux/mlx5/device.h
> > > +++ b/include/linux/mlx5/device.h
> > > @@ -710,6 +711,7 @@ struct mlx5_modify_cq_mbox_in {
> > > =20
> > >  struct mlx5_modify_cq_mbox_out {
> > >  	struct mlx5_outbox_hdr	hdr;
> > > +	u8			rsvd[8];
> > >  };
> > > =20
> > >  struct mlx5_enable_hca_mbox_in {
> > >=20
> >=20
> > It not clear why 8 bytes are needed here ?
> >=20
> This is a requirement of the driver/firmware interface.

It's a bit of magic :(

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

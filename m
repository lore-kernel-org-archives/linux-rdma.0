From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next v6 3/8] RDMA/restrack: Add general
 infrastructure to track RDMA resources
Date: Thu, 25 Jan 2018 22:27:10 +0200
Message-ID: <20180125202710.GS1393@mtr-leonro.local>
References: <20180125151227.28202-1-leon@kernel.org>
 <20180125151227.28202-4-leon@kernel.org>
 <20180125174529.GB3739@ziepe.ca>
 <20180125194436.GR1393@mtr-leonro.local>
 <20180125201023.GA9162@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="9+yvdhHLKXN64C4s"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180125201023.GA9162-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--9+yvdhHLKXN64C4s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 25, 2018 at 01:10:23PM -0700, Jason Gunthorpe wrote:
> On Thu, Jan 25, 2018 at 09:44:36PM +0200, Leon Romanovsky wrote:
> > > > +	/*
> > > > +	 * @kref: Protect destroy of the resource
> > > > +	 */
> > > > +	struct kref		kref;
> > >
> > > Sticking a kref in a random structure that is itself not malloc'd is a
> > > big red flag:
> >
> > It is not "rand", but embedded part of ib_qp,ib_pd and ib_cq. It is
> > malloced as part of their creation.
>
> I mean the kref isn't in any way linked the lifetime of the malloc
> that contains it. So it isn't really a kref, it is just a refcount.

For now, yes, in the future no. IMHO it is the direction to manage RDMA
objects.

>
> > > @@ -1746,6 +1756,11 @@ struct ib_qp {
> > > +       struct rdma_restrack_root     res;
> > >
> > >
> > > Not seeing how this works at all.
> > >
> > > qp does this:
> > >
> > > +       rdma_restrack_del(&qp->res);
> > >         ret = qp->device->destroy_qp(qp);
> > >
> > > And for instance the mlx5 implementation of destroy_qp() does:
> > >
> > > int mlx5_ib_destroy_qp(struct ib_qp *qp)
> > > {
> > >         struct mlx5_ib_qp *mqp = to_mqp(qp);
> > > [..]
> > >
> > >         kfree(mqp);
> > >
> > > So we kfree the kref containing memory outside the kref's release
> > > function. Super big red flag.
> >
> > It is worth to look on the actual implementation, the
> > rdma_restrack_del() doesn't do a lot: removes from the list and marks
> > the resource as not valid.
>
> It doesn't even do that if the kref count is elevated.
>
> Which is the whole point, the rdma_restrack_del *doesn't* prevent the
> use-after-free on the read side.

I understand it and agree that it is the bug, which is very easy to fix.

>
> > > The best idea I've had to make this locking work is what I emailed you
> > > a few days ago..
> >
> > It is more or less the same idea, but needs to move
> > down_write(&dev->res.rwsem) to be part of rdma_restrack_del and not
> > release routine. It will cause to block the progress of release.
>
> That doesn't help - the kref is still totally non-functional as a kref:
>
>  CPU0                                CPU1
>
>                                  down_read()
>                                  rdma_restrack_get()
> 				 up_read()
> down_write()
> restrack_release()
> up_write()
> kfree(qp)
>                                  fill_res_qp_entry(qp)
> 				 // boom, use after free
>
> A kref is not a lock, and a kref that *doesn't* put kfree in the
> release function is probably not a kref but a refcount.
>
> What I sent you wasn't remotely like this, it had two nested locks,
> the outer mutex and a very special open coded inner read/write lock
> that doesn't deadlock when nested..

I still didn't like your approach, because it has three words which i don't want
to see here: "special open-coded variant". I believe that the way to go is to add
completion structure and convert _del to be something like that:

void rdma_restrack_del(struct rdma_restrack_entry *res)
{
	if (!rdma_restrack_put(res))
		/* it is pseudo-code */
		wait_for_completion(!res->valid);
	return;
}


>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--9+yvdhHLKXN64C4s
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpqPZ4ACgkQ5GN7iDZy
WKcVwQ/+JtVYMTxFmPoAUP6zh9Eu9Ud5v4UI1hGvCs9nmu3bs+FpV4Y2pPVyqh+u
2K8UyU6bOEgXO7eiLu3yNLEsZ03UobTcusOqfQN0JyGowPHakyQ6kCtQqUeNw/Tn
1OBZDsWdIwCUBq6o+FSvtGxNz09ajbfFafIvDZtHKxCP7XVXc/k4zSOlpvm5Ccv2
89xgM2RoVawKgBMarTBXmIdZIgwzsKGEQvvvnd+eSu7ui1gDfte+zYaUxEuAb/gO
gsCajgpr1GjLFdBy7JN8xut8XPSMPbaU0HPJtN0tJRjVmaWFqH/SvKoItSkYJ2wW
qG3i7fOJEdsZOPevVCuDs9PiZ3+aiwR/eMn9UQcFy+ZFE6uXhBvkeObgtiN8CUub
9lP7XNOd2C0eo0+1zOd3IKJpmwRfyh/4uFpbo8T8V2XYMTzr5JtWRvHZUFkU4S0g
u5jE4PWIyqWuF/xXahx3qlxB3z7eWHvWcVfbzngqNglIverYvrXlFn4HsFAWeMOe
FYyf4OPGyUFVAdBUmeDuZXpxuRDy9DWXyv6FctY06UIILOSW7F1+OgeeZpK96Ixt
CdpOAbNHo3a4zxzz4wDbgePsA1fKKO1cjno//NoMHrnpJZQypEYkImTh/w4u8gpk
PDS7Ju+spk2Wxpd9AERplMMah/Ha5t+0O3rzkOveOx2i9LkfCEs=
=fjLo
-----END PGP SIGNATURE-----

--9+yvdhHLKXN64C4s--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next v6 3/8] RDMA/restrack: Add general
 infrastructure to track RDMA resources
Date: Thu, 25 Jan 2018 21:44:36 +0200
Message-ID: <20180125194436.GR1393@mtr-leonro.local>
References: <20180125151227.28202-1-leon@kernel.org>
 <20180125151227.28202-4-leon@kernel.org>
 <20180125174529.GB3739@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="cNo5QvG9KeB9cWDw"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180125174529.GB3739-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--cNo5QvG9KeB9cWDw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 25, 2018 at 10:45:29AM -0700, Jason Gunthorpe wrote:
> On Thu, Jan 25, 2018 at 05:12:22PM +0200, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > +
> > +/**
> > + * struct rdma_restrack_entry - metadata per-entry
> > + */
> > +struct rdma_restrack_entry {
> > +	/**
> > +	 * @valid: validity indicator
> > +	 *
> > +	 * The entries are filled during rdma_restrack_add,
> > +	 * can be attempted to be free during rdma_restrack_del.
> > +	 *
> > +	 * As an example for that, see mlx5 QPs with type MLX5_IB_QPT_HW_GSI
> > +	 */
> > +	bool			valid;
> > +	/*
> > +	 * @kref: Protect destroy of the resource
> > +	 */
> > +	struct kref		kref;
>
> Sticking a kref in a random structure that is itself not malloc'd is a
> big red flag:

It is not "rand", but embedded part of ib_qp,ib_pd and ib_cq. It is
malloced as part of their creation.

>
> @@ -1746,6 +1756,11 @@ struct ib_qp {
> +       struct rdma_restrack_root     res;
>
>
> Not seeing how this works at all.
>
> qp does this:
>
> +       rdma_restrack_del(&qp->res);
>         ret = qp->device->destroy_qp(qp);
>
> And for instance the mlx5 implementation of destroy_qp() does:
>
> int mlx5_ib_destroy_qp(struct ib_qp *qp)
> {
>         struct mlx5_ib_qp *mqp = to_mqp(qp);
> [..]
>
>         kfree(mqp);
>
> So we kfree the kref containing memory outside the kref's release
> function. Super big red flag.

It is worth to look on the actual implementation, the
rdma_restrack_del() doesn't do a lot: removes from the list and marks
the resource as not valid.

>
> rdma_restrack_del is just:
>
> +       return kref_put(&res->kref, restrack_release);
>
> So we don't do anything to block progress to the kfree unless
> the kref drefs to 0. But the reader holds a get/put across its
> critical section so we never hit the 0 case when there is another
> user.
>
> Not even remotely right.
>
> Adding a kref means it has to be added to struct ib_qp and then kfree's
> in the drivers need to change to kref_put. That is alot of work.
>
> The best idea I've had to make this locking work is what I emailed you
> a few days ago..

It is more or less the same idea, but needs to move
down_write(&dev->res.rwsem) to be part of rdma_restrack_del and not
release routine. It will cause to block the progress of release.

Thanks

>
> Jason

--cNo5QvG9KeB9cWDw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpqM6QACgkQ5GN7iDZy
WKdjkw//RZ4T0M2Wu0FYdZfaC/LvWUUkISy5ImUyOSOo8yNI6l0CrNEeRW/1YK+7
CncXMh818tVoQrOV756F/lcdikes0hcr47YJrP18rsoIYiErkyXVoz3ElBosUXEg
ezqaEUT2MLEftdRjj6chIkGVOh3VsupiZlpupaCfqZyODr7F3I3b1qBFltzxmhNj
CdYof40o3B2+8eXkxwaEMfzX19ScN56FSQMdGqHqho6OPb++GbDylsNIiKOv/+Oy
gFMscmmaEuLw4m5tLQ1MVz8Ou72ukn8FTBW/PemZcoErE08Kv3wpGfHCdKT9TKpF
orEic75jiz7D82JkmA+CbLEOsA60EOYrrb7jHA78oMJmnNmth6VXewWpoKS5+xhl
ZI8bMp8+LqO+GfUFez6YB+Asd0qUl/tGciV9kehEVoF/WZYI3tfA/KGowxAK2P5A
bN7QOCPZOWB1A37YYrJRsFfAXoafWd6IPnpddbXhuHwyrQwdn3Umpown7/HC1irp
IXUtLtLQhebPU+Q9Zf8vaYRKFJSwoYIs7I9/gfLTnj7SfFRgA4iCPP1pGB4+JVPv
3E8K4ZYnfZ5+cZNJdrx7Vr883E+fyAbfVTiq1yKWwVp3OFzcszCnjH7/TtjGBpSV
hE+4Zao++iDsnH/vqzrgBwJ2GgEk0n5DuZO6SbktwdF7G8LMgDU=
=fZ0o
-----END PGP SIGNATURE-----

--cNo5QvG9KeB9cWDw--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

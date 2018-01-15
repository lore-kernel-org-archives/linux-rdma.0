From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next v3 1/7] RDMA/restrack: Add general
 infrastructure to track RDMA resources
Date: Mon, 15 Jan 2018 12:25:04 +0200
Message-ID: <20180115102504.GZ15760@mtr-leonro.local>
References: <20180111153132.11143-1-leon@kernel.org>
 <20180111153132.11143-2-leon@kernel.org>
 <1515700046.2752.52.camel@wdc.com>
 <20180111195535.GI30208@mellanox.com>
 <20180112061924.GF15760@mtr-leonro.local>
 <20180114212613.GD9088@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="FYmwbMCTM+aCvPj+"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180114212613.GD9088-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--FYmwbMCTM+aCvPj+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jan 14, 2018 at 02:26:13PM -0700, Jason Gunthorpe wrote:
> On Fri, Jan 12, 2018 at 08:19:24AM +0200, Leon Romanovsky wrote:
> > On Thu, Jan 11, 2018 at 12:55:35PM -0700, Jason Gunthorpe wrote:
> > > On Thu, Jan 11, 2018 at 07:47:27PM +0000, Bart Van Assche wrote:
> > > > On Thu, 2018-01-11 at 17:31 +0200, Leon Romanovsky wrote:
> > > > > +struct rdma_restrack_entry {
> > > > > +       struct list_head        list;
> > > > > +
> > > > > +       /*
> > > > > +        * The entries are filled during rdma_restrack_add,
> > > > > +        * can be attempted to be free during rdma_restrack_del.
> > > > > +        *
> > > > > +        * As an example for that, see mlx5 QPs with type MLX5_IB_QPT_HW_GSI
> > > > > +        */
> > > > > +       bool                    valid;
> > > > > +
> > > > > +       /*
> > > > > +        * Sleepabale RCU to protect object data.
> > > > > +        */
> > > > > +       struct srcu_struct      srcu;
> > > > > +
> > > > > +       struct task_struct      *task;
> > > > > +       char                    *task_comm;
> > > > > +};
> > > >
> > > > Please use the kernel-doc syntax to document the meaning of the names of the
> > > > fields in this structure. It is e.g. nontrivial to guess what "task_comm" stands
> > > > for. The presense of a task_struct pointer is also nontrivial.
> > >
> > > And task_comm doesn't seem like a great name anymore, and should be
> > > const char *, right ?
> >
> > No problem, what will be great "name" now? "const char *name"?
>
> I haven't looked closely yet, but is is the kernel name for the object
> right? So kern_name? And same remark about the netlink attribute name
> as well.

No problem

>
> I'm also uncertain that _ib_create_qp is a good idea, and I really
> dislike the _ for a public API.
>
> Do you propose to add a kernel name to every kernel object we add
> restrack to?
>
> It feels simpler to give a name to alloc_pd and use that name as the
> kernel name for every object created under it? Or is there a reason to
> have a per object name?

Not really.

>
> Jason
>

--FYmwbMCTM+aCvPj+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpcgYAACgkQ5GN7iDZy
WKfkaA/+JALxBOaEHsGwN+nVwp2chKdaHrTFfSlcVkJqcHFj1i1AivR4NBT7+YtZ
IJX1YdECkGLBXB+FqxP3RHk6i4mpeUp2efs3yrz6PuploYjH03QcE4D0lx+P4mfF
oo+teZ26Ib6OfkbsE02rXVfBkxCYd05/YzDUkcFATwErxq/BehQbQ0iiBlkQsp4X
m8oavOiG3Yw0svNYiAKzcneo8h5MhxikDPtaHp9QKnrDrY2uB1Dbeqgxbo2+wzO4
w6SOIwH7BDAY3pZmHyqKtLzEVOEpD4Idd91cmcpcfiOiS/z/7J1aD6hTwIYxoGGs
CoxYCwgzZS8C7YykSsFqp+R2iuP/52EDIq+PNE87eIzVRPD4GvKICA+RjrFplUKn
DaXiK5BXGc26kDvSZIEQvktVPThq5UJOOSVzw52uf2m5I5L+RtrNNLksWbdVMKex
5gelZ4g5iFzMSdibEvpnKXE5T37p/Dfo25nTukkEpQxlJqP36zHmVUxeTsHNpYIl
0guxqqaNCl6L1spwI40BFYKLUuGuHUcZkWQ8FUAMsQP4MLsb2tx+Q0waK9JuTKLz
22K9bT6YCVl/qpy3qXOkfn1MbxgauEKISFSLMotFguBSSk4HKYy3ZNrEjGX7EPc0
Gl5/SMcemThhE1wyY+7Pl4DALb0sNd7AoU6CPoSwiEyvOaDIFU8=
=NpsZ
-----END PGP SIGNATURE-----

--FYmwbMCTM+aCvPj+--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

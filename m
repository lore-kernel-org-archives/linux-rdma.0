From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next v3 1/7] RDMA/restrack: Add general
 infrastructure to track RDMA resources
Date: Fri, 12 Jan 2018 08:19:24 +0200
Message-ID: <20180112061924.GF15760@mtr-leonro.local>
References: <20180111153132.11143-1-leon@kernel.org>
 <20180111153132.11143-2-leon@kernel.org>
 <1515700046.2752.52.camel@wdc.com>
 <20180111195535.GI30208@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="BI5RvnYi6R4T2M87"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180111195535.GI30208-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--BI5RvnYi6R4T2M87
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 11, 2018 at 12:55:35PM -0700, Jason Gunthorpe wrote:
> On Thu, Jan 11, 2018 at 07:47:27PM +0000, Bart Van Assche wrote:
> > On Thu, 2018-01-11 at 17:31 +0200, Leon Romanovsky wrote:
> > > +struct rdma_restrack_entry {
> > > +       struct list_head        list;
> > > +
> > > +       /*
> > > +        * The entries are filled during rdma_restrack_add,
> > > +        * can be attempted to be free during rdma_restrack_del.
> > > +        *
> > > +        * As an example for that, see mlx5 QPs with type MLX5_IB_QPT_HW_GSI
> > > +        */
> > > +       bool                    valid;
> > > +
> > > +       /*
> > > +        * Sleepabale RCU to protect object data.
> > > +        */
> > > +       struct srcu_struct      srcu;
> > > +
> > > +       struct task_struct      *task;
> > > +       char                    *task_comm;
> > > +};
> >
> > Please use the kernel-doc syntax to document the meaning of the names of the
> > fields in this structure. It is e.g. nontrivial to guess what "task_comm" stands
> > for. The presense of a task_struct pointer is also nontrivial.
>
> And task_comm doesn't seem like a great name anymore, and should be
> const char *, right ?

No problem, what will be great "name" now? "const char *name"?

>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--BI5RvnYi6R4T2M87
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpYU2wACgkQ5GN7iDZy
WKfXkBAAzRKPmlHEwlMcsHCHKJvSQPxzDcOJIJLNtn/g6T6DNnpwQsw9X2qx+suq
pbk2bgntUSqEwF9SdE4CeXtXjHrf2J94VeKdaL07ZqoaKFKtCQk0vUFDIJBorDYM
s/RB8H2EBchKCVmsI0qAnuoiE/S07QceyS8Yl4O0uyrgBBNyL/f/5fe9lZPSVQSL
ODp+qv/pIbp21z+9bnDtwUbyxL+usF9FY7wobC9UOhXoAAp9mMg4l/I5TBYjyAiI
UzwF8zvtzWSnFCUiXrv2YQ//uWBJ9sId2JeXRD83eCJUGx6aQxZB4B3SKmaxlwbB
DM+ivlJXDU7IXqIuYc1fZ13RDKZNQpvUg0Ioqz9wonEeNlaoIR9vtzUfed6A8xaO
FC84htyE+19zQzW4lQqnZF/u22dPxYNJ7XFrxNUG9g72fOJX5gdi2rOKjmcpd7DB
8Kzhf43qx+UlZY6SqI64ZuD84p3Uj/pT3t0EEow5fVT92THS4xNBxWg4wDSFECoK
I4FTwFFkJH9oYcYZXs+gTjYlYvs0cvMFxIeKO1K6EC4jAM5wE+nfKDoruTo0c3f9
Gc8P3ZX6kUB0a1uDq7eCOQom+MF9iq7cnmx6S67chRiAAtGhTmbntNmMoTHhhRsf
0z6agPoz5xSy9Pm81cmiItgPXrfOkW2dGmuMBERO3/oclPc0img=
=yLrB
-----END PGP SIGNATURE-----

--BI5RvnYi6R4T2M87--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

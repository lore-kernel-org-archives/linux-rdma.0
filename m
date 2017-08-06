From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 12/27] IB/core: Change port_attr.sm_lid from 16
 to 32 bits
Date: Sun, 6 Aug 2017 11:22:17 +0300
Message-ID: <20170806082217.GE3636@mtr-leonro.local>
References: <20170804204842.17853.14858.stgit@scvm10.sc.intel.com>
 <20170804205320.17853.77236.stgit@scvm10.sc.intel.com>
 <20170806081857.GC3636@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="qFgkTsE6LiHkLPZw"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170806081857.GC3636-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--qFgkTsE6LiHkLPZw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Aug 06, 2017 at 11:18:57AM +0300, Leon Romanovsky wrote:
> On Fri, Aug 04, 2017 at 01:53:21PM -0700, Dennis Dalessandro wrote:
> > From: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >
> > sm_lid field in struct ib_port_attr is increased to 32 bits. This
> > enables core components to use larger LIDs if needed.
> > The user ABI is unchanged and return 16 bit values when queried.
> >
> > Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Signed-off-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > ---
> >  drivers/infiniband/core/uverbs_cmd.c |    8 +++++---
> >  include/rdma/ib_verbs.h              |    2 +-
> >  2 files changed, 6 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
> > index 7ef74b0..38dce45 100644
> > --- a/drivers/infiniband/core/uverbs_cmd.c
> > +++ b/drivers/infiniband/core/uverbs_cmd.c
> > @@ -275,11 +275,13 @@ ssize_t ib_uverbs_query_port(struct ib_uverbs_file *file,
> >  	resp.bad_pkey_cntr   = attr.bad_pkey_cntr;
> >  	resp.qkey_viol_cntr  = attr.qkey_viol_cntr;
> >  	resp.pkey_tbl_len    = attr.pkey_tbl_len;
> > -	resp.sm_lid 	     = attr.sm_lid;
> > -	if (rdma_cap_opa_ah(ib_dev, cmd.port_num))
> > +	if (rdma_cap_opa_ah(ib_dev, cmd.port_num)) {
> >  		resp.lid  = OPA_TO_IB_UCAST_LID(attr.lid);
> > -	else
> > +		resp.sm_lid  = OPA_TO_IB_UCAST_LID(attr.sm_lid);
> > +	} else {
> >  		resp.lid     = (u16)attr.lid;
> > +		resp.sm_lid  = (u16)attr.sm_lid;
>
> I see that lid is already has casting from u32 to u16 and now it is sm_lid.
> Do we have more elegant way to achieve that? And comment for future
> developers can be good too.

I see now, you changed lid in patch 11. The same comment there.

>
> > +	}
> >  	resp.lmc 	     = attr.lmc;
> >  	resp.max_vl_num      = attr.max_vl_num;
> >  	resp.sm_sl 	     = attr.sm_sl;
> > diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> > index 4eccf89..5f4f2d3 100644
> > --- a/include/rdma/ib_verbs.h
> > +++ b/include/rdma/ib_verbs.h
> > @@ -549,7 +549,7 @@ struct ib_port_attr {
> >  	u32			bad_pkey_cntr;
> >  	u32			qkey_viol_cntr;
> >  	u16			pkey_tbl_len;
> > -	u16			sm_lid;
> > +	u32			sm_lid;
> >  	u32			lid;
> >  	u8			lmc;
> >  	u8			max_vl_num;
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html



--qFgkTsE6LiHkLPZw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmG0bgACgkQ5GN7iDZy
WKc5+g//fx4VegBQ9np2HSbGKTcRqMEh8al15rXiI/XQIikDFlyoSPgGGllLXA72
8CM04INdbkFcDkZb1R2X8UgBGX27zpH6Nw7B1RSAtYva4HievQsIytErrDxFwtXM
kRCj4l3ymX3UWcy47G5I1kmY3i/ZYF/rF6Pid5hD8pPz2OviY6LuILZsAp3RyklA
h/6hlDj9E6a6V/AiGXvFwvqKP06/UCcBRSprPoEsX4E1ghzpkldylzFWRCC4SVVf
DbYpB16Cszn6Y+VT2w9yWobyzmHZdrdf4RNu/P62Kzba+RjthACzaXm9O7foSM0A
F3qTejeNzOcZBkWAHDTtWoqmKdy4u12kG4aznalNaYCsgRP8uARdQHfX3eSGasWf
DzIMh668UW1D3+5Wi9B0AeS575E0gxtSwyObO3PXXmZnLIx9VIawqZgNf4FWskQd
CTHgoITpJhsED44eNZ/QXCevIcGWiZiXUz3fXBqjGpaH0J7NM7URKga/b4mTBHLR
fif6C4oquqF3U8ioTzLWrITpx1iQQfP20PWpd/vY6kfvGLue7qNAa4IuQpw0TRAz
VTzpt5n+ZKK4ruxwNs2e49Qio86lAkfLKROb7+9CtpCllHXuVT8//rlJR+RjDici
1Dbj+3AKJ2+OfAK2mJcB++PBsxkGZJ1D6GeOrgoogv8oma2zgM0=
=RLMO
-----END PGP SIGNATURE-----

--qFgkTsE6LiHkLPZw--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

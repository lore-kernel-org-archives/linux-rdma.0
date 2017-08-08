From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 12/27] IB/core: Change port_attr.sm_lid from 16
 to 32 bits
Date: Tue, 8 Aug 2017 17:41:46 +0300
Message-ID: <20170808144146.GF28851@mtr-leonro.local>
References: <20170804204842.17853.14858.stgit@scvm10.sc.intel.com>
 <20170804205320.17853.77236.stgit@scvm10.sc.intel.com>
 <20170806081857.GC3636@mtr-leonro.local>
 <20170806082217.GE3636@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="L2Brqb15TUChFOBK"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170806082217.GE3636-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--L2Brqb15TUChFOBK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Aug 06, 2017 at 11:22:17AM +0300, Leon Romanovsky wrote:
> On Sun, Aug 06, 2017 at 11:18:57AM +0300, Leon Romanovsky wrote:
> > On Fri, Aug 04, 2017 at 01:53:21PM -0700, Dennis Dalessandro wrote:
> > > From: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > >
> > > sm_lid field in struct ib_port_attr is increased to 32 bits. This
> > > enables core components to use larger LIDs if needed.
> > > The user ABI is unchanged and return 16 bit values when queried.
> > >
> > > Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > Signed-off-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > ---
> > >  drivers/infiniband/core/uverbs_cmd.c |    8 +++++---
> > >  include/rdma/ib_verbs.h              |    2 +-
> > >  2 files changed, 6 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
> > > index 7ef74b0..38dce45 100644
> > > --- a/drivers/infiniband/core/uverbs_cmd.c
> > > +++ b/drivers/infiniband/core/uverbs_cmd.c
> > > @@ -275,11 +275,13 @@ ssize_t ib_uverbs_query_port(struct ib_uverbs_file *file,
> > >  	resp.bad_pkey_cntr   = attr.bad_pkey_cntr;
> > >  	resp.qkey_viol_cntr  = attr.qkey_viol_cntr;
> > >  	resp.pkey_tbl_len    = attr.pkey_tbl_len;
> > > -	resp.sm_lid 	     = attr.sm_lid;
> > > -	if (rdma_cap_opa_ah(ib_dev, cmd.port_num))
> > > +	if (rdma_cap_opa_ah(ib_dev, cmd.port_num)) {
> > >  		resp.lid  = OPA_TO_IB_UCAST_LID(attr.lid);
> > > -	else
> > > +		resp.sm_lid  = OPA_TO_IB_UCAST_LID(attr.sm_lid);
> > > +	} else {
> > >  		resp.lid     = (u16)attr.lid;
> > > +		resp.sm_lid  = (u16)attr.sm_lid;
> >
> > I see that lid is already has casting from u32 to u16 and now it is sm_lid.
> > Do we have more elegant way to achieve that? And comment for future
> > developers can be good too.
>
> I see now, you changed lid in patch 11. The same comment there.

To be clear on that point: NAK on *current* implementation.

At least, it should be done in separate function, with comment explains
why are you doing and why it is safe to cast from higher value to lower
value and proper checks that you are not loosing information when you
are casting.

Thanks

--L2Brqb15TUChFOBK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmJzaYACgkQ5GN7iDZy
WKe6gxAAgXiaPgXbvtA3f2/UYlh8pQnG0TR2nvouoGKecztqYhmL0Kw+NMazSrqj
sm7p0qNxd6ewqBzZr618nZrs2YYXrhuaKMBUBsM8SS4G4IsdQj6bWMCsj4YelOVG
XIAQJzqwldxAh9eCvgGFZDf6zDair48tL0Nl8yCWWpOvmtrUj+xq4ZO7O9ZeMooh
8UmK/SXMxH69Xv2QOiSOQK3NkZrwqorN0BlGM9V1qTDplRSvmqc5/BTNdmQwi6Vp
7cr4MPaIF+6DfreUoVzKmbzHGMdTPa1k/azlmsWT2O9z404nlCwiSPfBGFOh1Doq
/4WsrDIZ67EjwNEKV5EXqSMvRYcdE1kVGtEmB2ai0xGg9rj479pQDQaKTEqCIOn2
9TBW1GGt3mKD4UqRLcyEp70fgUzFJKsFF5MRDn06lxuw9/0MsGSnHEkJmbVORMuN
Pe+KSzIWZGtaTaVDluT4I6mXi8NDu7Y3q/h9liLSbL1tY0ucEQXjCPsZ8A6pnvj5
2bBolhQzb4hY5j5+u8Lv/AN2ciaBHTyxiuwPyRts3UbIUsZ8VIcsz3fs/ViiIdzZ
mkN7Xs0aI3N+GBhF519nyfxThKU2OEBAQqb6DD9f0cxDFpRoazX0HXBVKTH78kvZ
KBrppe5AEkZYserOzUJc9v8Frf3EqQf1aqC4AJgwsLRA1+/mRFo=
=dFlu
-----END PGP SIGNATURE-----

--L2Brqb15TUChFOBK--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Alex Margolin <alexma-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [RFC] Registering non-contiguous memory
Date: Thu, 23 Mar 2017 18:21:09 +0000
Message-ID: <DB5PR05MB12702D1DE9A7E7773FF823ACB93F0@DB5PR05MB1270.eurprd05.prod.outlook.com>
References: <VI1PR05MB127817A311C332553E4391AFB9410@VI1PR05MB1278.eurprd05.prod.outlook.com>
 <20170205224401.GB26474@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170205224401.GB26474-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Jason Gunthorpe [mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org]
> Sent: Monday, February 06, 2017 12:44 AM
> To: Alex Margolin <alexma-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [RFC] Registering non-contiguous memory
>=20
> On Sun, Feb 05, 2017 at 04:46:04PM +0000, Alex Margolin wrote:
>=20
> > +struct verbs_mw {
> > +	struct ibv_mw		mw;
> > +	uint32_t		comp_mask;
> > +	uint32_t		lkey;
> > +	uint32_t		descriptor_num;
> > +};
>=20
> Just as a general comment for all future patches - now that the provider
> interface is private I don't want to see 'comp_mask' stuff in driver.h

How else would we support future extensibility otherwise? It seems that all=
 the other structs in driver.h have comp_mask: struct verbs_xrcd, struct ve=
rbs_srq and struct verbs_qp.

>=20
>=20
> > @@ -1411,11 +1478,13 @@ enum verbs_context_mask {
> >  	VERBS_CONTEXT_QP	=3D 1 << 2,
> >  	VERBS_CONTEXT_CREATE_FLOW =3D 1 << 3,
> >  	VERBS_CONTEXT_DESTROY_FLOW =3D 1 << 4,
> > -	VERBS_CONTEXT_RESERVED	=3D 1 << 5
> > +	VERBS_CONTEXT_ALLOC_MW	=3D 1 << 5,
> > +	VERBS_CONTEXT_RESERVED	=3D 1 << 6
> >  };
>=20
> What is this reserved thing?

Note that this reserved bit was there before the patch... I just left it th=
ere.

>=20
> Don't forget man pages are required.
>=20
> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

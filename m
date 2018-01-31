From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH RFC 2/2] RDMA/nldev: provide detailed CM_ID information
Date: Wed, 31 Jan 2018 21:18:39 +0000
Message-ID: <VI1PR0502MB30088B50BEA14B4C05EA2BC7D1FB0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
References: <cover.1517418595.git.swise@opengridcomputing.com>
 <531889e6a24f7919dec71734c91298d266aa9721.1517418595.git.swise@opengridcomputing.com>
 <VI1PR0502MB3008805F1A6056F50A12DEDBD1FB0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <01ea01d39ad5$ec30f7a0$c492e6e0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <01ea01d39ad5$ec30f7a0$c492e6e0$@opengridcomputing.com>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Steve Wise
> Sent: Wednesday, January 31, 2018 2:56 PM
> To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; Jason
> Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
> Subject: RE: [PATCH RFC 2/2] RDMA/nldev: provide detailed CM_ID informati=
on
>=20
> > > 182,6 +199,7 @@ static int fill_res_info(struct sk_buff *msg, struct
> ib_device
> > > *device)
> > >  		[RDMA_RESTRACK_PD] =3D "pd",
> > >  		[RDMA_RESTRACK_CQ] =3D "cq",
> > >  		[RDMA_RESTRACK_QP] =3D "qp",
> > > +		[RDMA_RESTRACK_CM_ID] =3D "cm_id",
> >
> > May be rdmacm_id a better name to avoid confusion with ib_cm/iw_cm ids?
>=20
> Eventually, I could see the ib_cm and/or iw_cm info also getting dumped a=
s part
Yes. But it is still coming through id of rdmacm_id as transport id informa=
tion.
> of this.  So perhaps the name "cm_id" is ok?=20
It's just that longer name removes the ambiguity.
I am not too particular about this particular naming.

> I prefer it also because its shorter (lazy typer! :) )
Sure, shorter names are useful to end user.
But I think this is handled well at iproute2 tool level.
For example below two commands achieves the same task.
#ip address show
#ip a s
So may be shorter naming at command level is better left at user space tool=
 level.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH 8/8] iw_cxgb4: Use uninitialized_var()
Date: Wed, 26 Mar 2014 09:48:11 -0500
Message-ID: <004001cf4902$691d3dc0$3b57b940$@opengridcomputing.com>
References: <1395840239-4368-1-git-send-email-hariprasad@chelsio.com>	 <1395840239-4368-9-git-send-email-hariprasad@chelsio.com> <1395844433.3297.2.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1395844433.3297.2.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Yann Droneaud' <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, 'Hariprasad Shenai' <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner@vger.=
kernel.org] On
> Behalf Of Yann Droneaud
> Sent: Wednesday, March 26, 2014 9:34 AM
> To: Hariprasad Shenai
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org; swise@opengri=
dcomputing.com;
> kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org; nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
> Subject: Re: [PATCH 8/8] iw_cxgb4: Use uninitialized_var()
>=20
> Le mercredi 26 mars 2014 =C3=A0 18:53 +0530, Hariprasad Shenai a =C3=A9=
crit :
> > From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> >
>=20
> What for ? Please describe the reason to use uninitialized_var()
>=20

=46unction poll_cq() fills out var cqe.  The compiler doesn't know that=
 so either you initialize cqe unnecessarily, or use uninitized_var().  =
The poll path is performance-critical, and I hate to initialize variabl=
es without reason.


>=20
> > Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> > ---
> >  drivers/infiniband/hw/cxgb4/cq.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/infiniband/hw/cxgb4/cq.c b/drivers/infiniband/=
hw/cxgb4/cq.c
> > index e17b155..cfaa56a 100644
> > --- a/drivers/infiniband/hw/cxgb4/cq.c
> > +++ b/drivers/infiniband/hw/cxgb4/cq.c
> > @@ -672,7 +672,7 @@ skip_cqe:
> >  static int c4iw_poll_cq_one(struct c4iw_cq *chp, struct ib_wc *wc)
> >  {
> >  	struct c4iw_qp *qhp =3D NULL;
> > -	struct t4_cqe cqe =3D {0, 0}, *rd_cqe;
> > +	struct t4_cqe uninitialized_var(cqe), *rd_cqe;
> >  	struct t4_wq *wq;
> >  	u32 credit =3D 0;
> >  	u8 cqe_flushed;
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

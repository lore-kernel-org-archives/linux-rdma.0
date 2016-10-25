From: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH rdma-core 4/6] libqedr: main
Date: Tue, 25 Oct 2016 12:39:33 +0000
Message-ID: <SN1PR07MB2207FF170E96A8C8A35DAC3AF8A80@SN1PR07MB2207.namprd07.prod.outlook.com>
References: <1476956952-17388-1-git-send-email-Ram.Amrani@cavium.com>
 <1476956952-17388-5-git-send-email-Ram.Amrani@cavium.com>
 <20161020170828.GC28181@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161020170828.GC28181-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I've just submitted fixes via github.

Thanks for the feedback,

Ram


> -----Original Message-----
> From: Jason Gunthorpe [mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org]
> Sent: Thursday, October 20, 2016 8:08 PM
> To: Amrani, Ram <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
> Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Elior, Ariel
> <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>; Kalderon, Michal <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
> Subject: Re: [PATCH rdma-core 4/6] libqedr: main
>=20
> On Thu, Oct 20, 2016 at 12:49:10PM +0300, Ram Amrani wrote:
> > +struct {
> > +	unsigned int vendor;
> > +	unsigned int device;
> > +} hca_table[] =3D {
>=20
> needs static const, please check all your stuff for static and const..
>=20
> > +int qelr_modify_qp(struct ibv_qp *, struct ibv_qp_attr *,
> > +		   int ibv_qp_attr_mask);
> > +int qelr_query_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr, int att=
r_mask,
> > +		  struct ibv_qp_init_attr *init_attr);
>=20
> It would be nice to be consistent, I prefer the argument name to be in th=
e
> prototype.
>=20
> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH v3 10/15] IB/pvrdma: Add support for memory regions
Date: Wed, 7 Sep 2016 19:06:32 +0000
Message-ID: <BLUPR0501MB83611E62567F90A4B8FB454C5F80@BLUPR0501MB836.namprd05.prod.outlook.com>
References: <1470266864-16888-1-git-send-email-aditr@vmware.com>
 <1470266864-16888-11-git-send-email-aditr@vmware.com>
 <20160825141505.GD27446@yuval-lap.uk.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160825141505.GD27446-Hxa29pjIrETlQW142y8m19+IiqhCXseY@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, pv-drivers <pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, "Jorgen S. Hansen" <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, George Zhang <georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Aug 25, 2016 at 07:16:32 -0700, Yuval Shaia wrote:
> On Wed, Aug 03, 2016 at 04:27:39PM -0700, Adit Ranadive wrote:
> > This patch adds support for creating and destroying memory regions.
> > The PVRDMA device supports User MRs, DMA MRs (no Remote
> Read/Write
> > support), Fast Register MRs.
> >
> > Changes v2->v3:
> >  - Removed boolean in pvrdma_cmd_post.
> >
> > Reviewed-by: Jorgen Hansen <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > Reviewed-by: George Zhang <georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > Reviewed-by: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > Reviewed-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > Signed-off-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > ---
> >  drivers/infiniband/hw/pvrdma/pvrdma_mr.c | 331
> > +++++++++++++++++++++++++++++++
> >  1 file changed, 331 insertions(+)
> >  create mode 100644 drivers/infiniband/hw/pvrdma/pvrdma_mr.c
> >

...

> > +/**
> > + * pvrdma_get_dma_mr - get a DMA memory region
> > + * @pd: protection domain
> > + * @acc: access flags
> > + *
> > + * @return: ib_mr pointer on success, otherwise returns an errno.
> > + */
> > +struct ib_mr *pvrdma_get_dma_mr(struct ib_pd *pd, int acc) {
> > +	struct pvrdma_dev *dev =3D to_vdev(pd->device);
> > +	struct pvrdma_user_mr *mr;
> > +	union pvrdma_cmd_req req;
> > +	union pvrdma_cmd_resp rsp;
> > +	struct pvrdma_cmd_create_mr *cmd =3D &req.create_mr;
> > +	struct pvrdma_cmd_create_mr_resp *resp =3D &rsp.create_mr_resp;
> > +	int ret;
> > +
> > +	if (acc !=3D IB_ACCESS_LOCAL_WRITE) {
>=20
> Since those access flags are bits i suggest to use bit operations.
> 	if (!(acc & IB_ACCESS_LOCAL_WRITE))

Ok.

> > +		dev_warn(&dev->pdev->dev, "unsupported dma mr access
> flags\n");
> > +		return ERR_PTR(-EOPNOTSUPP);
> > +	}
> > +
> > +	mr =3D kzalloc(sizeof(*mr), GFP_KERNEL);
> > +	if (!mr)
> > +		return ERR_PTR(-ENOMEM);
>=20
> Suggesting to do this allocation after command succeeds. This way you wil=
l
> not have to deal with free-ing it when cmd fails.

Hmm, I kept it as it is in upcoming v4 mainly because if the mr alloc faile=
d I would
have to issue another device command to destroy the MR. I would rather free=
 the
MR here than issue a device command to destroy it.

Thanks,
Adit

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

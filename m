From: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH v3 01/15] IB/pvrdma: Add user-level shared functions
Date: Tue, 6 Sep 2016 18:58:37 +0000
Message-ID: <BLUPR0501MB8360B8A54D98AEE4B8C689FC5F90@BLUPR0501MB836.namprd05.prod.outlook.com>
References: <1470266864-16888-1-git-send-email-aditr@vmware.com>
 <1470266864-16888-2-git-send-email-aditr@vmware.com>
 <20160821112436.GA22012@yuval-lap.uk.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160821112436.GA22012-Hxa29pjIrETlQW142y8m19+IiqhCXseY@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, pv-drivers <pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, "Jorgen S. Hansen" <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, George Zhang <georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Aug 21, 2016 at 04:24:53 -0700, Yuval Shaia wrote:
> One minor comment.
> Besides that:
> 	Reviewed-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>=20
> Yuval
>=20
> On Wed, Aug 03, 2016 at 04:27:30PM -0700, Adit Ranadive wrote:
> > We share some common structures with the user-level driver. This patch
> > adds those structures and shared functions to traverse the QP/CQ rings.
> >
> > Changes from v2->v3:
> >  - Defined what -1 means for an index return value in pvrdma_uapi.h
> >
> > Reviewed-by: Jorgen Hansen <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > Reviewed-by: George Zhang <georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > Reviewed-by: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > Reviewed-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > Signed-off-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > ---
> >  drivers/infiniband/hw/pvrdma/pvrdma_uapi.h | 248 +++++++++++++++++++++=
++++++++
> >  drivers/infiniband/hw/pvrdma/pvrdma_user.h |  99 ++++++++++++
> >  2 files changed, 347 insertions(+)
> >  create mode 100644 drivers/infiniband/hw/pvrdma/pvrdma_uapi.h
> >  create mode 100644 drivers/infiniband/hw/pvrdma/pvrdma_user.h
> >

...

> > +
> > +/* PVRDMA receive queue work request */
> > +struct pvrdma_rq_wqe_hdr {
> > +	__u64 wr_id;		/* wr id */
> > +	__u32 num_sge;		/* size of s/g array */
> > +	__u32 total_len;	/* reserved */
> > +};
> > +/* Use pvrdma_sge (ib_sge) for receieve queue s/g array elements. */
>=20
> This comment refers to a structure that defined in patch #2.

In v4, will move the pvrdma_sge struct here so its more consistent.

Thanks,
Adit
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

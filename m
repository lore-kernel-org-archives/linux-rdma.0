From: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH v3 08/15] IB/pvrdma: Add support for Completion Queues
Date: Thu, 8 Sep 2016 18:26:35 +0000
Message-ID: <BLUPR0501MB836A35B3F4B839B1E2055A8C5FB0@BLUPR0501MB836.namprd05.prod.outlook.com>
References: <1470266864-16888-1-git-send-email-aditr@vmware.com>
 <1470266864-16888-9-git-send-email-aditr@vmware.com>
 <20160825124120.GB27446@yuval-lap.uk.oracle.com>
 <BLUPR0501MB83629470B22B65E27B4332AC5F80@BLUPR0501MB836.namprd05.prod.outlook.com>
 <20160908081802.GA3300@yuval-lap.mynet>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160908081802.GA3300-Hxa29pjIrESt9MVyvc/JHg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, pv-drivers <pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, "Jorgen S. Hansen" <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, George Zhang <georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 08, 2016 at 01:18:16 -0700, Yuval Shaia wrote:=20
> On Wed, Sep 07, 2016 at 05:25:30PM +0000, Adit Ranadive wrote:
> > > > +
> > > > +static int pvrdma_poll_one(struct pvrdma_cq *cq, struct pvrdma_qp
> > > **cur_qp,
> > > > +			   struct ib_wc *wc)
> > > > +{
> > > > +	struct pvrdma_dev *dev =3D to_vdev(cq->ibcq.device);
> > > > +	int has_data;
> > > > +	unsigned int head;
> > > > +	bool tried =3D false;
> > > > +	struct pvrdma_cqe *cqe;
> > > > +
> > > > +retry:
> > > > +	has_data =3D pvrdma_idx_ring_has_data(&cq->ring_state->rx,
> > > > +					    cq->ibcq.cqe, &head);
> > > > +	if (has_data =3D=3D 0) {
> > > > +		u32 val;
> > > > +
> > > > +		if (tried)
> > > > +			return -EAGAIN;
> > > > +
> > > > +		/* Pass down POLL to give physical HCA a chance to poll. */
> > > > +		val =3D cq->cq_handle | PVRDMA_UAR_CQ_POLL;
> > > > +		writel(cpu_to_le32(val),
> > > > +		       dev->driver_uar.map + PVRDMA_UAR_CQ_OFFSET);
> > > > +
> > > > +		tried =3D true;
> > > > +		goto retry;
> > > > +	} else if (has_data =3D=3D PVRDMA_INVALID_IDX) {
> > > > +		/* Ring state could be corrupted. Treat as unrecoverable. */
> > > > +		return -EINVAL;
> > >
> > > Please try your best not to return anything but 0 or -EAGAIN from
> > > this function.
> > > Returning -EINVAL will cause caller (pvrdma_poll_cq) to drop all
> > > successive CQE in tn batch.
> >
> > This reason I want to return -EINVAL here is that its possible that
> > the ring state is corrupted so any successive calls to poll_cq will lik=
ely not
> give any valid data.
> > If that means successive CQEs are dropped then that should be okay
> > since we have no idea now which CQEs were consumed.
>=20
> In this case you should handle the problematic CQ in driver, ULPs are not=
 built
> to handle it.

Ok, sounds reasonable. I understand Jason's concerns. Thanks for pointing m=
e those
links! I can return -EAGAIN here and add a dev warning to make sure we atle=
ast log this
condition.

How would the ULP recover if the driver kept returning 0 for CQEs polled? D=
o ULPs
usually have some timeout notion when polling CQs?

Thanks,
Adit


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

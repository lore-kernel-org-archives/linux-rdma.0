From: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-rc] RDMA/vmw_pvrdma: Report CQ missed events
Date: Thu, 10 Aug 2017 17:20:53 +0000
Message-ID: <CY4PR05MB3510E71AF280B2473639A0CCC5880@CY4PR05MB3510.namprd05.prod.outlook.com>
References: <1502351175-1762-1-git-send-email-aditr@vmware.com>
 <20170810111557.GT1423@mtr-leonro.local>,<20170810112536.GB3500@yuvallap>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170810112536.GB3500@yuvallap>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, pv-drivers <pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> On Thu, Aug 10, 2017 at 02:15:57PM +0300, Leon Romanovsky wrote:
> > On Thu, Aug 10, 2017 at 12:46:15AM -0700, Adit Ranadive wrote:
> > > From: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > >
> > > There is a chance of a race between arming the CQ and receiving
> > > completions. By reporting CQ missed events any ULPs should poll
> > > again to get the completions.
> > >
> > > Fixes: 29c8d9eba550 ("IB: Add vmw_pvrdma driver")
> > > Acked-by: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > > Signed-off-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > > Signed-off-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> > > ---
> > >=A0 drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c | 15 +++++++++++++++
> > >=A0 1 file changed, 15 insertions(+)
> > >
> > > diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c b/drivers/i=
nfiniband/hw/vmw_pvrdma/pvrdma_cq.c
> > > index 69bda61..f4ab5fa 100644
> > > --- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c
> > > +++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c
> > > @@ -65,12 +65,27 @@ int pvrdma_req_notify_cq(struct ib_cq *ibcq,
> > >=A0=A0=A0=A0=A0 struct pvrdma_dev *dev =3D to_vdev(ibcq->device);
> > >=A0=A0=A0=A0=A0 struct pvrdma_cq *cq =3D to_vcq(ibcq);
> > >=A0=A0=A0=A0=A0 u32 val =3D cq->cq_handle;
> > > +=A0=A0 unsigned long flags;
> > >
> > >=A0=A0=A0=A0=A0 val |=3D (notify_flags & IB_CQ_SOLICITED_MASK) =3D=3D =
IB_CQ_SOLICITED ?
> > >=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 PVRDMA_UAR_CQ_ARM_SOL : PVRDMA=
_UAR_CQ_ARM;
> > >
> > > +=A0=A0 spin_lock_irqsave(&cq->cq_lock, flags);
> > > +
> > >=A0=A0=A0=A0=A0 pvrdma_write_uar_cq(dev, val);
> > >
> > > +=A0=A0 if (notify_flags & IB_CQ_REPORT_MISSED_EVENTS) {
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 unsigned int head;
> > > +
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (pvrdma_idx_ring_has_data(&cq->rin=
g_state->rx,
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 cq->ibcq.cqe, &head)) {
> >
> > The pvrdma_idx_ring_has_data function can return PVRDMA_INVALID_IDX (-1=
).
>
> I believe that the case of PVRDMA_INVALID_IDX is only due to some bug. I =
do
> not think it is an expected behaviour, it means that ring is corrupted, a=
m
> i right Adit?

Thanks Leon, Yuval. While hitting the INVALID_IDX is really rare (we haven'=
t hit it ever in our internal testing), we should check this for consistenc=
y purposes. Look for a v1.

- Adit=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

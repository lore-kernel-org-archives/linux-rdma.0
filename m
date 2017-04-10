From: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v2] nvme-rdma: support devices with queue size < 32
Date: Mon, 10 Apr 2017 15:27:14 +0000
Message-ID: <1491838033.4199.3.camel@sandisk.com>
References: <1519881025.363156294.1491837154312.JavaMail.zimbra@kalray.eu>
         <20170410151657.GA15173@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170410151657.GA15173-jcswGhMUV9g@public.gmane.org>
Content-Language: en-US
Content-ID: <72ABBB6A77B9894D93F8B2E635ED2937-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "hch-jcswGhMUV9g@public.gmane.org" <hch-jcswGhMUV9g@public.gmane.org>, "mrybczyn-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org" <mrybczyn-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>
Cc: "leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "axboe-b10kYP2dOMg@public.gmane.org" <axboe-b10kYP2dOMg@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "samuel.jones-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org" <samuel.jones-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>, "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 2017-04-10 at 17:16 +0200, Christoph Hellwig wrote:
> > +static inline nvme_rdma_queue_sig_limit(struct nvme_rdma_queue *queue)
> > +{
> > +       int sig_limit;
> > +
> > +       /* We signal completion every queue depth/2 and also
> > +        * handle the case of possible device with queue_depth=3D1,
> > +        * where we would need to signal every message.
> > +        */
> > +       sig_limit =3D max(queue->queue_size / 2, 1);
> > +       return (++queue->sig_count % sig_limit) =3D=3D 0;
> > +}
>=20
> I would love if we could do this at the ib_qp level.

Hello Christoph,

Please keep in mind that some but not all RDMA drivers need a construct lik=
e
this.

Bart.=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

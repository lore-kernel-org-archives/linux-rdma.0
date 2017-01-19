From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCHv3] nvmet-rdma: Fix missing dma sync to nvme data
        structures
Date: Thu, 19 Jan 2017 15:45:30 +0000
Message-ID: <VI1PR0502MB300864C57897C37D4397A76AD17E0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
References: <1484785346-2991-1-git-send-email-parav@mellanox.com>
 <20170119152240.GA32400@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170119152240.GA32400-jcswGhMUV9g@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: "sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Christoph,

> -----Original Message-----
> From: Christoph Hellwig [mailto:hch-jcswGhMUV9g@public.gmane.org]
> Sent: Thursday, January 19, 2017 9:23 AM
> To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: hch-jcswGhMUV9g@public.gmane.org; sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org; linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org; linux-
> rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> Subject: Re: [PATCHv3] nvmet-rdma: Fix missing dma sync to nvme data
> structures
>=20
> >
> > +	ib_dma_sync_single_for_cpu(queue->dev->device,
> > +		cmd->cmd->sge[0].addr, cmd->cmd->sge[0].length,
> > +		DMA_FROM_DEVICE);
> > +	ib_dma_sync_single_for_cpu(queue->dev->device,
> > +			cmd->send_sge.addr, cmd->send_sge.length,
> > +			DMA_TO_DEVICE);
>=20
> Why the different indentation here?  Both one or two tab indents look fin=
e to
> me in this context, but don't mix them.
>=20
I agree. I should have taken care of that.
Shall I resend patch with same indentation at all places or this can be tak=
en care during commit?

> Except for that this looks fine:
>=20
> Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

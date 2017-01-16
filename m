From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH] nvmet-rdma: Fix missing dma sync to nvme data      structures
Date: Mon, 16 Jan 2017 17:18:15 +0000
Message-ID: <VI1PR0502MB3008EBE381C87D629A784279D17D0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
References: <1484412337-10860-1-git-send-email-parav@mellanox.com>
 <20170116153109.GA16170@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170116153109.GA16170-jcswGhMUV9g@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: "sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch-jcswGhMUV9g@public.gmane.org]
> Sent: Monday, January 16, 2017 9:31 AM
> To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: hch-jcswGhMUV9g@public.gmane.org; sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org; linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org; linux-
> rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> Subject: Re: [PATCH] nvmet-rdma: Fix missing dma sync to nvme data
> structures
>=20
> > +++ b/drivers/nvme/target/rdma.c
> > @@ -438,6 +438,14 @@ static int nvmet_rdma_post_recv(struct
> > nvmet_rdma_device *ndev,  {
> >  	struct ib_recv_wr *bad_wr;
> >
> > +	ib_dma_sync_single_for_device(ndev->device,
> > +			cmd->sge[0].addr, sizeof(*cmd->nvme_cmd),
> > +			DMA_FROM_DEVICE);
> > +
> > +	if (cmd->sge[1].addr)
>=20
> 0 can be a valid address returned from dma_map_single on some
> architectures.

I see. I will change it to check for the non-zero length instead of non-zer=
o address.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

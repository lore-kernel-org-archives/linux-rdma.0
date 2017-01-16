From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCHv1] nvmet-rdma: Fix missing dma sync to nvme data
 structures
Date: Mon, 16 Jan 2017 20:51:02 +0000
Message-ID: <VI1PR0502MB30084319E1D41697F27C593AD17D0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
References: <1484597945-31143-1-git-send-email-parav@mellanox.com>
 <20170116203132.GB7384@yuval-lap>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170116203132.GB7384@yuval-lap>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "hch-jcswGhMUV9g@public.gmane.org" <hch-jcswGhMUV9g@public.gmane.org>, "sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Yuval,

> -----Original Message-----
> From: Yuval Shaia [mailto:yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org]
> Sent: Monday, January 16, 2017 2:32 PM
> To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: hch-jcswGhMUV9g@public.gmane.org; sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org; linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org; linux-
> rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> Subject: Re: [PATCHv1] nvmet-rdma: Fix missing dma sync to nvme data
> structures
>=20
> On Mon, Jan 16, 2017 at 02:19:05PM -0600, Parav Pandit wrote:
> > This patch performs dma sync operations on nvme_command, inline
> > page(s) and nvme_completion.
> >
> > nvme_command and write cmd inline data is synced
> > (a) on receiving of the recv queue completion for cpu access.
> > (b) before posting recv wqe back to rdma adapter for device access.
> >
> > nvme_completion is synced
> > (a) on receiving send completion for nvme_completion for cpu access.
> > (b) before posting send wqe to rdma adapter for device access.
> >
> > This patch is generated for git://git.infradead.org/nvme-fabrics.git
> > Branch: nvmf-4.10
> >
> > Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Reviewed-by: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > ---
> >  drivers/nvme/target/rdma.c | 25 +++++++++++++++++++++++++
> >  1 file changed, 25 insertions(+)
> >
> > diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
> > index 6c1c368..fe7e257 100644
> > --- a/drivers/nvme/target/rdma.c
> > +++ b/drivers/nvme/target/rdma.c
> > @@ -437,6 +437,14 @@ static int nvmet_rdma_post_recv(struct
> nvmet_rdma_device *ndev,
> >  		struct nvmet_rdma_cmd *cmd)
> >  {
> >  	struct ib_recv_wr *bad_wr;
> > +	int i;
> > +
> > +	for (i =3D 0; i < 2; i++) {
> > +		if (cmd->sge[i].length)
> > +			ib_dma_sync_single_for_device(ndev->device,
>=20
> Aren't we trying to get rid of all these ib_dma_* wrappers?

Yes. We are. Bart patch is still not merged. Lastly there was some issue wi=
th SDMA or hfi changes.
I have sent out patch on top of Bart's patch for inux-rdma tree using regul=
ar dma_xx APIs.
However Sagi and Christoph acknowledged that this fix needs to go to 4.8-st=
able and 4.10-rc as bug fix.
So this patch is generated from the nvme-fabrics tree as mentioned in comme=
nt.
When this gets to linux-rdma tree, Bart's new patch will translate this add=
itional calls to regular dma_xx APIs.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

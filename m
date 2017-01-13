From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH] nvmet-rdma: Fix missing dma sync to nvme data      structures
Date: Fri, 13 Jan 2017 15:08:07 +0000
Message-ID: <VI1PR0502MB30086F641A07262801C02A28D1780@VI1PR0502MB3008.eurprd05.prod.outlook.com>
References: <1484261109-3316-1-git-send-email-parav@mellanox.com>
 <20170113074420.GA25814@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170113074420.GA25814-jcswGhMUV9g@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: "sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Christoph,

> -----Original Message-----
> From: Christoph Hellwig [mailto:hch-jcswGhMUV9g@public.gmane.org]
> Sent: Friday, January 13, 2017 1:44 AM
> To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: hch-jcswGhMUV9g@public.gmane.org; sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org; linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org; linux-
> rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> Subject: Re: [PATCH] nvmet-rdma: Fix missing dma sync to nvme data
> structures
>=20
> On Thu, Jan 12, 2017 at 04:45:09PM -0600, Parav Pandit wrote:
> > This patch performs dma sync operations on nvme_commmand, inline
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
> > Pushing this patch through linux-rdma tree as its more relavant with
> > Bart's changes for dma_map_ops of[1].
> >
> > [1] https://patchwork.kernel.org/patch/9514085/
>=20
> This seems like a fix for 4.10-rc as the old code is buggy on not DMA coh=
erent
> architectures, so I suspect it should go in without being based on Barts
> cleanup.
>=20
I first found and tested on git://git.infradead.org/nvme-fabrics.git in nvm=
f-4.10 branch.
If it has to go to 4.10-rc in above git repo,

Doug needs to rebase to above git tree.
Followed by Bart's patches, followed by my changes in his tree.
Without that, Linux-next will get compile error because ib_dma_xx won't be =
defined.
Let me know, I have 4.10-rc patch also tested.

> Btw, what architecture did you test this with?  One of the not coherent A=
RM
> SOCs?
On x86_64.
Currently testing on ARM.
While doing some performance improvement using inline sge mode, I encounter=
 this bug in review.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

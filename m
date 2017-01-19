From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCHv3] nvmet-rdma: Fix missing dma sync to nvme data
        structures
Date: Thu, 19 Jan 2017 15:51:25 +0000
Message-ID: <VI1PR0502MB30085FE37E38A20D99BD03C0D17E0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
References: <1484785346-2991-1-git-send-email-parav@mellanox.com>
 <20170119152240.GA32400@lst.de>
 <VI1PR0502MB300864C57897C37D4397A76AD17E0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20170119154601.GA597@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170119154601.GA597-jcswGhMUV9g@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: "sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

After sending I realized that Doug might also need to do that to merge this=
 to Linux-rdma so that Bart's dma_ops series works correctly.
So its work for more people.
Let me just resend it. Its minor.

Parav

> -----Original Message-----
> From: Christoph Hellwig [mailto:hch-jcswGhMUV9g@public.gmane.org]
> Sent: Thursday, January 19, 2017 9:46 AM
> To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>; sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org; linux-
> nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org;
> dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> Subject: Re: [PATCHv3] nvmet-rdma: Fix missing dma sync to nvme data
> structures
>=20
> On Thu, Jan 19, 2017 at 03:45:30PM +0000, Parav Pandit wrote:
> > I agree. I should have taken care of that.
> > Shall I resend patch with same indentation at all places or this can be=
 taken
> care during commit?
>=20
> I think Sagi or I can just take care of it on commit.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

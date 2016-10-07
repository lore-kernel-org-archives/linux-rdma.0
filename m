From: "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH qedr 04/10] qedr: Add support for PD,PKEY and CQ verbs
Date: Fri, 7 Oct 2016 10:47:18 +0000
Message-ID: <CY1PR0701MB1337AC7B933E917765C3EBC990C60@CY1PR0701MB1337.namprd07.prod.outlook.com>
References: <1475682483-9878-1-git-send-email-Ram.Amrani@cavium.com>
 <1475682483-9878-5-git-send-email-Ram.Amrani@cavium.com>
 <20161006133357.GP9282@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161006133357.GP9282-2ukJVAZIZ/Y@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Mintz, Yuval" <Yuval.Mintz-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Borundia, Rajesh" <Rajesh.Borundia-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > @@ -66,6 +85,12 @@ struct rdma_cqe_common {
> >     struct regpair qp_handle;
> >     __le16 reserved1[7];
> >     u8 flags;
> > +#define RDMA_CQE_COMMON_TOGGLE_BIT_MASK  0x1
> > +#define RDMA_CQE_COMMON_TOGGLE_BIT_SHIFT 0
> > +#define RDMA_CQE_COMMON_TYPE_MASK        0x3
> > +#define RDMA_CQE_COMMON_TYPE_SHIFT       1
> > +#define RDMA_CQE_COMMON_RESERVED2_MASK   0x1F
> > +#define RDMA_CQE_COMMON_RESERVED2_SHIFT  3
> >     u8 status;
>
> It is VERY uncommon to mix defines and structs together.
> Please don't do it, it confuses a lot and doesn't help to
> readability/debug.

Hi Leon,
Firstly, thanks for investing your time in reviewing our driver.
As for mixed defines and structures, far from being very uncommon, they are
actually ubiquitous throughout the kernel and are used by the foremost
developers (Dave Miller, Linus, Jeff Kirsher).

In infiniband tree alone, at least three drivers employ this:
drivers/infiniband/hw/ocrdma/ocrdma_sli.h line 1900
drivers/infiniband/hw/mthca/mthca_user.h line 68
drivers/infiniband/hw/cxgb3/cxio_hal.h line 116

In the net subsystem, it is even more widely used (~14k places), including
mellanox and intel drivers, as well as our bnx2x and qed* drivers and many
others. A few examples can be seen under:
drivers/net/ethernet/mellanox/mlx4/en_port.h line 94
drivers/net/ethernet/mellanox/mlx4/mlx4_en.h line 345
drivers/net/ethernet/mellanox/mlx4/fw.c line 2759
drivers/net/ethernet/intel/ixgbe/ixgbe.h line 623 (Jeff Kirsher)
drivers/net/ethernet/broadcom/tg3.h line 2540 (Dave Miller)
ixgbe.h uses this exactly like we do in the code you cited.

In other kernel cornerstones:
fs/ext4/ext4.h line 1287 (Linus)
include/net/sock.h line 312 (Dave)

I don't think there are grounds for objecting to this style. We'll take car=
e
of the rest of your comments.

Thanks,
Ariel
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH qedr 04/10] qedr: Add support for PD,PKEY and CQ verbs
Date: Fri, 7 Oct 2016 17:24:54 +0300
Message-ID: <20161007142454.GU9282@leon.nu>
References: <1475682483-9878-1-git-send-email-Ram.Amrani@cavium.com>
 <1475682483-9878-5-git-send-email-Ram.Amrani@cavium.com>
 <20161006133357.GP9282@leon.nu>
 <CY1PR0701MB1337AC7B933E917765C3EBC990C60@CY1PR0701MB1337.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="V4yrq4dHtCqH+JvC"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CY1PR0701MB1337AC7B933E917765C3EBC990C60-UpKza+2NMNLi6bjPjkn3FE5OhdzP3rhOnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Mintz, Yuval" <Yuval.Mintz-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Borundia, Rajesh" <Rajesh.Borundia-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--V4yrq4dHtCqH+JvC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 07, 2016 at 10:47:18AM +0000, Elior, Ariel wrote:
> > > @@ -66,6 +85,12 @@ struct rdma_cqe_common {
> > >     struct regpair qp_handle;
> > >     __le16 reserved1[7];
> > >     u8 flags;
> > > +#define RDMA_CQE_COMMON_TOGGLE_BIT_MASK  0x1
> > > +#define RDMA_CQE_COMMON_TOGGLE_BIT_SHIFT 0
> > > +#define RDMA_CQE_COMMON_TYPE_MASK        0x3
> > > +#define RDMA_CQE_COMMON_TYPE_SHIFT       1
> > > +#define RDMA_CQE_COMMON_RESERVED2_MASK   0x1F
> > > +#define RDMA_CQE_COMMON_RESERVED2_SHIFT  3
> > >     u8 status;
> >
> > It is VERY uncommon to mix defines and structs together.
> > Please don't do it, it confuses a lot and doesn't help to
> > readability/debug.
>
> Hi Leon,
> Firstly, thanks for investing your time in reviewing our driver.
> As for mixed defines and structures, far from being very uncommon, they are
> actually ubiquitous throughout the kernel and are used by the foremost
> developers (Dave Miller, Linus, Jeff Kirsher).

Net subsystem is very different from other kernel community.
For example, this article from LWN [1] - "Coding-style exceptionalism"
talks about it.

>
> In infiniband tree alone, at least three drivers employ this:
> drivers/infiniband/hw/ocrdma/ocrdma_sli.h line 1900
> drivers/infiniband/hw/mthca/mthca_user.h line 68
> drivers/infiniband/hw/cxgb3/cxio_hal.h line 116

All of them are copy-paste from pre-historic era.

>
> In the net subsystem, it is even more widely used (~14k places), including
> mellanox and intel drivers, as well as our bnx2x and qed* drivers and many
> others. A few examples can be seen under:
> drivers/net/ethernet/mellanox/mlx4/en_port.h line 94
> drivers/net/ethernet/mellanox/mlx4/mlx4_en.h line 345
> drivers/net/ethernet/mellanox/mlx4/fw.c line 2759

Thanks for pointing it.
We will fix it.

> drivers/net/ethernet/intel/ixgbe/ixgbe.h line 623 (Jeff Kirsher)
> drivers/net/ethernet/broadcom/tg3.h line 2540 (Dave Miller)
> ixgbe.h uses this exactly like we do in the code you cited.
>
> In other kernel cornerstones:
> fs/ext4/ext4.h line 1287 (Linus)

1. From git blame, this define was added in 2010 !!!!
2. It has totally different meaning from your code - to mark the
position in the structure.

> include/net/sock.h line 312 (Dave)

Net is a bad example.

>
> I don't think there are grounds for objecting to this style. We'll take care
> of the rest of your comments.

As you wish, at the end it will be Doug's decision, if he wants to see
driver submitted in 2016 in different coding style from rest of the subsystem.

[1] https://lwn.net/Articles/694755/

>
> Thanks,
> Ariel

--V4yrq4dHtCqH+JvC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX97A2AAoJEORje4g2clinV/EP/AiJRfTDtq9IEU61wMR7lMi7
wHcxuc6kDZqOuqLB5IX99vTyna6RcbKwp5xkVMdUHzWdf0AXcUJdRxzdWFCspIn2
XO0LDnOPJ72l3Z6FJ2ZmzlrAWk/Um8JlglxbU08QdipHRJUv1eE3sL0dVlEdwNIQ
YTQ+ur0Af++9rGTr+eV5vbMX8XGzb8Y70JP7dZZrZfuqzidczlzrNQ91n/J5ieyo
eKUfJMRWkWsULAgc/i3cVlghPMuNe6TBbhSvCz1AsIF7iex4n8bmlaatVgfCWmvC
CQRpb07WmDvgeWi/pjUfaYF6Q1jB5p0VXtXi2vM2zkRrkFp63VFvXCXKl1wrW9s4
grj7HmbkeGIEgaGrHFFL9xhhSHpxe/V3ddqIvcm1/FTLiSIzsABVq7RXwSqqFMcd
IkQcdeRHW7rQ4ci+L5YYqm35rRIyYzdXGnoJF84OLdgKyopW9//gq41QWth/X7tv
zbonDlfgUUK15mhISnIlbQ6g4lhtONqOuZz09dvF3PQEd4D4YYU12fgr8tXXnQ21
D/FyRCj8lc3ZTGfG36xpcZQ9WZIHd/gB+vniCQeY93zZrXDT2At9l7w31u6dV54e
oXy8NBBKskFqL15WeY0P+yPUJ5HaIHNdqA2vaOFKLysDsl750vk8Ua5LA8KygKTw
4JMpHq5xfJVT6cc6Hr9W
=0SCN
-----END PGP SIGNATURE-----

--V4yrq4dHtCqH+JvC--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

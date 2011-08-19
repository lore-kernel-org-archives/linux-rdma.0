From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: [PATCH 0/20 v2] rdma: Add XRC support
Date: Fri, 19 Aug 2011 09:55:48 -0700
Message-ID: <CAL1RGDWrEN9nT=z5c_H=YXykFqVgOrp0vgBkcSshKodPLq+1mw@mail.gmail.com>
References: <1828884A29C6694DAF28B7E6B8A8237316E41B0A@FMSMSX151.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237316E41B0A-Q3cL8pyY+6ukrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Great stuff!  I'd really like to get this into kernel 3.2... do you hav=
e any
open issues or is it all good from your POV?

 - R.

On Thu, Aug 18, 2011 at 7:14 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wro=
te:
> XRC provides a scalability enhancement when a process on one node
> must communicate with multiple processes on another node. =A0This
> is commonly the case when running MPI applications on multi-core
> systems in a cluster.
>
> An XRC connection consists of an initiator (XRC INI) qp and a target
> (XRC TGT) qp. =A0A single xrc ini -> xrc tgt qp connection enables a
> process to communicate with all remote processes on a single node.
> Security is enforced through the use of a special type of protection
> domain and shared receive queues. =A0An xrc srq is allocated
> on an xrc domain. =A0The xrc tgt qp is also allocated on an xrc domai=
n.
> A process may receive data on an xrc srq from a tgt qp if the xrc
> domains are the same.
>
> The following patch series adds support for XRC. =A0The patches used
> the patches found in Roland's xrc branch as a base, plus added in
> patches found in the OFED 1.5 linux git tree. =A0The latter were main=
ly
> used for updating the mlx4 driver. =A0I broke the patches up, so that
> I could follow each change better.
>
> This set differs from Roland's xrc branch in that XRC initiator and
> target QP types are separated, and a type is specified when creating
> an SRQ. =A0The patches differ from the OFED 1.5 patches by using the
> existing QP APIs and ABI to create and manage XRC QPs. =A0XRCD's may
> still be shared among multiple processes, and XRC QPs may be connecte=
d
> out of band.
>
> There are corresponding patches to libibverbs, libmlx4, and the
> librdmacm to support XRC.
>
> This patch sets are also available on the ofa server:
>
> =A0 =A0 =A0 =A0git://git.openfabrics.org/~shefty/rdma-dev.git =A0 xrc
> =A0 =A0 =A0 =A0git://git.openfabrics.org/~shefty/libibverbs.git xrc
> =A0 =A0 =A0 =A0git://git.openfabrics.org/~shefty/libmlx4.git =A0 =A0x=
rc
> =A0 =A0 =A0 =A0git://git.openfabrics.org/~shefty/librdmacm.git =A0xrc
>
> Changes from v1:
> - Add ability for any process using an xrcd to open an existing tgt q=
p
> - Provided update to ib_cm changes based on proposed errata.
>
> Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

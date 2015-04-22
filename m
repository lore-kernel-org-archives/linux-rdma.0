From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v5 00/27] IB/Verbs: IB Management Helpers
Date: Tue, 21 Apr 2015 22:41:24 -0400
Message-ID: <20150422024123.GA18675@phlsvsds.ph.intel.com>
References: <5534B8C9.506@profitbricks.com> <DB4PR05MB0863E9CCCD1BEA34F244EE2CB1EF0@DB4PR05MB0863.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <DB4PR05MB0863E9CCCD1BEA34F244EE2CB1EF0-xsq7jzH2t6llkovD9u25SNqRiQSDpxhJvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, "raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org" <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Apr 21, 2015 at 11:36:40PM +0000, Liran Liss wrote:
> Hi Michael,
>=20
> The spirit of this patch-set is great, but I think that we need to cl=
arify some concepts.
> Since this will affect the whole patch-set, I am laying out my concer=
ns here instead.
>=20
> A suggestion for the resulting management helpers is given below.
> I believe the result would be much more coherent.
> --Liran
>=20
> In general
> =3D=3D=3D=3D=3D=3D=3D=3D
>=20
> An ib_dev (or a port of) should be distinguished by 3 qualifiers:
> - The link layer:
> -- Ethernet (shared by iWARP, USNIC, and ROCE)
> -- Infiniband
>=20
> - The transport (*)
> -- IBTA transport (shared by IB and ROCE)
> -- iWARP transport
> -- USNIC transport
>=20
> (*) Transport means both:
> - The L4 wire protocols (e.g., BTH+ headers of IBTA, optionally encap=
sulated by UDP in ROCEv2, or the iWARP stack)
> - The transport semantics (for example, there are slight semantic dif=
ferences between IBTA and iWARP)
>=20
> - The node type (**)
> -- CA
> -- Switch
> -- Router
>=20
> (**) This has been extended to also encode the transport in the curre=
nt code.
> At least for user-space visible APIs, we might chose to leave this fo=
r backward compatibility, but we can consider cleaning up the kernel co=
de.
>=20
> So, I think that our "old-transport" below is just fine.
> No need to change it (and you aren't, since it is currently implement=
ed as a function).

I think there is a need to change this.  Encoding the transport into th=
e node
type is not a good idea.  Having different "transport semantics" while =
still
returning the same transport for the port is confusing.

The only thing which is clear currently is Link Layer.

But the use of "Link Layer" in the code is so convoluted that it is ver=
y
confusing.

>=20
> The "new-transport" does not really exist, but is broken into several=
 capability checks of the L4 transport, optionally with conditions on t=
he link type.
> I would remove the table below and tell what we really want to achiev=
e:
> =3D=3D> move technology-specific feature-check logic out of the (mult=
iple!) IB code components and various ULPs into per-feature helpers.
>=20
>=20
> Detailed remarks
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> 1) The introduction of cap_*_*() stuff should have been introduced di=
rectly in patch 02/27.
> This back-and-forth between rdma_ib_or_iboe() and cap_* is confusing =
and increases the number of patches in the patch-set.
> Do this and remove patches 16-24.

I think this is a result of the back and forth which has gone on.  Some
squashing could be done but the current series is pretty straight forwa=
rd when
you look at the patches.  Most are less than a page long at this point.

>=20
> 2)The name rdma_tech_* is lame.
> rdma_transport_*(), adhering to the above (*) remark, is much better.
> For example, both IB and ROCE *do* use the same transport.=20

Define Transport?  There has been a lot of discussion over what a trans=
port is
in Verbs.

>=20
> 3) The name cap_* as it is used above is not accurate.
> You use it to describe technology characteristics rather than extenda=
ble capabilities.
> I would suggest having a single convention for all helpers, such as r=
dma_has_*() and rdma_is_*().
> For example: cap_ib_smi() =3D=3D> rdma_has_smi().

rdma_has_smi is not sufficient for the new OPA technology.  We discusse=
d many
different names and cap_* was settled on.  The use of cap_ib_* was for =
things
which are specific to IB Ports.

=46rankly when RoCE was added functions like this this should have been=
 added for
clarity into the CM and multicast code.  But at the time a simple "is l=
ink layer
check" was sufficient.  Now we have so many different devices and layer=
s that
this clean up is needed to support the future.

>=20
> 4) Remove all capabilities that do not introduce any distinction in t=
he current code.
> We can add them as needed later.
> This means remove patches:
> - [PATCH v5 22/27] IB/Verbs: Use management helper cap_ipoib() =E2=80=
=93 all IB devices support ipoib

Ah?  What is the point of supporting IPoIB on RoCE?  What do you mean b=
y "IB
device"?

> - [PATCH v5 24/27] IB/Verbs: Use management helper cap_af_ib() =E2=80=
=93 all IB devices support AF_IB.

But not a generic RDMA device...  Which is what is being queried in the=
 call.

>=20
> On the other hand:
> - rdma_has_multicast() makes sense, since iWARP doesn=E2=80=99t suppo=
rt it.
> - cap_ib_sa() might make sense to cut code even further in the CMA, s=
ince RoCE has a GSI but no SA.

As does cap_ib_mad, cap_ib_cm, etc.

>=20
> 5) Do no modify phys_state_show() in [PATCH v5 09/27] IB/Verbs: Refor=
m IB-core verbs/uverbs_cmd/sysfs
> It *is* the link layer!

I agree with this.  When the Link Layer is directly being requested we =
should
report the link layer.  However, the internal uses of Link Layer should=
 be
minimal if not 0.

>=20
> 6) Remove cap_read_multi_sge
> It is not device/port feature, but a transport capability.
> Use rdma_is_iwarp_transport() instead, or introduce a new transport f=
lag in 'enum ib_device_cap_flags'.

This was already debated and we settled on cap_read_multi_sge.  Checkin=
g the
transport does not allow for other verbs devices to support this unless=
 they set
that same transport.

> =20
> 7) Remove [PATCH v5 25/27] IB/Verbs: Use management helper cap_eth_ah=
().
> Address handles that refer to Ethernet links always have Ethernet add=
ressing.

But how does the upper level code _know_ that?  That is the point of
cap_eth_ah.

>=20
> In the CMA code, using rdma_tech_iboe() is just fine. This is how you=
 define cap_eth_ah() anyway.
> Currently, this patch just adds clutter.
>=20
> 8) Remove patch [PATCH v5 26/27] IB/Verbs: Clean up rdma_ib_or_iboe()=
=2E
> We do need a transport qualifier, as exemplified in comment 5) above,=
 and for a complete clean model.

I'm confused, comment 5 was talking about Link Layer???

> This is after renaming the function to rdma_is_ib_transport()...
>=20
>=20
> Putting it all together
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> We are left with the following helpers:
> - rdma_is_ib_transport()
> - rdma_is_iwarp_transport()
> - rdma_is_usnic_transport()
> - rdma_is_iboe()
> - rdma_has_mad()

Not sufficient to distinguish OPA MADs from IB

> - rdma_has_smi()
> - rdma_has_gsi() - complements smi; can be used by the mad code for c=
larity
> - rdma_has_sa()
> - rdma_has_cm()

Not sufficient to distinguish between the IB CM and iWarp "CM".

> - rdma_has_mcast()

Not sufficient to distinguish between the IB Multicast vs IBoE Multicas=
t.


In general I'm flexible on the function names.  "cap" vs "rdma" does no=
t really
matter to me.  Likewise "has" vs "requires" vs "uses" does not matter.

Regardless we still need more granularity than "Transport" and "Link La=
yer" for many
of the code choices.

The result of this series is pretty explicit and much cleaner as to wha=
t the
upper layers are really checking for.

=46urthermore we know that the implementations are going to change goin=
g forward.
The point of this series is to decouple the MAD, CM, SA, IPoIB, etc mod=
ules
from the knowledge of transport and link layer.  The new interface is s=
imply
using the old implementation as a stepping stone.

Ira

>=20
>=20
> > Subject: [PATCH v5 00/27] IB/Verbs: IB Management Helpers
> >=20
> >=20
> > Since v4:
> >   * Thanks for the comments from Hal, Sean, Tom, Or Gerlitz, Jason,
> >     Roland, Ira and Steve :-) Please remind me if anything missed :=
-P
> >   * Fix logical issue inside 3#, 14#
> >   * Refine 3#, 4#, 5# with label 'free'
> >   * Rework 10# to stop using port 1 when port already assigned
> >=20
> > There are plenty of lengthy code to check the transport type of IB =
device, or
> > the link layer type of it's port, but actually we are just speculat=
ing whether a
> > particular management/feature is supported by the device/port.
> >=20
> > Thus instead of inferring, we should have our own mechanism for IB
> > management capability/protocol/feature checking, several proposals =
below.
> >=20
> > This patch set will reform the method of getting transport type, we=
 will now
> > using query_transport() instead of inferring from transport and lin=
k layer
> > respectively, also we defined the new transport type to make the co=
ncept
> > more reasonable.
> >=20
> > Mapping List:
> > 		node-type	link-layer	old-transport	new-transport
> > nes		RNIC		ETH		IWARP		IWARP
> > amso1100	RNIC		ETH		IWARP		IWARP
> > cxgb3   	RNIC		ETH		IWARP		IWARP
> > cxgb4   	RNIC		ETH		IWARP		IWARP
> > usnic   	USNIC_UDP	ETH		USNIC_UDP	USNIC_UDP
> > ocrdma  	IB_CA		ETH		IB		IBOE
> > mlx4    	IB_CA		IB/ETH		IB		IB/IBOE
> > mlx5    	IB_CA		IB		IB		IB
> > ehca    	IB_CA		IB		IB		IB
> > ipath   	IB_CA		IB		IB		IB
> > mthca   	IB_CA		IB		IB		IB
> > qib     	IB_CA		IB		IB		IB
> >=20
> > For example:
> > 	if (transport =3D=3D IB) && (link-layer =3D=3D ETH) will now becom=
e:
> > 	if (query_transport() =3D=3D IBOE)
> >=20
> > Thus we will be able to get rid of the respective transport and lin=
k-layer
> > checking, and it will help us to add new protocol/Technology (like =
OPA) more
> > easier, also with the introduced management helpers, IB management =
logical
> > will be more clear and easier for extending.
> >=20
> > Highlights:
> >     The patch set covered a wide range of IB stuff, thus for those =
who are
> >     familiar with the particular part, your suggestion would be inv=
aluable ;-)
> >=20
> >     Patch 1#~15# included all the logical reform, 16#~25# introduce=
d the
> >     management helpers, 26#~27# do clean up.
> >=20
> >     Patches haven't been tested yet, we appreciate if any one who h=
ave these
> >     HW willing to provide his Tested-by :-)
> >=20
> >     Doug suggested the bitmask mechanism:
> > 	https://www.mail-archive.com/linux-
> > rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg23765.html
> >     which could be the plan for future reforming, we prefer that to=
 be another
> >     series which focus on semantic and performance.
> >=20
> >     This patch-set is somewhat 'bloated' now and it may be a good t=
iming for
> >     staging, I'd like to suggest we focus on improving existed help=
ers and push
> >     all the further reforms into next series ;-)
> >=20
> > Proposals:
> >     Sean:
> > 	https://www.mail-archive.com/linux-
> > rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg23339.html
> >     Doug:
> > 	https://www.mail-archive.com/linux-
> > rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg23418.html
> > 	https://www.mail-archive.com/linux-
> > rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg23765.html
> >     Jason:
> > 	https://www.mail-archive.com/linux-
> > rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg23425.html
> >=20
> > Michael Wang (27):
> >     IB/Verbs: Implement new callback query_transport()
> >     IB/Verbs: Implement raw management helpers
> >     IB/Verbs: Reform IB-core mad/agent/user_mad
> >     IB/Verbs: Reform IB-core cm
> >     IB/Verbs: Reform IB-core sa_query
> >     IB/Verbs: Reform IB-core multicast
> >     IB/Verbs: Reform IB-ulp ipoib
> >     IB/Verbs: Reform IB-ulp xprtrdma
> >     IB/Verbs: Reform IB-core verbs/uverbs_cmd/sysfs
> >     IB/Verbs: Reform cm related part in IB-core cma/ucm
> >     IB/Verbs: Reform route related part in IB-core cma
> >     IB/Verbs: Reform mcast related part in IB-core cma
> >     IB/Verbs: Reserve legacy transport type in 'dev_addr'
> >     IB/Verbs: Reform cma_acquire_dev()
> >     IB/Verbs: Reform rest part in IB-core cma
> >     IB/Verbs: Use management helper cap_ib_mad()
> >     IB/Verbs: Use management helper cap_ib_smi()
> >     IB/Verbs: Use management helper cap_ib_cm()
> >     IB/Verbs: Use management helper cap_iw_cm()
> >     IB/Verbs: Use management helper cap_ib_sa()
> >     IB/Verbs: Use management helper cap_ib_mcast()
> >     IB/Verbs: Use management helper cap_ipoib()
> >     IB/Verbs: Use management helper cap_read_multi_sge()
> >     IB/Verbs: Use management helper cap_af_ib()
> >     IB/Verbs: Use management helper cap_eth_ah()
> >     IB/Verbs: Clean up rdma_ib_or_iboe()
> >     IB/Verbs: Cleanup rdma_node_get_transport()
> >=20
> > ---
> >  drivers/infiniband/core/agent.c              |    4
> >  drivers/infiniband/core/cm.c                 |   26 +-
> >  drivers/infiniband/core/cma.c                |  328 ++++++++++++--=
-------------
> >  drivers/infiniband/core/device.c             |    1
> >  drivers/infiniband/core/mad.c                |   51 ++--
> >  drivers/infiniband/core/multicast.c          |   18 -
> >  drivers/infiniband/core/sa_query.c           |   41 +--
> >  drivers/infiniband/core/sysfs.c              |    8
> >  drivers/infiniband/core/ucm.c                |    5
> >  drivers/infiniband/core/ucma.c               |   27 --
> >  drivers/infiniband/core/user_mad.c           |   32 +-
> >  drivers/infiniband/core/uverbs_cmd.c         |    6
> >  drivers/infiniband/core/verbs.c              |   33 --
> >  drivers/infiniband/hw/amso1100/c2_provider.c |    7
> >  drivers/infiniband/hw/cxgb3/iwch_provider.c  |    7
> >  drivers/infiniband/hw/cxgb4/provider.c       |    7
> >  drivers/infiniband/hw/ehca/ehca_hca.c        |    6
> >  drivers/infiniband/hw/ehca/ehca_iverbs.h     |    3
> >  drivers/infiniband/hw/ehca/ehca_main.c       |    1
> >  drivers/infiniband/hw/ipath/ipath_verbs.c    |    7
> >  drivers/infiniband/hw/mlx4/main.c            |   10
> >  drivers/infiniband/hw/mlx5/main.c            |    7
> >  drivers/infiniband/hw/mthca/mthca_provider.c |    7
> >  drivers/infiniband/hw/nes/nes_verbs.c        |    6
> >  drivers/infiniband/hw/ocrdma/ocrdma_main.c   |    1
> >  drivers/infiniband/hw/ocrdma/ocrdma_verbs.c  |    6
> >  drivers/infiniband/hw/ocrdma/ocrdma_verbs.h  |    3
> >  drivers/infiniband/hw/qib/qib_verbs.c        |    7
> >  drivers/infiniband/hw/usnic/usnic_ib_main.c  |    1
> >  drivers/infiniband/hw/usnic/usnic_ib_verbs.c |    6
> >  drivers/infiniband/hw/usnic/usnic_ib_verbs.h |    2
> >  drivers/infiniband/ulp/ipoib/ipoib_main.c    |   17 -
> >  include/rdma/ib_verbs.h                      |  204 ++++++++++++++=
+-
> >  net/sunrpc/xprtrdma/svc_rdma_recvfrom.c      |    6
> >  net/sunrpc/xprtrdma/svc_rdma_transport.c     |   51 +---
> >  35 files changed, 584 insertions(+), 368 deletions(-)
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdm=
a" in the
> > body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info =
at
> > http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

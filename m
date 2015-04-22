From: Michael Wang <yun.wang@profitbricks.com>
Subject: Re: [PATCH v5 00/27] IB/Verbs: IB Management Helpers
Date: Wed, 22 Apr 2015 10:30:08 +0200
Message-ID: <55375C10.8070901@profitbricks.com>
References: <5534B8C9.506@profitbricks.com> <DB4PR05MB0863E9CCCD1BEA34F244EE2CB1EF0@DB4PR05MB0863.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <DB4PR05MB0863E9CCCD1BEA34F244EE2CB1EF0@DB4PR05MB0863.eurprd05.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Liran Liss <liranl@mellanox.com>, Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hal@dev.mellanox.co.il" <hal@dev.mellanox.co.il>
Cc: Tom Tucker <tom@opengridcomputing.com>, Steve Wise <swise@opengridcomputing.com>, Hoang-Nam Nguyen <hnguyen@de.ibm.com>, "raisch@de.ibm.com" <raisch@de.ibm.com>, Mike Marciniszyn <infinipath@intel.com>, Eli Cohen <eli@mellanox.com>, Faisal Latif <faisal.latif@intel.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Or Gerlitz <ogerlitz@mellanox.com>, Haggai Eran <haggaie@mellanox.com>, Ira Weiny <ira.weiny@intel.com>, Tom Talpey <tom@talpey.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Doug Ledford <dledford@redhat.com>
List-Id: linux-rdma@vger.kernel.org

Hi, Liran

Thanks for the comment :-)

On 04/22/2015 01:36 AM, Liran Liss wrote:
[snip]
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
>=20
> The "new-transport" does not really exist, but is broken into several=
 capability checks of the L4 transport, optionally with conditions on t=
he link type.
> I would remove the table below and tell what we really want to achiev=
e:
> =3D=3D> move technology-specific feature-check logic out of the (mult=
iple!) IB code components and various ULPs into per-feature helpers.

Our purpose is to help core layer do management more clearly, rather th=
en
referring from transport and linklayer.

IMHO from management's point of view, what we really care about is whet=
her
a particular management required by device or not, rather then the deta=
ils
on transport and link layer.

This new transport is only understand by core-layer currently, for user=
-layer
we still reserve the old transport for them, next step is to use bitmas=
k
instead of transport, at that time we can erase the new transport and m=
ake
the whole stuff used by user-layer only :-)

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

We have some discussion about compress the patch set, merge the reform =
and introducing patch
will mix the concept (like the earlier version), IMHO it will increase =
the difficulty
of review...

And now since many review already been done, it's not wise to change th=
e whole structure
of patch set IMHO...

>=20
> 2)The name rdma_tech_* is lame.
> rdma_transport_*(), adhering to the above (*) remark, is much better.
> For example, both IB and ROCE *do* use the same transport.=20

We have some discussion on that too, use transport means going back...

>=20
> 3) The name cap_* as it is used above is not accurate.
> You use it to describe technology characteristics rather than extenda=
ble capabilities.
> I would suggest having a single convention for all helpers, such as r=
dma_has_*() and rdma_is_*().
> For example: cap_ib_smi() =3D=3D> rdma_has_smi().

That means going back too...

>=20
> 4) Remove all capabilities that do not introduce any distinction in t=
he current code.
> We can add them as needed later.
> This means remove patches:
> - [PATCH v5 22/27] IB/Verbs: Use management helper cap_ipoib() =E2=80=
=93 all IB devices support ipoib
> - [PATCH v5 24/27] IB/Verbs: Use management helper cap_af_ib() =E2=80=
=93 all IB devices support AF_IB.
>=20
> On the other hand:
> - rdma_has_multicast() makes sense, since iWARP doesn=E2=80=99t suppo=
rt it.
> - cap_ib_sa() might make sense to cut code even further in the CMA, s=
ince RoCE has a GSI but no SA.

We have discussion on define these helpers previously, again, name is n=
ot really
a problem, I would rather to see such changes in the following series a=
fter this
one working stably :-)

>=20
> 5) Do no modify phys_state_show() in [PATCH v5 09/27] IB/Verbs: Refor=
m IB-core verbs/uverbs_cmd/sysfs
> It *is* the link layer!

Actually nothing changed after the modify, the prev purpose it to elimi=
nate the link layer helpers.

But now we are not going to remove the helper any more, so let's drop t=
his modification in next version :-)

>=20
> 6) Remove cap_read_multi_sge
> It is not device/port feature, but a transport capability.
> Use rdma_is_iwarp_transport() instead, or introduce a new transport f=
lag in 'enum ib_device_cap_flags'.
> =20
> 7) Remove [PATCH v5 25/27] IB/Verbs: Use management helper cap_eth_ah=
().
> Address handles that refer to Ethernet links always have Ethernet add=
ressing.
>=20
> In the CMA code, using rdma_tech_iboe() is just fine. This is how you=
 define cap_eth_ah() anyway.
> Currently, this patch just adds clutter.

There are also some discussion on these helpers, drop them means going =
back..

The tech helper is not enough to explain the management purpose, and th=
is can
be the wrapper for bitmask stuff too.

>=20
> 8) Remove patch [PATCH v5 26/27] IB/Verbs: Clean up rdma_ib_or_iboe()=
=2E
> We do need a transport qualifier, as exemplified in comment 5) above,=
 and for a complete clean model.
> This is after renaming the function to rdma_is_ib_transport()...

This means going back again... rdma_is_ib_transport() has been used pre=
viously.

This helper is just to make the review more easier, we won't need it in=
ternally,
not to mention after bitmask was introduced :-)

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
> - rdma_has_smi()
> - rdma_has_gsi() - complements smi; can be used by the mad code for c=
larity
> - rdma_has_sa()
> - rdma_has_cm()
> - rdma_has_mcast()

I think we can put the discussion on name and new helpers in future, cu=
rrently
let's focus on these basic reform and make them working stably ;-)

Regards,
Michael Wang

>=20
>=20
>> Subject: [PATCH v5 00/27] IB/Verbs: IB Management Helpers
>>
>>
>> Since v4:
>>   * Thanks for the comments from Hal, Sean, Tom, Or Gerlitz, Jason,
>>     Roland, Ira and Steve :-) Please remind me if anything missed :-=
P
>>   * Fix logical issue inside 3#, 14#
>>   * Refine 3#, 4#, 5# with label 'free'
>>   * Rework 10# to stop using port 1 when port already assigned
>>
>> There are plenty of lengthy code to check the transport type of IB d=
evice, or
>> the link layer type of it's port, but actually we are just speculati=
ng whether a
>> particular management/feature is supported by the device/port.
>>
>> Thus instead of inferring, we should have our own mechanism for IB
>> management capability/protocol/feature checking, several proposals b=
elow.
>>
>> This patch set will reform the method of getting transport type, we =
will now
>> using query_transport() instead of inferring from transport and link=
 layer
>> respectively, also we defined the new transport type to make the con=
cept
>> more reasonable.
>>
>> Mapping List:
>> 		node-type	link-layer	old-transport	new-transport
>> nes		RNIC		ETH		IWARP		IWARP
>> amso1100	RNIC		ETH		IWARP		IWARP
>> cxgb3   	RNIC		ETH		IWARP		IWARP
>> cxgb4   	RNIC		ETH		IWARP		IWARP
>> usnic   	USNIC_UDP	ETH		USNIC_UDP	USNIC_UDP
>> ocrdma  	IB_CA		ETH		IB		IBOE
>> mlx4    	IB_CA		IB/ETH		IB		IB/IBOE
>> mlx5    	IB_CA		IB		IB		IB
>> ehca    	IB_CA		IB		IB		IB
>> ipath   	IB_CA		IB		IB		IB
>> mthca   	IB_CA		IB		IB		IB
>> qib     	IB_CA		IB		IB		IB
>>
>> For example:
>> 	if (transport =3D=3D IB) && (link-layer =3D=3D ETH) will now become=
:
>> 	if (query_transport() =3D=3D IBOE)
>>
>> Thus we will be able to get rid of the respective transport and link=
-layer
>> checking, and it will help us to add new protocol/Technology (like O=
PA) more
>> easier, also with the introduced management helpers, IB management l=
ogical
>> will be more clear and easier for extending.
>>
>> Highlights:
>>     The patch set covered a wide range of IB stuff, thus for those w=
ho are
>>     familiar with the particular part, your suggestion would be inva=
luable ;-)
>>
>>     Patch 1#~15# included all the logical reform, 16#~25# introduced=
 the
>>     management helpers, 26#~27# do clean up.
>>
>>     Patches haven't been tested yet, we appreciate if any one who ha=
ve these
>>     HW willing to provide his Tested-by :-)
>>
>>     Doug suggested the bitmask mechanism:
>> 	https://www.mail-archive.com/linux-
>> rdma@vger.kernel.org/msg23765.html
>>     which could be the plan for future reforming, we prefer that to =
be another
>>     series which focus on semantic and performance.
>>
>>     This patch-set is somewhat 'bloated' now and it may be a good ti=
ming for
>>     staging, I'd like to suggest we focus on improving existed helpe=
rs and push
>>     all the further reforms into next series ;-)
>>
>> Proposals:
>>     Sean:
>> 	https://www.mail-archive.com/linux-
>> rdma@vger.kernel.org/msg23339.html
>>     Doug:
>> 	https://www.mail-archive.com/linux-
>> rdma@vger.kernel.org/msg23418.html
>> 	https://www.mail-archive.com/linux-
>> rdma@vger.kernel.org/msg23765.html
>>     Jason:
>> 	https://www.mail-archive.com/linux-
>> rdma@vger.kernel.org/msg23425.html
>>
>> Michael Wang (27):
>>     IB/Verbs: Implement new callback query_transport()
>>     IB/Verbs: Implement raw management helpers
>>     IB/Verbs: Reform IB-core mad/agent/user_mad
>>     IB/Verbs: Reform IB-core cm
>>     IB/Verbs: Reform IB-core sa_query
>>     IB/Verbs: Reform IB-core multicast
>>     IB/Verbs: Reform IB-ulp ipoib
>>     IB/Verbs: Reform IB-ulp xprtrdma
>>     IB/Verbs: Reform IB-core verbs/uverbs_cmd/sysfs
>>     IB/Verbs: Reform cm related part in IB-core cma/ucm
>>     IB/Verbs: Reform route related part in IB-core cma
>>     IB/Verbs: Reform mcast related part in IB-core cma
>>     IB/Verbs: Reserve legacy transport type in 'dev_addr'
>>     IB/Verbs: Reform cma_acquire_dev()
>>     IB/Verbs: Reform rest part in IB-core cma
>>     IB/Verbs: Use management helper cap_ib_mad()
>>     IB/Verbs: Use management helper cap_ib_smi()
>>     IB/Verbs: Use management helper cap_ib_cm()
>>     IB/Verbs: Use management helper cap_iw_cm()
>>     IB/Verbs: Use management helper cap_ib_sa()
>>     IB/Verbs: Use management helper cap_ib_mcast()
>>     IB/Verbs: Use management helper cap_ipoib()
>>     IB/Verbs: Use management helper cap_read_multi_sge()
>>     IB/Verbs: Use management helper cap_af_ib()
>>     IB/Verbs: Use management helper cap_eth_ah()
>>     IB/Verbs: Clean up rdma_ib_or_iboe()
>>     IB/Verbs: Cleanup rdma_node_get_transport()
>>
>> ---
>>  drivers/infiniband/core/agent.c              |    4
>>  drivers/infiniband/core/cm.c                 |   26 +-
>>  drivers/infiniband/core/cma.c                |  328 ++++++++++++---=
------------
>>  drivers/infiniband/core/device.c             |    1
>>  drivers/infiniband/core/mad.c                |   51 ++--
>>  drivers/infiniband/core/multicast.c          |   18 -
>>  drivers/infiniband/core/sa_query.c           |   41 +--
>>  drivers/infiniband/core/sysfs.c              |    8
>>  drivers/infiniband/core/ucm.c                |    5
>>  drivers/infiniband/core/ucma.c               |   27 --
>>  drivers/infiniband/core/user_mad.c           |   32 +-
>>  drivers/infiniband/core/uverbs_cmd.c         |    6
>>  drivers/infiniband/core/verbs.c              |   33 --
>>  drivers/infiniband/hw/amso1100/c2_provider.c |    7
>>  drivers/infiniband/hw/cxgb3/iwch_provider.c  |    7
>>  drivers/infiniband/hw/cxgb4/provider.c       |    7
>>  drivers/infiniband/hw/ehca/ehca_hca.c        |    6
>>  drivers/infiniband/hw/ehca/ehca_iverbs.h     |    3
>>  drivers/infiniband/hw/ehca/ehca_main.c       |    1
>>  drivers/infiniband/hw/ipath/ipath_verbs.c    |    7
>>  drivers/infiniband/hw/mlx4/main.c            |   10
>>  drivers/infiniband/hw/mlx5/main.c            |    7
>>  drivers/infiniband/hw/mthca/mthca_provider.c |    7
>>  drivers/infiniband/hw/nes/nes_verbs.c        |    6
>>  drivers/infiniband/hw/ocrdma/ocrdma_main.c   |    1
>>  drivers/infiniband/hw/ocrdma/ocrdma_verbs.c  |    6
>>  drivers/infiniband/hw/ocrdma/ocrdma_verbs.h  |    3
>>  drivers/infiniband/hw/qib/qib_verbs.c        |    7
>>  drivers/infiniband/hw/usnic/usnic_ib_main.c  |    1
>>  drivers/infiniband/hw/usnic/usnic_ib_verbs.c |    6
>>  drivers/infiniband/hw/usnic/usnic_ib_verbs.h |    2
>>  drivers/infiniband/ulp/ipoib/ipoib_main.c    |   17 -
>>  include/rdma/ib_verbs.h                      |  204 +++++++++++++++=
-
>>  net/sunrpc/xprtrdma/svc_rdma_recvfrom.c      |    6
>>  net/sunrpc/xprtrdma/svc_rdma_transport.c     |   51 +---
>>  35 files changed, 584 insertions(+), 368 deletions(-)
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma=
" in the
>> body of a message to majordomo@vger.kernel.org More majordomo info a=
t
>> http://vger.kernel.org/majordomo-info.html

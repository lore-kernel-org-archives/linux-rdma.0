From: Michael Wang <yun.wang@profitbricks.com>
Subject: Re: [PATCH v5 00/27] IB/Verbs: IB Management Helpers
Date: Thu, 23 Apr 2015 09:33:08 +0200
Message-ID: <5538A034.4030904@profitbricks.com>
References: <5534B8C9.506@profitbricks.com> <DB4PR05MB0863E9CCCD1BEA34F244EE2CB1EF0@DB4PR05MB0863.eurprd05.prod.outlook.com> <55375C10.8070901@profitbricks.com> <DB4PR05MB0863B84F5AF4F8203CFDAC36B1EE0@DB4PR05MB0863.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <DB4PR05MB0863B84F5AF4F8203CFDAC36B1EE0@DB4PR05MB0863.eurprd05.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Liran Liss <liranl@mellanox.com>, Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hal@dev.mellanox.co.il" <hal@dev.mellanox.co.il>
Cc: Tom Tucker <tom@opengridcomputing.com>, Steve Wise <swise@opengridcomputing.com>, Hoang-Nam Nguyen <hnguyen@de.ibm.com>, "raisch@de.ibm.com" <raisch@de.ibm.com>, Mike Marciniszyn <infinipath@intel.com>, Eli Cohen <eli@mellanox.com>, Faisal Latif <faisal.latif@intel.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Or Gerlitz <ogerlitz@mellanox.com>, Haggai Eran <haggaie@mellanox.com>, Ira Weiny <ira.weiny@intel.com>, Tom Talpey <tom@talpey.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Doug Ledford <dledford@redhat.com>
List-Id: linux-rdma@vger.kernel.org



On 04/22/2015 06:16 PM, Liran Liss wrote:
[snip]
>=20
> Depends on who is "we".
> For ULPs, you are probably right.
>=20
> However, core services (e.g., mad management, CM, SA) do care about v=
arious details.
> In some cases, where it doesn't matter, this code will use management=
 helpers.
> In other cases, this code will inspect link, transport, and node attr=
ibutes of rdma devices.
>=20
> For example, the CM code has specific code paths for IB, RoCE, and iW=
ARP.
> There is no other CM code; there is no reason to abstract 'CM'. This =
code will have code
> paths that depend on various specific details.

That's exactly what we want to stop, we have classified the CM to IB an=
d IWARP now :-)

>=20
>> This new transport is only understand by core-layer currently, for u=
ser-layer
>> we still reserve the old transport for them, next step is to use bit=
mask instead
>> of transport, at that time we can erase the new transport and make t=
he
>> whole stuff used by user-layer only :-)
>>
>=20
> I am not sure that we need a bit mask at all.
> Your helpers already provide all the useful abstractions, which both =
core and ULPs call directly.
> All the information is inferred directly from <link, transport, node>=
 tuples.
>=20
> Some of the user-space tools need *exactly* the same reasoning.
> For example, management tools manage specific technologies and protoc=
ols, not some abstraction.
>=20
> So, For user-space, we can think about exposing exactly the same help=
er framework, while providing
> backward compatibility for the existing interfaces.

I'd really like to put the topic on bitmask and user app reform into
different thread...

bitmask should be next topic, there are many discussion already, but
I could imaging far more discussion there, the user reform should be
the last step, after every thing in kernel settled down :-)

>=20
>>>
>>>
>>> Detailed remarks
>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>>
>>> 1) The introduction of cap_*_*() stuff should have been introduced =
directly
>> in patch 02/27.
>>> This back-and-forth between rdma_ib_or_iboe() and cap_* is confusin=
g and
>> increases the number of patches in the patch-set.
>>> Do this and remove patches 16-24.
>>
>> We have some discussion about compress the patch set, merge the refo=
rm
>> and introducing patch will mix the concept (like the earlier version=
), IMHO it
>> will increase the difficulty of review...
>>
>> And now since many review already been done, it's not wise to change=
 the
>> whole structure of patch set IMHO...
>>
>=20
> I think it is because you are conditioning code on one thing, and the=
n conditioning
> the same code on another thing.
>=20
> This is confusing.
>=20
> Once we get our abstractions correct (i.e., the right helper function=
s), you replace the
> existing logic with the suitable helper up-front.

We need to classify and integrate the concept into mgmt helper, that
would be very helpful for further reform, reform followed by integratio=
n
sounds not that bad, correct?

>=20
>>>
>>> 2)The name rdma_tech_* is lame.
>>> rdma_transport_*(), adhering to the above (*) remark, is much bette=
r.
>>> For example, both IB and ROCE *do* use the same transport.
>>
>> We have some discussion on that too, use transport means going back.=
=2E.
>>
>=20
> No.
> The existing notion of transport was correct. It was the node type th=
at wasn't.
> And in any case the new helpers didn't use it.
>=20
> We need the original meaning of transport - see my response to Ira.
> I propose replacing rdma_node_get_transport() with the following help=
ers:
> - rdma_get_transport()
> - rdma_is_ib_transport()
> - rdma_is_iwarp_transport()

We can change the name at anytime, tech/transport/protocol/standard, ju=
st
one patch later can easily change it and start the topic of naming, any=
 of these
name will unsatisfied someone AFAIK, I'd like to suggest we consider th=
is
as a mark temporarily and focus on the logical issue.

> - ...
>=20
>>>
>>> 3) The name cap_* as it is used above is not accurate.
>>> You use it to describe technology characteristics rather than exten=
dable
>> capabilities.
>>> I would suggest having a single convention for all helpers, such as
>> rdma_has_*() and rdma_is_*().
>>> For example: cap_ib_smi() =3D=3D> rdma_has_smi().
>>
>> That means going back too...
>=20
> See response to Ira (https://lkml.org/lkml/2015/4/21/951).
>=20
>=20
>>
>>>
>>> 4) Remove all capabilities that do not introduce any distinction in=
 the
>> current code.
>>> We can add them as needed later.
>>> This means remove patches:
>>> - [PATCH v5 22/27] IB/Verbs: Use management helper cap_ipoib() =E2=80=
=93 all
>>> IB devices support ipoib
>>> - [PATCH v5 24/27] IB/Verbs: Use management helper cap_af_ib() =E2=80=
=93 all IB
>> devices support AF_IB.
>>>
>>> On the other hand:
>>> - rdma_has_multicast() makes sense, since iWARP doesn=E2=80=99t sup=
port it.
>>> - cap_ib_sa() might make sense to cut code even further in the CMA,=
 since
>> RoCE has a GSI but no SA.
>>
>> We have discussion on define these helpers previously, again, name i=
s not
>> really a problem, I would rather to see such changes in the followin=
g series
>> after this one working stably :-)
>>
>=20
> The names are not critical. This comment is about introducing helpers=
 that are
> do not introduce any new semantic notion in the current patch-set.
>=20
> cap_ipoib(), for example, is brain-dead because only a single technol=
ogy (as of now)
> enables it: Infiniband.

This will be dropped in next version :-)

>=20
>>>
>>> 5) Do no modify phys_state_show() in [PATCH v5 09/27] IB/Verbs: Ref=
orm
>>> IB-core verbs/uverbs_cmd/sysfs It *is* the link layer!
>>
>> Actually nothing changed after the modify, the prev purpose it to el=
iminate
>> the link layer helpers.
>>
>> But now we are not going to remove the helper any more, so let's dro=
p this
>> modification in next version :-)
>>
>=20
> You don't add modifications just to drop them later.
> Don't add them in the first place!
>=20
> This patch-set will remain forever in the kernel commit log - we want=
 it to be
> as self-explaining and coherent as possible.
>=20
> Remove this.

What i mean is this will be removed in v6...

>=20
>>>
>>> 6) Remove cap_read_multi_sge
>>> It is not device/port feature, but a transport capability.
>>> Use rdma_is_iwarp_transport() instead, or introduce a new transport=
 flag in
>> 'enum ib_device_cap_flags'.
>>>
>>> 7) Remove [PATCH v5 25/27] IB/Verbs: Use management helper
>> cap_eth_ah().
>>> Address handles that refer to Ethernet links always have Ethernet
>> addressing.
>>>
>>> In the CMA code, using rdma_tech_iboe() is just fine. This is how y=
ou define
>> cap_eth_ah() anyway.
>>> Currently, this patch just adds clutter.
>>
>> There are also some discussion on these helpers, drop them means goi=
ng
>> back..
>>
>=20
> Back to where? Management helpers are a new concept. Let's get them r=
ight.

Back to one point during v1~v5.

>=20
>> The tech helper is not enough to explain the management purpose, and=
 this
>> can be the wrapper for bitmask stuff too.
>>
>=20
> As I said, I am not sure that we will need any bitmasks.
> Also see response to Ira (https://lkml.org/lkml/2015/4/21/951).

Better discussed in another thread.

>=20
>>>
>>> 8) Remove patch [PATCH v5 26/27] IB/Verbs: Clean up rdma_ib_or_iboe=
().
>>> We do need a transport qualifier, as exemplified in comment 5) abov=
e, and
>> for a complete clean model.
>>> This is after renaming the function to rdma_is_ib_transport()...
>>
>> This means going back again... rdma_is_ib_transport() has been used
>> previously.
>>
>> This helper is just to make the review more easier, we won't need it
>> internally, not to mention after bitmask was introduced :-)
>>
>=20
> The same...
> =20
>>>
>>>
>>> Putting it all together
>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>>
>>> We are left with the following helpers:
>>> - rdma_is_ib_transport()
>>> - rdma_is_iwarp_transport()
>>> - rdma_is_usnic_transport()
>>> - rdma_is_iboe()
>>> - rdma_has_mad()
>>> - rdma_has_smi()
>>> - rdma_has_gsi() - complements smi; can be used by the mad code for
>>> clarity
>>> - rdma_has_sa()
>>> - rdma_has_cm()
>>> - rdma_has_mcast()
>>
>> I think we can put the discussion on name and new helpers in future,
>> currently let's focus on these basic reform and make them working st=
ably ;-)
>=20
> It's not just the names, it's their semantics.
> Any problems with the names proposed above?

These were once used in old version, again, name can't satisfied anyone
at this moment and I'd like to discuss this after the logical was right=
,
I really don't want folks to focus on this issue since it won't broken
anything and can be easily changed once we have the agreement.

Regards,
Michael Wang

>=20
>>
>> Regards,
>> Michael Wang
>>
>>>
>>>
>>>> Subject: [PATCH v5 00/27] IB/Verbs: IB Management Helpers
>>>>
>>>>
>>>> Since v4:
>>>>   * Thanks for the comments from Hal, Sean, Tom, Or Gerlitz, Jason=
,
>>>>     Roland, Ira and Steve :-) Please remind me if anything missed =
:-P
>>>>   * Fix logical issue inside 3#, 14#
>>>>   * Refine 3#, 4#, 5# with label 'free'
>>>>   * Rework 10# to stop using port 1 when port already assigned
>>>>
>>>> There are plenty of lengthy code to check the transport type of IB
>>>> device, or the link layer type of it's port, but actually we are j=
ust
>>>> speculating whether a particular management/feature is supported b=
y the
>> device/port.
>>>>
>>>> Thus instead of inferring, we should have our own mechanism for IB
>>>> management capability/protocol/feature checking, several proposals
>> below.
>>>>
>>>> This patch set will reform the method of getting transport type, w=
e
>>>> will now using query_transport() instead of inferring from transpo=
rt
>>>> and link layer respectively, also we defined the new transport typ=
e
>>>> to make the concept more reasonable.
>>>>
>>>> Mapping List:
>>>> 		node-type	link-layer	old-transport	new-transport
>>>> nes		RNIC		ETH		IWARP		IWARP
>>>> amso1100	RNIC		ETH		IWARP		IWARP
>>>> cxgb3   	RNIC		ETH		IWARP		IWARP
>>>> cxgb4   	RNIC		ETH		IWARP		IWARP
>>>> usnic   	USNIC_UDP	ETH		USNIC_UDP	USNIC_UDP
>>>> ocrdma  	IB_CA		ETH		IB		IBOE
>>>> mlx4    	IB_CA		IB/ETH		IB		IB/IBOE
>>>> mlx5    	IB_CA		IB		IB		IB
>>>> ehca    	IB_CA		IB		IB		IB
>>>> ipath   	IB_CA		IB		IB		IB
>>>> mthca   	IB_CA		IB		IB		IB
>>>> qib     	IB_CA		IB		IB		IB
>>>>
>>>> For example:
>>>> 	if (transport =3D=3D IB) && (link-layer =3D=3D ETH) will now beco=
me:
>>>> 	if (query_transport() =3D=3D IBOE)
>>>>
>>>> Thus we will be able to get rid of the respective transport and
>>>> link-layer checking, and it will help us to add new
>>>> protocol/Technology (like OPA) more easier, also with the introduc=
ed
>>>> management helpers, IB management logical will be more clear and e=
asier
>> for extending.
>>>>
>>>> Highlights:
>>>>     The patch set covered a wide range of IB stuff, thus for those=
 who are
>>>>     familiar with the particular part, your suggestion would be
>>>> invaluable ;-)
>>>>
>>>>     Patch 1#~15# included all the logical reform, 16#~25# introduc=
ed the
>>>>     management helpers, 26#~27# do clean up.
>>>>
>>>>     Patches haven't been tested yet, we appreciate if any one who =
have
>> these
>>>>     HW willing to provide his Tested-by :-)
>>>>
>>>>     Doug suggested the bitmask mechanism:
>>>> 	https://www.mail-archive.com/linux-
>>>> rdma@vger.kernel.org/msg23765.html
>>>>     which could be the plan for future reforming, we prefer that t=
o be
>> another
>>>>     series which focus on semantic and performance.
>>>>
>>>>     This patch-set is somewhat 'bloated' now and it may be a good =
timing
>> for
>>>>     staging, I'd like to suggest we focus on improving existed hel=
pers and
>> push
>>>>     all the further reforms into next series ;-)
>>>>
>>>> Proposals:
>>>>     Sean:
>>>> 	https://www.mail-archive.com/linux-
>>>> rdma@vger.kernel.org/msg23339.html
>>>>     Doug:
>>>> 	https://www.mail-archive.com/linux-
>>>> rdma@vger.kernel.org/msg23418.html
>>>> 	https://www.mail-archive.com/linux-
>>>> rdma@vger.kernel.org/msg23765.html
>>>>     Jason:
>>>> 	https://www.mail-archive.com/linux-
>>>> rdma@vger.kernel.org/msg23425.html
>>>>
>>>> Michael Wang (27):
>>>>     IB/Verbs: Implement new callback query_transport()
>>>>     IB/Verbs: Implement raw management helpers
>>>>     IB/Verbs: Reform IB-core mad/agent/user_mad
>>>>     IB/Verbs: Reform IB-core cm
>>>>     IB/Verbs: Reform IB-core sa_query
>>>>     IB/Verbs: Reform IB-core multicast
>>>>     IB/Verbs: Reform IB-ulp ipoib
>>>>     IB/Verbs: Reform IB-ulp xprtrdma
>>>>     IB/Verbs: Reform IB-core verbs/uverbs_cmd/sysfs
>>>>     IB/Verbs: Reform cm related part in IB-core cma/ucm
>>>>     IB/Verbs: Reform route related part in IB-core cma
>>>>     IB/Verbs: Reform mcast related part in IB-core cma
>>>>     IB/Verbs: Reserve legacy transport type in 'dev_addr'
>>>>     IB/Verbs: Reform cma_acquire_dev()
>>>>     IB/Verbs: Reform rest part in IB-core cma
>>>>     IB/Verbs: Use management helper cap_ib_mad()
>>>>     IB/Verbs: Use management helper cap_ib_smi()
>>>>     IB/Verbs: Use management helper cap_ib_cm()
>>>>     IB/Verbs: Use management helper cap_iw_cm()
>>>>     IB/Verbs: Use management helper cap_ib_sa()
>>>>     IB/Verbs: Use management helper cap_ib_mcast()
>>>>     IB/Verbs: Use management helper cap_ipoib()
>>>>     IB/Verbs: Use management helper cap_read_multi_sge()
>>>>     IB/Verbs: Use management helper cap_af_ib()
>>>>     IB/Verbs: Use management helper cap_eth_ah()
>>>>     IB/Verbs: Clean up rdma_ib_or_iboe()
>>>>     IB/Verbs: Cleanup rdma_node_get_transport()
>>>>
>>>> ---
>>>>  drivers/infiniband/core/agent.c              |    4
>>>>  drivers/infiniband/core/cm.c                 |   26 +-
>>>>  drivers/infiniband/core/cma.c                |  328 ++++++++++++-=
--------------
>>>>  drivers/infiniband/core/device.c             |    1
>>>>  drivers/infiniband/core/mad.c                |   51 ++--
>>>>  drivers/infiniband/core/multicast.c          |   18 -
>>>>  drivers/infiniband/core/sa_query.c           |   41 +--
>>>>  drivers/infiniband/core/sysfs.c              |    8
>>>>  drivers/infiniband/core/ucm.c                |    5
>>>>  drivers/infiniband/core/ucma.c               |   27 --
>>>>  drivers/infiniband/core/user_mad.c           |   32 +-
>>>>  drivers/infiniband/core/uverbs_cmd.c         |    6
>>>>  drivers/infiniband/core/verbs.c              |   33 --
>>>>  drivers/infiniband/hw/amso1100/c2_provider.c |    7
>>>>  drivers/infiniband/hw/cxgb3/iwch_provider.c  |    7
>>>>  drivers/infiniband/hw/cxgb4/provider.c       |    7
>>>>  drivers/infiniband/hw/ehca/ehca_hca.c        |    6
>>>>  drivers/infiniband/hw/ehca/ehca_iverbs.h     |    3
>>>>  drivers/infiniband/hw/ehca/ehca_main.c       |    1
>>>>  drivers/infiniband/hw/ipath/ipath_verbs.c    |    7
>>>>  drivers/infiniband/hw/mlx4/main.c            |   10
>>>>  drivers/infiniband/hw/mlx5/main.c            |    7
>>>>  drivers/infiniband/hw/mthca/mthca_provider.c |    7
>>>>  drivers/infiniband/hw/nes/nes_verbs.c        |    6
>>>>  drivers/infiniband/hw/ocrdma/ocrdma_main.c   |    1
>>>>  drivers/infiniband/hw/ocrdma/ocrdma_verbs.c  |    6
>>>>  drivers/infiniband/hw/ocrdma/ocrdma_verbs.h  |    3
>>>>  drivers/infiniband/hw/qib/qib_verbs.c        |    7
>>>>  drivers/infiniband/hw/usnic/usnic_ib_main.c  |    1
>>>>  drivers/infiniband/hw/usnic/usnic_ib_verbs.c |    6
>>>>  drivers/infiniband/hw/usnic/usnic_ib_verbs.h |    2
>>>>  drivers/infiniband/ulp/ipoib/ipoib_main.c    |   17 -
>>>>  include/rdma/ib_verbs.h                      |  204 +++++++++++++=
++-
>>>>  net/sunrpc/xprtrdma/svc_rdma_recvfrom.c      |    6
>>>>  net/sunrpc/xprtrdma/svc_rdma_transport.c     |   51 +---
>>>>  35 files changed, 584 insertions(+), 368 deletions(-)
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-rd=
ma"
>>>> in the body of a message to majordomo@vger.kernel.org More majordo=
mo
>>>> info at http://vger.kernel.org/majordomo-info.html

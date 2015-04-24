From: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH v5 00/27] IB/Verbs: IB Management Helpers
Date: Fri, 24 Apr 2015 17:07:26 +0200
Message-ID: <553A5C2E.8090901@profitbricks.com>
References: <5534B8C9.506@profitbricks.com> <DB4PR05MB0863E9CCCD1BEA34F244EE2CB1EF0@DB4PR05MB0863.eurprd05.prod.outlook.com> <55375C10.8070901@profitbricks.com> <DB4PR05MB0863B84F5AF4F8203CFDAC36B1EE0@DB4PR05MB0863.eurprd05.prod.outlook.com> <5538A034.4030904@profitbricks.com> <DB4PR05MB08635737AF7A40F3F82B7628B1EC0@DB4PR05MB0863.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <DB4PR05MB08635737AF7A40F3F82B7628B1EC0-xsq7jzH2t6llkovD9u25SNqRiQSDpxhJvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, "raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org" <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 04/24/2015 04:44 PM, Liran Liss wrote:
>> From: Michael Wang [mailto:yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org]
>=20
>=20
>> [snip]
[snip]
>>
>=20
> We don't want to stop code branches that are not abstractions but rat=
her depend
> on the specific technology!
> There is no generic "iWARP CM" - only one.
> There is no generic "ROCE CM" - only one.
> There is no generic "IB CM" - only one.
>=20
> At the CM high-level (i.e., whether an ib_dev port registers an IB cl=
ient), you could consider
> an rdma_has_cm() call, but this the only place in the code that this =
check will be called!
> Hence, no need for a generic check.

There is plenty of places to check IB or IWARP CM in cma, that is 18# a=
nd 19#.

And the purpose is to make sure core-layer check the right thing rather=
 than the
'tech' or 'transport', even if there is only one use case, as long as i=
t meaningful, a
helper would make sense IMHO, so later when comes other cases we could =
use the
helpers rather than the meaningless tech check.

>=20
> You want to stop abstract code that uses IB core infrastructure.

We want the check on management make more sense :-)

>=20
>>>
>>>> This new transport is only understand by core-layer currently, for
>>>> user-layer we still reserve the old transport for them, next step =
is
>>>> to use bitmask instead of transport, at that time we can erase the
>>>> new transport and make the whole stuff used by user-layer only :-)
[snip]
>> We need to classify and integrate the concept into mgmt helper, that=
 would
>> be very helpful for further reform, reform followed by integration s=
ounds not
>> that bad, correct?
>>
>=20
> The problem is that it is hard to follow the reasoning for the first =
use consumer
> code with the in-complete helper frame-work.

The problem is, with the current implementation in core layer, expandin=
g
to new tech would be painful, the reform would come into core directly,
which make the logical even more confusing.

This patch set aim to collect all those places where a management check
necessary and integrate them together, this is the reform on core-layer
so later we don't have to change core but replace the internal
implementation of helpers, eg the idea of bitmask.

>=20
>>>
>>>>>
>>>>> 2)The name rdma_tech_* is lame.
>>>>> rdma_transport_*(), adhering to the above (*) remark, is much bet=
ter.
>>>>> For example, both IB and ROCE *do* use the same transport.
>>>>
>>>> We have some discussion on that too, use transport means going bac=
k...
>>>>
>>>
>>> No.
>>> The existing notion of transport was correct. It was the node type =
that
>> wasn't.
>>> And in any case the new helpers didn't use it.
>>>
>>> We need the original meaning of transport - see my response to Ira.
>>> I propose replacing rdma_node_get_transport() with the following he=
lpers:
>>> - rdma_get_transport()
>>> - rdma_is_ib_transport()
>>> - rdma_is_iwarp_transport()
>>
>> We can change the name at anytime, tech/transport/protocol/standard,=
 just
>> one patch later can easily change it and start the topic of naming, =
any of
>> these name will unsatisfied someone AFAIK, I'd like to suggest we co=
nsider
>> this as a mark temporarily and focus on the logical issue.
>=20
> Sure.
>=20
> The logical issue is:
>=20
> 1. We need the existing notion of transport, meaning "a bunch of L4+h=
eaders + semantics presented to apps".
> 2. We might need an *additional* notion of "rdma_protocol", which des=
ignates a complete wire-format: L2-L4+ including.
> This could be later a bitmask, a management helper, whatever.
> Currently, I don't see anything in the existing code that would call =
such helpers.

My thought is mostly focus on the core-layer, so the name won't satisfi=
ed
someone focus on hw or user app, but as long as the reform won't break
anything, I prefer to leave the naming to those who more expert on
that particular part, after this first step :-)

Regards,
Michael Wang

>=20
>>
>>> - ...
>>>
>>>>>
>>>>> 3) The name cap_* as it is used above is not accurate.
>>>>> You use it to describe technology characteristics rather than
>>>>> extendable
>>>> capabilities.
>>>>> I would suggest having a single convention for all helpers, such =
as
>>>> rdma_has_*() and rdma_is_*().
>>>>> For example: cap_ib_smi() =3D=3D> rdma_has_smi().
>>>>
>>>> That means going back too...
>>>
>>> See response to Ira (https://lkml.org/lkml/2015/4/21/951).
>>>
>>>
>>>>
>>>>>
>>>>> 4) Remove all capabilities that do not introduce any distinction =
in
>>>>> the
>>>> current code.
>>>>> We can add them as needed later.
>>>>> This means remove patches:
>>>>> - [PATCH v5 22/27] IB/Verbs: Use management helper cap_ipoib() =E2=
=80=93 all
>>>>> IB devices support ipoib
>>>>> - [PATCH v5 24/27] IB/Verbs: Use management helper cap_af_ib() =E2=
=80=93 all
>>>>> IB
>>>> devices support AF_IB.
>>>>>
>>>>> On the other hand:
>>>>> - rdma_has_multicast() makes sense, since iWARP doesn=E2=80=99t s=
upport it.
>>>>> - cap_ib_sa() might make sense to cut code even further in the CM=
A,
>>>>> since
>>>> RoCE has a GSI but no SA.
>>>>
>>>> We have discussion on define these helpers previously, again, name=
 is
>>>> not really a problem, I would rather to see such changes in the
>>>> following series after this one working stably :-)
>>>>
>>>
>>> The names are not critical. This comment is about introducing helpe=
rs
>>> that are do not introduce any new semantic notion in the current pa=
tch-set.
>>>
>>> cap_ipoib(), for example, is brain-dead because only a single
>>> technology (as of now) enables it: Infiniband.
>>
>> This will be dropped in next version :-)
>>
>>>
>>>>>
>>>>> 5) Do no modify phys_state_show() in [PATCH v5 09/27] IB/Verbs:
>>>>> Reform IB-core verbs/uverbs_cmd/sysfs It *is* the link layer!
>>>>
>>>> Actually nothing changed after the modify, the prev purpose it to
>>>> eliminate the link layer helpers.
>>>>
>>>> But now we are not going to remove the helper any more, so let's d=
rop
>>>> this modification in next version :-)
>>>>
>>>
>>> You don't add modifications just to drop them later.
>>> Don't add them in the first place!
>>>
>>> This patch-set will remain forever in the kernel commit log - we wa=
nt
>>> it to be as self-explaining and coherent as possible.
>>>
>>> Remove this.
>>
>> What i mean is this will be removed in v6...
>>
>>>
>>>>>
>>>>> 6) Remove cap_read_multi_sge
>>>>> It is not device/port feature, but a transport capability.
>>>>> Use rdma_is_iwarp_transport() instead, or introduce a new transpo=
rt
>>>>> flag in
>>>> 'enum ib_device_cap_flags'.
>>>>>
>>>>> 7) Remove [PATCH v5 25/27] IB/Verbs: Use management helper
>>>> cap_eth_ah().
>>>>> Address handles that refer to Ethernet links always have Ethernet
>>>> addressing.
>>>>>
>>>>> In the CMA code, using rdma_tech_iboe() is just fine. This is how
>>>>> you define
>>>> cap_eth_ah() anyway.
>>>>> Currently, this patch just adds clutter.
>>>>
>>>> There are also some discussion on these helpers, drop them means
>>>> going back..
>>>>
>>>
>>> Back to where? Management helpers are a new concept. Let's get them
>> right.
>>
>> Back to one point during v1~v5.
>>
>>>
>>>> The tech helper is not enough to explain the management purpose, a=
nd
>>>> this can be the wrapper for bitmask stuff too.
>>>>
>>>
>>> As I said, I am not sure that we will need any bitmasks.
>>> Also see response to Ira (https://lkml.org/lkml/2015/4/21/951).
>>
>> Better discussed in another thread.
>>
>>>
>>>>>
>>>>> 8) Remove patch [PATCH v5 26/27] IB/Verbs: Clean up rdma_ib_or_ib=
oe().
>>>>> We do need a transport qualifier, as exemplified in comment 5)
>>>>> above, and
>>>> for a complete clean model.
>>>>> This is after renaming the function to rdma_is_ib_transport()...
>>>>
>>>> This means going back again... rdma_is_ib_transport() has been use=
d
>>>> previously.
>>>>
>>>> This helper is just to make the review more easier, we won't need =
it
>>>> internally, not to mention after bitmask was introduced :-)
>>>>
>>>
>>> The same...
>>>
>>>>>
>>>>>
>>>>> Putting it all together
>>>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>>>>
>>>>> We are left with the following helpers:
>>>>> - rdma_is_ib_transport()
>>>>> - rdma_is_iwarp_transport()
>>>>> - rdma_is_usnic_transport()
>>>>> - rdma_is_iboe()
>>>>> - rdma_has_mad()
>>>>> - rdma_has_smi()
>>>>> - rdma_has_gsi() - complements smi; can be used by the mad code f=
or
>>>>> clarity
>>>>> - rdma_has_sa()
>>>>> - rdma_has_cm()
>>>>> - rdma_has_mcast()
>>>>
>>>> I think we can put the discussion on name and new helpers in futur=
e,
>>>> currently let's focus on these basic reform and make them working
>>>> stably ;-)
>>>
>>> It's not just the names, it's their semantics.
>>> Any problems with the names proposed above?
>>
>> These were once used in old version, again, name can't satisfied any=
one at
>> this moment and I'd like to discuss this after the logical was right=
, I really
>> don't want folks to focus on this issue since it won't broken anythi=
ng and can
>> be easily changed once we have the agreement.
>>
>> Regards,
>> Michael Wang
>>
>=20
> OK
>=20
>>>
>>>>
>>>> Regards,
>>>> Michael Wang
>>>>
>>>>>
>>>>>
>>>>>> Subject: [PATCH v5 00/27] IB/Verbs: IB Management Helpers
>>>>>>
>>>>>>
>>>>>> Since v4:
>>>>>>   * Thanks for the comments from Hal, Sean, Tom, Or Gerlitz, Jas=
on,
>>>>>>     Roland, Ira and Steve :-) Please remind me if anything misse=
d :-P
>>>>>>   * Fix logical issue inside 3#, 14#
>>>>>>   * Refine 3#, 4#, 5# with label 'free'
>>>>>>   * Rework 10# to stop using port 1 when port already assigned
>>>>>>
>>>>>> There are plenty of lengthy code to check the transport type of =
IB
>>>>>> device, or the link layer type of it's port, but actually we are
>>>>>> just speculating whether a particular management/feature is
>>>>>> supported by the
>>>> device/port.
>>>>>>
>>>>>> Thus instead of inferring, we should have our own mechanism for =
IB
>>>>>> management capability/protocol/feature checking, several proposa=
ls
>>>> below.
>>>>>>
>>>>>> This patch set will reform the method of getting transport type,=
 we
>>>>>> will now using query_transport() instead of inferring from
>>>>>> transport and link layer respectively, also we defined the new
>>>>>> transport type to make the concept more reasonable.
>>>>>>
>>>>>> Mapping List:
>>>>>> 		node-type	link-layer	old-transport	new-transport
>>>>>> nes		RNIC		ETH		IWARP
>> 	IWARP
>>>>>> amso1100	RNIC		ETH		IWARP		IWARP
>>>>>> cxgb3   	RNIC		ETH		IWARP		IWARP
>>>>>> cxgb4   	RNIC		ETH		IWARP		IWARP
>>>>>> usnic   	USNIC_UDP	ETH		USNIC_UDP	USNIC_UDP
>>>>>> ocrdma  	IB_CA		ETH		IB		IBOE
>>>>>> mlx4    	IB_CA		IB/ETH		IB		IB/IBOE
>>>>>> mlx5    	IB_CA		IB		IB		IB
>>>>>> ehca    	IB_CA		IB		IB		IB
>>>>>> ipath   	IB_CA		IB		IB		IB
>>>>>> mthca   	IB_CA		IB		IB		IB
>>>>>> qib     	IB_CA		IB		IB		IB
>>>>>>
>>>>>> For example:
>>>>>> 	if (transport =3D=3D IB) && (link-layer =3D=3D ETH) will now be=
come:
>>>>>> 	if (query_transport() =3D=3D IBOE)
>>>>>>
>>>>>> Thus we will be able to get rid of the respective transport and
>>>>>> link-layer checking, and it will help us to add new
>>>>>> protocol/Technology (like OPA) more easier, also with the
>>>>>> introduced management helpers, IB management logical will be mor=
e
>>>>>> clear and easier
>>>> for extending.
>>>>>>
>>>>>> Highlights:
>>>>>>     The patch set covered a wide range of IB stuff, thus for tho=
se who are
>>>>>>     familiar with the particular part, your suggestion would be
>>>>>> invaluable ;-)
>>>>>>
>>>>>>     Patch 1#~15# included all the logical reform, 16#~25# introd=
uced the
>>>>>>     management helpers, 26#~27# do clean up.
>>>>>>
>>>>>>     Patches haven't been tested yet, we appreciate if any one wh=
o
>>>>>> have
>>>> these
>>>>>>     HW willing to provide his Tested-by :-)
>>>>>>
>>>>>>     Doug suggested the bitmask mechanism:
>>>>>> 	https://www.mail-archive.com/linux-
>>>>>> rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg23765.html
>>>>>>     which could be the plan for future reforming, we prefer that=
 to
>>>>>> be
>>>> another
>>>>>>     series which focus on semantic and performance.
>>>>>>
>>>>>>     This patch-set is somewhat 'bloated' now and it may be a goo=
d
>>>>>> timing
>>>> for
>>>>>>     staging, I'd like to suggest we focus on improving existed
>>>>>> helpers and
>>>> push
>>>>>>     all the further reforms into next series ;-)
>>>>>>
>>>>>> Proposals:
>>>>>>     Sean:
>>>>>> 	https://www.mail-archive.com/linux-
>>>>>> rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg23339.html
>>>>>>     Doug:
>>>>>> 	https://www.mail-archive.com/linux-
>>>>>> rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg23418.html
>>>>>> 	https://www.mail-archive.com/linux-
>>>>>> rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg23765.html
>>>>>>     Jason:
>>>>>> 	https://www.mail-archive.com/linux-
>>>>>> rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg23425.html
>>>>>>
>>>>>> Michael Wang (27):
>>>>>>     IB/Verbs: Implement new callback query_transport()
>>>>>>     IB/Verbs: Implement raw management helpers
>>>>>>     IB/Verbs: Reform IB-core mad/agent/user_mad
>>>>>>     IB/Verbs: Reform IB-core cm
>>>>>>     IB/Verbs: Reform IB-core sa_query
>>>>>>     IB/Verbs: Reform IB-core multicast
>>>>>>     IB/Verbs: Reform IB-ulp ipoib
>>>>>>     IB/Verbs: Reform IB-ulp xprtrdma
>>>>>>     IB/Verbs: Reform IB-core verbs/uverbs_cmd/sysfs
>>>>>>     IB/Verbs: Reform cm related part in IB-core cma/ucm
>>>>>>     IB/Verbs: Reform route related part in IB-core cma
>>>>>>     IB/Verbs: Reform mcast related part in IB-core cma
>>>>>>     IB/Verbs: Reserve legacy transport type in 'dev_addr'
>>>>>>     IB/Verbs: Reform cma_acquire_dev()
>>>>>>     IB/Verbs: Reform rest part in IB-core cma
>>>>>>     IB/Verbs: Use management helper cap_ib_mad()
>>>>>>     IB/Verbs: Use management helper cap_ib_smi()
>>>>>>     IB/Verbs: Use management helper cap_ib_cm()
>>>>>>     IB/Verbs: Use management helper cap_iw_cm()
>>>>>>     IB/Verbs: Use management helper cap_ib_sa()
>>>>>>     IB/Verbs: Use management helper cap_ib_mcast()
>>>>>>     IB/Verbs: Use management helper cap_ipoib()
>>>>>>     IB/Verbs: Use management helper cap_read_multi_sge()
>>>>>>     IB/Verbs: Use management helper cap_af_ib()
>>>>>>     IB/Verbs: Use management helper cap_eth_ah()
>>>>>>     IB/Verbs: Clean up rdma_ib_or_iboe()
>>>>>>     IB/Verbs: Cleanup rdma_node_get_transport()
>>>>>>
>>>>>> ---
>>>>>>  drivers/infiniband/core/agent.c              |    4
>>>>>>  drivers/infiniband/core/cm.c                 |   26 +-
>>>>>>  drivers/infiniband/core/cma.c                |  328 +++++++++++=
+---------------
>>>>>>  drivers/infiniband/core/device.c             |    1
>>>>>>  drivers/infiniband/core/mad.c                |   51 ++--
>>>>>>  drivers/infiniband/core/multicast.c          |   18 -
>>>>>>  drivers/infiniband/core/sa_query.c           |   41 +--
>>>>>>  drivers/infiniband/core/sysfs.c              |    8
>>>>>>  drivers/infiniband/core/ucm.c                |    5
>>>>>>  drivers/infiniband/core/ucma.c               |   27 --
>>>>>>  drivers/infiniband/core/user_mad.c           |   32 +-
>>>>>>  drivers/infiniband/core/uverbs_cmd.c         |    6
>>>>>>  drivers/infiniband/core/verbs.c              |   33 --
>>>>>>  drivers/infiniband/hw/amso1100/c2_provider.c |    7
>>>>>>  drivers/infiniband/hw/cxgb3/iwch_provider.c  |    7
>>>>>>  drivers/infiniband/hw/cxgb4/provider.c       |    7
>>>>>>  drivers/infiniband/hw/ehca/ehca_hca.c        |    6
>>>>>>  drivers/infiniband/hw/ehca/ehca_iverbs.h     |    3
>>>>>>  drivers/infiniband/hw/ehca/ehca_main.c       |    1
>>>>>>  drivers/infiniband/hw/ipath/ipath_verbs.c    |    7
>>>>>>  drivers/infiniband/hw/mlx4/main.c            |   10
>>>>>>  drivers/infiniband/hw/mlx5/main.c            |    7
>>>>>>  drivers/infiniband/hw/mthca/mthca_provider.c |    7
>>>>>>  drivers/infiniband/hw/nes/nes_verbs.c        |    6
>>>>>>  drivers/infiniband/hw/ocrdma/ocrdma_main.c   |    1
>>>>>>  drivers/infiniband/hw/ocrdma/ocrdma_verbs.c  |    6
>>>>>>  drivers/infiniband/hw/ocrdma/ocrdma_verbs.h  |    3
>>>>>>  drivers/infiniband/hw/qib/qib_verbs.c        |    7
>>>>>>  drivers/infiniband/hw/usnic/usnic_ib_main.c  |    1
>>>>>>  drivers/infiniband/hw/usnic/usnic_ib_verbs.c |    6
>>>>>>  drivers/infiniband/hw/usnic/usnic_ib_verbs.h |    2
>>>>>>  drivers/infiniband/ulp/ipoib/ipoib_main.c    |   17 -
>>>>>>  include/rdma/ib_verbs.h                      |  204 +++++++++++=
++++-
>>>>>>  net/sunrpc/xprtrdma/svc_rdma_recvfrom.c      |    6
>>>>>>  net/sunrpc/xprtrdma/svc_rdma_transport.c     |   51 +---
>>>>>>  35 files changed, 584 insertions(+), 368 deletions(-)
>>>>>> --
>>>>>> To unsubscribe from this list: send the line "unsubscribe linux-=
rdma"
>>>>>> in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More
>>>>>> majordomo info at http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

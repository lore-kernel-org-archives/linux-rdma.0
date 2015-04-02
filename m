From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 0/9] mlx4 changes in virtual GID management
Date: Thu, 2 Apr 2015 17:32:53 +0300
Message-ID: <CAJ3xEMgptECgnWXfW7wN8sjqRfUvzF3tCN=Lj8MZtdOG8yg3jQ@mail.gmail.com>
References: <20150330.233602.155832546277570456.davem@davemloft.net>
	<CAL1RGDUmDGCGdTBeTTBiHygO5UgEbRm_Qgxtx-+bxo1vg1v-8g@mail.gmail.com>
	<CAJ3xEMjfbxt2Ouh4bhuf3_LMc7qY807h6FryvdCr0rr_gdiZAw@mail.gmail.com>
	<20150331.114824.651005354305268415.davem@davemloft.net>
	<1828884A29C6694DAF28B7E6B8A82373A8FBB790@ORSMSX109.amr.corp.intel.com>
	<CAJ3xEMgm+6t1OSMZFJ41Hr4=8B1cKP+5svwc38Lg0wfpCZMO=g@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A82373A8FBBCE3@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A8FBBCE3-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Apr 1, 2015 at 12:33 AM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>> I must disagree. You made this claim back when we submitted the IB
>> core patch which adds support for signature, protection etc offloads
>> (commit 1b01d33560e7 "IB/core: Introduce signature verbs API" and the
>> detailed replied you got were explaining that
>
> And I'll continue to make this claim because it is true.
>
>> Very similar arguments would apply to the ODP submission.
>
> Yes - ODP will _have_ to change the core.  USNIC had to change the core, and had changes rejected that made perfect sense conceptually.  This is part of the problem!!!   If you disagree, then submit patches that don't touch the core.

Sean,

ODP (On Demand Paging)

8ada2c1 IB/core: Add support for on demand paging regions
860f10a IB/core: Add flags for on demand paging support

is upstream for few releases already, and it changed the core indeed.
Memory Registration is sort of PITA for RDMA consumers and ODP is a
brilliant concept which down the road should be removing the hassle of
memory registration altogether (think on transparent lkey per process,
but days will tell).

As you pointed out during the USNIC review, it's sort of hack which is
not supported by any standard, unlike the other supported RDMA
technologies which are upstream: IB, RoCE and iWARP. But guess what,
the RDMA maintainer made no comments, and silently picked it up.

Your claim says more or less "don't touch the good old
include/rdma/ib_verbs.h from 2.6.12, just add new low-level drivers"
-- this is very close to claiming that it doesn't make sense to change
anything in the low areas of the core networking stack or in
netdevice.h over the years, just add new Ethernet drivers. This does
not make any sense.

There are more and more new use cases for RDMA and indeed a nice
challenge to frame them generally with modified/new verbs APIs and
changes to the IB core, such as the patches to support name-spaces to
make RDMA usable in containers which you (maintainer of the CM and
RDMA-CM in the IB core) is ignoring for couple of months too
(following Roland?).


>> So examples please!
> Sure - this is from Somnath's latest patch series:
>
> Matan Barak (14):
>   IB/core: Add RoCE GID cache
>   IB/core: Add kref to IB devices
>   IB/core: Add RoCE GID population
>   IB/core: Add default GID for RoCE GID Cache
>   net/bonding: make DRV macros private
>   net: Add info for NETDEV_CHANGEUPPER event
>   IB/core: Add RoCE cache bonding support
>   IB/core: GID attribute should be returned from verbs API and cache API
>   IB/core: Report gid_type and gid_ndev through sysfs
>   IB/core: Support find sgid index using a filter function
>   IB/core: Modify ib_verbs and cma in order to use roce_gid_cache
>   IB/core: Add gid_type to path and rdma_id_private
>   IB/core: Add rdma_network_type to wc
>   IB/cma: Add configfs for rdma_cm
>
> Moni Shoua (13):
>   IB/mlx4: Remove gid table management for RoCE
>   IB/mlx4: Replace spin_lock with rw_semaphore
>   IB/mlx4: Lock with RCU instead of RTNL
>   net/mlx4: Postpone the registration of net_device
>   IB/mlx4: Advertise RoCE support in port capabilities
>   IB/mlx4: Implement ib_device callback - get_netdev
>   IB/mlx4: Implement ib_device callback - modify_gid
>   IB/mlx4: Configure device to work in RoCEv2
>   IB/mlx4: Translate cache gid index to real index
>   IB/core: Initialize UD header structure with IP and UDP headers
>   IB/mlx4: Enable send of RoCE QP1 packets with IP/UDP headers
>   IB/mlx4: Create and use another QP1 for RoCEv2
>   IB/cma: Join and leave multicast groups with IGMP
>
> That's a significant number of patches that modify the core rdma layer.

This series indeed is a bit heavy as it brings three changes

1. move the RoCE GID table management from LL drivers (ocrdma and
mlx4) into the IB core
2. support multiple GID types
3. support RoCE V2

#1 is terribly making sense, b/c RoCE GID addresses are derived
through net events
from IP addresses configured to the  buddy Ethernet net-device and uppers (vlan,
bond and such) so there's no point to have this logic replicated over
and over in LL drivers.

#2 and #3 follow the IBTA spec of RoCE V2

It could be perfect maintainer comment to say: do it one-by-one, but
anybody there?

If you have concrete feedback on step #1 or anything else in the
series, let them know.

> NFSoRDMA had 5 different ways to register memory.

that's bad protocol implementation, so they are fixing it now. Has
nothing to do with the IB core.

> I agree that Roland's response time is ridiculously slow.  But he does tend to merge in new drivers and updates that only touch a single vendor's driver fairly quickly.  It's the thrashing on the core that sees significant delays.

Without ability to add the changed to the core, we can't make progress

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

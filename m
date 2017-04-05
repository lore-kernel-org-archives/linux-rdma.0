From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next V1 0/6] Enhanced mode for IPoIB driver
Date: Wed,  5 Apr 2017 17:09:07 +0300
Message-ID: <20170405140913.2551-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

This patchset mostly comes from Erez with one exception in the first patch.

That patch origins from two different commits, first from Niranjana who added
RDMA netdev interface and second from Erez who added IPoIB support.

During the preparation to submission, I squashed their commits into one
and refactored code to allow submission as a standalone topic without creating
dependecies between different submissions. This caused to change in author line.
I hope that it doesn't really matter and it won't stop you from merging it.

Per-your request, I based this patch set on v4.11-rc3.

Changes from V0:
----------------------
1. ipoib_priv function returns struct ipoib_dev_priv * instead of void
2. Move all the refactoring of netdev_priv to be in single patch
3. Change the name of the Formation commit.
4. Remove unneeded blank lines
5. Set rn->hca on creation.
6. Return -EOPNOTSUPP instead of ENOTSUPP
7. Remove hunk with DMA from ib_device struct.

Thanks,
	Leon

CC: Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
CC: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---

The rest comes from Erez:

    The IPoIB protocol encapsulates IP packets over Infiniband datagrams.
    As a direct RDMA Upper Layer Protocol (ULP), IPoIB cannot support HW
    features that are specific to the IP protocol stack.

    Nevertheless, RDMA interfaces have been extended to support some of the
    prominent IP offload features, such as TCP/UDP checksum and TSO.
    This provided reasonable performance gain for IPoIB but is still
    insufficient to cope with the increasing network bandwidth demand.

    However, New features are exisiting in common network interfaces that
    are very hard to implement in IPoIB interfaces while it uses the RDMA
    layer, examples include TSS and RSS, tunneling offloads, and XDP.
    Rather than continuously porting IP network interface developments into
    the RDMA stack, we propose adding an abstract network data-path
    interfaces to RDMA devices.

    In order to present a consistent interface to users, the IPoIB ULP
    continues to represent the network device to the IP stack.
    The common code also manages the IPoIB control plane, such as resolving
    path queries and registering to multicast groups.
    Data path operations are forwarded to devices that implement the new
    API, or fallback to the standard implementation otherwise.
    Using the forgoing approach, we show how IPoIB closes the performance
    gap compared to state-of-the-art Ethernet network interfaces.

    The implementation idea is to use the api of
    alloc_rdma_netdev/free_rdma_netdev to expose a struct that has data
    members and set of functions that are used for IB network interfaces,
    like attach/detach multicast to qp, and send IB packet.

    The functions are specific for IB operations and are not part of the
    common api the the netdev struct exposes via the ndo functions.
    1. multicast handling - attach/detach
    2. send operation - the ndo start_xmit has only 2 parameters and the IB
    send needs the destination qp and the ah object, there were few options
    to handle it via the netdev ndo, but they don't make more sense than
    using a specific send function (we are rdma_netdev after all)

    The IPoIB code will be adapted to enable the option of accelerating the
    network interface, but the code will work as before if the HW below
    doesn't support the acceleration.
    That means that in the default mode of ipoib I tried to keep it as much
    as it was before, not to force it to adopt the new api, where there is
    no code sharing between the ipoib and the vnic/hfi.
    The default code uses the controll and the data, the accelerator uses
    only the control flows andstructors.
    The changes of the default ipoib can be made on top of that series.

    Each HW vendor can supply the acceleration for the IPoIB or to leave
    IPoIB to work as before.

Thanks,
	Erez

Erez Shitrit (5):
  IB/IPoIB: Separate control and data related initializations
  IB/IPoIB: Separate control from HW operation on ipoib_open/stop ndo
  IB/IPoIB: Rename qpn to be dqpn in ipoib_send and post_send functions
  IB/IPoIB: Use defined function for netdev_priv function
  IB/IPoIB: Support acceleration options callbacks

Leon Romanovsky (1):
  IB/IPoIB: Introduce RDMA netdev interface and IPoIB structs

 drivers/infiniband/ulp/ipoib/ipoib.h           |  39 ++-
 drivers/infiniband/ulp/ipoib/ipoib_cm.c        |  66 ++---
 drivers/infiniband/ulp/ipoib/ipoib_ethtool.c   |   6 +-
 drivers/infiniband/ulp/ipoib/ipoib_fs.c        |   4 +-
 drivers/infiniband/ulp/ipoib/ipoib_ib.c        | 340 +++++++++++++------------
 drivers/infiniband/ulp/ipoib/ipoib_main.c      | 306 ++++++++++++++++------
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |  39 +--
 drivers/infiniband/ulp/ipoib/ipoib_netlink.c   |  12 +-
 drivers/infiniband/ulp/ipoib/ipoib_verbs.c     |  64 ++---
 drivers/infiniband/ulp/ipoib/ipoib_vlan.c      |   9 +-
 include/rdma/ib_verbs.h                        |  41 +++
 11 files changed, 568 insertions(+), 358 deletions(-)

--
2.12.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

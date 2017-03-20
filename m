From: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC v2 for accelerated IPoIB 00/6] Enhanced mode for IPoIB driver
Date: Mon, 20 Mar 2017 21:08:22 +0200
Message-ID: <1490036908-12528-1-git-send-email-erezsh@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

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
    the RDMA stack, we propose adding an abstract network data-path interfaces
    to RDMA devices.

    In order to present a consistent interface to users, the IPoIB ULP
    continues to represent the network device to the IP stack.
    The common code also manages the IPoIB control plane, such as resolving
    path queries and registering to multicast groups.
    Data path operations are forwarded to devices that implement the new
    API, or fallback to the standard implementation otherwise.
    Using the forgoing approach, we show how IPoIB closes the performance
    gap compared to state-of-the-art Ethernet network interfaces.

    The implementation idea is to expose a struct that has data members and set
    of functions that are used for network interfaces, like create, delete, init hw
    resources, send, and attach/detach multicast to qp.
    That set of functions encapsulates in new struct, and this struct can or
    can't be given by the specific HW layer.

    The IPoIB code will be adapted to enable the option of accelerating the
    network interface, but the code will work as before if the HW below
    doesn't support the acceleration.
    Each HW vendor can supply the acceleration for the IPoIB or to leave
    IPoIB to work as before.

   TODO:
        1.change the send api in order to move it to the ndo start_xmit (unless it hurts the performance of the default driver)
        2.Take out the ipoib_ah from the send signature and use ib_ah instead, no need with including ipoib.h
        3.Check if/how to add rdma_netdev layer to the default ipoib
        4. splitting out the bulk rename of ipoib_priv into a single patch
        5. change the name of the header to be ipoib_rn.h
        6. no need to pass qkey, it is in the ah struct.

Changes fron v0:
---------------
1. Use the vnic/hfi API as a base for the new design/impl.
2. Change the low level driver to support the new struct.


Changes fron v1:
---------------
1.Add hca to rdma_netdev
2.Take out qp_num and context from rdma_netdev
3.Move dev_init/dev_cleanup to be part of the ndo's (ndo_init/ndo_uninit)
4.mlid instead of lid in mcast funcs
5.Arrange the code to return ENOTSUPP when needed
6.No dev->ib_dev.free_rdma_netdev while it is empty.
7.No need to pass the size of struct ipoib_rdma_netdev to the low-level driver


Erez Shitrit (6):
  IB/ipoib: Separate control and data related initializations
  IB/ipoib: separate control from HW operation on ipoib_open/stop ndo
  IB/ipoib: Rename qpn to dqpn in ipoib_send and post_send functions
  IB/verb: Add ipoib_options struct and API
  IB/ipoib: Support ipoib acceleration options callbacks
  mlx5_ib: skeleton for mlx5_ib to support ipoib_ops

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

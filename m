From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH RFC 0/3] Support standard SRIOV configuration for IB VFs
Date: Thu, 21 May 2015 19:24:04 +0300
Message-ID: <1432225447-6536-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Standard configuration of SRIOV VFs through the host is done over the
following chain of calls: libvirt --> netlink --> PF netdevice -- where
the PF netdevice exports the ndo_set_vf_ calls.

When this comes to IB/IPoIB we should normalize this into the verbs
framework so we further go: PF IPoIB --> verbs API --> PF HW driver

Virtualization systems assign VMs with 48 bits mac, to allow working 
with non-modified SW layers (open-stack, libvirt, etc), we can safely
extend this mac to unique 64 bits GUID. Hence the IPoIB ndo_set_vf_mac
entry calls the set_vf_guid verb.

One thing to clean for being beyond RFC is to make the get_vf_config 
verb return guid and have IPoIB to make it back a mac.

Here's how it looks when using the ip tool (libvirt runs the same
netlink to set it out) and later reflected when the VF read their port.

# ip link set dev ib0 vf 1 mac aa:bb:cc:dd:ee:ff

# ibstat -d mlx4_2
CA 'mlx4_2'
        CA type: MT4100
        Number of ports: 1
        Firmware version: 2.34.1260
        Hardware version: 0
        Node GUID: 0x00140500f30e84c4
        System image GUID: 0xf452140300117423
        Port 1:
                State: Active
                Physical state: LinkUp
                Rate: 56
                Base lid: 7
                LMC: 0
                SM lid: 1
                Capability mask: 0x02514868
                Port GUID: 0xffeeddfeffccbbaa
                Link layer: InfiniBand

Or Gerlitz (3):
  IB/IPoIB: Support SRIOV standard configuration
  IB/mlx4: Refactor Alias GUID storing
  IB/mlx4: Add support for SRIOV VF management

 drivers/infiniband/hw/mlx4/main.c         |   26 ++++++++++++++
 drivers/infiniband/hw/mlx4/mlx4_ib.h      |    4 ++
 drivers/infiniband/hw/mlx4/sysfs.c        |   54 ++++++++++++++++++----------
 drivers/infiniband/ulp/ipoib/ipoib_main.c |   39 +++++++++++++++++++++
 drivers/net/ethernet/mellanox/mlx4/cmd.c  |   26 +++++++++----
 include/linux/mlx4/device.h               |    2 +
 include/rdma/ib_verbs.h                   |    4 ++
 7 files changed, 128 insertions(+), 27 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Shamir Rabinovitch <shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3] IB/IPoIB: ibX: failed to create mcg debug file
Date: Mon, 27 Mar 2017 23:11:57 +0300
Message-ID: <20170327201156.GA29831@srabinov-linux.uk.oracle.com>
References: <1490599139-12665-1-git-send-email-shamir.rabinovitch@oracle.com>
 <4058624b-a947-9635-76ca-482fd6a6bd95@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="FCuugMFkClbJLl1L"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4058624b-a947-9635-76ca-482fd6a6bd95-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vijay.ac.kumar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 27, 2017 at 06:06:42PM +0300, Mark Bloch wrote:
> Hi Shamir,
> 
> Like I've said in v1 of this patch, I believe we are calling ipoib_delete_debug_files too many times.
> We are calling in unconditionally in: ipoib_dev_cleanup
> and also in ipoib_netdev_event when we get an NETDEV_UNREGISTER event.
> 
> For example, I have a setup with ConnectX-4 dual port configured to be in IB mode.
> So I have two ipoib interfaces (ib0, ib1)
> 
> When I load and unload mlx5_ib (while ib_ipoib is loaded:
> 
> root@dev-r-vrt-175 tools]# ./funccount.py 'ipoib_*_debug_files'
> Tracing 2 functions for "ipoib_*_debug_files"... Hit Ctrl-C to end.
> ^C
> FUNC                                    COUNT
> ipoib_create_debug_files                    2
> ipoib_delete_debug_files                    4
> Detaching...
> 
> Why not just remove the call in ipoib_dev_cleanup?
> 

Hi Mark,

v3 of this patch works fine on system that has CX3 with 2 ports and the
below udev rules:

# InfiniBand: Mellanox Technologies MT27500 Family [ConnectX-3]
SUBSYSTEM=="net", ACTION=="add", DRIVERS=="mlx4_core", BUS=="pci",
ID=="0002:01:00.0", ATTR{dev_id}=="0x0", KERNEL=="ib*", NAME="ib1"
SUBSYSTEM=="net", ACTION=="add", DRIVERS=="mlx4_core", BUS=="pci",
ID=="0002:01:00.0", ATTR{dev_id}=="0x1", KERNEL=="ib*", NAME="ib0"

On this system, the udev rules rename ib0-ib1 & ib1->ib0 causing small
chaos in the ipoib device names.

The attached logs include the information collected when the openibd
service was started and when it was stopped. You can have a look in the
files and see what are the network events and how they are processed by
the ipoib devices.

I think it will answer your concerns. 

BR, Shamir

--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="openibd.start"

mlx4_core: unknown parameter 'module_unload_allowed' ignored
mlx4_core: Mellanox ConnectX core driver v2.2-1 (Feb, 2014)
mlx4_core: Initializing 0002:01:00.0
PCI: Enabling device: (0002:01:00.0), cmd 2
mlx4_core 0002:01:00.0: Old device ETS support detected
mlx4_core 0002:01:00.0: Consider upgrading device FW.
mlx4_core 0002:01:00.0: PCIe link speed is 8.0GT/s, device supports 8.0GT/s
mlx4_core 0002:01:00.0: PCIe link width is x8, device supports x8
mlx4_core: Initializing 0006:01:00.0
PCI: Enabling device: (0006:01:00.0), cmd 2
mlx4_core 0006:01:00.0: Old device ETS support detected
mlx4_core 0006:01:00.0: Consider upgrading device FW.
mlx4_core 0006:01:00.0: PCIe link speed is 8.0GT/s, device supports 8.0GT/s
mlx4_core 0006:01:00.0: PCIe link width is x8, device supports x8
<mlx4_ib> mlx4_ib_add: mlx4_ib: Mellanox ConnectX InfiniBand driver v2.2-1 (Feb 2014)
<mlx4_ib> mlx4_ib_add: counter index 0 for port 1 allocated 0
<mlx4_ib> mlx4_ib_add: counter index 1 for port 2 allocated 0
<mlx4_ib> mlx4_ib_add: counter index 0 for port 1 allocated 0
<mlx4_ib> mlx4_ib_add: counter index 1 for port 2 allocated 0
ib_ipoib: unknown parameter 'module_unload_allowed' ignored
ipoib_netdev_event: dev fff8001f59984000 name ib0 event 0x5
ipoib_netdev_event: dev fff8001f568b4000 name ib1 event 0x5
ipoib_netdev_event: dev fff8001f57b4a000 name ib2 event 0x5
ipoib_netdev_event: dev fff8001f54dda000 name ib3 event 0x5
mlx4_core 0002:01:00.0 rename57: renamed from ib1
ipoib_netdev_event: dev fff8001f568b4000 name rename57 event 0xa
mlx4_core 0002:01:00.0 rename56: renamed from ib0
ipoib_netdev_event: dev fff8001f59984000 name rename56 event 0xa
mlx4_core 0002:01:00.0 ib0: renamed from rename57
ipoib_netdev_event: dev fff8001f568b4000 name ib0 event 0xa
mlx4_core 0002:01:00.0 ib1: renamed from rename56
ipoib_netdev_event: dev fff8001f59984000 name ib1 event 0xa
ipoib_netdev_event: dev fff8001f57b4a000 name ib2 event 0x17
ipoib_netdev_event: dev fff8001f57b4a000 name ib2 event 0x7
ipoib_netdev_event: dev fff8001f54dda000 name ib3 event 0x17
ipoib_netdev_event: dev fff8001f54dda000 name ib3 event 0x7
ipoib_netdev_event: dev fff8001f57b4a000 name ib2 event 0xd
IPv6: ADDRCONF(NETDEV_UP): ib2: link is not ready
ipoib_netdev_event: dev fff8001f57b4a000 name ib2 event 0x1
ipoib_netdev_event: dev fff8001f57b4a000 name ib2 event 0x4
ipoib_netdev_event: dev fff8001f54dda000 name ib3 event 0xd
IPv6: ADDRCONF(NETDEV_UP): ib3: link is not ready
ipoib_netdev_event: dev fff8001f54dda000 name ib3 event 0x1
ipoib_netdev_event: dev fff8001f59984000 name ib1 event 0x17
ipoib_netdev_event: dev fff8001f59984000 name ib1 event 0x7
ipoib_netdev_event: dev fff8001f568b4000 name ib0 event 0x17
ipoib_netdev_event: dev fff8001f568b4000 name ib0 event 0x7
ipoib_netdev_event: dev fff8001f59984000 name ib1 event 0xd
IPv6: ADDRCONF(NETDEV_UP): ib1: link is not ready
ipoib_netdev_event: dev fff8001f59984000 name ib1 event 0x1
ipoib_netdev_event: dev fff8001f568b4000 name ib0 event 0xd
IPv6: ADDRCONF(NETDEV_UP): ib0: link is not ready
ipoib_netdev_event: dev fff8001f568b4000 name ib0 event 0x1
ipoib_netdev_event: dev fff8001f54dda000 name ib3 event 0x4
ipoib_netdev_event: dev fff8001f59984000 name ib1 event 0x4
ipoib_netdev_event: dev fff8001f568b4000 name ib0 event 0x4
ipoib_netdev_event: dev fff8001f568b4000 name ib0 event 0x4
ipoib_netdev_event: dev fff8001f59984000 name ib1 event 0x4
ipoib_netdev_event: dev fff8001f57b4a000 name ib2 event 0x4
ipoib_netdev_event: dev fff8001f54dda000 name ib3 event 0x4
Kernel unaligned access at TPC[107ea098] ipoib_dev_addr_changed_valid+0x58/0x1c0 [ib_ipoib]
Kernel unaligned access at TPC[107ea098] ipoib_dev_addr_changed_valid+0x58/0x1c0 [ib_ipoib]
Kernel unaligned access at TPC[107ea098] ipoib_dev_addr_changed_valid+0x58/0x1c0 [ib_ipoib]
Kernel unaligned access at TPC[107ea098] ipoib_dev_addr_changed_valid+0x58/0x1c0 [ib_ipoib]
IPv6: ADDRCONF(NETDEV_CHANGE): ib3: link becomes ready
ipoib_netdev_event: dev fff8001f54dda000 name ib3 event 0x4
Kernel unaligned access at TPC[107ea098] ipoib_dev_addr_changed_valid+0x58/0x1c0 [ib_ipoib]
IPv6: ADDRCONF(NETDEV_CHANGE): ib1: link becomes ready
ipoib_netdev_event: dev fff8001f59984000 name ib1 event 0x4
IPv6: ADDRCONF(NETDEV_CHANGE): ib0: link becomes ready
ipoib_netdev_event: dev fff8001f568b4000 name ib0 event 0x4
IPv6: ADDRCONF(NETDEV_CHANGE): ib2: link becomes ready
ipoib_netdev_event: dev fff8001f57b4a000 name ib2 event 0x4
ipoib_netdev_event: dev fff8001f54dda000 name ib3 event 0x4

--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="openibd.stop"

ipoib_netdev_event: dev fff8001f59984000 name ib1 event 0x9
ipoib_netdev_event: dev fff8001f59984000 name ib1 event 0x2
ipoib_netdev_event: dev fff8001f568b4000 name ib0 event 0x9
ipoib_netdev_event: dev fff8001f568b4000 name ib0 event 0x2
ipoib_netdev_event: dev fff8001f57b4a000 name ib2 event 0x9
ipoib_netdev_event: dev fff8001f57b4a000 name ib2 event 0x2
ipoib_netdev_event: dev fff8001f54dda000 name ib3 event 0x9
ipoib_netdev_event: dev fff8001f54dda000 name ib3 event 0x2
ipoib_netdev_event: dev fff8001f59984000 name ib1 event 0x6
ipoib_netdev_event: dev fff8001f568b4000 name ib0 event 0x6
ipoib_netdev_event: dev fff8001f57b4a000 name ib2 event 0x6
ipoib_netdev_event: dev fff8001f54dda000 name ib3 event 0x6

--FCuugMFkClbJLl1L--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

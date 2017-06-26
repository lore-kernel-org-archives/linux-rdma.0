From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: NFS/RDMA RoCE with mlx4_en
Date: Mon, 26 Jun 2017 13:24:11 -0400
Message-ID: <5E2BFC42-DDA1-4666-BA45-2E33A47C0ED5@oracle.com>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Running various I/O stress workloads with iozone on an
NFSv3 mount using RDMA on RoCEv1 (FRWR).

Jun 26 12:50:21 morisot kernel: mlx4_core 0000:01:00.0: command 0x49 timed out (go bit not cleared)
Jun 26 12:50:21 morisot kernel: mlx4_core 0000:01:00.0: device is going to be reset
Jun 26 12:50:22 morisot kernel: mlx4_core 0000:01:00.0: device was reset successfully
Jun 26 12:50:22 morisot kernel: mlx4_en 0000:01:00.0: Internal error detected, restarting device
Jun 26 12:50:22 morisot kernel: <mlx4_ib> mlx4_ib_handle_catas_error: mlx4_ib_handle_catas_error was started
Jun 26 12:50:22 morisot kernel: <mlx4_ib> mlx4_ib_handle_catas_error: mlx4_ib_handle_catas_error ended
Jun 26 12:50:22 morisot kernel: ib_srpt received unrecognized IB event 8
Jun 26 12:50:22 morisot kernel: mlx4_core 0000:01:00.0: command 0x1e failed: fw status = 0x1

Jun 26 12:50:32 morisot kernel: cma: cma_alloc: alloc failed, req-size: 17 pages, ret: -12
Jun 26 12:50:32 morisot kernel: cma: cma_alloc: alloc failed, req-size: 1 pages, ret: -12
Jun 26 12:50:32 morisot kernel: mlx4_en: 0000:01:00.0: Port 1: Using 32 TX rings
Jun 26 12:50:32 morisot kernel: mlx4_en: 0000:01:00.0: Port 1: Using 4 RX rings
Jun 26 12:50:32 morisot kernel: mlx4_en: 0000:01:00.0: Port 1: Initializing port
Jun 26 12:50:32 morisot kernel: mlx4_en 0000:01:00.0: registered PHC clock
Jun 26 12:50:32 morisot kernel: <mlx4_ib> mlx4_ib_add: counter index 1 for port 1 allocated 1
Jun 26 12:50:32 morisot NetworkManager[810]: <info>  [1498495832.7797] manager: (eth0): new Ethernet device (/org/freedesktop/NetworkManager/Devices/3)
Jun 26 12:50:32 morisot kernel: mlx4_core 0000:01:00.0 enp1s0: renamed from eth0
Jun 26 12:50:32 morisot kernel: cma: cma_alloc: alloc failed, req-size: 1 pages, ret: -12
Jun 26 12:50:32 morisot kernel: cma: cma_alloc: alloc failed, req-size: 1 pages, ret: -12
Jun 26 12:50:32 morisot kernel: cma: cma_alloc: alloc failed, req-size: 1 pages, ret: -12
Jun 26 12:50:32 morisot kernel: cma: cma_alloc: alloc failed, req-size: 1 pages, ret: -12
Jun 26 12:50:32 morisot kernel: cma: cma_alloc: alloc failed, req-size: 1 pages, ret: -12
Jun 26 12:50:32 morisot kernel: cma: cma_alloc: alloc failed, req-size: 1 pages, ret: -12
Jun 26 12:50:32 morisot kernel: cma: cma_alloc: alloc failed, req-size: 1 pages, ret: -12
Jun 26 12:50:32 morisot kernel: cma: cma_alloc: alloc failed, req-size: 1 pages, ret: -12
Jun 26 12:50:32 morisot kernel: cma: cma_alloc: alloc failed, req-size: 1 pages, ret: -12
Jun 26 12:50:32 morisot kernel: cma: cma_alloc: alloc failed, req-size: 1 pages, ret: -12
Jun 26 12:50:32 morisot kernel: cma: cma_alloc: alloc failed, req-size: 1 pages, ret: -12
Jun 26 12:50:32 morisot kernel: cma: cma_alloc: alloc failed, req-size: 1 pages, ret: -12
Jun 26 12:50:32 morisot kernel: cma: cma_alloc: alloc failed, req-size: 1 pages, ret: -12
Jun 26 12:50:32 morisot kernel: cma: cma_alloc: alloc failed, req-size: 1 pages, ret: -12
Jun 26 12:50:32 morisot kernel: cma: cma_alloc: alloc failed, req-size: 1 pages, ret: -12
Jun 26 12:50:32 morisot kernel: cma: cma_alloc: alloc failed, req-size: 1 pages, ret: -12
Jun 26 12:50:32 morisot NetworkManager[810]: <info>  [1498495832.7962] device (eth0): interface index 4 renamed iface from 'eth0' to 'enp1s0'
Jun 26 12:50:32 morisot NetworkManager[810]: <info>  [1498495832.7971] device (enp1s0): state change: unmanaged -> unavailable (reason 'managed') [10 20 2]
Jun 26 12:50:32 morisot kernel: cma: cma_alloc: alloc failed, req-size: 20 pages, ret: -12
Jun 26 12:50:32 morisot kernel: cma: cma_alloc: alloc failed, req-size: 24 pages, ret: -12
Jun 26 12:50:32 morisot kernel: IPv6: ADDRCONF(NETDEV_UP): enp1s0: link is not ready
Jun 26 12:50:32 morisot kernel: cma: cma_alloc: alloc failed, req-size: 1 pages, ret: -12
Jun 26 12:50:32 morisot kernel: cma: cma_alloc: alloc failed, req-size: 1 pages, ret: -12
Jun 26 12:50:32 morisot kernel: cma: cma_alloc: alloc failed, req-size: 1 pages, ret: -12

Within a few more moments, the system became unreachable and
had to be restarted via remote power-on reset.

The cma_alloc failures start at system boot time and continue
whenever the mlx4_en device is used. Those don't seem like
unreasonably sized requests.

I tried reproducing this immediately. Similar result:

Jun 26 13:16:47 morisot kernel: nfs: server klimt-roce not responding, still trying
Jun 26 13:16:47 morisot kernel: nfs: server klimt-roce not responding, still trying
Jun 26 13:16:47 morisot kernel: nfs: server klimt-roce not responding, still trying
Jun 26 13:16:47 morisot kernel: nfs: server klimt-roce not responding, still trying
Jun 26 13:16:51 morisot kernel: mlx4_core 0000:01:00.0: command 0x49 timed out (go bit not cleared)
Jun 26 13:16:51 morisot kernel: mlx4_core 0000:01:00.0: device is going to be reset
Jun 26 13:16:52 morisot kernel: mlx4_core 0000:01:00.0: device was reset successfully
Jun 26 13:16:52 morisot kernel: mlx4_en 0000:01:00.0: Internal error detected, restarting device
Jun 26 13:16:52 morisot kernel: <mlx4_ib> mlx4_ib_handle_catas_error: mlx4_ib_handle_catas_error was started
Jun 26 13:16:52 morisot kernel: <mlx4_ib> mlx4_ib_handle_catas_error: mlx4_ib_handle_catas_error ended
Jun 26 13:16:52 morisot kernel: ib_srpt received unrecognized IB event 8
Jun 26 13:16:52 morisot kernel: mlx4_core 0000:01:00.0: command 0x1e failed: fw status = 0x1
Jun 26 13:16:52 morisot kernel: cma: cma_alloc: alloc failed, req-size: 129 pages, ret: -12
Jun 26 13:16:55 morisot kernel: mlx4_core 0000:01:00.0: Internal error mark was detected on device

Jun 26 13:16:55 morisot nm-dispatcher: req:1 'down' [enp1s0]: new request (4 scripts)
Jun 26 13:16:55 morisot nm-dispatcher: req:1 'down' [enp1s0]: start running ordered scripts...
Jun 26 13:16:55 morisot kernel: mlx4_en 0000:01:00.0: removed PHC
Jun 26 13:16:55 morisot kernel: rpcrdma: removing device mlx4_0 for 192.168.3.5:20049
Jun 26 13:16:55 morisot kernel: mlx4_core 0000:01:00.0: Fail to set mac in port 1 during unregister
Jun 26 13:16:58 morisot kernel: alloc_contig_range: [41e417, 41e418) PFNs busy
Jun 26 13:16:58 morisot kernel: alloc_contig_range: [41e418, 41e419) PFNs busy
Jun 26 13:17:00 morisot kernel: rpcrdma_ep_recreate_xprt: r_xprt = ffff8804090f8000
Jun 26 13:17:01 morisot kernel: alloc_contig_range: [41e417, 41e418) PFNs busy
Jun 26 13:17:01 morisot kernel: alloc_contig_range: [41e418, 41e419) PFNs busy
Jun 26 13:17:01 morisot kernel: alloc_contig_range: [41e4c0, 41e500) PFNs busy
Jun 26 13:17:01 morisot kernel: mlx4_core 0000:01:00.0: PCIe link speed is 8.0GT/s, device supports 8.0GT/s
Jun 26 13:17:01 morisot kernel: mlx4_core 0000:01:00.0: PCIe link width is x8, device supports x8
Jun 26 13:17:01 morisot kernel: alloc_contig_range: [41e417, 41e418) PFNs busy
Jun 26 13:17:01 morisot kernel: alloc_contig_range: [41e418, 41e419) PFNs busy
Jun 26 13:17:01 morisot kernel: alloc_contig_range: [41e417, 41e418) PFNs busy
Jun 26 13:17:01 morisot kernel: alloc_contig_range: [41e418, 41e419) PFNs busy

Jun 26 13:17:02 morisot kernel: cma: cma_alloc: alloc failed, req-size: 1 pages, ret: -12
Jun 26 13:17:02 morisot kernel: cma: cma_alloc: alloc failed, req-size: 1 pages, ret: -12
Jun 26 13:17:02 morisot kernel: cma: cma_alloc: alloc failed, req-size: 1 pages, ret: -12
Jun 26 13:17:02 morisot kernel: cma: cma_alloc: alloc failed, req-size: 1 pages, ret: -12
Jun 26 13:17:02 morisot kernel: mlx4_en 0000:01:00.0: Activating port:1
Jun 26 13:17:02 morisot kernel: cma: cma_alloc: alloc failed, req-size: 1 pages, ret: -12
Jun 26 13:17:02 morisot kernel: cma: cma_alloc: alloc failed, req-size: 8 pages, ret: -12
Jun 26 13:17:02 morisot kernel: cma: cma_alloc: alloc failed, req-size: 8 pages, ret: -12
Jun 26 13:17:02 morisot kernel: cma: cma_alloc: alloc failed, req-size: 8 pages, ret: -12
Jun 26 13:17:02 morisot kernel: cma: cma_alloc: alloc failed, req-size: 8 pages, ret: -12


--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

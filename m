From: jackm <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: NFS/RDMA RoCE with mlx4_en
Date: Tue, 27 Jun 2017 13:33:06 +0300
Message-ID: <20170627133306.00003fda@dev.mellanox.co.il>
References: <5E2BFC42-DDA1-4666-BA45-2E33A47C0ED5@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5E2BFC42-DDA1-4666-BA45-2E33A47C0ED5-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 26 Jun 2017 13:24:11 -0400
Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:

> Running various I/O stress workloads with iozone on an
> NFSv3 mount using RDMA on RoCEv1 (FRWR).
> 
Hi Chuck, I have some questions to help us understand what is happening:

1. What kernel are you running here?
2. What is the underlying Linux distribution?
3. What FW is installed on the ConnectX-3 HCA?
4. Is SRIOV enabled? (i.e., is there a line in a modprobe conf file:
    options mlx4_core num_vfs=<integer greater than zero>
5. Could you dump the card's .ini file and sent it to us?
   (flint dc -d <pci bus-dev-fn> dc connectx3.ini)
6. Is this a dual-port HCA, Are both ports connected?

7. Could you try disabling the mlx4 driver automatic driver start at
boot time?

8. After disabling automatic start at boot time, could you reboot the
host to see if it has problems without the mlx4 driver stack?

9. The mlx4 device was reset because a timeout was detected for the
   DUMP_ETH_STATS command (0x49). The timeout for this command is 60
   seconds.  Did the message log show anything at around 1 minute before
   the timeout occurred?

10. Do you know which app is calling cma_alloc?  If you are willing to
modify your kernel code temporarily for this, you might put a
stack_dump() in file mm/cma.c at line 454 (where the cma_alloc failure
line is output).

Thanks, Chuck -- any help you can give us here will be greatly
appreciated.

-Jack

P.S., some more comments:
Jun 26 12:50:22 morisot kernel: ib_srpt received unrecognized IB event 8
- The above IB event is IB_EVENT_DEVICE_FATAL
  -ib_srpt might consider handling this event somehow.


> Jun 26 12:50:21 morisot kernel: mlx4_core 0000:01:00.0: command 0x49
> timed out (go bit not cleared) Jun 26 12:50:21 morisot kernel:
> mlx4_core 0000:01:00.0: device is going to be reset Jun 26 12:50:22
> morisot kernel: mlx4_core 0000:01:00.0: device was reset successfully
> Jun 26 12:50:22 morisot kernel: mlx4_en 0000:01:00.0: Internal error
> detected, restarting device Jun 26 12:50:22 morisot kernel: <mlx4_ib>
> mlx4_ib_handle_catas_error: mlx4_ib_handle_catas_error was started
> Jun 26 12:50:22 morisot kernel: <mlx4_ib> mlx4_ib_handle_catas_error:
> mlx4_ib_handle_catas_error ended Jun 26 12:50:22 morisot kernel:
> ib_srpt received unrecognized IB event 8 Jun 26 12:50:22 morisot
> kernel: mlx4_core 0000:01:00.0: command 0x1e failed: fw status = 0x1
> 
> Jun 26 12:50:32 morisot kernel: cma: cma_alloc: alloc failed,
> req-size: 17 pages, ret: -12 Jun 26 12:50:32 morisot kernel: cma:
> cma_alloc: alloc failed, req-size: 1 pages, ret: -12 Jun 26 12:50:32
> morisot kernel: mlx4_en: 0000:01:00.0: Port 1: Using 32 TX rings Jun
> 26 12:50:32 morisot kernel: mlx4_en: 0000:01:00.0: Port 1: Using 4 RX
> rings Jun 26 12:50:32 morisot kernel: mlx4_en: 0000:01:00.0: Port 1:
> Initializing port Jun 26 12:50:32 morisot kernel: mlx4_en
> 0000:01:00.0: registered PHC clock Jun 26 12:50:32 morisot kernel:
> <mlx4_ib> mlx4_ib_add: counter index 1 for port 1 allocated 1 Jun 26
> 12:50:32 morisot NetworkManager[810]: <info>  [1498495832.7797]
> manager: (eth0): new Ethernet device
> (/org/freedesktop/NetworkManager/Devices/3) Jun 26 12:50:32 morisot
> kernel: mlx4_core 0000:01:00.0 enp1s0: renamed from eth0 Jun 26
> 12:50:32 morisot kernel: cma: cma_alloc: alloc failed, req-size: 1
> pages, ret: -12 Jun 26 12:50:32 morisot kernel: cma: cma_alloc: alloc
> failed, req-size: 1 pages, ret: -12 Jun 26 12:50:32 morisot kernel:
> cma: cma_alloc: alloc failed, req-size: 1 pages, ret: -12 Jun 26
> 12:50:32 morisot kernel: cma: cma_alloc: alloc failed, req-size: 1
> pages, ret: -12 Jun 26 12:50:32 morisot kernel: cma: cma_alloc: alloc
> failed, req-size: 1 pages, ret: -12 Jun 26 12:50:32 morisot kernel:
> cma: cma_alloc: alloc failed, req-size: 1 pages, ret: -12 Jun 26
> 12:50:32 morisot kernel: cma: cma_alloc: alloc failed, req-size: 1
> pages, ret: -12 Jun 26 12:50:32 morisot kernel: cma: cma_alloc: alloc
> failed, req-size: 1 pages, ret: -12 Jun 26 12:50:32 morisot kernel:
> cma: cma_alloc: alloc failed, req-size: 1 pages, ret: -12 Jun 26
> 12:50:32 morisot kernel: cma: cma_alloc: alloc failed, req-size: 1
> pages, ret: -12 Jun 26 12:50:32 morisot kernel: cma: cma_alloc: alloc
> failed, req-size: 1 pages, ret: -12 Jun 26 12:50:32 morisot kernel:
> cma: cma_alloc: alloc failed, req-size: 1 pages, ret: -12 Jun 26
> 12:50:32 morisot kernel: cma: cma_alloc: alloc failed, req-size: 1
> pages, ret: -12 Jun 26 12:50:32 morisot kernel: cma: cma_alloc: alloc
> failed, req-size: 1 pages, ret: -12 Jun 26 12:50:32 morisot kernel:
> cma: cma_alloc: alloc failed, req-size: 1 pages, ret: -12 Jun 26
> 12:50:32 morisot kernel: cma: cma_alloc: alloc failed, req-size: 1
> pages, ret: -12 Jun 26 12:50:32 morisot NetworkManager[810]: <info>
> [1498495832.7962] device (eth0): interface index 4 renamed iface from
> 'eth0' to 'enp1s0' Jun 26 12:50:32 morisot NetworkManager[810]:
> <info>  [1498495832.7971] device (enp1s0): state change: unmanaged ->
> unavailable (reason 'managed') [10 20 2] Jun 26 12:50:32 morisot
> kernel: cma: cma_alloc: alloc failed, req-size: 20 pages, ret: -12
> Jun 26 12:50:32 morisot kernel: cma: cma_alloc: alloc failed,
> req-size: 24 pages, ret: -12 Jun 26 12:50:32 morisot kernel: IPv6:
> ADDRCONF(NETDEV_UP): enp1s0: link is not ready Jun 26 12:50:32
> morisot kernel: cma: cma_alloc: alloc failed, req-size: 1 pages, ret:
> -12 Jun 26 12:50:32 morisot kernel: cma: cma_alloc: alloc failed,
> req-size: 1 pages, ret: -12 Jun 26 12:50:32 morisot kernel: cma:
> cma_alloc: alloc failed, req-size: 1 pages, ret: -12
> 
> Within a few more moments, the system became unreachable and
> had to be restarted via remote power-on reset.
> 
> The cma_alloc failures start at system boot time and continue
> whenever the mlx4_en device is used. Those don't seem like
> unreasonably sized requests.
> 
> I tried reproducing this immediately. Similar result:
> 
> Jun 26 13:16:47 morisot kernel: nfs: server klimt-roce not
> responding, still trying Jun 26 13:16:47 morisot kernel: nfs: server
> klimt-roce not responding, still trying Jun 26 13:16:47 morisot
> kernel: nfs: server klimt-roce not responding, still trying Jun 26
> 13:16:47 morisot kernel: nfs: server klimt-roce not responding, still
> trying Jun 26 13:16:51 morisot kernel: mlx4_core 0000:01:00.0:
> command 0x49 timed out (go bit not cleared) Jun 26 13:16:51 morisot
> kernel: mlx4_core 0000:01:00.0: device is going to be reset Jun 26
> 13:16:52 morisot kernel: mlx4_core 0000:01:00.0: device was reset
> successfully Jun 26 13:16:52 morisot kernel: mlx4_en 0000:01:00.0:
> Internal error detected, restarting device Jun 26 13:16:52 morisot
> kernel: <mlx4_ib> mlx4_ib_handle_catas_error:
> mlx4_ib_handle_catas_error was started Jun 26 13:16:52 morisot
> kernel: <mlx4_ib> mlx4_ib_handle_catas_error:
> mlx4_ib_handle_catas_error ended Jun 26 13:16:52 morisot kernel:
> ib_srpt received unrecognized IB event 8 Jun 26 13:16:52 morisot
> kernel: mlx4_core 0000:01:00.0: command 0x1e failed: fw status = 0x1
> Jun 26 13:16:52 morisot kernel: cma: cma_alloc: alloc failed,
> req-size: 129 pages, ret: -12 Jun 26 13:16:55 morisot kernel:
> mlx4_core 0000:01:00.0: Internal error mark was detected on device
> 
> Jun 26 13:16:55 morisot nm-dispatcher: req:1 'down' [enp1s0]: new
> request (4 scripts) Jun 26 13:16:55 morisot nm-dispatcher: req:1
> 'down' [enp1s0]: start running ordered scripts... Jun 26 13:16:55
> morisot kernel: mlx4_en 0000:01:00.0: removed PHC Jun 26 13:16:55
> morisot kernel: rpcrdma: removing device mlx4_0 for 192.168.3.5:20049
> Jun 26 13:16:55 morisot kernel: mlx4_core 0000:01:00.0: Fail to set
> mac in port 1 during unregister Jun 26 13:16:58 morisot kernel:
> alloc_contig_range: [41e417, 41e418) PFNs busy Jun 26 13:16:58
> morisot kernel: alloc_contig_range: [41e418, 41e419) PFNs busy Jun 26
> 13:17:00 morisot kernel: rpcrdma_ep_recreate_xprt: r_xprt =
> ffff8804090f8000 Jun 26 13:17:01 morisot kernel: alloc_contig_range:
> [41e417, 41e418) PFNs busy Jun 26 13:17:01 morisot kernel:
> alloc_contig_range: [41e418, 41e419) PFNs busy Jun 26 13:17:01
> morisot kernel: alloc_contig_range: [41e4c0, 41e500) PFNs busy Jun 26
> 13:17:01 morisot kernel: mlx4_core 0000:01:00.0: PCIe link speed is
> 8.0GT/s, device supports 8.0GT/s Jun 26 13:17:01 morisot kernel:
> mlx4_core 0000:01:00.0: PCIe link width is x8, device supports x8 Jun
> 26 13:17:01 morisot kernel: alloc_contig_range: [41e417, 41e418) PFNs
> busy Jun 26 13:17:01 morisot kernel: alloc_contig_range: [41e418,
> 41e419) PFNs busy Jun 26 13:17:01 morisot kernel: alloc_contig_range:
> [41e417, 41e418) PFNs busy Jun 26 13:17:01 morisot kernel:
> alloc_contig_range: [41e418, 41e419) PFNs busy
> 
> Jun 26 13:17:02 morisot kernel: cma: cma_alloc: alloc failed,
> req-size: 1 pages, ret: -12 Jun 26 13:17:02 morisot kernel: cma:
> cma_alloc: alloc failed, req-size: 1 pages, ret: -12 Jun 26 13:17:02
> morisot kernel: cma: cma_alloc: alloc failed, req-size: 1 pages, ret:
> -12 Jun 26 13:17:02 morisot kernel: cma: cma_alloc: alloc failed,
> req-size: 1 pages, ret: -12 Jun 26 13:17:02 morisot kernel: mlx4_en
> 0000:01:00.0: Activating port:1 Jun 26 13:17:02 morisot kernel: cma:
> cma_alloc: alloc failed, req-size: 1 pages, ret: -12 Jun 26 13:17:02
> morisot kernel: cma: cma_alloc: alloc failed, req-size: 8 pages, ret:
> -12 Jun 26 13:17:02 morisot kernel: cma: cma_alloc: alloc failed,
> req-size: 8 pages, ret: -12 Jun 26 13:17:02 morisot kernel: cma:
> cma_alloc: alloc failed, req-size: 8 pages, ret: -12 Jun 26 13:17:02
> morisot kernel: cma: cma_alloc: alloc failed, req-size: 8 pages, ret:
> -12
> 
> 
> --
> Chuck Lever
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"
> in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

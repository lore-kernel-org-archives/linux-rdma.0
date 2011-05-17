From: Greg I Kerr <kerr.g-movQPkccWJngpn9g0Uvcdg@public.gmane.org>
Subject: rdma_bw fails
Date: Tue, 17 May 2011 12:47:16 -0400
Message-ID: <BANLkTik_42DBsd5SdyDcMvpTaw9+dXTr_w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

After finally fully comprehending libibverbs, I am now trying to
expand my understand to librdma_cm but it would seem I am having some
problems getting connected.

If I run rdma_bw on two nodes with the -c option (use rdma_cm) it
fails with the error: "4390:pp_client_connect: unexpected CM event 1."
event 1 is RDMA_CM_EVENT_ADDR_ERROR. I was under the impression that
it should work if ib0 is configured.

Thanks in advance for any help,

Greg Kerr

[kerrg@compute-0-3 rdma]$ rdma_bw -c
4292: | port=18515 | ib_port=1 | size=65536 | tx_depth=100 | sl=0 |
iters=1000 | duplex=0 | cma=1 |

[kerrg@compute-0-2 rdma]$ rdma_bw -c 10.1.1.30
4390: | port=18515 | ib_port=1 | size=65536 | tx_depth=100 | sl=0 |
iters=1000 | duplex=0 | cma=1 |
4390:pp_client_connect: unexpected CM event 1

Here is the output of /sbin/ifconfig:

[kerrg@compute-0-3 rdma]$ /sbin/ifconfig
eth0      Link encap:Ethernet  HWaddr 00:30:48:BE:D9:84
          inet addr:10.1.255.251  Bcast:10.1.255.255  Mask:255.255.0.0
          inet6 addr: fe80::230:48ff:febe:d984/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:55999 errors:0 dropped:0 overruns:0 frame:0
          TX packets:12608 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:6023763 (5.7 MiB)  TX bytes:2459277 (2.3 MiB)
          Memory:febe0000-fec00000

ib0       Link encap:InfiniBand  HWaddr
80:00:00:48:FE:80:00:00:00:00:00:00:00:00:00:00:00:00:00:00
          inet addr:10.1.1.30  Bcast:10.255.255.255  Mask:255.0.0.0
          inet6 addr: fe80::230:48be:d984:1/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:65520  Metric:1
          RX packets:8 errors:0 dropped:0 overruns:0 frame:0
          TX packets:42 errors:0 dropped:5 overruns:0 carrier:0
          collisions:0 txqueuelen:256
          RX bytes:560 (560.0 b)  TX bytes:3696 (3.6 KiB)

lo        Link encap:Local Loopback
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:16436  Metric:1
          RX packets:1253 errors:0 dropped:0 overruns:0 frame:0
          TX packets:1253 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0
          RX bytes:2093229 (1.9 MiB)  TX bytes:2093229 (1.9 MiB)

[kerrg@compute-0-2 rdma]$ /sbin/ifconfig
eth0      Link encap:Ethernet  HWaddr 00:30:48:BE:DA:D4
          inet addr:10.1.255.252  Bcast:10.1.255.255  Mask:255.255.0.0
          inet6 addr: fe80::230:48ff:febe:dad4/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:66833 errors:0 dropped:0 overruns:0 frame:0
          TX packets:17905 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:6323062 (6.0 MiB)  TX bytes:2166485 (2.0 MiB)
          Memory:febe0000-fec00000

ib0       Link encap:InfiniBand  HWaddr
80:00:00:48:FE:80:00:00:00:00:00:00:00:00:00:00:00:00:00:00
          inet addr:10.1.1.31  Bcast:10.255.255.255  Mask:255.0.0.0
          inet6 addr: fe80::230:48be:dad4:1/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:65520  Metric:1
          RX packets:52 errors:0 dropped:0 overruns:0 frame:0
          TX packets:4 errors:0 dropped:5 overruns:0 carrier:0
          collisions:0 txqueuelen:256
          RX bytes:4088 (3.9 KiB)  TX bytes:352 (352.0 b)

lo        Link encap:Local Loopback
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:16436  Metric:1
          RX packets:1230 errors:0 dropped:0 overruns:0 frame:0
          TX packets:1230 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0
          RX bytes:2055348 (1.9 MiB)  TX bytes:2055348 (1.9 MiB)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

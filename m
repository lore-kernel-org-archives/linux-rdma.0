From: Hari Subramoni <subramon-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org>
Subject: Re: Issue with RDMA_CM on systems with multiple IB HCA's.
Date: Thu, 29 Jul 2010 20:20:47 -0400 (EDT)
Message-ID: <Pine.GSO.4.40.1007292016001.4226-100000@kappa.cse.ohio-state.edu>
References: <Pine.GSO.4.40.1007261442050.20664-100000@omicron.cse.ohio-state.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.GSO.4.40.1007261442050.20664-100000-3mrvs1K0uXjA85jc68Yv76kAi/sjxfazN7jzCyCsa88@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, 26 Jul 2010, Hari Subramoni wrote:
> Hi,
>
> Yes, both cards are on the same IB subnet.
>
> The machines are down for maintanence now. We will send out the
> information you requested as soon as they are up.
>
> Thanks a lot,
> Hari.
>
> On Fri, 23 Jul 2010, Or Gerlitz wrote:
>
> > Hari Subramoni <subramon-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org> wrote:
> >
> > > The nodes have LID's assigned to them and OpenSM is running fine.
> > > I've attached the configurations of the two hosts along with this e-mail.
> > >  As Jonathan mentioned, we are able to ping between them.
> >
> > are the two HCAs on each of the nodes connected to the same IB subnet?
> >
> > > The issue is intermittent. It happens at times and at other times, things
> > > work fine. Please let us know if you need any more information.
> >
> > lets focus on rping, please use both -v -d  flags with rping, also
> > when  rping fails, please send the neighbours info (#ip neigh show)
> > from host .5
> >
> > Or.
> >
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Hi Or,

Sorry for the delay. I as able to reproduce the error after a few
attempts. The details are given below. The systems have OFED-1.5.1. OpenSM
is running and the interfaces are up and active.

Host 1
======
[subramon@amd5 exp2-amd5-install]$ rping -vVd -s -C 1 -a 172.16.2.5
server
count 1
created cm_id 0x5ed7550
rdma_bind_addr successful
rdma_listen

[subramon@amd5 exp2-amd5-install]$ ping 172.16.2.6
PING 172.16.2.6 (172.16.2.6) 56(84) bytes of data.
64 bytes from 172.16.2.6: icmp_seq=1 ttl=64 time=0.169 ms
64 bytes from 172.16.2.6: icmp_seq=2 ttl=64 time=0.104 ms

--- 172.16.2.6 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1000ms
rtt min/avg/max/mdev = 0.104/0.136/0.169/0.034 ms

[subramon@amd5 exp2-amd5-install]$ ip neigh show
172.16.2.6 dev ib2 lladdr
80:00:00:48:fe:80:00:00:00:00:00:00:00:02:c9:03:00:01:e4:4f REACHABLE
164.107.119.153 dev eth0 lladdr 00:15:17:0f:a8:28 REACHABLE
164.107.119.237 dev eth0 lladdr 00:30:48:d0:19:ca STALE
164.107.119.1 dev eth0 lladdr 00:21:59:85:b0:06 REACHABLE
[subramon@amd5 exp2-amd5-install]$

[subramon@amd5 exp2-amd5-install]$ ifconfig ib0
ib0       Link encap:InfiniBand  HWaddr
80:00:00:48:FE:80:00:00:00:00:00:00:00:00:00:00:00:00:00:00
          inet addr:172.16.1.5  Bcast:172.16.1.255  Mask:255.255.255.0
          inet6 addr: fe80::202:c903:1:e387/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:65520  Metric:1
          RX packets:75 errors:0 dropped:0 overruns:0 frame:0
          TX packets:25 errors:0 dropped:9 overruns:0 carrier:0
          collisions:0 txqueuelen:256
          RX bytes:29059 (28.3 KiB)  TX bytes:9176 (8.9 KiB)

[subramon@amd5 exp2-amd5-install]$ ifconfig ib2
ib2       Link encap:InfiniBand  HWaddr
80:00:00:48:FE:80:00:00:00:00:00:00:00:00:00:00:00:00:00:00
          inet addr:172.16.2.5  Bcast:172.16.2.255  Mask:255.255.255.0
          inet6 addr: fe80::202:c903:1:e453/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:65520  Metric:1
          RX packets:36 errors:0 dropped:0 overruns:0 frame:0
          TX packets:23 errors:0 dropped:10 overruns:0 carrier:0
          collisions:0 txqueuelen:256
          RX bytes:11455 (11.1 KiB)  TX bytes:8001 (7.8 KiB)

[subramon@amd5 exp2-amd5-install]$ netstat -rn
Kernel IP routing table
Destination     Gateway         Genmask         Flags   MSS Window  irtt Iface
172.16.4.0      0.0.0.0         255.255.255.0   U         0 0          0 ib1
172.16.2.0      0.0.0.0         255.255.255.0   U         0 0          0 ib2
164.107.119.0   0.0.0.0         255.255.255.0   U         0 0          0 eth0
172.16.1.0      0.0.0.0         255.255.255.0   U         0 0          0 ib0
192.168.122.0   0.0.0.0         255.255.255.0   U         0 0          0 virbr0
169.254.0.0     0.0.0.0         255.255.0.0     U         0 0          0 eth0
0.0.0.0         164.107.119.1   0.0.0.0         UG        0 0          0 eth0

Host 2
======
[subramon@amd6 ~]$ rping -vVdc -a 172.16.2.5 -C 1
client
count 1
created cm_id 0xe017550
cma_event type RDMA_CM_EVENT_ADDR_RESOLVED cma_id 0xe017550 (parent)
cma_event type RDMA_CM_EVENT_ROUTE_RESOLVED cma_id 0xe017550 (parent)
rdma_resolve_addr - rdma_resolve_route successful
created pd 0xe017a10
created channel 0xe017a30
created cq 0xe017a50
created qp 0xe017b90
rping_setup_buffers called on cb 0xe011010
allocated & registered buffers...
cq_thread started.
cq completion failed status 5
cma_event type RDMA_CM_EVENT_REJECTED cma_id 0xe017550 (parent)
wait for CONNECTED state 10
connect error -1
rping_free_buffers called on cb 0xe011010
cma event RDMA_CM_EVENT_REJECTED, error 8


[subramon@amd6 ~]$ ping 172.16.2.5
PING 172.16.2.5 (172.16.2.5) 56(84) bytes of data.
64 bytes from 172.16.2.5: icmp_seq=1 ttl=64 time=3.04 ms
64 bytes from 172.16.2.5: icmp_seq=2 ttl=64 time=1.09 ms

--- 172.16.2.5 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1000ms
rtt min/avg/max/mdev = 1.097/2.071/3.045/0.974 ms
[subramon@amd6 ~]$
[subramon@amd6 ~]$
[subramon@amd6 ~]$ ip neigh show
164.107.119.1 dev eth0 lladdr 00:21:59:85:b0:06 REACHABLE
172.16.2.5 dev ib2 lladdr
80:00:00:48:fe:80:00:00:00:00:00:00:00:02:c9:03:00:01:e4:53 REACHABLE
164.107.119.236 dev eth0 lladdr 00:30:48:d0:19:be STALE
172.16.2.5 dev ib0 lladdr
80:00:00:48:fe:80:00:00:00:00:00:00:00:02:c9:03:00:01:e4:53 STALE
172.16.1.5 dev ib0 lladdr
80:00:00:48:fe:80:00:00:00:00:00:00:00:02:c9:03:00:01:e3:87 STALE
164.107.119.153 dev eth0 lladdr 00:15:17:0f:a8:28 REACHABLE
[subramon@amd6 ~]$

[subramon@amd6 ~]$ ifconfig ib0
ib0       Link encap:InfiniBand  HWaddr
80:00:00:48:FE:80:00:00:00:00:00:00:00:00:00:00:00:00:00:00
          inet addr:172.16.1.6  Bcast:172.16.1.255  Mask:255.255.255.0
          inet6 addr: fe80::202:c903:1:e443/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:65520  Metric:1
          RX packets:61 errors:0 dropped:0 overruns:0 frame:0
          TX packets:25 errors:0 dropped:9 overruns:0 carrier:0
          collisions:0 txqueuelen:256
          RX bytes:20049 (19.5 KiB)  TX bytes:8263 (8.0 KiB)

[subramon@amd6 ~]$ ifconfig ib2
ib2       Link encap:InfiniBand  HWaddr
80:00:00:48:FE:80:00:00:00:00:00:00:00:00:00:00:00:00:00:00
          inet addr:172.16.2.6  Bcast:172.16.2.255  Mask:255.255.255.0
          inet6 addr: fe80::202:c903:1:e44f/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:65520  Metric:1
          RX packets:14 errors:0 dropped:0 overruns:0 frame:0
          TX packets:23 errors:0 dropped:9 overruns:0 carrier:0
          collisions:0 txqueuelen:256
          RX bytes:1740 (1.6 KiB)  TX bytes:8341 (8.1 KiB)

[subramon@amd6 ~]$ netstat -rn
Kernel IP routing table
Destination     Gateway         Genmask         Flags   MSS Window  irtt Iface
172.16.4.0      0.0.0.0         255.255.255.0   U         0 0          0 ib1
172.16.2.0      0.0.0.0         255.255.255.0   U         0 0          0 ib2
164.107.119.0   0.0.0.0         255.255.255.0   U         0 0          0 eth0
172.16.1.0      0.0.0.0         255.255.255.0   U         0 0          0 ib0
192.168.122.0   0.0.0.0         255.255.255.0   U         0 0          0 virbr0
169.254.0.0     0.0.0.0         255.255.0.0     U         0 0          0 eth0
0.0.0.0         164.107.119.1   0.0.0.0         UG        0 0          0 eth0

Thx,
Hari.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

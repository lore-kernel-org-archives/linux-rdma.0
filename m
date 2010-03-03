From: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: Bug in OFED1.5 ib_ipoib: IPv6 doesn't interoperate between RHEL4
 and other Linux distros
Date: Wed, 3 Mar 2010 11:00:44 -0600
Message-ID: <4C2744E8AD2982428C5BFE523DF8CDCB477C9726E5@MNEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

One of my testers reported this, has anyone else seen it? Given two RHE=
L4 hosts, IPV6 works correctly, (according to the testers) but IPV6 doe=
s not work between hosts running RHEL4u8 and hosts running SLES10 or RH=
EL5.

Given an RHEL5 host:

[root@homer ~]# ifconfig ib0
ib0=A0=A0=A0=A0=A0=A0 Link encap:InfiniBand=A0 HWaddr 80:00:04:04:FE:80=
:00:00:00:00:00:00:00:00:00:00:00:00:00:00=A0=20
=A0=A0=A0=A0=A0=A0=A0=A0=A0 inet addr:172.21.33.208=A0 Bcast:172.21.33.=
255=A0 Mask:255.255.255.0
=A0=A0=A0=A0=A0=A0=A0=A0=A0 inet6 addr: fe80::206:6a00:a000:707f/64 Sco=
pe:Link
=A0=A0=A0=A0=A0=A0=A0=A0=A0 UP BROADCAST RUNNING MULTICAST=A0 MTU:65520=
=A0 Metric:1
=A0=A0=A0=A0=A0=A0=A0=A0=A0 RX packets:17 errors:0 dropped:0 overruns:0=
 frame:0
=A0=A0=A0=A0=A0=A0=A0=A0=A0 TX packets:9 errors:0 dropped:24 overruns:0=
 carrier:0
=A0=A0=A0=A0=A0=A0=A0=A0=A0 collisions:0 txqueuelen:256=20

And an RHEL4 host:

[root@apu ~]# ifconfig ib0
ib0=A0=A0=A0=A0=A0=A0 Link encap:UNSPEC=A0 HWaddr 80-00-04-04-FE-80-00-=
00-00-00-00-00-00-00-00-00=A0=20
=A0=A0=A0=A0=A0=A0=A0=A0=A0 inet addr:172.21.33.210=A0 Bcast:172.21.33.=
255=A0 Mask:255.255.255.0
=A0=A0=A0=A0=A0=A0=A0=A0=A0 inet6 addr: fe80::206:6a00:a000:6ca8/64 Sco=
pe:Link
=A0=A0=A0=A0=A0=A0=A0=A0=A0 UP BROADCAST RUNNING MULTICAST=A0 MTU:65520=
=A0 Metric:1
=A0=A0=A0=A0=A0=A0=A0=A0=A0 RX packets:15 errors:0 dropped:0 overruns:0=
 frame:0
=A0=A0=A0=A0=A0=A0=A0=A0=A0 TX packets:26 errors:0 dropped:0 overruns:0=
 carrier:0
=A0=A0=A0=A0=A0=A0=A0=A0=A0 collisions:0 txqueuelen:256=20
=A0=A0=A0=A0=A0=A0=A0=A0=A0 RX bytes:1092 (1.0 KiB)=A0 TX bytes:2176 (2=
=2E1 KiB)

pinging over ipv4 works:

[root@homer ~]# ping 172.21.33.210
PING 172.21.33.210 (172.21.33.210) 56(84) bytes of data.
64 bytes from 172.21.33.210: icmp_seq=3D1 ttl=3D64 time=3D0.064 ms
64 bytes from 172.21.33.210: icmp_seq=3D2 ttl=3D64 time=3D0.035 ms
64 bytes from 172.21.33.210: icmp_seq=3D3 ttl=3D64 time=3D0.024 ms
64 bytes from 172.21.33.210: icmp_seq=3D4 ttl=3D64 time=3D0.026 ms

[root@apu ~]# ping 172.21.33.208
PING 172.21.33.208 (172.21.33.208) 56(84) bytes of data.
64 bytes from 172.21.33.208: icmp_seq=3D0 ttl=3D64 time=3D0.053 ms
64 bytes from 172.21.33.208: icmp_seq=3D1 ttl=3D64 time=3D0.026 ms
64 bytes from 172.21.33.208: icmp_seq=3D2 ttl=3D64 time=3D0.026 ms
64 bytes from 172.21.33.208: icmp_seq=3D3 ttl=3D64 time=3D0.027 ms
64 bytes from 172.21.33.208: icmp_seq=3D4 ttl=3D64 time=3D0.025 ms

However, pinging over ipv6 fails:

[root@homer ~]# ping6 -I ib0 fe80::206:6a00:a000:6ca8 PING fe80::206:6a=
00:a000:6ca8(fe80::206:6a00:a000:6ca8) from fe80::206:6a00:a000:707f ib=
0: 56 data bytes From fe80::206:6a00:a000:707f icmp_seq=3D1 Destination=
 unreachable: Address unreachable From fe80::206:6a00:a000:707f icmp_se=
q=3D2 Destination unreachable: Address unreachable From fe80::206:6a00:=
a000:707f icmp_seq=3D3 Destination unreachable: Address unreachable

But pinging over ipv6 works between rhel5 boxes:

[root@homer ~]# ping6 -I ib0 fe80::206:6a00:a000:7d5e PING fe80::206:6a=
00:a000:7d5e(fe80::206:6a00:a000:7d5e) from fe80::206:6a00:a000:707f ib=
0: 56 data bytes
64 bytes from fe80::206:6a00:a000:7d5e: icmp_seq=3D0 ttl=3D64 time=3D1.=
72 ms
64 bytes from fe80::206:6a00:a000:7d5e: icmp_seq=3D1 ttl=3D64 time=3D0.=
063 ms
64 bytes from fe80::206:6a00:a000:7d5e: icmp_seq=3D2 ttl=3D64 time=3D0.=
033 ms
64 bytes from fe80::206:6a00:a000:7d5e: icmp_seq=3D3 ttl=3D64 time=3D0.=
044 ms

Similarly, the RHEL5 host can ping IPV6 to a SLES10 host:

[root@homer ~]# ping6 -I ib0 fe80::206:6a00:a000:6cc1 PING fe80::206:6a=
00:a000:6cc1(fe80::206:6a00:a000:6cc1) from fe80::206:6a00:a000:707f ib=
0: 56 data bytes
64 bytes from fe80::206:6a00:a000:6cc1: icmp_seq=3D0 ttl=3D64 time=3D1.=
91 ms
64 bytes from fe80::206:6a00:a000:6cc1: icmp_seq=3D1 ttl=3D64 time=3D0.=
048 ms

Any ideas? Has anyone seen this?=20

Interestingly, the SM shows that the ping packet is leaving the RHEL4 m=
achine, but it appears to have a garbled address in it:

Wed Mar=A0 3 11:58:07 2010: fm0_sm(13922): ERROR[sareader]: SA: sa_Path=
Record: gidprefix in Dest Gid 0x0000000000000006:6a00a0006ca80000 of PA=
TH request from Lid 0x9 does not match SM's(0xfe80000000000000)

What makes this interesting is that the actual GID of the RHEL4 box is =
fe80000000000000:00066a00a0006ca8 - so it looks like the GID in the pin=
g packet is shifted 16 bits.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

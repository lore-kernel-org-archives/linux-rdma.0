From: "David J. Wilder" <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: Bug in OFED1.5 ib_ipoib: IPv6 doesn't interoperate between
	RHEL4 and other Linux distros
Date: Wed, 03 Mar 2010 12:43:46 -0800
Message-ID: <1267649027.18434.11.camel@wilder.ibm.com>
References: <4C2744E8AD2982428C5BFE523DF8CDCB477C9726E5@MNEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C2744E8AD2982428C5BFE523DF8CDCB477C9726E5-amwN6d8PyQWXx9kJd3VG2h2eb7JE58TQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Mike-

A number of fixes related to ipv6 address resolution by rdma_cm went in
to ofed 1.5.1 that may be related to this.  You may want to test 1.5.1
and see if it resolves your issue.  As I recall link-local address are
treated different that assigned ipv6 address so you might want to try
using assigned address.

Dave..

On Wed, 2010-03-03 at 11:00 -0600, Mike Heinz wrote:
> One of my testers reported this, has anyone else seen it? Given two RHEL4 hosts, IPV6 works correctly, (according to the testers) but IPV6 does not work between hosts running RHEL4u8 and hosts running SLES10 or RHEL5.
> 
> Given an RHEL5 host:
> 
> [root@homer ~]# ifconfig ib0
> ib0       Link encap:InfiniBand  HWaddr 80:00:04:04:FE:80:00:00:00:00:00:00:00:00:00:00:00:00:00:00  
>           inet addr:172.21.33.208  Bcast:172.21.33.255  Mask:255.255.255.0
>           inet6 addr: fe80::206:6a00:a000:707f/64 Scope:Link
>           UP BROADCAST RUNNING MULTICAST  MTU:65520  Metric:1
>           RX packets:17 errors:0 dropped:0 overruns:0 frame:0
>           TX packets:9 errors:0 dropped:24 overruns:0 carrier:0
>           collisions:0 txqueuelen:256 
> 
> And an RHEL4 host:
> 
> [root@apu ~]# ifconfig ib0
> ib0       Link encap:UNSPEC  HWaddr 80-00-04-04-FE-80-00-00-00-00-00-00-00-00-00-00  
>           inet addr:172.21.33.210  Bcast:172.21.33.255  Mask:255.255.255.0
>           inet6 addr: fe80::206:6a00:a000:6ca8/64 Scope:Link
>           UP BROADCAST RUNNING MULTICAST  MTU:65520  Metric:1
>           RX packets:15 errors:0 dropped:0 overruns:0 frame:0
>           TX packets:26 errors:0 dropped:0 overruns:0 carrier:0
>           collisions:0 txqueuelen:256 
>           RX bytes:1092 (1.0 KiB)  TX bytes:2176 (2.1 KiB)
> 
> pinging over ipv4 works:
> 
> [root@homer ~]# ping 172.21.33.210
> PING 172.21.33.210 (172.21.33.210) 56(84) bytes of data.
> 64 bytes from 172.21.33.210: icmp_seq=1 ttl=64 time=0.064 ms
> 64 bytes from 172.21.33.210: icmp_seq=2 ttl=64 time=0.035 ms
> 64 bytes from 172.21.33.210: icmp_seq=3 ttl=64 time=0.024 ms
> 64 bytes from 172.21.33.210: icmp_seq=4 ttl=64 time=0.026 ms
> 
> [root@apu ~]# ping 172.21.33.208
> PING 172.21.33.208 (172.21.33.208) 56(84) bytes of data.
> 64 bytes from 172.21.33.208: icmp_seq=0 ttl=64 time=0.053 ms
> 64 bytes from 172.21.33.208: icmp_seq=1 ttl=64 time=0.026 ms
> 64 bytes from 172.21.33.208: icmp_seq=2 ttl=64 time=0.026 ms
> 64 bytes from 172.21.33.208: icmp_seq=3 ttl=64 time=0.027 ms
> 64 bytes from 172.21.33.208: icmp_seq=4 ttl=64 time=0.025 ms
> 
> However, pinging over ipv6 fails:
> 
> [root@homer ~]# ping6 -I ib0 fe80::206:6a00:a000:6ca8 PING fe80::206:6a00:a000:6ca8(fe80::206:6a00:a000:6ca8) from fe80::206:6a00:a000:707f ib0: 56 data bytes From fe80::206:6a00:a000:707f icmp_seq=1 Destination unreachable: Address unreachable From fe80::206:6a00:a000:707f icmp_seq=2 Destination unreachable: Address unreachable From fe80::206:6a00:a000:707f icmp_seq=3 Destination unreachable: Address unreachable
> 
> But pinging over ipv6 works between rhel5 boxes:
> 
> [root@homer ~]# ping6 -I ib0 fe80::206:6a00:a000:7d5e PING fe80::206:6a00:a000:7d5e(fe80::206:6a00:a000:7d5e) from fe80::206:6a00:a000:707f ib0: 56 data bytes
> 64 bytes from fe80::206:6a00:a000:7d5e: icmp_seq=0 ttl=64 time=1.72 ms
> 64 bytes from fe80::206:6a00:a000:7d5e: icmp_seq=1 ttl=64 time=0.063 ms
> 64 bytes from fe80::206:6a00:a000:7d5e: icmp_seq=2 ttl=64 time=0.033 ms
> 64 bytes from fe80::206:6a00:a000:7d5e: icmp_seq=3 ttl=64 time=0.044 ms
> 
> Similarly, the RHEL5 host can ping IPV6 to a SLES10 host:
> 
> [root@homer ~]# ping6 -I ib0 fe80::206:6a00:a000:6cc1 PING fe80::206:6a00:a000:6cc1(fe80::206:6a00:a000:6cc1) from fe80::206:6a00:a000:707f ib0: 56 data bytes
> 64 bytes from fe80::206:6a00:a000:6cc1: icmp_seq=0 ttl=64 time=1.91 ms
> 64 bytes from fe80::206:6a00:a000:6cc1: icmp_seq=1 ttl=64 time=0.048 ms
> 
> Any ideas? Has anyone seen this? 
> 
> Interestingly, the SM shows that the ping packet is leaving the RHEL4 machine, but it appears to have a garbled address in it:
> 
> Wed Mar  3 11:58:07 2010: fm0_sm(13922): ERROR[sareader]: SA: sa_PathRecord: gidprefix in Dest Gid 0x0000000000000006:6a00a0006ca80000 of PATH request from Lid 0x9 does not match SM's(0xfe80000000000000)
> 
> What makes this interesting is that the actual GID of the RHEL4 box is fe80000000000000:00066a00a0006ca8 - so it looks like the GID in the ping packet is shifted 16 bits.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

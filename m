From: Rui Machado <ruimario-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: problems running rdmaoe examples
Date: Thu, 18 Mar 2010 19:22:06 +0100
Message-ID: <6978b4af1003181122l7fbd454fj23c28cf108145ed1@mail.gmail.com>
References: <6978b4af1003181041m3d03afc7t8687e88be2e4b179@mail.gmail.com>
	 <1E3DCD1C63492545881FACB6063A57C1055E57FE@mtiexch01.mti.com>
	 <6978b4af1003181101q56eb6ae7sdae2bb7e57623c16@mail.gmail.com>
	 <1E3DCD1C63492545881FACB6063A57C1055E5819@mtiexch01.mti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1E3DCD1C63492545881FACB6063A57C1055E5819-SDnKeQl2TTymvrjiD8yIlgC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Boris Shpolyansky <boris-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Your are right, I missed it.
>
> Can you send me the output of ifconfig command on both ends?
>

Sure!

=46irst machine:

eth0      Link encap:Ethernet  HWaddr 00:24:81:0E:6C:FD
          inet addr:192.168.10.95  Bcast:192.168.255.255  Mask:255.255.=
0.0
          inet6 addr: fe80::224:81ff:fe0e:6cfd/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:453847 errors:0 dropped:0 overruns:0 frame:0
          TX packets:245179 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:597238275 (569.5 Mb)  TX bytes:19574101 (18.6 Mb)
          Interrupt:17

eth2      Link encap:Ethernet  HWaddr 00:02:C9:02:CA:06
          inet addr:192.168.60.100  Bcast:192.168.60.255  Mask:255.255.=
255.0
          inet6 addr: fe80::202:c9ff:fe02:ca06/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:2297671 errors:0 dropped:0 overruns:0 frame:0
          TX packets:46146504 errors:23 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:137879685 (131.4 Mb)  TX bytes:69864665042 (66628.1 =
Mb)

lo        Link encap:Local Loopback
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:16436  Metric:1
          RX packets:14142 errors:0 dropped:0 overruns:0 frame:0
          TX packets:14142 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0
          RX bytes:2044414 (1.9 Mb)  TX bytes:2044414 (1.9 Mb)

Second machine:

eth0      Link encap:Ethernet  HWaddr 00:24:81:0E:6E:0D
          inet addr:192.168.10.96  Bcast:192.168.10.255  Mask:255.255.2=
55.0
          inet6 addr: fe80::224:81ff:fe0e:6e0d/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:30220 errors:0 dropped:0 overruns:0 frame:0
          TX packets:21443 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:12710557 (12.1 Mb)  TX bytes:2856949 (2.7 Mb)
          Interrupt:17


eth2      Link encap:Ethernet  HWaddr 00:02:C9:02:CA:02
          inet addr:192.168.60.101  Bcast:192.168.60.255  Mask:255.255.=
255.0
          inet6 addr: fe80::202:c9ff:fe02:ca02/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:46146483 errors:0 dropped:0 overruns:0 frame:0
          TX packets:2297704 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:69864660355 (66628.1 Mb)  TX bytes:137885351 (131.4 =
Mb)

lo        Link encap:Local Loopback
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:16436  Metric:1
          RX packets:7026 errors:0 dropped:0 overruns:0 frame:0
          TX packets:7026 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0
          RX bytes:455835 (445.1 Kb)  TX bytes:455835 (445.1 Kb)


Cheers,
Rui

> Boris Shpolyansky
> Sr. Member of Technical Staff, Applications
>
> Mellanox Technologies Inc.
> 350 Oakmead Parkway, Suite 100
> Sunnyvale, CA 94085
> Tel.: (408) 916 0014
> Fax: (408) 585 0314
> Cell: (408) 834 9365
> www.mellanox.com
>
> Mellanox on Twitter and Facebook
>
>
> -----Original Message-----
> From: Rui Machado [mailto:ruimario-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
> Sent: Thursday, March 18, 2010 11:02 AM
> To: Boris Shpolyansky
> Cc: linux-rdma
> Subject: Re: problems running rdmaoe examples
>
> Hi Boris,
>
> thanks for the quick answer.
>
>>
>> It seems that you are trying to run RDMAoE over InfiniBand device (a=
nd
>> probably over InfiniBand network). I believe you intent was to do ac=
tual
>> testing over 10GE network. Please, clarify.
>>
>
> Yes, the intention is to test over 10GE. That's why I'm trying to run
> the examples on port 2 (-i option). Or am I missing something?
> It is Ethernet network( eth2 if).
>
> Thanks,
> Rui
>
>
>>
>> -----Original Message-----
>> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Rui Machado
>> Sent: Thursday, March 18, 2010 10:41 AM
>> To: linux-rdma
>> Subject: problems running rdmaoe examples
>>
>> Hi list,
>>
>> I installed OFED-1.5.1-rc4 on a couple of machines to give a try to
>> mlx4_en and RDMAoE capabilities.
>> Trying to run ibv_rc_pingpong as:
>> server: ibv_rc_pingpong -i 2 -g 0
>> client: ibv_rc_pingpong -i 2 -g 0 192.168.60.101
>>
>> results in the following output:
>>
>> (client)
>> =A0local address: =A0LID 0x0000, QPN 0x5c004d, PSN 0x579776, GID
>> fe80::202:c9ff:fe02:ca06
>> =A0remote address: LID 0x0000, QPN 0x38004d, PSN 0xde57b8, GID
>> fe80::202:c9ff:fe02:ca02
>> Failed status transport retry counter exceeded (12) for wr_id 2
>>
>> (server)
>> =A0local address: =A0LID 0x0000, QPN 0x38004d, PSN 0xde57b8, GID
>> fe80::202:c9ff:fe02:ca02
>> =A0remote address: LID 0x0000, QPN 0x5c004d, PSN 0x579776, GID
>> fe80::202:c9ff:fe02:ca06
>>
>> My ibv_devinfo reports:
>>
>> hca_id: mlx4_0
>> =A0 =A0 =A0 =A0transport: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
InfiniBand (0)
>> =A0 =A0 =A0 =A0fw_ver: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 2.7.000
>> =A0 =A0 =A0 =A0node_guid: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
0002:c903:0002:ca04
>> =A0 =A0 =A0 =A0sys_image_guid: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0002:=
c903:0002:ca07
>> =A0 =A0 =A0 =A0vendor_id: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
0x02c9
>> =A0 =A0 =A0 =A0vendor_part_id: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 26428
>> =A0 =A0 =A0 =A0hw_ver: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 0xA0
>> =A0 =A0 =A0 =A0board_id: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 MT_04E0120005
>> =A0 =A0 =A0 =A0phys_port_cnt: =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A02
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0port: =A0 1
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0state: =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0PORT_ACTIVE (4)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0max_mtu: =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A02048 (4)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0active_mtu: =A0 =A0 =A0=
 =A0 =A0 =A0 2048 (4)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sm_lid: =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 6
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0port_lid: =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 6
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0port_lmc: =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 0x00
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0link_layer: =A0 =A0 =A0=
 =A0 =A0 =A0 IB
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0port: =A0 2
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0state: =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0PORT_ACTIVE (4)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0max_mtu: =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A02048 (4)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0active_mtu: =A0 =A0 =A0=
 =A0 =A0 =A0 1024 (3)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sm_lid: =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 0
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0port_lid: =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 0
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0port_lmc: =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 0x00
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0link_layer: =A0 =A0 =A0=
 =A0 =A0 =A0 Ethernet
>>
>>
>> Can someone give me any hint on what's the problem here (forgot to d=
o
>> something?)?
>>
>> Platform:
>> Linux 2.6.27.7-9-default #1 SMP 2008-12-04 18:10:04 +0100 x86_64
>> x86_64 x86_64 GNU/Linux
>> openSUSE 11.1 (x86_64)
>>
>> Thanks in advance,
>> Rui
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma=
" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

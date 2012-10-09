From: =?UTF-8?Q?Xavier_Gu=C3=A9rin?= <xrguerin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: ConnectX-3 VPI ETH issues
Date: Tue, 9 Oct 2012 15:19:31 -0400
Message-ID: <CAHBb3is3dJZwWFjDwYUSL_FP=twgs4_LbH+SjXiRRFDLZyTkdA@mail.gmail.com>
References: <CAHBb3iuhfZxGPX+zKMahLYeRwD9B4038-+8eRWWmRdfO_9MZrQ@mail.gmail.com>
	<507476DB.6090804@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <507476DB.6090804-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello Hal,

Thank you for your answer. It turned out to be an issue with our
router installation. We now have the port activated and the link set
up. We still are having issue with the connection itself (wr timeout
with ibv_rc_pingpong and ARP packet not distributed), but it may be an
router issue as well.

Xavier

On Tue, Oct 9, 2012 at 3:11 PM, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>=
 wrote:
> Hi Xavier,
>
> On 10/2/2012 8:59 PM, Xavier Gu=C3=A9rin wrote:
>> Hi list,
>>
>> I am afraid I am stuck with a very stupid problem, and I am at my wi=
t's ends.
>>
>> I am deploying a set a blades loaded with ConnectX-3 VPI adapters. T=
he
>> blades run under RHEL 6.3 and the connectors are driven using the
>> MLNX_OFED 1.5.3.3 stack.
>
>> When the ports are configured in IB (default), the physical state of
>> the ports is POLLING, which is expected since the adapters are
>> connected with Ethernet wires and switches:
>>
>> $ ibstat
>> CA 'mlx4_0'
>>         CA type: MT4099
>>         Number of ports: 2
>>         Firmware version: 2.10.2322
>>         Hardware version: 0
>>         Node GUID: 0x0002c90300f31160
>>         System image GUID: 0x0002c90300f31163
>>         Port 1:
>>                 State: Down
>>                 Physical state: Polling
>>                 Rate: 40
>>                 Base lid: 0
>>                 LMC: 0
>>                 SM lid: 0
>>                 Capability mask: 0x02514868
>>                 Port GUID: 0x0002c90300f31161
>>                 Link layer: InfiniBand
>>         Port 2:
>>                 State: Down
>>                 Physical state: Polling
>>                 Rate: 40
>>                 Base lid: 0
>>                 LMC: 0
>>                 SM lid: 0
>>                 Capability mask: 0x02514868
>>                 Port GUID: 0x0002c90300f31162
>>                 Link layer: InfiniBand
>>
>> But when I enable the ports as ETH, the physical state shows up as D=
ISABLED:
>>
>> $ ibstat
>> CA 'mlx4_0'
>>         CA type: MT4099
>>         Number of ports: 2
>>         Firmware version: 2.10.2322
>>         Hardware version: 0
>>         Node GUID: 0x0002c90300f31160
>>         System image GUID: 0x0002c90300f31163
>>         Port 1:
>>                 State: Down
>>                 Physical state: Disabled
>>                 Rate: 40
>>                 Base lid: 0
>>                 LMC: 0
>>                 SM lid: 0
>>                 Capability mask: 0x00010000
>>                 Port GUID: 0x0202c9fffef31160
>>                 Link layer: Ethernet
>>         Port 2:
>>                 State: Down
>>                 Physical state: Disabled
>>                 Rate: 40
>>                 Base lid: 0
>>                 LMC: 0
>>                 SM lid: 0
>>                 Capability mask: 0x00010000
>>                 Port GUID: 0x0202c9fffef31161
>>                 Link layer: Ethernet
>
> ibstat is showing an RDMA device's IB state and IB physical state. A =
VPI
> port shows up as down/disabled when it's in ethernet mode.
>
>> Besides, ibportstate fails opening the port in ETH mode:
>>
>> $ ibportstate -C mlx4_0 -L 0 -P 1 q
>
> ibportstate will only work with IB ports so it can't open port in
> ethernet mode.
>
> -- Hal
>
>> Finally, if that helps, when set in auto mode, the port configuratio=
n
>> stick with IB.
>>
>> I went through any possible user guide without help. Any clue about
>> what I am doing wrong?
>>
>> Thanks,
>> Xavier
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma=
" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

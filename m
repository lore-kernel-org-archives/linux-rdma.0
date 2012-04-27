From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: Mellanox/RoCE
Date: Fri, 27 Apr 2012 08:24:18 -0400
Message-ID: <4F9A8FF2.9090104@dev.mellanox.co.il>
References: <OF11A843C0.B83CA9CD-ONC12579ED.004252F0-C12579ED.0042969B@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <OF11A843C0.B83CA9CD-ONC12579ED.004252F0-C12579ED.0042969B-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Klaus Wacker <Klaus.Wacker-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Klaus,

On 4/27/2012 8:07 AM, Klaus Wacker wrote:
> 
> Hi,
> i want to setup Mellanox/RoCE. My system is SUSE SLES11.2 with
> Mellanox-OFED-1.5.3
> I have ping on the ethernet interface working and also ibv_ud_pingpong.
> ibv_rc_pingpong fails:
> bc2x03:~ # ibv_rc_pingpong -g 0 -s 128 -d mlx4_0 -i 2 10.100.10.24
>   local address:  LID 0x0000, QPN 0x600048, PSN 0x5e836d, GID
> fe80::202:c9ff:fe4c:5aa3
>   remote address: LID 0x0000, QPN 0x0c0048, PSN 0x2ced8f, GID
> fe80::202:c9ff:fe4c:5aeb
> Failed status transport retry counter exceeded (12) for wr_id 2
> 
> The ibstat info is:
> bc2x03:~ # ibstat
> CA 'mlx4_0'
>         CA type: MT26448
>         Number of ports: 2
>         Firmware version: 2.9.1100
>         Hardware version: b0
>         Node GUID: 0x0002c903004c5aa2
>         System image GUID: 0x0002c903004c5aa5
>         Port 1:
>                 State: Active
>                 Physical state: LinkUp
>                 Rate: 10
>                 Base lid: 0
>                 LMC: 0
>                 SM lid: 0
>                 Capability mask: 0x00010000
>                 Port GUID: 0x0202c9fffe4c5aa2
>                 Link layer: Ethernet
>         Port 2:
>                 State: Active
>                 Physical state: LinkUp
>                 Rate: 10
>                 Base lid: 0
>                 LMC: 0
>                 SM lid: 0
>                 Capability mask: 0x00010000
>                 Port GUID: 0x0202c9fffe4c5aa3
>                 Link layer: Ethernet
> 
> The Capability mask shows weak settings, gives this an indication for the
> failure? where is the capability mask described?

CapabilityMask is showing bit 16 which means:
16: IsCommunicationManagementSupported
which is accurate for RoCE since only CM is supported.

I'm not sure what capabilities you are looking for here (they are
management related) or what the relationship is to the "transport retry
counter exceeded" problem.

-- Hal

> Thanks for your time.
> 
> Kind regards
> 
> Klaus Wacker
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

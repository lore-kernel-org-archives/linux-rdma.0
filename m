From: Klaus Wacker <Klaus.Wacker-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
Subject: RE: Mellanox/RoCE
Date: Mon, 30 Apr 2012 13:05:52 +0200
Message-ID: <OF5E413131.604A997A-ONC12579F0.003C12A9-C12579F0.003CF883@de.ibm.com>
References: <OF11A843C0.B83CA9CD-ONC12579ED.004252F0-C12579ED.0042969B@de.ibm.com> <4F9A8FF2.9090104@dev.mellanox.co.il> <196072F1C8E91D46B78B7E46E094F7F31D116F5A@MTIDAG01.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <196072F1C8E91D46B78B7E46E094F7F31D116F5A-BVKCrmiI1TiuSA5JZHE7gA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Boris Shpolyansky <boris-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,
thanks for your comments.
We use switch "BNT Virtual Fabric 10 Gb" which is DCB capable. I assume no
link-level flow control mechanism (global pause/PFC) is enabled yet.
I'll try that next and post the results.

Klaus-Dieter Wacker
IBM


|------------>
| From:      |
|------------>
  >--------------------------------------------------------------------------------------------------------------------------------------------------|
  |Boris Shpolyansky <boris-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>                                                                                                            |
  >--------------------------------------------------------------------------------------------------------------------------------------------------|
|------------>
| To:        |
|------------>
  >--------------------------------------------------------------------------------------------------------------------------------------------------|
  |Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Klaus Wacker/Germany/IBM@IBMDE,                                                                          |
  >--------------------------------------------------------------------------------------------------------------------------------------------------|
|------------>
| Cc:        |
|------------>
  >--------------------------------------------------------------------------------------------------------------------------------------------------|
  |"linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Husemann <thomash-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Nir Gal <nirgal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>                  |
  >--------------------------------------------------------------------------------------------------------------------------------------------------|
|------------>
| Date:      |
|------------>
  >--------------------------------------------------------------------------------------------------------------------------------------------------|
  |27/04/2012 18:26                                                                                                                                  |
  >--------------------------------------------------------------------------------------------------------------------------------------------------|
|------------>
| Subject:   |
|------------>
  >--------------------------------------------------------------------------------------------------------------------------------------------------|
  |RE: Mellanox/RoCE                                                                                                                                 |
  >--------------------------------------------------------------------------------------------------------------------------------------------------|





Klaus,

You may be experiencing frame drops on our Ethernet fabric.
Is flow control (pause frames) enabled?
RDMA traffic requires lossless layer-2 network, it is not designed to
handle situation where multiple frames are re-transmitted due to packets
being dropped.

Boris Shpolyansky
Director of Field Application Engineering, North America

Mellanox Technologies Inc.
350 Oakmead Parkway, Suite 100
Sunnyvale, CA 94085
Tel.: (408) 916 0014
Fax: (408) 585 0314
Cell: (408) 834 9365
www.mellanox.com
Mellanox on Twitter and Facebook


-----Original Message-----
From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [
mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Hal Rosenstock
Sent: Friday, April 27, 2012 5:25 AM
To: Klaus Wacker
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: Re: Mellanox/RoCE

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
> fe80::202:c9ff:fe4c:5aeb Failed status transport retry counter
> exceeded (12) for wr_id 2
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
> The Capability mask shows weak settings, gives this an indication for
> the failure? where is the capability mask described?

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
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"
> in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo
> info at  http://vger.kernel.org/majordomo-info.html
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at
http://vger.kernel.org/majordomo-info.html




--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

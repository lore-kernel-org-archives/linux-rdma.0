From: Klaus Wacker <Klaus.Wacker-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
Subject: RE: Mellanox/RoCE
Date: Mon, 7 May 2012 09:42:03 +0200
Message-ID: <OF42BAA817.DDA1AF7C-ONC12579F7.002A2D00-C12579F7.002A5018@de.ibm.com>
References: <OF11A843C0.B83CA9CD-ONC12579ED.004252F0-C12579ED.0042969B@de.ibm.com> <4F9A8FF2.9090104@dev.mellanox.co.il> <196072F1C8E91D46B78B7E46E094F7F31D116F5A@MTIDAG01.mtl.com> <OF0CABEC7E.4612AA0B-ONC12579F4.002E7F03-C12579F4.002F99D4@de.ibm.com> <OF276B9773.8FB55E28-ON852579F4.004A5051-852579F4.004A8071@ca.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	Boundary="0__=4EBBF364DFB9AB908f9e8a93df938690918c4EBBF364DFB9AB90"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <OF276B9773.8FB55E28-ON852579F4.004A5051-852579F4.004A8071-G1DYhSM1WHTQT0dZR+AlfA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Y Lee <ykalee-G1DYhSM1WHTQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

--0__=4EBBF364DFB9AB908f9e8a93df938690918c4EBBF364DFB9AB90
Content-type: text/plain; charset=US-ASCII

Hello Alan, thanks for your posting. Both systems have set:

bc2x03:~ # sysctl -a | grep rp_filter
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.all.arp_filter = 0
net.ipv4.conf.default.rp_filter = 0
net.ipv4.conf.default.arp_filter = 0
net.ipv4.conf.lo.rp_filter = 0
net.ipv4.conf.lo.arp_filter = 0
net.ipv4.conf.eth0.rp_filter = 0
net.ipv4.conf.eth0.arp_filter = 0
net.ipv4.conf.eth1.rp_filter = 0
net.ipv4.conf.eth1.arp_filter = 0
net.ipv4.conf.usb0.rp_filter = 0
net.ipv4.conf.usb0.arp_filter = 0
net.ipv4.conf.eth2.rp_filter = 0
net.ipv4.conf.eth2.arp_filter = 0
net.ipv4.conf.eth3.rp_filter = 0
net.ipv4.conf.eth3.arp_filter = 0
bc2x03:~ # sysctl -a | grep arp_ignore
net.ipv4.conf.all.arp_ignore = 0
net.ipv4.conf.default.arp_ignore = 0
net.ipv4.conf.lo.arp_ignore = 0
net.ipv4.conf.eth0.arp_ignore = 0
net.ipv4.conf.eth1.arp_ignore = 0
net.ipv4.conf.usb0.arp_ignore = 0
net.ipv4.conf.eth2.arp_ignore = 0
net.ipv4.conf.eth3.arp_ignore = 0


Klaus-Dieter Wacker
IBM


|------------>
| From:      |
|------------>
  >--------------------------------------------------------------------------------------------------------------------------------------------------|
  |Alan Y Lee <ykalee-G1DYhSM1WHTQT0dZR+AlfA@public.gmane.org>                                                                                                                    |
  >--------------------------------------------------------------------------------------------------------------------------------------------------|
|------------>
| To:        |
|------------>
  >--------------------------------------------------------------------------------------------------------------------------------------------------|
  |Klaus Wacker/Germany/IBM@IBMDE,                                                                                                                   |
  >--------------------------------------------------------------------------------------------------------------------------------------------------|
|------------>
| Date:      |
|------------>
  >--------------------------------------------------------------------------------------------------------------------------------------------------|
  |04/05/2012 15:33                                                                                                                                  |
  >--------------------------------------------------------------------------------------------------------------------------------------------------|
|------------>
| Subject:   |
|------------>
  >--------------------------------------------------------------------------------------------------------------------------------------------------|
  |RE: Mellanox/RoCE                                                                                                                                 |
  >--------------------------------------------------------------------------------------------------------------------------------------------------|





Hi Klaus, saw your question from the distribution list ... just curious at
what is the following set to in your server and client boxes ?

sysctl -a | grep rp_filter
sysctl -a | grep arp_ignore

Regards,

Alan Y Lee
DB2 LUW Kernel Development
Phone: 905-413-2380, Tie-Line: 313-2380,
ITN : 23132380, Fax: 905-413-4849
Email: ykalee-G1DYhSM1WHTQT0dZR+AlfA@public.gmane.org


(Embedded image moved to file: pic62702.gif)Inactive hide details for Klaus
Wacker ---05/04/2012 04:40:22 AM---Hi all, the follow-up on my
Mellanox/RoCE setup gave me the Klaus Wacker ---05/04/2012 04:40:22 AM---Hi
all, the follow-up on my Mellanox/RoCE setup gave me the following:

From: Klaus Wacker <Klaus.Wacker-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Date: 05/04/2012 04:40 AM
Subject: RE: Mellanox/RoCE
Sent by: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



Hi all,
the follow-up on my Mellanox/RoCE setup gave me the following:
I checked the BNT 10Gb Virtual Fabric switch and found that the ports of my
blades have "Flow Control = both Rx/Tx" whcih enables "global pause".
I did the failing ibv_rc_pingpong again and monitored the port stats
in /sys/class/infiniband/mlx4_0/ports/2/counters/... and found the
following:
Server:
bc2x04:/sys/class/infiniband/mlx4_0/ports/2/counters/port_rcv_packets:
21457
bc2x04:/sys/class/infiniband/mlx4_0/ports/2/counters/port_xmit_packets:
21329
bc2x04:~ # ibv_rc_pingpong -g 0 -s 128 -d mlx4_0 -i 2
local address: LID 0x0000, QPN 0x180048, PSN 0x35e068, GID
fe80::202:c9ff:fe4c:5aeb
remote address: LID 0x0000, QPN 0x6c0048, PSN 0x99a3c6, GID
fe80::202:c9ff:fe4c:5aa3


bc2x04:/sys/class/infiniband/mlx4_0/ports/2/counters/port_rcv_packets:
21465
bc2x04:/sys/class/infiniband/mlx4_0/ports/2/counters/port_xmit_packets:
21329

===============================================================
Client:
bc2x03:/sys/class/infiniband/mlx4_0/ports/2/counters/port_rcv_packets:
11034
bc2x03:/sys/class/infiniband/mlx4_0/ports/2/counters/port_xmit_packets:
11290
bc2x03:~ # ibv_rc_pingpong -g 0 -s 128 -d mlx4_0 -i 2 10.100.10.24
local address: LID 0x0000, QPN 0x700048, PSN 0x5b1244, GID
fe80::202:c9ff:fe4c:5aa3
remote address: LID 0x0000, QPN 0x1c0048, PSN 0x24fe44, GID
fe80::202:c9ff:fe4c:5aeb
Failed status transport retry counter exceeded (12) for wr_id 2


bc2x03:/sys/class/infiniband/mlx4_0/ports/2/counters/port_rcv_packets:
11034
bc2x03:/sys/class/infiniband/mlx4_0/ports/2/counters/port_xmit_packets:
11298

==============================================================

Looks like the packets go over the wire and reach the target RoCE card but
do not make it into the servers receive buffer.
I use mlnx-ofed 1.5.3 on sles11.2, downloaded it from Mellanox site
recently.

Any suggestions how to go from here?

Regards,
Klaus-Dieter Wacker
IBM


|------------>
| From: |
|------------>
>--------------------------------------------------------------------------------------------------------------------------------------------------|

|Boris Shpolyansky <boris-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> |
>--------------------------------------------------------------------------------------------------------------------------------------------------|

|------------>
| To: |
|------------>
>--------------------------------------------------------------------------------------------------------------------------------------------------|

|Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Klaus Wacker/Germany/IBM@IBMDE, |
>--------------------------------------------------------------------------------------------------------------------------------------------------|

|------------>
| Cc: |
|------------>
>--------------------------------------------------------------------------------------------------------------------------------------------------|

|"linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Husemann
<thomash-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Nir Gal <nirgal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> |
>--------------------------------------------------------------------------------------------------------------------------------------------------|

|------------>
| Date: |
|------------>
>--------------------------------------------------------------------------------------------------------------------------------------------------|

|27/04/2012 18:26 |
>--------------------------------------------------------------------------------------------------------------------------------------------------|

|------------>
| Subject: |
|------------>
>--------------------------------------------------------------------------------------------------------------------------------------------------|

|RE: Mellanox/RoCE |
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
> local address: LID 0x0000, QPN 0x600048, PSN 0x5e836d, GID
> fe80::202:c9ff:fe4c:5aa3
> remote address: LID 0x0000, QPN 0x0c0048, PSN 0x2ced8f, GID
> fe80::202:c9ff:fe4c:5aeb Failed status transport retry counter
> exceeded (12) for wr_id 2
>
> The ibstat info is:
> bc2x03:~ # ibstat
> CA 'mlx4_0'
> CA type: MT26448
> Number of ports: 2
> Firmware version: 2.9.1100
> Hardware version: b0
> Node GUID: 0x0002c903004c5aa2
> System image GUID: 0x0002c903004c5aa5
> Port 1:
> State: Active
> Physical state: LinkUp
> Rate: 10
> Base lid: 0
> LMC: 0
> SM lid: 0
> Capability mask: 0x00010000
> Port GUID: 0x0202c9fffe4c5aa2
> Link layer: Ethernet
> Port 2:
> State: Active
> Physical state: LinkUp
> Rate: 10
> Base lid: 0
> LMC: 0
> SM lid: 0
> Capability mask: 0x00010000
> Port GUID: 0x0202c9fffe4c5aa3
> Link layer: Ethernet
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
> info at http://vger.kernel.org/majordomo-info.html
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at
http://vger.kernel.org/majordomo-info.html




--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at http://vger.kernel.org/majordomo-info.html



--0__=4EBBF364DFB9AB908f9e8a93df938690918c4EBBF364DFB9AB90
Content-type: image/gif;
	name="pic62702.gif"
Content-Disposition: attachment; filename="pic62702.gif"
Content-transfer-encoding: base64

R0lGODlhEAAQAKECAMzMzAAAAP///wAAACH5BAEAAAIALAAAAAAQABAAAAIXlI+py+0PopwxUbpu
ZRfKZ2zgSJbmSRYAIf4fT3B0aW1pemVkIGJ5IFVsZWFkIFNtYXJ0U2F2ZXIhAAA7

--0__=4EBBF364DFB9AB908f9e8a93df938690918c4EBBF364DFB9AB90--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

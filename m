From: Reid O <hpc_reid-PkbjNfxxIARBDgjK7y7TUQ@public.gmane.org>
Subject: =?windows-1256?Q?Subnet_man?= =?windows-1256?Q?agement_on?=
 =?windows-1256?Q?_non_pure_?= =?windows-1256?Q?fat-tree_n?=
 =?windows-1256?Q?etwork=FE?=
Date: Sun, 28 Nov 2010 16:18:05 -0600
Message-ID: <SNT140-w638ED9C5E0455EBAEBC0FEF1230@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1256
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Hello,
=A0 We have an Infiniband cluster in a fat tree configuration with 8 co=
re switches and
12 leaf switches.=A0 The compute nodes are all in enclosures connected =
to the 12
leaf switches.=A0 However, we have a number of non-compute nodes (admin=
,
login and storage nodes) that we have connected directly to the core
switches.=A0 Initially, we were getting credit-loop issues so we switch=
ed
from Min Hop to UPDN routing.=A0 However, now 90% of our IB traffic see=
ms
to be routed through a single core switch.=A0 I have tried adding a roo=
t
guid file with the -a option, but that results in us getting this error=
:

Nov
28 16:47:19 319442 [45007960] 0x01 -> __osm_pr_rcv_get_path_parms:
ERR 1F07: Dead end on path to LID 0x6F from switch for GUID
0x00066a00d9000ac8
Nov 28 16:47:22 319469 [43C05960] 0x01 ->
__osm_pr_rcv_get_path_parms: ERR 1F07: Dead end on path to LID 0x6F
from switch for GUID 0x00066a00d9000ac8

Is there any way we can handle this hardware config via subnet manageme=
nt?

Thanks,

Reid O. 		 	   		 =20
 		 	   		 =20
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

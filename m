From: "Woodruff, Robert J" <robert.j.woodruff-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [Announce] rxe dev tree available (soft RDMAoE)
Date: Wed, 16 Dec 2009 16:19:16 -0800
Message-ID: <382A478CAD40FA4FB46605CF81FE39F4431FB84A@orsmsx507.amr.corp.intel.com>
References: <4B294BDD.3010405@systemfabricworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B294BDD.3010405-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: frank zago <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Bob Pearson <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>, John Groves <john-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

What is soft RDMA over ethernet, does this mean it is RDMAoE that will run over
any ethernet interface that is installed in the system ?

woody
 

-----Original Message-----
From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of frank zago
Sent: Wednesday, December 16, 2009 1:07 PM
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Bob Pearson; John Groves
Subject: [Announce] rxe dev tree available (soft RDMAoE)

Hello,

The development tree for a soft RDMA transport over Ethernet driver 
(rxe) is available in the OFA git repository. This is a work in progress 
but has enough functionality for people interested in looking at it to 
be worth sharing. Going forward changes to the driver will be maintained 
here.

To get a copy of the driver type

   git clone git://git.openfabrics.org/~fzago/rxe

This work is being supported by Mellanox and System Fabric Works.

Regards,
   Frank
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

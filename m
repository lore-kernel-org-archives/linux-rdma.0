From: frank zago <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Subject: [Announce] rxe dev tree available (soft RDMAoE)
Date: Wed, 16 Dec 2009 15:06:37 -0600
Message-ID: <4B294BDD.3010405@systemfabricworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Bob Pearson <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>, John Groves <john-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

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

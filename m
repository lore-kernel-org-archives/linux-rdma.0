From: =?ISO-8859-1?Q?S=E9bastien_Boisvert?=
	<sebastien.boisvert.3-qLLbaQniQ8D3fQ9qLvQP4Q@public.gmane.org>
Subject: Is there a code path for adaptive routing with the torus-2QoS engine
 in opensm ?
Date: Mon, 17 Dec 2012 16:11:18 -0500
Message-ID: <50CF8A76.5090904@ulaval.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Hello,

The documentation of torus-2QoS says "Unicast routing in torus-2QoS is based on Dimension Order Routing (DOR)."

Is there a code path that does adaptive routing (i.e. avoid saturated edges in the communication graph) in opensm ?


Thanks !



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

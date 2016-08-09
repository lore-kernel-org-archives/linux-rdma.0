From: Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org>
Subject: Connectivity between containers with ipoib interface.
Date: Tue, 9 Aug 2016 17:33:44 +0300
Message-ID: <57A9E9C8.5060905@kyup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello, 

I have multiple containers into which I have put "virtual" ipoib 
interface like so: 

ip link add link ib0 name ip1 type ipoib
ip link set dev ip1 netns $(pid of container)

The containers are setup with ip addresses from a different subnet
than the "base" addresses on the host-side ib0 interface. With 
this setup containers can access other nodes on the infiniband 
network with no problems. However, if 2 containers on the same
host node, with ipoib addresses from the same subnet try to 
access one another - this doesn't work. The only way to enable
such communication is to play tricks with routing such that 
packets exit the container and host node, and are sent to 
another physical node on the infiniband network, which then 
routes them back to the initial host node. I'd like to avoid
such gymnastics and have connectivity to containers on the 
same node without traffic going out the ib0 interface.

I guess what I'm asking for is something similar to the 
bridge mode in macvlan/macvtap drivers.


Regards, 
Nikolay 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

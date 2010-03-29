From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: nfsrdma broken on 2.6.34-rc1?
Date: Mon, 29 Mar 2010 12:42:08 -0500
Message-ID: <4BB0E670.3010507@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hey Sean,

I'm trying NFSRDMA on net-next and the server side fails when 
registering the rdma transport.  I think its due to the INET6 support 
added to the rdma-cm.  I'm still debugging though.

In fs/nfsd/nfsctl.c:__write_ports_addxprt(), it tries to create a new 
svc transport for PF_INET, and PF_INET6 using the same port and the 
wildcard address.  If the INET6 fails with anything other than 
-EAFNOSUPPORT, then the entire transport registration fails (ie no 
RDMA/INET support is added). 

When I do echo "rdma 20049" > /proc/fs/nfsd/portlist  I see the PF_INET 
transport get created successfully, but the INET6 transport create fails 
with -EADDRNOTAVAIL. 

Does the rdma-cm allow concurrent binds to PF_INET, INADDR_ANY, port=X 
and PF_INET6, IN6ADDR_ANY_INIT, port=X ?  Apparently the native stack 
allows this (which makes sense seeing as how they are different protocol 
families).


Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

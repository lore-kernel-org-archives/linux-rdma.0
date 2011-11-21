From: dev-x2spCj9RiN0z5UmgcLIfJQ@public.gmane.org
Subject: Independent server management of Multicasting connections
Date: Mon, 21 Nov 2011 07:15:51 -0700
Message-ID: <20111121071551.14306gf6ogr9z8yf@celticblues.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

 From what I understand, and I may not understand correctly, to  
perform IB Multicast, betweeen two nodes, I need to swap addresses and  
remote keys for the two nodes.  In the examples I have seen this has  
been done via RDMA CM directly between the two nodes.  Does it matter  
how this information is exchanged?  In my application I will have  
several nodes multicasting to several other nodes and I want to manage  
the connections from a independent application.  What I would like to  
do is write this application, server, etc. so that each node would  
request connection with another node and then be provied with the  
information it needs to multicast.  For example... Node 1 would  
request a connection (from the server app) Node 2 and Node 2 would  
request a connection (again, from the server app) to Node 1.  The  
Server app would provide Node 2's "credentials" to Node 1 and likewise  
to Node 2.  Is this even possible?


CD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

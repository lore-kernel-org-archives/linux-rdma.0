From: dev-x2spCj9RiN0z5UmgcLIfJQ@public.gmane.org
Subject: RE: Independent server management of Multicasting connections
Date: Tue, 22 Nov 2011 12:33:51 -0700
Message-ID: <20111122123351.3062401wh8eggf8f@celticblues.com>
References: <20111121071551.14306gf6ogr9z8yf@celticblues.com>
 <1828884A29C6694DAF28B7E6B8A8237316E9B9E9@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237316E9B9E9-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

[These questions are related to my original questions in the post data  
11/21 7:15 AM MST, subject: Independent server management of  
Multicasting connections]

The original post was to determine if it were possible to have server  
app that managed the data required to establish multicast IB  
communctions between 2 or more nodes.  Each node would initialize  
itself as needed wrt IB and each node would request from the server,  
as I now understand, the qpn, qkey and address handle for the  
multicast group it desired to communicate with.  The server, having  
created dynamically through the SA, the multicast group, would return  
said data and then the node would be able to begin posting multicast  
sends, or receives.  Alternatively, if I understand correctly, I can  
create the multicast group on start up of the opensmd.

In the rdma and multicast examples I have seen, each node sets up an  
rdma cm event channel.  The node then polls for events.

I had hoped to be able to avoid using the rdma_cm and avoid having to  
monitor an rdma_cm event channel. What I think I would like to do is  
have each node of my sim initialize it's side of the communiction,  
which I think should include

rdma_bind_addr
rdma_resolve_addr
ibv_create_ah
rdma_join_multicast

then ibv_post_send/ibv_post_recv as required.

However, the rdma_* calls require an rdma_cm_id which I won't have if  
I don't use the rdma cm.

Can I bypass using the rdma cm and the polling of the event channel?   
Or perhaps am I going to have to establish an event channel between my  
management server and each individual node?  On the other hand, if I  
can terminate the polling of the event channel once initialization is  
done, maybe I don't mind the rdma cm....

Can I bypass the polling of the completion queue?... which would imply  
I am simply trusting the data arrived at its destination?

Sorry to ask so many questions.  Are they any good books on this  
programming infiniband?

CD


Quoting "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>:

>>  From what I understand, and I may not understand correctly, to
>> perform IB Multicast, betweeen two nodes, I need to swap addresses and
>> remote keys for the two nodes.  In the examples I have seen this has
>
> You only need to do this for unicast UD.  Multicast doesn't require  
> exchanging addresses and qkeys, but see below.
>
>> been done via RDMA CM directly between the two nodes.  Does it matter
>> how this information is exchanged?  In my application I will have
>
> For multicast, you need to 1. have the SA create the multicast group  
> and 2. join the group.  To create the group, you need to either have  
> the SA automatically create the group (if this is possible) or  
> create it dynamically.  To create the group dynamically from user  
> space, you should use the rdma_cm or ib_umad interfaces.  The  
> rdma_cm is easier.
>
> To join the group, you need to let the SA know that the node should  
> receive multicast traffic, so that it can program the switches.   
> This is done through the rdma_cm (easy way) or using ib_umad (hard  
> way that gets harder if you want to support multiple applications  
> joining the same group from the same system).
>
>> several nodes multicasting to several other nodes and I want to manage
>> the connections from a independent application.  What I would like to
>> do is write this application, server, etc. so that each node would
>> request connection with another node and then be provied with the
>> information it needs to multicast.  For example... Node 1 would
>> request a connection (from the server app) Node 2 and Node 2 would
>> request a connection (again, from the server app) to Node 1.  The
>> Server app would provide Node 2's "credentials" to Node 1 and likewise
>> to Node 2.  Is this even possible?
>
> The SA basically does the work that you're describing for your  
> server app.  Node 1 can ask the SA to create a multicast group.   
> Node 2 can ask to join that group.  Somehow node 2 needs to know  
> what group node 1 created.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

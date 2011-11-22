From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Independent server management of Multicasting connections
Date: Tue, 22 Nov 2011 20:01:44 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E9BDB4@ORSMSX101.amr.corp.intel.com>
References: <20111121071551.14306gf6ogr9z8yf@celticblues.com>
 <1828884A29C6694DAF28B7E6B8A8237316E9B9E9@ORSMSX101.amr.corp.intel.com>
 <20111122123351.3062401wh8eggf8f@celticblues.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111122123351.3062401wh8eggf8f-x2spCj9RiN0z5UmgcLIfJQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "dev-x2spCj9RiN0z5UmgcLIfJQ@public.gmane.org" <dev-x2spCj9RiN0z5UmgcLIfJQ@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> The original post was to determine if it were possible to have server
> app that managed the data required to establish multicast IB
> communctions between 2 or more nodes.  Each node would initialize
> itself as needed wrt IB and each node would request from the server,
> as I now understand, the qpn, qkey and address handle for the
> multicast group it desired to communicate with.  The server, having
> created dynamically through the SA, the multicast group, would return
> said data and then the node would be able to begin posting multicast
> sends, or receives.  Alternatively, if I understand correctly, I can
> create the multicast group on start up of the opensmd.

Every node that wants to participate in a multicast group must join the group.  This is usually done by having the node that wishes to join send a multicast join request directly to the SA.  (Note that the join request can also create the group.)  There are 2 interfaces available to applications that result in sending join requests: umad and the rdma_cm.

Node X cannot join a multicast group and pass its multicast address to Node Y.  Each join request must be for a specific node.  I believe it's architecturally possible for node X to send the join request on behalf of node Y, I don't know if anyone has ever tried that or if the existing implementations support that.

Also, be aware that the SA manages multicast joins per node and not per request.  I.e. If node X joins a group twice, followed by 1 leave request, the node will be removed from the group.  The SA does not perform reference counting.  (It cannot distinguish between 2 separate requests, versus a single request that may have been retried.)

> In the rdma and multicast examples I have seen, each node sets up an
> rdma cm event channel.  The node then polls for events.

The rdma_cm also supports synchronous operation.  If an rdma_cm_id is created without an event channel, all calls will block until they complete.  Any results (e.g. communication parameters) are returned in the rdma_cm_id.  See rdma_client and rdma_server for examples of synchronous operation.  (Those establish a connection, but the same principals apply.)

> I had hoped to be able to avoid using the rdma_cm and avoid having to
> monitor an rdma_cm event channel. What I think I would like to do is
> have each node of my sim initialize it's side of the communiction,
> which I think should include
> 
> rdma_bind_addr
> rdma_resolve_addr
> ibv_create_ah
> rdma_join_multicast

You should be able to eliminate rdma_bind_addr and pass in the source address into rdma_resolve_addr.  If your IP routing tables will resolve a multicast address to an IPoIB device, you can eliminate the source address completely.  (rdma_resolve_addr calls rdma_bind_addr internally.)

The ibv_create_ah must come after rdma_join_multicast, after you have the join response.

> then ibv_post_send/ibv_post_recv as required.
> 
> However, the rdma_* calls require an rdma_cm_id which I won't have if
> I don't use the rdma cm.

correct
 
> Can I bypass using the rdma cm and the polling of the event channel?
> Or perhaps am I going to have to establish an event channel between my
> management server and each individual node?  On the other hand, if I
> can terminate the polling of the event channel once initialization is
> done, maybe I don't mind the rdma cm....

See above to use synchronous operation and avoid polling the event channel.
 
> Can I bypass the polling of the completion queue?... which would imply
> I am simply trusting the data arrived at its destination?

You must poll the CQ to avoid overrunning the send queue.  Multicast is unreliable, so a successful completion simply means that the data was transmitted without error.  It does not guarantee that the receiver has it.  Using QP based communication isn't trivial...
 
> Sorry to ask so many questions.  Are they any good books on this
> programming infiniband?

I'm not aware of any books, let alone good ones...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: QoS in local SA entity
Date: Thu, 05 Nov 2009 14:07:38 +0200
Message-ID: <4AF2C00A.4040808@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>
> I think this really needs to be discussed wrt the implementation of the entity providing the path records.
fair-enough, lets do it then...

> I think what's needed is a way for the SA to distribute QoS information to the end nodes, so that the decisions can be made locally.  If someone wants some sort of dynamic QoS management and is happy using a small cluster, then they can disable any local SA entities and contact the SA directly.

I believe we can go also on a middle way, where the SA isn't contacted 
directly using path query for each resolution, but rather "indirectly" 
e.g using a dedicated multicast based protocol.

> In the case of ACM, the pkey is embedded in the MGID.  'Something' could tell the SA to create ACM multicast groups using a specific SL for a given MGID or pkey in the join request.  That SL would be distributed to the end nodes when they joined their groups.

So assuming ACM supports AF_INET, using network stack route lookup on 
the destination address / rdma_bind on the source address, etc as we 
discussed, ACM can use the rdma-cm to resolve the pkey, then use this 
pkey the MGID and a management software could tell the SA to use a 
specific SL for MGIDs on this partition. Next, ACM can use this SL in 
the path it generates for the IB connection, makes sense?

> The entity that provides the path records cannot depend on calling into the librdmacm.  The dependency needs to go the other way.
I understand that you want to be dependent less as much as possible, but 
I believe that my suggestion doesn't contradict your design but rather 
enhance it.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

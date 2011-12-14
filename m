From: dev-x2spCj9RiN0z5UmgcLIfJQ@public.gmane.org
Subject: RE: Multiple multicast groups
Date: Wed, 14 Dec 2011 09:30:09 -0700
Message-ID: <20111214093009.12962ipxxrmw0avl@celticblues.com>
References: <20111213135346.132670b3va8kdk62@celticblues.com>
 <1828884A29C6694DAF28B7E6B8A8237325660A13@ORSMSX102.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237325660A13-P5GAC/sN6hlcIJlls4ac1rfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

That sounds simple enough... but a few questions:

1.  If I am not using rdma_join_multicast, would I simply use multiple  
calls to ibv_attach_multicast?

2.  My IB code is serving as a pass through layer between two  
pre-existing simulations which previously communicated via reflective  
memory.  It is much easier for me to insert this layer rather than  
modify these existing apps.  So SimApp A passes data to my IBLayer  
which multicasts it to IBLayers on other machines.  Instances of these  
IBLayers, upon receiving hte data, place it in shared memory for  
SimApp B to consume.  There are multiple types of data passing between  
the SimApps and my IBlayer...  All I want my IBLayer to do is take N  
Bytes of Data and place it in the correct shared memory location.  But  
if it doesn't know what type of data it is, it won't know the correct  
shared memory location...  I thought if I have multiple multicast  
groups and I use each one for a different type of data, e.g. MG 1 for  
DataType 1, MG2 for DataType 2 and so on.  Then the IBLayers receving  
the data would know that data received from MG 1 goes in shared mem  
segment 1 etc.

If I create my multicast groups as you suggested, will data coming  
from each multicast group will appear to each node as coming from the  
same place, or on the same qp?  It seems like I would have to 1 qp for  
each data type, post an rr for each data type on  thereceiver side,  
post a sr for each data type on the sender side, and would receive  
completion events on completion queues for each data type.  If that is  
the case, what else besides qps, cqs, etc, would each multicast group  
require...

Thx

Quoting "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>:

>> I am trying to modify one of the multicast examples (mckey.c) so that
>> I have multiple multicast groups each one handling a different type of
>> data.  I am somewhat confused as to how I would do this.  can I keep 1
>> RDMA CM channel between each server/client pair?  Would I need to keep
>> a qp, send/recv queue and completion queue for each multicast group?
>
> You can use a single QP, rdma_cm_id, completion channel, and CQ for  
> all multicast groups.  Simply call rdma_join_multicast() for every  
> group that you want to join.   E.g.
>
> rdma_create_id()
> rdma_bind_addr()
> rdma_create_qp()
> rdma_join_multicast()
> rdma_join_multicast()
> rdma_join_multicast()
> rdma_join_multicast()
> ...
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

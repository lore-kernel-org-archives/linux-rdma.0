From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Multiple multicast groups
Date: Wed, 14 Dec 2011 17:14:10 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237325660C03@ORSMSX102.amr.corp.intel.com>
References: <20111213135346.132670b3va8kdk62@celticblues.com>
 <1828884A29C6694DAF28B7E6B8A8237325660A13@ORSMSX102.amr.corp.intel.com>
 <20111214093009.12962ipxxrmw0avl@celticblues.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111214093009.12962ipxxrmw0avl-x2spCj9RiN0z5UmgcLIfJQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "dev-x2spCj9RiN0z5UmgcLIfJQ@public.gmane.org" <dev-x2spCj9RiN0z5UmgcLIfJQ@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> 1.  If I am not using rdma_join_multicast, would I simply use multiple
> calls to ibv_attach_multicast?

Yes
 
> 2.  My IB code is serving as a pass through layer between two
> pre-existing simulations which previously communicated via reflective
> memory.  It is much easier for me to insert this layer rather than
> modify these existing apps.  So SimApp A passes data to my IBLayer
> which multicasts it to IBLayers on other machines.  Instances of these
> IBLayers, upon receiving hte data, place it in shared memory for
> SimApp B to consume.  There are multiple types of data passing between
> the SimApps and my IBlayer...  All I want my IBLayer to do is take N
> Bytes of Data and place it in the correct shared memory location.  But
> if it doesn't know what type of data it is, it won't know the correct
> shared memory location...  I thought if I have multiple multicast
> groups and I use each one for a different type of data, e.g. MG 1 for
> DataType 1, MG2 for DataType 2 and so on.  Then the IBLayers receving
> the data would know that data received from MG 1 goes in shared mem
> segment 1 etc.

Work completions contain the source QP number and source LID.  I don't think you can tell which multicast group specific data was sent on.  You would probably need to carry that information in a header.  You could try using immediate data for that.  Btw - multicast traffic is unreliable, so you would need to implement your own ack / retry mechanism if you wanted reliability.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH V4 for-next 1/5] IB/core: Add RSS and TSS QP groups
Date: Thu, 11 Apr 2013 14:45:48 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A823736F36DCF9@ORSMSX101.amr.corp.intel.com>
References: <1364129012-12198-1-git-send-email-ogerlitz@mellanox.com>
	<1364129012-12198-2-git-send-email-ogerlitz@mellanox.com>
 <CAJZOPZKBns8kPH+ayzd1k--6K0NXFx=1Pez_bfSg9rQz-fvmHg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZKBns8kPH+ayzd1k--6K0NXFx=1Pez_bfSg9rQz-fvmHg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > I have no issue with RSS/TSS.  But the 'qp group' interface to using this
> seems kludgy.
> 
> lets try to be more specific
> 
> > On a node, this is multiple send/receive queues grouped together to form a
> larger
> > construct.  On the wire, this is a single QP - maybe?  I'm still not clear on
> that.  From
> > what's written, all the send queues appear as a single QPN.  The receive
> queues
> > appear as different QPNs.
> 
> Starting with RSS QP groups: its a group made of one parent QP and N
> RSS child QPs.
> 
> On the wire everything is sent to the RSS parent QP, however, when the
> HW receives a packet for which this QP/QPN is the destination, it
> applies a hash function on the packet header and subject to the hash
> result dispatches the packet to one of the N child QPs.

I'm not trying to be facetious here, but a QP is a 'pair' of queues - one send, one receive.  The construct that you're talking about is a collection of send and/or receive queues, all addressed using the same transport level value.  I don't see where or why there's a parent-child relationship between queues, either from the perspective of the user or the remote endpoint.  The transport level address happens to be called a QPN, but that's just a misnomer.

> The design applies for IB UD QPs and Raw Ethernet Packet QP types,
> under IB the QPN of the parent is on the wire, under Eth, there are no
> QPNs on the wire, but that HW has some "steering rule" which makes
> certain packets to be steered to that RSS parent, and the RSS parent
> in turn further does dispatching decision (hashing) to determine which
> of the child RSS QPs will actually receive that packet.

The current implementation only applies to UD QPs, but I don't see why the concept can't apply to UC or RC.
 
In my mind, a QP is really a special case of the RSS/TSS construct.

> With IPoIB, the remote side is provided with the RSS parent QPN as
> part of the IPoIB HW address provided in the ARP reply payload, so
> packets are sent to that QPN. With RAW Packet Eth QPs, the remote side
> isn't aware to QPNs at all, all goes through a steering rule who is
> directing to the RSS parent.
> 
> You can send packets over RSS packet QP but not receive packets.
> 
> So for RSS, the remote side isn't aware to that QP group @ all.
> 
> Makes sense?
> 
> As for TSS QP groups, basically && generally speaking, the only case
> that really matters are applications/drivers that care for the source
> QPN of a packet.
> 
> but lets get there after hopefully agreeing what is RSS QP group.

So far, this is what I think it is:

- a collection of related receive queues
- each queue is configured somewhat separately - i.e. sized, CQ, sge size, etc.
- receives are posted to the queues separately
- the queues are allocated together

This is where it gets confusing.  They're allocated together, but through separate API calls.

I'm not sure if they share states or not.  Can all of them but one go into the error state and still receive data?  Do packets get routed to whichever queue actually works, or do packets sometimes get dropped, but sometimes don't, depending on some local rules which have been programmed into the HCA?  Can the queues really be destroyed independently?

Is it even necessary to treat the receive queues as being independent?  What happens if they're allocated, destroyed, and modified as a single entity?  We don't treat send and receive queues that belong as part of a single queue 'pair' as having completely separate states.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

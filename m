From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V2 for-next 2/6] IB/core: Add RSS and TSS QP groups
Date: Wed, 13 Feb 2013 12:31:44 +0200
Message-ID: <511B6B90.4050100@mellanox.com>
References: <1360079337-8173-1-git-send-email-ogerlitz@mellanox.com> <1360079337-8173-3-git-send-email-ogerlitz@mellanox.com> <1828884A29C6694DAF28B7E6B8A8237368B99E0B@ORSMSX101.amr.corp.intel.com> <CAJZOPZ+eT=UGfqbwyMn8BtKCei2t1RKj1auAhSbPphLF9A6eVg@mail.gmail.com> <1828884A29C6694DAF28B7E6B8A8237368B9A0FE@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237368B9A0FE-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/02/2013 20:59, Hefty, Sean wrote:
> My understanding of this is that there's NO changes to the wire protocols.

For RSS no changes.

For TSS, added a flag in the IPoIB HW address and used a reserved field 
of the IPoIB header, see the change log for patch #5 "IB/IPoIB: Add RSS 
and TSS support for datagram mode" for the details.


> A QP is simply that, a pair of queues - one send, one receive.  To the best that I can figure out, you're wanting to allocate 'multiple-queues' - something that has multiple send and receive queues.  (I use the term MQ, because it seems to be the most appropriate based on my understanding.)  A QP can be viewed as a special case of a MQ.  Is single QPN is used on the wire for all queues which are part of a MQ?  Like a QP, each queue can have its own size and CQ.  So, they're independent.. except that they're dependent on some higher association, (referred to as a parent QP).

HW driver supporting single QPN on the wire for all the TSS child QPs of 
a given parent is a HW feature called "HW TSS" in the core (this) patch 
and the IPoIB RSS/TSS patch (#5) which will simplify the implementation 
and under which the code avoids the wire changes, indeed (so we have 
were to improve...).

Yep, child QPs are independent to large extent, under HW TSS 
instrumented to put their parent QPN on the wire and other than that 
totally independent. For RSS they should be using the same PD/QKEY as I 
said and with typical HW implementations would have consecutive numbers, 
as networking RSS HW is typically configured with {RSS hash function, 
starting queue number (== the QPN of the "first" RSS child), # of RX 
queues} all  this for what is called the RSS indirection QP (== RSS 
parent), see the mlx4 and IPoIB TSS/RSS patch for more details.



> The user has the joy of not knowing beforehand how many queues will be allocated.  Just that they need to somehow allocate them all, transition them all into a usable state, and keep all of them in that state.  The extra queues are allocated by the HW, but the user still needs to specify how big they are, how many SGEs each should have, etc.  I'm guessing specifying a size of 0 isn't acceptable if the user really doesn't want it.  But it would be okay if it went unused... maybe?  There's no mention of what happens if a user fails to allocate all queues, destroys one of the queues but keeps the others, or has the queues in different states - such as transitioning the 'parent' QP into the error state.  It's not even clear to me if the 'parent QP' has send and receive queues, or if it even 
 should.


Cases you indicate here such as failing to allocate or destroying some 
of the queues would be problematic to RSS, good catch! thinking out loud 
I think we can solve it if we let the parent QP creation to actually 
trigger a creation of the whole set of childs (instead of only reserving 
QPNs for them as done now by the mlx4 patch), we'll look into this.


> Honestly, I like to see the entire concept flushed out before trying to decide if the implementation matches up with what the architecture is trying to accomplish.  Maybe you end up with the same implementation, but there are details in the usage model that seem to be missing.  The email threads talk about UD, but wants to leave open the possibility of other QP types.  How would RC even work in this model?  How would it connect?  How do you manage associated QPs being in different states?  How would this export into user space?  How and when does the HW decide to direct receives to a specific queue?
>

Re the entire concept flushed out, this requirement makes sense, and I 
think we're trying to do it now through these emails... As for QP types 
supported for this feature, they are UD and RAW_PACKET, the two types 
which are commonly used for TCP/IP networking in the relevant 
environment (IB UD - "plain" IPoIB and offloaded IPoIB, Eth RAW_PACKET - 
offloaded TCP/IP).

RC doesn't have a good fit here since some contract (e.g pre-set hash or 
advertizement of QPNs) has to be set over the wire, which isn't the case 
for RSS over UD/RAW_PACKET QPs, as of this indirection QP doing a hash 
on recieved packet and further dispatching them to multiple queues.

Or.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

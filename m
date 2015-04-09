From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: RDMA Multicasting
Date: Thu, 9 Apr 2015 13:35:14 -0500 (CDT)
Message-ID: <alpine.DEB.2.11.1504091329180.24028@gentwo.org>
References: <A1EC1DB6D8AEAF4CB8006B3653F61C5471F997F9@CMEXMB1.ad.emulex.com> <alpine.DEB.2.11.1504090955080.19714@gentwo.org> <5526c0f8.2116430a.28f7.ffffd059SMTPIN_ADDED_BROKEN@mx.google.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5526c0f8.2116430a.28f7.ffffd059SMTPIN_ADDED_BROKEN-ATjtLOhZ0NVl57MIdRCFDg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Caitlin Bestler <cait-DpaxOq6QOWMAvxtiuMwx3w@public.gmane.org>
Cc: Allen Andrews <Allen.Andrews-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, 9 Apr 2015, Caitlin Bestler wrote:

> RDMA requires specific delivery semantics. Successful completion of an
> untagged message (an RDMA Send) implies that all prior tagged
> (Write/Read) packets have been successfully placed in user memory.

That seems to be incompatible with a multicast delivery mechanism
because there is state to all endpoints involved.

> Just putting RDMA packets over an unreliable transport will not accomplish that.

I am not sure what an "RDMA packet" is. RDMA is a memory to memory
transfer action. A packet is information send on a medium. A packet that
describes an RDMA action to be taken between certain endpoints?

Infiniband is lossless and thus what "unreliable" means is also quite
foggy.

> You are probably better off using RDMA ideas over UDP/UD, and doing the
> direct memory placement from your own code, instead.

So send the memory transfer info via multicast datagram to the
endpoints and then run the transfer from the endpoint.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

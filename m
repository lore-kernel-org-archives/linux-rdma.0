From: Kleber Sacilotto de Souza <klebers-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH] IB/mlx4: Fail post send command on error recovery
Date: Mon, 08 Apr 2013 11:07:05 -0300
Message-ID: <5162CF09.1010509@linux.vnet.ibm.com>
References: <1364496315-7588-1-git-send-email-klebers@linux.vnet.ibm.com> <CAL1RGDW7wMVmyFhCv-Ei8Mbca-Y9yv+nygzfREU2_TozNSZ60A@mail.gmail.com> <515D79B3.4090808@linux.vnet.ibm.com> <CAJZOPZLgCMDmTO-qqZXm9Y9xv+xCh5bezz3A_nBn6BEtB-G+0A@mail.gmail.com> <CAL1RGDU=hn7hMy0ECQ7AOQqmuB8R6+BT6JUudNS_6rPBKr2UtQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDU=hn7hMy0ECQ7AOQqmuB8R6+BT6JUudNS_6rPBKr2UtQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 04/04/2013 06:49 PM, Roland Dreier wrote:
> 
> I don't know so much about this PCI error recovery stuff but it does
> seem sensible to trigger a catastrophic error async event when it
> happens (I'm assuming the recovery mechanism resets the adapter).

The PCI error recovery in the powerpc architecture, which is where I'm
focusing, works by identifying a misbehaving adapter and freezing its
slot, so that all MMIO writes to that device will be ignored and reads
will return all 1's. When that happens the Linux implementation will
invoke some callbacks on the driver (in this case mlx4_core) to recover
from the error, and reset the slot. The most common procedure is the
driver to remove the adapter and add it back, which is what the mlx4_ib
is trying to do.

> 
> Then we should fix at least kernel ULPs behave appropriately when they
> get such an async event.  And similarly if someone wants to harden
> some subset of userspace apps to handle PCI error recovery too, that
> would be another step forward.
> 

I agree, this seems to be what is missing to have the error recovery
fully functional.


Thanks,

-- 
Kleber Sacilotto de Souza
IBM Linux Technology Center

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

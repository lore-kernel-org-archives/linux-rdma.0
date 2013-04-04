From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] IB/mlx4: Fail post send command on error recovery
Date: Thu, 4 Apr 2013 14:49:51 -0700
Message-ID: <CAL1RGDU=hn7hMy0ECQ7AOQqmuB8R6+BT6JUudNS_6rPBKr2UtQ@mail.gmail.com>
References: <1364496315-7588-1-git-send-email-klebers@linux.vnet.ibm.com>
 <CAL1RGDW7wMVmyFhCv-Ei8Mbca-Y9yv+nygzfREU2_TozNSZ60A@mail.gmail.com>
 <515D79B3.4090808@linux.vnet.ibm.com> <CAJZOPZLgCMDmTO-qqZXm9Y9xv+xCh5bezz3A_nBn6BEtB-G+0A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZLgCMDmTO-qqZXm9Y9xv+xCh5bezz3A_nBn6BEtB-G+0A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Kleber Sacilotto de Souza <klebers-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Apr 4, 2013 at 2:45 PM, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> The problem that I'm trying to solve is that some IB core modules are
>> hanging waiting on completion queues on their remove path during error recovery.

> So maybe patch them to give up after some time?

I don't know so much about this PCI error recovery stuff but it does
seem sensible to trigger a catastrophic error async event when it
happens (I'm assuming the recovery mechanism resets the adapter).

Then we should fix at least kernel ULPs behave appropriately when they
get such an async event.  And similarly if someone wants to harden
some subset of userspace apps to handle PCI error recovery too, that
would be another step forward.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
